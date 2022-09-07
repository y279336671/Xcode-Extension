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
    
    NSArray *lines = [[NSArray alloc] initWithArray:invocation.buffer.lines];
    NSLog(@"startLine = %ld, endLine = %ld, startColumn = %ld, endColumn = %ld, funName = %@", startLine, endLine, startColumn, endColumn, funName);
    
    NSString *funcLocation = @"";
    NSString *className = @"";
    for (int n = 0; n < lines.count; n++) {
        NSString *tempLine = lines[n];
        if ([tempLine containsString:@"@implementation"] || [tempLine containsString:@"@interface"]) {
            NSArray *tempLineArray = [tempLine componentsSeparatedByString:@" "];
            if (tempLineArray.count >= 2) {
                NSString *suffix = [tempLine containsString:@"@interface"] ? @".h" : @".m";
                className = [NSString stringWithFormat:@"%@%@", tempLineArray[1], suffix];
                funcLocation = [NSString stringWithFormat:@"%@:%ld",className, (long)startLine];
            }
        }
    }
    NSLog(@"className = %@ ,funName = %@ , funcLocation = %@",className, funName ,funcLocation);
    // 列表名称,用户自定义
        // 类名
            // 方法名
    
    
    
    //    NSMutableDictionary *classObject = [[NSMutableDictionary alloc] initWithDictionary:@{
    //        className:@{
    //        }
    //    }];
    //    [[classObject objectForKey:className]  addEntriesFromDictionary:funObject];
    //    NSLog(@"%@", classObject);
    //    NSUserDefaults *local = [NSUserDefaults standardUserDefaults];
    
    
    
    // 1. 获取收藏方法名称
    // 2. 解析类名 (类名要和文件名称相同)
    // 3. 手动设置项目根目录 ✅
    // 4. 根据类名扫根目录里面的文件.
    // 5. 通过apple script 调用当前xCode 打开文件并定位到当前行数
    // 6. todo 将选中数据发给 主窗口
    
    
    //    {
    //        "列表名字": {
    //            "类名":{
    //                "方法名1":{
    //                    "lineNum":52,
    //                    "columnNum":100
    //                },
    //                "方法名2":{
    //                    "lineNum":52,
    //                    "columnNum":100
    //                }
    //            }
    //        }
    //    }
}
@end
