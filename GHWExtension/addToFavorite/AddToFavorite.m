//
//  AddToFavorite.m
//  GHWExtension
//
//  Created by yanghe04 on 2022/8/23.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "AddToFavorite.h"
#import "GHWExtensionConst.h"
#import "ItemObjectManager.h"
#import "ItemModel.h"
#import "MJExtension.h"
#import "EGOCache.h"
@implementation AddToFavorite
- (NSString *)menuTitle {
    return @"addToFavorite";
}

- (void)processCodeWithInvocation:(XCSourceEditorCommandInvocation *)invocation {
    NSMutableArray *bookmarks = [ItemObjectManager fetchBookmarkOject];
    if (!NSArrayCheck(bookmarks)) {
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
    NSString *className = @"";
    for (int n = 0; n < lines.count; n++) {
        NSString *tempLine = lines[n];
        if ([tempLine containsString:@"@implementation"] || [tempLine containsString:@"@interface"]) {
            NSArray *tempLineArray = [tempLine componentsSeparatedByString:@" "];
            if (tempLineArray.count >= 2) {
                NSString *suffix = [tempLine containsString:@"@interface"] ? @".h" : @".m";
                NSString *tempClassName = [tempLineArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                className = [NSString stringWithFormat:@"%@%@", tempClassName, suffix];
                funcLocation = [NSString stringWithFormat:@"%@:%ld",className, (long)startLine];
                break;
            }
        }
    }
    NSLog(@"className = %@ ,funName = %@ , funcLocation = %@",className, funName ,funcLocation);
    NSLog(@"<<<<<<<<<<<");
    NSDictionary *itemInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%ld", (long)startLine], @"startLine",
                              [NSString stringWithFormat:@"%ld", (long)endLine], @"endLine",
                              [NSString stringWithFormat:@"%ld", (long)startColumn], @"startColumn",
                              [NSString stringWithFormat:@"%ld", (long)endColumn], @"endColumn",
                              [NSString stringWithFormat:@"%@", funName], @"funName",
                              [NSString stringWithFormat:@"%@", className], @"className",
                              [NSString stringWithFormat:@"%@", funcLocation], @"funcLocation",
                              nil];
    ItemModel *model = [ItemModel mj_objectWithKeyValues:itemInfo];
    [ItemObjectManager addBookmarkObject:model];

}


@end
