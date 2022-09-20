//
//  AddToFavorite.m
//  GHWExtension
//
//  Created by yanghe04 on 2022/8/23.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "AddToFavorite.h"
#import <Cocoa/Cocoa.h>

@implementation AddToFavorite
- (NSString *)menuTitle {
    return @"addToFavorite";
}

- (void)processCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation {
    NSArray *bookmarks = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"kBookmarksInfo"];
    if (!bookmarks || bookmarks.count == 0) {
        // 没有创建书签就什么也不做
        return;
    }
    
    XCSourceTextRange *textRange = invocation.buffer.selections[0];
    NSInteger startLine = textRange.start.line;
    NSInteger endLine = textRange.end.line;
    NSInteger startColumn = textRange.start.column;
    NSInteger endColumn = textRange.end.column;
    
    NSString *funName = invocation.buffer.lines[startLine];
    
    NSArray *lines = [[NSArray alloc] initWithArray:invocation.buffer.lines];
    NSLog(@"startLine = %ld, endLine = %ld, startColumn = %ld, endColumn = %ld, funName = %@", startLine, endLine, startColumn, endColumn, funName);
    
    NSString *funcLocation = @"";
    NSString *fullClassName = @"";
    for (int n = 0; n < lines.count; n++) {
        NSString *tempLine = lines[n];
        if ([tempLine containsString:@"@implementation"] || [tempLine containsString:@"@interface"]) {
            NSArray *tempLineArray = [tempLine componentsSeparatedByString:@" "];
            if (tempLineArray.count >= 2) {
                NSString *suffix = [tempLine containsString:@"@interface"] ? @".h" : @".m";
                NSString *className = [tempLineArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                fullClassName = [NSString stringWithFormat:@"%@%@", className, suffix];
                funcLocation = [NSString stringWithFormat:@"%@:%ld",fullClassName, (long)startLine];
                break;
            }
        }
    }
    NSLog(@"className = %@ ,funName = %@ , funcLocation = %@",fullClassName, funName ,funcLocation);
    
    NSMutableDictionary *itemInfo = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"startLine":[NSString stringWithFormat:@"%ld", (long)startLine],
        @"endLine":[NSString stringWithFormat:@"%ld", (long)endLine],
        @"startColumn":[NSString stringWithFormat:@"%ld", (long)startColumn],
        @"endColumn":[NSString stringWithFormat:@"%ld", (long)endColumn],
        @"funName":[NSString stringWithFormat:@"%@", funName],
        @"className":[NSString stringWithFormat:@"%@", fullClassName],
        @"funcLocation":[NSString stringWithFormat:@"%@", funcLocation],
    }];
    
    // 1. 先检查是否有书签列表 -> 列表第一层, 由用户手动创建.
    // 2. 检查是否有重名类名. 有 -> 直接加到对应类名下面, 没有 -> 创建第二层列表

    // todo 先去出来 ,再拼接上
    [[NSUserDefaults standardUserDefaults] setObject:itemInfo forKey:@"kItemInfo"];
    
}


@end
