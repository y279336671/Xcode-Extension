//
//  ScriptRunner.m
//  GHWExtension
//
//  Created by yanghe04 on 2022/7/25.
//  Copyright © 2022 Jingyao. All rights reserved.
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
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    [url URLByAppendingPathComponent:fileName];
    [url URLByAppendingPathExtension:@"scpt"];
    return url;
}

- (void)run:(NSString *)funcName {
   NSURL *filePath = [self fileScriptPath:@"XcodeWayScript"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
        return;;
    }
    NSUserAppleScriptTask *task =  [[NSUserAppleScriptTask alloc] initWithURL:filePath error:nil];
//    task executeWithAppleEvent:<#(nullable NSAppleEventDescriptor *)#> completionHandler:<#^(NSAppleEventDescriptor * _Nullable result, NSError * _Nullable error)handler#>
}

- (NSAppleEventDescriptor *)eventDescriptior:(NSString *)funcName {
    ProcessSerialNumber psn;
    psn.highLongOfPSN = 0;
    psn.lowLongOfPSN = kCurrentProcess;
    
    malloc(psn)
    
//    NSAppleEventDescriptor *target = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeProcessSerialNumber bytes:&psn length:MemoryLayout<ProcessSerialNumber>.size];
}
@end
