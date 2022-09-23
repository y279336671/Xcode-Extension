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

//-------------------------------插件中的单例和主程序中的单例完全是2个, 所以起不到单例的作用, 貌似唯一能通用的地方就是 NSUserDefault, 所有的增删改查 都要改NSUserDefault--------------------------------

+ (ItemObjectManager *)sharedInstane {
    static dispatch_once_t predicate;
    static ItemObjectManager * sharedInstane;
    dispatch_once(&predicate, ^{
        sharedInstane = [[ItemObjectManager alloc] init];
    });
    return sharedInstane;
}

- (NSMutableArray *)bookmarkModels {
    if (!_bookmarkModels) {
        
        _bookmarkModels = [self getBookmarkOject];
    }
    return _bookmarkModels;
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


- (ItemModel *)getDefautlBookmark {
    ItemModel *defaultModel = nil;
    if (self.bookmarkModels && self.bookmarkModels.count > 0) {
        for (ItemModel *model in self.bookmarkModels) {
            if (model.isDefault) {
                defaultModel = model;
                break;
            }
        }
    }
    return defaultModel;
}

- (void)addBookmarkObject:(ItemModel *)model {
    [self.bookmarkModels insertObject:model atIndex:0];
    [self updateAllBookmark];
}

- (void)removeBookmark:(ItemModel *)model{
    [self.bookmarkModels removeObject:model];
    [self updateAllBookmark];
}

- (void)setDefaultBookmark:(ItemModel *)bookmarkModel {
    if (self.bookmarkModels && self.bookmarkModels.count > 0) {
        BOOL isDefaultIn = NO;
        for (ItemModel *model in self.bookmarkModels) {
            if (model.keyName!=nil && model.keyName.length>0 && [model.keyName isEqualToString:bookmarkModel.keyName]) {
                model.isDefault = YES;
                isDefaultIn = YES;
            }
        }
        if (!isDefaultIn) {
            [self.bookmarkModels insertObject:bookmarkModel atIndex:0];
        }
    }
    [self updateAllBookmark];
}

- (void)updateAllBookmark {
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
    for (ItemModel *model in self.bookmarkModels) { 
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [bookmarks addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:kBookmarksInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
