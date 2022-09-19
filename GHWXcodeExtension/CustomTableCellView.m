#import "CustomTableCellView.h"
 
@implementation CustomTableCellView
 
static NSString * CustomTableCellID = @"CustomTableCellID";
 
+ (instancetype)cellWithTableView:(NSTableView *)tableView owner:(id)owner {
    CustomTableCellView *cell = [tableView makeViewWithIdentifier:CustomTableCellID owner:owner];
    if (!cell) {
        cell = [[CustomTableCellView alloc]init];
        cell.identifier = CustomTableCellID;
        [cell setUpViews];
    }
    return cell;
}
 
- (void)setUpViews {
    //UILabel 在Mac下不存在;Mac 使用NSTextField代替，设置为不可以编辑，不可选中
    NSTextField *titleLabel = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 200, 30)];
    [self addSubview:titleLabel];
    titleLabel.stringValue = @"123";
    titleLabel.editable = NO;
    titleLabel.bordered = NO;
    self.titleLabel = titleLabel;
    
    //在MacOS 开发中视图本身没有提供背景颜色,边框,圆角等属性。但是可以利用layer属性来控制这些效果,使用这些属性之前必须设置其属性wantsLayer为YES
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
}
 
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
 
@end
