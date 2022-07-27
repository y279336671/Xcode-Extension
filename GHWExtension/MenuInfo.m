//
//  MenuInfo.m
//  GHWExtension
//
 

#import "MenuInfo.h"
#import "ScriptRunner.h"
@implementation MenuInfo


- (void)processCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation {
    [[ScriptRunner sharedInstane] run:invocation.commandIdentifier];
}

- (void)runWithFuncName:(NSString *)fucName {
    
}
@end
