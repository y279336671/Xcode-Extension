//
//  MenuManager.m
//  GHWExtension
//
//  Created by yanghe04 on 2022/7/25.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "MenuManager.h"
#import "GHWAddImport.h"
#import "GHWAddComment.h"
#import "GHWInitView.h"
#import "GHWAddLazyCode.h"
#import "GHWSortImport.h"

@implementation MenuManager

+ (MenuManager *)sharedInstane {
    static dispatch_once_t predicate;
    static MenuManager * sharedInstane;
    dispatch_once(&predicate, ^{
        sharedInstane = [[MenuManager alloc] init];
    });
    return sharedInstane;
}

- (NSArray <MenuInfo *>*)menuArray {
    if (!_menuArray) {
        _menuArray = [[NSArray alloc]initWithObjects:[
                      [GHWAddImport alloc] init],
                      [[GHWAddComment alloc] init],
                      [[GHWInitView alloc] init],
                      [[GHWAddLazyCode alloc] init],
                      [[GHWSortImport alloc] init], nil];
    }
    return _menuArray;
}

- (MenuInfo *)findMenuInfo:(NSString *)identifier {
    MenuInfo *info = nil;
    for (int n = 0; n < [MenuManager sharedInstane].menuArray.count; n++) {
        MenuInfo *menuInfo = [MenuManager sharedInstane].menuArray[n];
        if ([identifier isEqualToString:menuInfo.title]) {
            info = menuInfo;
        }
    }
    return info;
}
@end
