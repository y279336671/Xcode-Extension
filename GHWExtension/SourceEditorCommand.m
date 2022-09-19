//
//  SourceEditorCommand.m
//  GHWExtension
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

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler{
    NSString *identifier = invocation.commandIdentifier;
    MenuInfo *menuInfo = [[MenuManager sharedInstane] findMenuInfo:identifier];
    [menuInfo processCodeWithInvocation:invocation];
        
    completionHandler(nil);
}

@end
