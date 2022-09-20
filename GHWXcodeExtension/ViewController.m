//
//  ViewController.m
//  GHWXcodeExtension
//
 

#import "ViewController.h"
#import "ItemModel.h"
#import "CustomTableRowView.h"
#import "CustomTableCellView.h"

#define  kDefaultProjectPath @"kDefaultProjectPath"
#define  kDefaultScriptPath  @"kDefaultScriptPath"


@interface ViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (weak) IBOutlet NSTextField *scriptsPath;
@property (weak) IBOutlet NSTextField *projectPath;
@property (weak) IBOutlet NSOutlineView *contentOutlineView;

@property (nonatomic, strong) NSMutableArray *bookmarks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *local = [NSUserDefaults standardUserDefaults];
    NSString *projectPath = [local stringForKey:kDefaultProjectPath];
    NSString *scriptPath = [local stringForKey:kDefaultScriptPath];
    self.projectPath.stringValue = projectPath != nil ? projectPath : @"";
    self.scriptsPath.stringValue = scriptPath != nil ? scriptPath : @"";

    [self bindOutlineView];
}

- (void)viewWillAppear {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"test"];
     NSLog(@"**************%@", obj);
}

- (void)bindOutlineView {
    ItemModel *funcItem1 = [[ItemModel alloc] init];
    funcItem1.funName = @"方法名1";
    
    ItemModel *funcItem11 = [[ItemModel alloc] init];
    funcItem11.funName = @"方法名11";
    funcItem1.subItems = [[NSMutableArray alloc] initWithArray:@[funcItem11]];
    
    ItemModel *funcItem111 = [[ItemModel alloc] init];
    funcItem111.funName = @"方法名111";
    funcItem11.subItems = [[NSMutableArray alloc] initWithArray:@[funcItem111]];
    
    
    ItemModel *funcItem2 = [[ItemModel alloc] init];
    funcItem2.funName = @"方法名2";
    ItemModel *funcItem22 = [[ItemModel alloc] init];
    funcItem22.funName = @"方法名22";
   
    ItemModel *funcItem222 = [[ItemModel alloc] init];
    funcItem222.funName = @"方法名222";
    funcItem2.subItems = [[NSMutableArray alloc] initWithArray:@[funcItem22, funcItem222]];
    
    ItemModel *funcItem3 = [[ItemModel alloc] init];
    funcItem3.funName = @"方法名3";
    
    self.bookmarks =  [[NSMutableArray alloc] initWithArray:@[funcItem1, funcItem2, funcItem3]];
    
    [self.contentOutlineView reloadData];
}

- (void)testNoti {
    NSLog(@">>>>>>>>>>>>>>");
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)testScript:(id)sender {
   id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"test"];
    NSLog(@"%@", obj);
}

- (IBAction)selectedProjectRoot:(id)sender {
    NSError *error;
    NSURL *directoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:directoryURL];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"确定"];
    [openPanel setMessage:@"请选择项目根目录"];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *selectedURL = [openPanel URL];
            self.projectPath.stringValue =  [NSString stringWithFormat:@"%@", selectedURL.absoluteURL];
            NSUserDefaults *local = [NSUserDefaults standardUserDefaults];
            [local setObject:self.projectPath.stringValue forKey:kDefaultProjectPath];
            [local synchronize];
            NSLog(@"%@", selectedURL.absoluteURL);
        }
    }];
}



- (IBAction)installAutomationScript:(id)sender {
    NSError *error;
    NSURL *directoryURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationScriptsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:directoryURL];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setPrompt:@"确定"];
    [openPanel setMessage:@"直接点击确定即可,或者选择 User > Library > Application Scripts > com.yanghe.boring.TBCXcodeExtension文件夹"];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *selectedURL = [openPanel URL];
            
            if ([selectedURL isEqual:directoryURL]) {
                NSURL *destinationURL = [selectedURL URLByAppendingPathComponent:@"XcodeWayScript.scpt"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSURL *sourceURL = [[NSBundle mainBundle] URLForResource:@"XcodeWayScript" withExtension:@"scpt"];
                NSError *error;
                BOOL success = [fileManager copyItemAtURL:sourceURL toURL:destinationURL error:&error];
                if (success) {
                    self.scriptsPath.stringValue = [NSString stringWithFormat:@"%@", selectedURL.absoluteURL];
                    NSUserDefaults *local = [NSUserDefaults standardUserDefaults];
                    [local setObject:self.scriptsPath.stringValue forKey:kDefaultScriptPath];
                    [local synchronize];
//                    self.scriptsPath set
                    
//                    NSAlert *alert = [[NSAlert alloc] init];
//                    [alert setMessageText:@"脚本已安装"];
//                    [alert addButtonWithTitle:@"确定"];
//                    [alert setInformativeText:@"自动化脚本安装完成"];
//                    [alert runModal];

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
                                self.scriptsPath.stringValue = [NSString stringWithFormat:@"%@", selectedURL.absoluteURL];
                                NSUserDefaults *local = [NSUserDefaults standardUserDefaults];
                                [local setObject:self.scriptsPath.stringValue forKey:kDefaultScriptPath];
                                [local synchronize];
//                                NSAlert *alert = [[NSAlert alloc] init];
//                                [alert setMessageText:@"脚本已更新"];
//                                [alert addButtonWithTitle:@"确定"];
//                                [alert setInformativeText:@"自动化脚本更新完成"];
//                                [alert runModal];
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



#pragma mark

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSInteger num = 0;
    if (!item) {
        num = self.bookmarks.count;
    } else {
        ItemModel *itemObject = (ItemModel *)item;
        num = itemObject.subItems.count;
    }
    return num;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        item = self.bookmarks[index];
    } else {
        ItemModel *itemObject = (ItemModel *)item;
        item = itemObject.subItems[index];
    }
    return item;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    NSInteger num = 0;
    if (!item) {
        num = self.bookmarks.count;
    } else {
        ItemModel *itemObject = (ItemModel *)item;
        num = itemObject.subItems.count;
    }
    return num != 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return  YES;
}

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item {
    CustomTableCellView *cell = [CustomTableCellView cellWithTableView:outlineView owner:self];
    NSLog(@"item : %@",item);
    ItemModel *itemObject = (ItemModel *)item;
    cell.titleLabel.stringValue = itemObject.funName;
    return cell;
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
    CustomTableRowView *rowView = [CustomTableRowView rowViewWithTableView:outlineView];
    rowView.backgroundColor = [NSColor orangeColor];
    return rowView;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    //提供Staff的名字
    return @"hhh";
}

// 自定义行高
- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 30;
}
 
// 选择节点后的通知
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSLog(@"--");
    NSOutlineView *outlineView = notification.object;
    NSInteger row = [outlineView selectedRow];
    id model = [outlineView itemAtRow:row];
    NSLog(@"name = %@",model);

}
@end
