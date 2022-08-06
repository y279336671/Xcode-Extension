//
//  ScriptRunner.m
//  GHWExtension
//
 

#import "ScriptRunner.h"
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>
@implementation ScriptRunner
+ (ScriptRunner *)sharedInstane {
    static dispatch_once_t predicate;
    static ScriptRunner * sharedInstane;
    dispatch_once(&predicate, ^{
        sharedInstane = [[ScriptRunner alloc] init];
    });
    return sharedInstane;
}

- (NSURL *)fileScriptPath:(NSString *)fileName {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle pathForResource:fileName ofType:@"scpt"];
    // todo 文件如何复制到 ~/Library/Application Scripts/code-signing-id 路径
    //file:///Users/yanghe04/Library/Application%20Scripts/com.yanghe.boring.TBCXcodeExtension/XcodeWayScript.scpt
//    /Users/yanghe04/Library/Application\ Scripts/com.yanghe.boring.TBCXcodeExtension
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [fileManager URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    if (!url) {
        NSError *error;
       BOOL isCreated = [fileManager createDirectoryAtPath:@"/Users/yanghe04/Library/Application Scripts/com.yanghe.boring.TBCXcodeExtension" withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"%@", error);
        if (isCreated) {
            NSError *error1;
            [fileManager copyItemAtPath:resPath toPath:[NSString stringWithFormat:@"/Users/yanghe04/Library/Application Scripts/com.yanghe.boring.TBCXcodeExtension/%@.scpt", fileName] error:nil];
            url = [fileManager URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error1];
            NSLog(@"%@", error1);
        }
    }
    url = [url URLByAppendingPathComponent:fileName];
    url = [url URLByAppendingPathExtension:@"scpt"];
    return url;
}

- (void)run:(NSString *)funcName {
//    NSURL *filePath = [self fileScriptPath:@"XcodeWayScript"];
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle pathForResource:@"XcodeWayScript" ofType:@"scpt"];
    NSURL *filePath = [NSURL URLWithString:resPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:resPath toPath:filePath.path error:&error];
        NSLog(@"%@", error);
    }
    NSError *error;
    
    NSUserAppleScriptTask *task =  [[NSUserAppleScriptTask alloc] initWithURL:filePath error:&error];
    
    NSLog(@"%@", error);
    NSAppleEventDescriptor *event = [self eventDescriptior:funcName];
    [task executeWithAppleEvent:event completionHandler:^(NSAppleEventDescriptor * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@, %@", result, error);
    }];
}

- (NSAppleEventDescriptor *)eventDescriptior:(NSString *)funcName {
    NSAppleEventDescriptor *target = [[NSAppleEventDescriptor alloc] initWithEventClass:kASAppleScriptSuite eventID:kASSubroutineEvent targetDescriptor:nil returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID];
    
    NSAppleEventDescriptor *function = [NSAppleEventDescriptor descriptorWithString:funcName];
    [target setParamDescriptor:function forKeyword:keyASSubroutineName];
    return target;
}

@end
