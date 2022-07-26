//
//  ViewController.m
//  GHWXcodeExtension
//
 

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
//
//#pragma mark 获取鼠标右键事件
//-(void)rightMouseDown:(NSEvent *)event{
//
//    //创建Menu
//    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
//    //NSMenu *theMenu = [[NSMenu alloc] init];
//    
//    //常规添加菜单
//    [theMenu insertItemWithTitle:@"Item 1"action:@selector(beep:)keyEquivalent:@""atIndex:0];
//
//    [theMenu insertItemWithTitle:@"Item 2"action:@selector(beep:)keyEquivalent:@""atIndex:1];
//    
//    //自定义的NSMenuItem
//    NSMenuItem *item3 = [[NSMenuItem alloc]init];
//
//    item3.title = @"Item 38";
//
//    item3.target = self;
//
//    item3.action = @selector(beep:);
//
//    [theMenu insertItem:item3 atIndex:2];
//
//    [NSMenu popUpContextMenu:theMenu withEvent:event forView:self.view];
//
//}
//
//#pragma mark 统一使用响应方法，不然不使用该方法的菜单栏将不能点击
//-(void)beep:(NSMenuItem *)menuItem{
//
//    NSLog(@"_____%@", menuItem);
//
//}

@end
