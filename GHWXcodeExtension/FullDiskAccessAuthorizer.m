//
//  FullDiskAccessAuthorizer.m
//  GHWXcodeExtension
//
//  Created by yanghe on 2022/10/3.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "FullDiskAccessAuthorizer.h"
#import <pwd.h>
#import <Cocoa/Cocoa.h>
static FullDiskAccessAuthorizer *instance;
@implementation FullDiskAccessAuthorizer
+ (instancetype)sharedInstance {

    @synchronized (self) {

        if(nil == instance) {

            instance = [[FullDiskAccessAuthorizer alloc] init];
        }
        return instance;
    }
}

- (FDAAuthorizationStatus)authorizationStatus {


    NSString *userHomePath = NSHomeDirectory();

    BOOL isSandboxed = (nil != NSProcessInfo.processInfo.environment[@"APP_SANDBOX_CONTAINER_ID"]);

    NSLog(@"isSandboxed : %d",isSandboxed);

    if (isSandboxed)
    {

        struct passwd *pw = getpwuid(getuid());
        assert(pw);
        userHomePath = [NSString stringWithUTF8String:pw->pw_dir];
    }

    NSString *path = [userHomePath stringByAppendingPathComponent:@"Library/Safari"];

    NSLog(@"userHomePath : %@, path : %@",userHomePath,path);

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSArray<NSString *> *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];

    NSLog(@"paths : %@",paths);

    if (paths == nil && fileExists){

        return FDAAuthorizationStatusDenied;
    } else if (fileExists) {

        return FDAAuthorizationStatusAuthorized;
    } else {

        return FDAAuthorizationStatusNotDetermined;
    }
}

- (void)requestAuthorization {

    if (@available(macOS 10.14, *)){

        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"]];
    }
}

@end
