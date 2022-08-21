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
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *resPath = [bundle pathForResource:fileName ofType:@"scpt"];
    NSError *error;
//    NSString *toPath = [NSString stringWithFormat:@"%@/%@.scpt",docPath, fileName];
//    BOOL isCopy = [fileManager copyItemAtPath:resPath toPath:toPath error:&error1];
//    NSURL *url = [NSURL URLWithString:toPath];;

    // todo 文件如何复制到 ~/Library/Application Scripts/code-signing-id 路径
    //file:///Users/yanghe04/Library/Application%20Scripts/com.yanghe.boring.TBCXcodeExtension/XcodeWayScript.scpt
//    /Users/yanghe04/Library/Application\ Scripts/com.yanghe.boring.TBCXcodeExtension
    
//    NSURL *url = [fileManager URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//    NSString *toPath = [NSString stringWithFormat:@"/Users/yanghe04/Library/Application Scripts/com.yanghe.boring.TBCXcodeExtension1/%@.scpt", fileName];
//    if (!url || ![fileManager fileExistsAtPath:toPath]) {
//        NSError *error;
//       BOOL isCreated = [fileManager createDirectoryAtPath:@"/Users/yanghe04/Library/Application Scripts/com.yanghe.boring.TBCXcodeExtension1" withIntermediateDirectories:YES attributes:nil error:&error];
//        NSLog(@"%@", error);
//        if (isCreated) {
//            NSError *error1;
//            [fileManager copyItemAtPath:resPath toPath:toPath error:&error1];
//            url = [fileManager URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//            NSLog(@"%@", error1);
//        }
//    }
//    url = [url URLByAppendingPathComponent:fileName];
//    url = [url URLByAppendingPathExtension:@"scpt"];
    NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.scpt", url.absoluteURL,fileName]];
    NSLog(@"%@", error);
    return url;
}

- (void)run:(NSString *)funcName {
    // todo 尝试使用直接script写在代码里面
    NSURL *filePath = [self fileScriptPath:@"XcodeWayScript"];
    NSError *error;
//
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
