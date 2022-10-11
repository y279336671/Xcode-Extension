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
#import "FullDiskAccessAuthorizer.h"
#import "EGOCache.h"

@interface ViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (weak) IBOutlet NSTextField *scriptsPath;
@property (weak) IBOutlet NSTextField *projectPath;
@property (weak) IBOutlet NSOutlineView *contentOutlineView;
@property (weak) IBOutlet NSTextField *changeKeyNameTextField;
@property (weak) IBOutlet NSButton *changeButton;

@property (nonatomic, strong) ItemModel *curSelectedModel;

- (IBAction)changeKeyName:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *projectPath = [[EGOCache globalCache] stringForKey:kDefaultProjectPath];
    NSString *scriptPath = [[EGOCache globalCache] stringForKey:kDefaultScriptPath];
    self.projectPath.stringValue = projectPath != nil ? projectPath : @"";
    self.scriptsPath.stringValue = scriptPath != nil ? scriptPath : @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindOutlineView) name:NSApplicationWillBecomeActiveNotification object:nil];
    
    [self bindOutlineView];
    [ItemObjectManager updateAllFilePath];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear {
  
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
//            [ItemObjectManager setDefaultBookmark:model];
            
        }
    } else {
        
        ItemModel *model = [[ItemModel alloc] init];
        model.keyName = bookmarkName;
        model.isDefault = YES;
        [ItemObjectManager addDefaultBookmark:model];
//        [ItemObjectManager setDefaultBookmark:model];
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
    // todo 扫所有目录结构, 定时扫.
    FullDiskAccessAuthorizer *fullDiskAccessAuthorizer = [FullDiskAccessAuthorizer sharedInstance];
    [fullDiskAccessAuthorizer requestAuthorization];
    NSLog(@"%d", fullDiskAccessAuthorizer.authorizationStatus);
//    int value = arc4random() % 5;
//    NSArray *testPath = @[@"/Users/yanghe/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/LaunchRelated/TBCLaunchADViewController.m",
//            @"/Users/yanghe/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/TBCInterstitialADManager.m",
//            @"/Users/yanghe/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/TBCLaunchADStatLogHelper.m",
//            @"/Users/yanghe/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/TBCBearParamsGetter.m",
//            @"/Users/yanghe/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/NetworkMonitor/TBCNetworkMonitorManager.m"];
//    NSArray *lineNums = @[@"20",
//            @"100",
//            @"5",
//            @"200",
//            @"70"];
//    self.messageText.stringValue = [NSString stringWithFormat:@"%@, %@", testPath[value], lineNums[value]];
//
//    [[ScriptRunner sharedInstane] run:@"openFileToFuncWithLineNum" params:@{
//            @"classPath":testPath[value],
//            @"lineNumber":lineNums[value]
//    }];

//    NSArray *testPath = @[@"xed -l 100 /Users/yanghe04/code/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/LaunchRelated/TBCLaunchADViewController.m",
//                          @"xed -l 20 /Users/yanghe04/code/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/TBCInterstitialADManager.m",
//                          @"xed -l 230 /Users/yanghe04/code/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/TBCLaunchADStatLogHelper.m",
//                          @"xed -l 10 /Users/yanghe04/code/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/TBCAD/TBCBearParamsGetter.m",
//                          @"xed -l 90 /Users/yanghe04/code/baidu/tieba-ios/tbapp/Services/IDK/Sources/CommonService/NetworkMonitor/TBCNetworkMonitorManager.m"];
//
//    [[ScriptRunner sharedInstane] run:@"dododoShell" inputString:testPath[value]];
}

- (IBAction)testScript1:(id)sender {
//    int value = arc4random() % 5;
//        NSArray *testClassNamme = @[@"TBCLaunchADViewController.m:20", @"TBCLaunchADViewController.m:800", @"TBCTabMyViewController.m:520", @"BDTBSMPlayerController.m:310", @"TBClientAppDelegate.m:909"];
//        [[ScriptRunner sharedInstane] run:@"openFileToFunc" inputString:testClassNamme[value]];


}


- (void)runShellWithCommand:(NSString *)command completeBlock:(dispatch_block_t)completeBlock{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath: @"/bin/sh"];
        NSArray *arguments;
        arguments = [NSArray arrayWithObjects:@"-c",command, nil];
        [task setArguments: arguments];
        [task launch];
        [task waitUntilExit];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
        });
    });
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
            [[EGOCache globalCache] setString:self.projectPath.stringValue forKey:kDefaultProjectPath];
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
                    [[EGOCache globalCache] setString:self.scriptsPath.stringValue forKey:kDefaultScriptPath];
                    [[EGOCache globalCache] removeCacheForKey:@"NSNavLastRootDirectory"];
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
                                [[EGOCache globalCache] setString:self.scriptsPath.stringValue forKey:kDefaultScriptPath];
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
    NSOutlineView *outlineView = notification.object;
    NSInteger row = [outlineView selectedRow];
    ItemModel *model = [outlineView itemAtRow:row];
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
    if (self.curSelectedModel && NSStringCheck(self.changeKeyNameTextField.stringValue)) {
        [ItemObjectManager changeBookmarkWithSourceMode:self.curSelectedModel withKeyName:self.changeKeyNameTextField.stringValue];
    }
}
@end
