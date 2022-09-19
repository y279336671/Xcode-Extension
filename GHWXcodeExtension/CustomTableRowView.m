#import "CustomTableRowView.h"
 
@implementation CustomTableRowView
 
static NSString * customTableRowViewID = @"customTableRowViewID";
 
+ (instancetype)rowViewWithTableView:(NSTableView *)tableView {
    CustomTableRowView *rowView = [tableView makeViewWithIdentifier:customTableRowViewID owner:self];
    if (!rowView) {
        rowView = [[CustomTableRowView alloc]init];
        rowView.identifier = customTableRowViewID;
    }
    return rowView;
}
 
//自定义 row 背景色
- (void)setBackgroundColor:(NSColor *)backgroundColor {
    super.backgroundColor = [NSColor whiteColor];
//    super.backgroundColor = [NSColor orangeColor];
}
 
// 自定义 row 被选中的背景色
- (void)drawSelectionInRect:(NSRect)dirtyRect{
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        [[NSColor lightGrayColor] setFill];
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:NSInsetRect(self.bounds, 0, 0)];
        [path fill];
        [path stroke];
    }
}
 
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
 
@end
