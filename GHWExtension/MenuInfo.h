//
//  MenuInfo.h
//  GHWExtension
//
 

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MenuInfo : NSObject
@property (nonatomic, copy) NSString *menuTitle;

- (void)processCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation;
- (void)runWithFuncName:(NSString *)fucName;
@end

NS_ASSUME_NONNULL_END
