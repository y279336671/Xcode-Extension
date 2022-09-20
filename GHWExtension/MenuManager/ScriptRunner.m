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
    NSError *error;

    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.scpt", url.absoluteURL,fileName]];
    NSLog(@"%@", error);
    return url;
}

- (void)run:(NSString *)funcName {
    [self run:funcName inputString:@""];
}

- (void)run:(NSString *)funcName inputString:(NSString *)inputString{
    NSURL *filePath = [self fileScriptPath:@"XcodeWayScript"];
    NSError *error;

    NSUserAppleScriptTask *task =  [[NSUserAppleScriptTask alloc] initWithURL:filePath error:&error];
    NSLog(@"%@", error);
    NSAppleEventDescriptor *event = [self eventDescriptior:funcName inputString:inputString];
    [task executeWithAppleEvent:event completionHandler:^(NSAppleEventDescriptor * _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@, %@", result, error);
    }];
}

- (NSAppleEventDescriptor *)eventDescriptior:(NSString *)funcName inputString:(NSString *)inputString {
    
    // parameter
    NSAppleEventDescriptor *parameter = [NSAppleEventDescriptor descriptorWithString:inputString];
    NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
    [parameters insertDescriptor:parameter atIndex:1];
    
    NSAppleEventDescriptor *target = [[NSAppleEventDescriptor alloc] initWithEventClass:kASAppleScriptSuite eventID:kASSubroutineEvent targetDescriptor:nil returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID];
    
    NSAppleEventDescriptor *function = [NSAppleEventDescriptor descriptorWithString:funcName];
    [target setParamDescriptor:function forKeyword:keyASSubroutineName];
    
    if (inputString && inputString.length > 0) {
        [target setParamDescriptor:parameters forKeyword:keyDirectObject];
    }
    
    return target;
}

@end
