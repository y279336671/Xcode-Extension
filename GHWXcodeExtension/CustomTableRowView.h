//
//  CustomTableRowView.h
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/19.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableRowView : NSTableRowView
+ (instancetype)rowViewWithTableView:(NSTableView *)tableView;
@end

NS_ASSUME_NONNULL_END
