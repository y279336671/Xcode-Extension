//
//  SourceEditorExtension.m
//  GHWExtension
//
 

#import "SourceEditorExtension.h"
#import "MenuManager/MenuManager.h"
#import "MenuInfo.h"
@implementation SourceEditorExtension

/*
- (void)extensionDidFinishLaunching
{
    // If your extension needs to do any work at launch, implement this optional method.
}
*/


- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions
{
    NSMutableArray *menus = [[NSMutableArray alloc] init];
    for (int n = 0; n < [MenuManager sharedInstane].menuArray.count; n++) {
        MenuInfo *menuInfo = [MenuManager sharedInstane].menuArray[n];
        NSLog(@">>>>%@", [menuInfo menuTitle]);
        [menus addObject:@{XCSourceEditorCommandClassNameKey: @"SourceEditorCommand",
                           XCSourceEditorCommandIdentifierKey: [menuInfo menuTitle],
                           XCSourceEditorCommandNameKey: [menuInfo menuTitle]
                           }];
    }
    return menus;
}


@end
