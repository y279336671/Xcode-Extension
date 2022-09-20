//
//  ItemObjectManager.m
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/20.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "ItemObjectManager.h"
#import "GHWExtensionConst.h"
@implementation ItemObjectManager
+ (ItemObjectManager *)sharedInstane {
    static dispatch_once_t predicate;
    static ItemObjectManager * sharedInstane;
    dispatch_once(&predicate, ^{
        sharedInstane = [[ItemObjectManager alloc] init];
    });
    return sharedInstane;
}
- (NSMutableArray *)getBookmarkOject {
    NSArray *temp =  [[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kBookmarksInfo]];
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
    for (NSData *data in temp) {
        ItemModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [bookmarks addObject:model];
    }
    
    return bookmarks;
}

- (void)addBookmarkObject:(ItemModel *)model {
    
    NSData *modelObject = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSMutableArray *tempObject = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kBookmarksInfo]];
    [tempObject addObject:modelObject];
    [[NSUserDefaults standardUserDefaults] setObject:tempObject forKey:kBookmarksInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDefaultBookmark:(ItemModel *)bookmarkModel {
    NSMutableArray *bookmarks = [[ItemObjectManager sharedInstane] getBookmarkOject];
    if (bookmarks && bookmarks.count > 0) {
        for (ItemModel *model in bookmarks) {
            if (model.keyName!=nil && model.keyName.length>0 && [model.keyName isEqualToString:bookmarkModel.keyName]) {
                model.isDefault = YES;
            }
            [self addBookmarkObject:model];
        }
    }
}

- (ItemModel *)getDefautlBookmark {
    ItemModel *defaultModel = nil;
    NSMutableArray *bookmarks = [[ItemObjectManager sharedInstane] getBookmarkOject];
    if (bookmarks && bookmarks.count > 0) {
        for (ItemModel *model in bookmarks) {
            if (model.isDefault) {
                defaultModel = model;
                break;
            }
        }
    }
    return defaultModel;
}
@end
