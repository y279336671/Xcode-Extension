//
//  MenuInfo.h
//  GHWExtension
//
//  Created by yanghe04 on 2022/7/25.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MenuInfo : NSObject
@property (nonatomic, copy) NSString *title;
- (void)processCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation;
- (void)runWithFuncName:(NSString *)fucName;
@end

NS_ASSUME_NONNULL_END
