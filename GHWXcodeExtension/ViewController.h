//
//  ViewController.h
//  GHWXcodeExtension
//
 

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (weak) IBOutlet NSTextField *scriptsPath;
@property (weak) IBOutlet NSTextField *projectPath;
@property (weak) IBOutlet NSOutlineView *contentTableView;

@end

