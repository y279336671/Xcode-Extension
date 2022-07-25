//
//  SourceEditorExtension.m
//  GHWExtension
//
//  Created by 黑化肥发灰 on 2019/8/29.
//  Copyright © 2019 黑化肥发灰. All rights reserved.
//

#import "SourceEditorExtension.h"
#import "MenuManager/MenuManager.h"
#import "Tools/MenuInfo.h"
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
        [menus addObject:@{XCSourceEditorCommandClassNameKey: @"SourceEditorCommand",
                           XCSourceEditorCommandIdentifierKey: menuInfo.title,
                           XCSourceEditorCommandNameKey: menuInfo.title
                           }];
    }
    
    return menus;
}


@end
