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
    // todo 文件如何复制到 ~/Library/Application Scripts/code-signing-id 路径
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    url = [url URLByAppendingPathComponent:fileName];
    url = [url URLByAppendingPathExtension:@"scpt"];
    return url;
}

- (void)run:(NSString *)funcName {
    NSURL *filePath = [self fileScriptPath:@"XcodeWayScript"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
        return;;
    }
    NSUserAppleScriptTask *task =  [[NSUserAppleScriptTask alloc] initWithURL:filePath error:nil];
    
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
