//
//  CustomTableCellView.h
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/19.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableCellView : NSTableCellView
@property (nonatomic, strong) NSTextField *titleLabel;
+ (instancetype)cellWithTableView:(NSTableView *)tableView owner:(id)owner;
@end

NS_ASSUME_NONNULL_END
