//
//  ViewController.h
//  GHWXcodeExtension
//
 

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController


- (IBAction)addBookmarkAction:(id)sender;
- (IBAction)removeBookmarkAction:(id)sender;
@property (weak) IBOutlet NSTextFieldCell *messageText;

@end

