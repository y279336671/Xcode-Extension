//
//  FullDiskAccessAuthorizer.h
//  GHWXcodeExtension
//
//  Created by yanghe on 2022/10/3.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, FDAAuthorizationStatus) {

    FDAAuthorizationStatusNotDetermined = 0,
    FDAAuthorizationStatusDenied,
    FDAAuthorizationStatusAuthorized
} NS_SWIFT_NAME(AuthorizationStatus);
NS_ASSUME_NONNULL_BEGIN

@interface FullDiskAccessAuthorizer : NSObject
+ (instancetype)sharedInstance;
- (FDAAuthorizationStatus)authorizationStatus;
- (void)requestAuthorization;
@end

NS_ASSUME_NONNULL_END
