//
//  EGOCache.m
//  enormego
//
//  Created by Shaun Harrison.
//  Copyright (c) 2009-2017 enormego.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOCache.h"
#import "ItemModel.h"
#if DEBUG
#	define CHECK_FOR_EGOCACHE_PLIST() if([key isEqualToString:@"EGOCache.plist"]) { \
		NSLog(@"EGOCache.plist is a reserved key and can not be modified."); \
		return; }
#else
#	define CHECK_FOR_EGOCACHE_PLIST() if([key isEqualToString:@"EGOCache.plist"]) return;
#endif

static inline NSString* cachePathForKey(NSString* directory, NSString* key) {
	key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return [directory stringByAppendingPathComponent:key];
    // /Users/yanghe04/Library/Application Scripts/com.yanghe.boring.TBCXcodeExtension/EGOCache
}

#pragma mark -

@interface EGOCache () {
	dispatch_queue_t _cacheInfoQueue;
	dispatch_queue_t _frozenCacheInfoQueue;
	dispatch_queue_t _diskQueue;
	NSMutableDictionary* _cacheInfo;
	NSString* _directory;
	BOOL _needsSave;
}

@property(nonatomic,copy) NSDictionary* frozenCacheInfo;
@end

@implementation EGOCache

+ (instancetype)globalCache {
	static id instance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[[self class] alloc] init];
	});
	
	return instance;
}

- (instancetype)init {
    
    NSError *error;
    NSURL *directoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    NSString *cachesDirectory = [self decodeString: directoryURL.resourceSpecifier];
    
//    /Users/yanghe04/Library/Containers/com.yanghe.boring.TBCXcodeExtension/Data/Library/    插件路径
//    /Users/yanghe04/Library/   主程序路径
//    /Users/yanghe04/Library/Containers/com.yanghe.boring.TBCXcodeExtension/Data/Library/Preferences  最终路径
    
    if ([cachesDirectory containsString:@"Containers/com.yanghe.boring.TBCXcodeExtension/Data/Library/"]) {
        cachesDirectory = [NSString stringWithFormat:@"%@Preferences", cachesDirectory];
    } else {
        cachesDirectory = [NSString stringWithFormat:@"%@Containers/com.yanghe.boring.TBCXcodeExtension/Data/Library/Preferences", cachesDirectory];
    }
    
	cachesDirectory = [[NSString stringWithFormat:@"%@",cachesDirectory] copy];
	return [self initWithCacheDirectory:cachesDirectory];
}

