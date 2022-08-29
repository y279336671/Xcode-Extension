//
//  AddToFavorite.m
//  GHWExtension
//
//  Created by yanghe04 on 2022/8/23.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "AddToFavorite.h"

@implementation AddToFavorite
- (NSString *)menuTitle {
    return @"addToFavorite";
}

- (void)processCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation {
   
    XCSourceTextRange *textRange = invocation.buffer.selections[0];
    NSInteger startLine = textRange.start.line;
    NSInteger endLine = textRange.end.line;
    NSInteger startColumn = textRange.start.column;
    NSInteger endColumn = textRange.end.column;
    
    NSString *funName = invocation.buffer.lines[startLine];
    
    NSLog(@"%@", invocation);
    
    
    // 1. 获取收藏方法名称
    // 2. 解析类名 (类名要和文件名称相同)
    // 3. 手动设置项目根目录
    // 4. 根据类名扫根目录里面的文件.
    // 6. 通过apple script 调用当前xCode 打开文件并定位到当前行数
    //todo 将选中数据发给 主窗口
}
@end
