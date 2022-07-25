//
//  SourceEditorCommand.m
//  GHWExtension
//
//  Created by 黑化肥发灰 on 2019/8/29.
//  Copyright © 2019 黑化肥发灰. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "GHWInitView.h"
#import "GHWAddLazyCode.h"
#import "GHWSortImport.h"
#import "GHWAddImport.h"
#import "MenuManager/MenuManager.h"
@interface SourceEditorCommand ()



@end

@implementation SourceEditorCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    NSString *identifier = invocation.commandIdentifier;
    [invocation.buffer.lines enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@", obj);
    }];
    
    [[[MenuManager sharedInstane] findMenuInfo:identifier] processCodeWithInvocation:invocation];
    
//    if ([identifier hasPrefix:@"com.jingyao.GHWXcodeExtension.GHWExtension.sortImport"]) {
//        [[GHWSortImport sharedInstane] processCodeWithInvocation:invocation];
//    } else if ([identifier hasPrefix:@"com.jingyao.GHWXcodeExtension.GHWExtension.initView"]) {
//        [[GHWInitView sharedInstane] processCodeWithInvocation:invocation];
//    } else if ([identifier hasPrefix:@"com.jingyao.GHWXcodeExtension.GHWExtension.addLazyCode"]) {
//        [[GHWAddLazyCode sharedInstane] processCodeWithInvocation:invocation];
//    } else if ([identifier hasPrefix:@"com.jingyao.GHWXcodeExtension.GHWExtension.addImport"]) {
//        [[GHWAddImport sharedInstane] processCodeWithInvocation:invocation];
//    }
    
    completionHandler(nil);
}

@end