//URLDEcode
-(NSString *)decodeString:(NSString*)encodedString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory {
	if((self = [super init])) {
		_cacheInfoQueue = dispatch_queue_create("com.enormego.egocache.info", DISPATCH_QUEUE_SERIAL);
		dispatch_queue_t priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
		dispatch_set_target_queue(priority, _cacheInfoQueue);
		
		_frozenCacheInfoQueue = dispatch_queue_create("com.enormego.egocache.info.frozen", DISPATCH_QUEUE_SERIAL);
		priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
		dispatch_set_target_queue(priority, _frozenCacheInfoQueue);
		
		_diskQueue = dispatch_queue_create("com.enormego.egocache.disk", DISPATCH_QUEUE_CONCURRENT);
		priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
		dispatch_set_target_queue(priority, _diskQueue);
		
		
		_directory = cacheDirectory;
        NSError *error;
        
        NSString *filePath = [NSString stringWithFormat:@"file://%@", cachePathForKey(_directory, @"EGOCache.plist")];
        filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		_cacheInfo = [[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:filePath] error:&error] mutableCopy];
        
		if(!_cacheInfo) {
			_cacheInfo = [[NSMutableDictionary alloc] init];
		}
		
		[[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:NULL];
		
		NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
		NSMutableArray* removedKeys = [[NSMutableArray alloc] init];
		
		for(NSString* key in _cacheInfo) {
			if([_cacheInfo[key] timeIntervalSinceReferenceDate] <= now) {
				[[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
				[removedKeys addObject:key];
			}
		}
		
		[_cacheInfo removeObjectsForKeys:removedKeys];
		self.frozenCacheInfo = _cacheInfo;
		[self setDefaultTimeoutInterval:999999999];
	}
	
	return self;
}

- (void)clearCache {
	dispatch_sync(_cacheInfoQueue, ^{
		for(NSString* key in _cacheInfo) {
			[[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
		}
		
		[_cacheInfo removeAllObjects];
		
		dispatch_sync(_frozenCacheInfoQueue, ^{
			self.frozenCacheInfo = [_cacheInfo copy];
		});

		[self setNeedsSave];
	});
}

- (void)removeCacheForKey:(NSString*)key {
	CHECK_FOR_EGOCACHE_PLIST();

	dispatch_async(_diskQueue, ^{
		[[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
	});

	[self setCacheTimeoutInterval:0 forKey:key];
}

- (BOOL)hasCacheForKey:(NSString*)key {
	NSDate* date = [self dateForKey:key];
	if(date == nil) return NO;
	if([date timeIntervalSinceReferenceDate] < CFAbsoluteTimeGetCurrent()) return NO;
	
	return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(_directory, key)];
}

- (NSDate*)dateForKey:(NSString*)key {
	__block NSDate* date = nil;

	dispatch_sync(_frozenCacheInfoQueue, ^{
		date = (self.frozenCacheInfo)[key];
	});

	return date;
}

- (NSArray*)allKeys {
	__block NSArray* keys = nil;

	dispatch_sync(_frozenCacheInfoQueue, ^{
		keys = [self.frozenCacheInfo allKeys];
	});

	return keys;
}

- (void)setCacheTimeoutInterval:(NSTimeInterval)timeoutInterval forKey:(NSString*)key {
	NSDate* date = timeoutInterval > 0 ? [NSDate dateWithTimeIntervalSinceNow:timeoutInterval] : nil;
	
	// Temporarily store in the frozen state for quick reads
	dispatch_sync(_frozenCacheInfoQueue, ^{
		NSMutableDictionary* info = [self.frozenCacheInfo mutableCopy];
		
		if(date) {
			info[key] = date;
		} else {
			[info removeObjectForKey:key];
		}
		
		self.frozenCacheInfo = info;
	});
	
	// Save the final copy (this may be blocked by other operations)
	dispatch_async(_cacheInfoQueue, ^{
		if(date) {
			_cacheInfo[key] = date;
		} else {
			[_cacheInfo removeObjectForKey:key];
		}
		
		dispatch_sync(_frozenCacheInfoQueue, ^{
			self.frozenCacheInfo = [_cacheInfo copy];
		});

		[self setNeedsSave];
	});
}

#pragma mark -
#pragma mark Copy file methods

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key {
	[self copyFilePath:filePath asKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
	dispatch_async(_diskQueue, ^{
		[[NSFileManager defaultManager] copyItemAtPath:filePath toPath:cachePathForKey(_directory, key) error:NULL];
	});
	
	[self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

#pragma mark -
#pragma mark Data methods

- (void)setData:(NSData*)data forKey:(NSString*)key {
	[self setData:data forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
	CHECK_FOR_EGOCACHE_PLIST();
	
	NSString* cachePath = cachePathForKey(_directory, key);
	
	dispatch_async(_diskQueue, ^{
        NSError *error;
        // 完犊子 插件没有写入权限
//        Error Domain=NSCocoaErrorDomain Code=513 "您没有将文件“kBookmarksInfo”存储到文件夹“EGOCache”中的权限。" UserInfo={NSFilePath=/Users/yanghe04/Library/Application Scripts/com.yanghe.boring.TBCXcodeExtension/EGOCache/kBookmarksInfo, NSUnderlyingError=0x600001bcafa0 {Error Domain=NSPOSIXErrorDomain Code=1 "Operation not permitted"}}
        [data writeToFile:cachePath options:NSDataWritingAtomic error:&error];
        NSLog(@"%@", error);
	});
	
	[self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

- (void)setNeedsSave {
	dispatch_async(_cacheInfoQueue, ^{
		if(_needsSave) return;
		_needsSave = YES;
		
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, _cacheInfoQueue, ^(void){
			if(!_needsSave) return;
			[_cacheInfo writeToFile:cachePathForKey(_directory, @"EGOCache.plist") atomically:YES];
			_needsSave = NO;
		});
	});
}

- (NSData*)dataForKey:(NSString*)key {
	if([self hasCacheForKey:key]) {
        NSString *filePath = cachePathForKey(_directory, key);
        filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        filePath = [NSString stringWithFormat:@"file://%@", filePath];
//        id object = [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
        
//        NSString *filePath = [NSString stringWithFormat:@"file://%@", cachePathForKey(_directory, @"EGOCache.plist")];
//        filePath = [filePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        id object = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
		return object;
	} else {
		return nil;
	}
}

#pragma mark -
#pragma mark String methods

- (NSString*)stringForKey:(NSString*)key {
	return [[NSString alloc] initWithData:[self dataForKey:key] encoding:NSUTF8StringEncoding];
}

- (void)setString:(NSString*)aString forKey:(NSString*)key {
	[self setString:aString forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setString:(NSString*)aString forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
	[self setData:[aString dataUsingEncoding:NSUTF8StringEncoding] forKey:key withTimeoutInterval:timeoutInterval];
}

#pragma mark -
#pragma mark Image methds

#if TARGET_OS_IPHONE

- (UIImage*)imageForKey:(NSString*)key {
	UIImage* image = nil;
	
	@try {
		image = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePathForKey(_directory, key)];
	} @catch (NSException* e) {
		// Surpress any unarchiving exceptions and continue with nil
	}
	
	return image;
}

- (void)setImage:(UIImage*)anImage forKey:(NSString*)key {
	[self setImage:anImage forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setImage:(UIImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
	@try {
		// Using NSKeyedArchiver preserves all information such as scale, orientation, and the proper image format instead of saving everything as pngs
		[self setData:[NSKeyedArchiver archivedDataWithRootObject:anImage] forKey:key withTimeoutInterval:timeoutInterval];
	} @catch (NSException* e) {
		// Something went wrong, but we'll fail silently.
	}
}

#else

- (NSImage*)imageForKey:(NSString*)key {
	return [[NSImage alloc] initWithData:[self dataForKey:key]];
}

- (void)setImage:(NSImage*)anImage forKey:(NSString*)key {
	[self setImage:anImage forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setImage:(NSImage*)anImage forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
	[self setData:[[NSBitmapImageRep imageRepWithData:anImage.TIFFRepresentation] representationUsingType:NSPNGFileType properties:@{ }] forKey:key withTimeoutInterval:timeoutInterval];
}

#endif

#pragma mark -
#pragma mark Property List methods

- (NSData*)plistForKey:(NSString*)key; {  
	NSData* plistData = [self dataForKey:key];
	return [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:nil error:nil];
}

- (void)setPlist:(id)plistObject forKey:(NSString*)key; {
	[self setPlist:plistObject forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setPlist:(id)plistObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval; {
	// Binary plists are used over XML for better performance
	NSData* plistData = [NSPropertyListSerialization dataWithPropertyList:plistObject format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];

	if(plistData != nil) {
		[self setData:plistData forKey:key withTimeoutInterval:timeoutInterval];
	}
}

#pragma mark -
#pragma mark Object methods

- (id<NSCoding>)objectForKey:(NSString*)key {
	if([self hasCacheForKey:key]) {
        NSError *error;
        id object =[NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[ItemModel.class, NSArray.class, NSMutableArray.class, NSObject.class]] fromData:[self dataForKey:key] error:&error];
        NSLog(@"archivedDataWithRootObject:>>>%@,%@", error, object);
		return object;
	} else {
		return nil;
	}
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key {
	[self setObject:anObject forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    NSError *error;
	[self setData:[NSKeyedArchiver archivedDataWithRootObject:anObject requiringSecureCoding:NO error:&error] forKey:key withTimeoutInterval:timeoutInterval];
  
}

@end
