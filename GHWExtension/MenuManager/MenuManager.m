//
//  MenuManager.m
//  GHWExtension
//
 

#import "MenuManager.h"
#import "GHWAddImport.h"
#import "GHWAddComment.h"
#import "GHWInitView.h"
#import "GHWAddLazyCode.h"
#import "GHWSortImport.h"
#import "OpenProjectRoot.h"
#import "OpenProjectRootWithTerminal.h"
#import "RemoveDerivedData.h"
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
        _menuArray = [[NSArray alloc]initWithObjects:
            [[GHWAddImport alloc] init],
            [[GHWAddComment alloc] init],
            [[GHWInitView alloc] init],
            [[GHWAddLazyCode alloc] init],
            [[GHWSortImport alloc] init],
            [[OpenProjectRoot alloc] init],
            [[OpenProjectRootWithTerminal alloc] init],
            [[RemoveDerivedData alloc] init],nil];
    }
    return _menuArray;
}

- (MenuInfo *)findMenuInfo:(NSString *)identifier {
    MenuInfo *info = nil;
    for (int n = 0; n < [MenuManager sharedInstane].menuArray.count; n++) {
        MenuInfo *menuInfo = [MenuManager sharedInstane].menuArray[n];
        if ([identifier isEqualToString:[menuInfo menuTitle] ]) {
            info = menuInfo;
        }
    }
    return info;
}
@end
