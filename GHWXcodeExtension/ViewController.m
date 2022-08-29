//
//  ViewController.m
//  GHWXcodeExtension
//
 

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)testScript:(id)sender {
    
}

- (IBAction)installAutomationScript:(id)sender {
    // NOTE: For this to work, you MUST update the Capbilities > App Sandbox > File Access > User Selected File to Read/Write.

    NSError *error;
    NSURL *directoryURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:directoryURL];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"Select Script Folder"];
    [openPanel setMessage:@"Please select the User > Library > Application Scripts > com.yanghe.boring.TBCXcodeExtension folder"];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *selectedURL = [openPanel URL];
            if ([selectedURL isEqual:directoryURL]) {
                NSURL *destinationURL = [selectedURL URLByAppendingPathComponent:@"XcodeWayScript.scpt"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSURL *sourceURL = [[NSBundle mainBundle] URLForResource:@"XcodeWayScript" withExtension:@"scpt"];
                NSError *error;
                BOOL success = [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error];
                if (success) {
                    NSAlert *alert = [NSAlert alertWithMessageText:@"Script Installed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The Automation script was installed succcessfully."];
                    [alert runModal];

                    // NOTE: This is a bit of a hack to get the Application Scripts path out of the next open or save panel that appears.
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NSNavLastRootDirectory"];
                }
                else {
                    NSLog(@"%s error = %@", __PRETTY_FUNCTION__, error);
                    if ([error code] == NSFileWriteFileExistsError) {
                        // the script was already installed Application Scripts folder

                        if (! [fileManager removeItemAtURL:destinationURL error:&error]) {
                            NSLog(@"%s error = %@", __PRETTY_FUNCTION__, error);
                        }
                        else {
                            BOOL success = [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error];
                            if (success) {
                                NSAlert *alert = [NSAlert alertWithMessageText:@"Script Updated" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"The Automation script was updated."];
                                [alert runModal];
                            }
                        }
                    }
                    else {
                        // the item couldn't be copied, try again
                        [self performSelector:@selector(installAutomationScript:) withObject:self afterDelay:0.0];
                    }
                }
            }
            else {
                // try again because the user changed the folder path
                [self performSelector:@selector(installAutomationScript:) withObject:self afterDelay:0.0];
            }
        }
    }];
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
