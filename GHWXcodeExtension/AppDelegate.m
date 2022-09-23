//
//  AppDelegate.m
//  GHWXcodeExtension
//
 

#import "AppDelegate.h"
#import "ItemObjectManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[ItemObjectManager sharedInstane] updateAllBookmark];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    NSLog(@"func name applicationWillBecomeActive");
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    NSLog(@"func name applicationDidBecomeActive");
}
- (void)applicationWillResignActive:(NSNotification *)notification {
    NSLog(@"func name applicationWillResignActive");
    [[ItemObjectManager sharedInstane] updateAllBookmark];
}
- (void)applicationDidResignActive:(NSNotification *)notification {
    NSLog(@"func name applicationDidResignActive");
}
@end
