//
//  ViewController.m
//  GHWXcodeExtension
//
 

#import "ViewController.h"
#import "ItemModel.h"
#import "CustomTableRowView.h"
#import "CustomTableCellView.h"
#import "ScriptRunner.h"
#import "GHWExtensionConst.h"
#import "ItemObjectManager.h"
#define  kDefaultProjectPath @"kDefaultProjectPath"
#define  kDefaultScriptPath  @"kDefaultScriptPath"


@interface ViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (weak) IBOutlet NSTextField *scriptsPath;
@property (weak) IBOutlet NSTextField *projectPath;
@property (weak) IBOutlet NSOutlineView *contentOutlineView;
@property (weak) IBOutlet NSTextField *changeKeyNameTextField;

@property (weak) IBOutlet NSButton *changeButton;
- (IBAction)changeKeyName:(id)sender;

@property (nonatomic, strong) ItemModel *curSelectedModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *local = [NSUserDefaults standardUserDefaults];
    NSString *projectPath = [local stringForKey:kDefaultProjectPath];
    NSString *scriptPath = [local stringForKey:kDefaultScriptPath];
    self.projectPath.stringValue = projectPath != nil ? projectPath : @"";
    self.scriptsPath.stringValue = scriptPath != nil ? scriptPath : @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindOutlineView) name:NSApplicationWillBecomeActiveNotification object:nil];
    
    [self bindOutlineView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"test"];
     NSLog(@"**************%@", obj);
}

- (void)bindOutlineView {
    [self.contentOutlineView reloadData];
}


- (void)createBookmark:(NSString *)bookmarkName {
    // 查找重名
    NSMutableArray *bookmarks =  [ItemObjectManager fetchBookmarkOject];;
    if (bookmarks && bookmarks.count > 0) {
        BOOL isContain = NO;
        for (ItemModel *model in bookmarks) {
            if ([model.keyName isEqualToString:bookmarkName]) {
                isContain = YES;
                break;
            }
        }
        
        if (isContain) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"包含同名书签"];
            [alert addButtonWithTitle:@"确定"];
            [alert runModal];
        } else {
            ItemModel *model = [[ItemModel alloc] init];
            model.keyName = bookmarkName;
            [ItemObjectManager addDefaultBookmark:model];
            
        }
    } else {
        
        ItemModel *model = [[ItemModel alloc] init];
        model.keyName = bookmarkName;
        [ItemObjectManager addDefaultBookmark:model];
    }
}

- (void)removeBookmarks {
    [ItemObjectManager removeBookmark:self.curSelectedModel];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)testScript:(id)sender {
//    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"test"];
//    NSLog(@"%@", obj);
//
//    [[ScriptRunner sharedInstane] run:@"openFileToFunc" inputString:@"TBCLaunchADViewController1111.m:20"];

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

#pragma mark

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSInteger num = 0;
    if (!item) {
        num = [ItemObjectManager fetchBookmarkOject].count;
    } else {
        ItemModel *itemObject = (ItemModel *)item;
        num = itemObject.subItems.count;
    }
    return num;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        item = [ItemObjectManager fetchBookmarkOject][index];
    } else {
        ItemModel *itemObject = (ItemModel *)item;
        item = itemObject.subItems[index];
    }
    return item;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    NSInteger num = 0;
    if (!item) {
        num = [ItemObjectManager fetchBookmarkOject].count;
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
    
    cell.titleLabel.stringValue = itemObject.keyName ? itemObject.keyName :itemObject.funName;
    return cell;
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
    CustomTableRowView *rowView = [CustomTableRowView rowViewWithTableView:outlineView];
    rowView.backgroundColor = [NSColor orangeColor];
    return rowView;
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
    ItemModel *model = [outlineView itemAtRow:row];
    NSLog(@"name = %@",model);
    self.curSelectedModel = model;

}
- (IBAction)removeBookmarkAction:(id)sender {
    [self removeBookmarks];
}

- (IBAction)addBookmarkAction:(id)sender {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger time = interval;
    NSString *bookmark = [NSString stringWithFormat:@"书签1%zd",time];
    [self createBookmark:bookmark];
}

- (IBAction)changeKeyName:(id)sender {
//
    if (self.curSelectedModel && NSStringCheck(self.changeKeyNameTextField.stringValue)) {
        [ItemObjectManager changeBookmarWithSourceMode:self.curSelectedModel withKeyName:self.changeKeyNameTextField.stringValue];
    }
    
}
@end
