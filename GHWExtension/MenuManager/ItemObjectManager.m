//
//  ItemObjectManager.m
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/20.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "ItemObjectManager.h"
#import "GHWExtensionConst.h"
#import "MJExtension.h"
@implementation ItemObjectManager

//-------------------------------插件中的单例和主程序中的单例完全是2个, 所以起不到单例的作用, 貌似唯一能通用的地方就是 NSUserDefault, 所有的增删改查 都要改NSUserDefault--------------------------------

+ (NSMutableArray *)fetchBookmarkOject {
    NSArray *temp =  [[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kBookmarksInfo]];
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
    for (NSData *data in temp) {
        ItemModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [bookmarks addObject:model];
    }
    
    return bookmarks;
}



+ (void)addBookmarkObject:(ItemModel *)newModel {
    NSMutableArray *temp = [self fetchBookmarkOject];
    ItemModel *defaultBookmark = nil;
    if (NSArrayCheck(temp)) {
        for (ItemModel *model in temp) {
            if (model.isDefault) {
                defaultBookmark = model;
                break;
            }
        }
        if (!defaultBookmark) {
            return;
        }
        NSMutableArray *defaultBookmarkFor = [[NSMutableArray alloc] initWithArray:defaultBookmark.subItems];
        if (NSArrayCheck(defaultBookmarkFor)) {
            BOOL isHave = NO;
            ItemModel *tempModel;
            for (ItemModel *model in defaultBookmarkFor) {
                if ([model.className isEqualToString:newModel.className]) {
                    isHave = YES;
                    tempModel = model;
                }
            }
            if (isHave) {
                if (NSArrayCheck(tempModel.subItems)) {
                    BOOL isSubHave = NO;
                    NSMutableArray *modelFor = [[NSMutableArray alloc] initWithArray:tempModel.subItems];
                    for (ItemModel *subModel in modelFor) {
                        if ([subModel.funcLocation isEqualToString:newModel.funcLocation]) {
                            isSubHave = YES;
                        }
                    }
                    if (!isSubHave){
                        [tempModel.subItems addObject:newModel];
                    }

                } else {
                    tempModel.subItems = [[NSMutableArray alloc] initWithArray:@[newModel]];
                }
            } else {
                ItemModel *tempNewModel = [[ItemModel alloc] init];
                tempNewModel.subItems = [[NSMutableArray alloc] initWithObjects:newModel, nil];
                tempNewModel.keyName = newModel.className;
                tempNewModel.className = newModel.className;
                [defaultBookmark.subItems addObject:tempNewModel];
            }

        } else {
            ItemModel *tempNewModel = [[ItemModel alloc] init];
            tempNewModel.subItems = [[NSMutableArray alloc] initWithObjects:newModel, nil];
            tempNewModel.keyName = newModel.className;
            tempNewModel.className = newModel.className;
            defaultBookmark.subItems = [[NSMutableArray alloc] initWithArray:@[tempNewModel]];
        }
    } else {
        [temp addObject:newModel];
        [ItemObjectManager updateAllBookmark:temp];
        [self setDefaultBookmark:newModel];
    }

    [ItemObjectManager updateAllBookmark:temp];
}

+ (void)removeBookmark:(ItemModel *)model{
    NSMutableArray *bookmarks = [self fetchBookmarkOject];
    NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:bookmarks];
    if (NSArrayCheck(temp)) {
        for (ItemModel *item in temp) {
            if ([model.funcLocation isEqualToString:item.funcLocation] || [model.keyName isEqualToString:item.keyName]) {
                [bookmarks removeObject:item];
                break;
            }
            NSMutableArray *subItemsTemp = [[NSMutableArray alloc]initWithArray:item.subItems];
            for (ItemModel *subItem in subItemsTemp) {
                if ([model.funcLocation isEqualToString:subItem.funcLocation] || [model.keyName isEqualToString:subItem.keyName]) {
                    [item.subItems removeObject:subItem];
                    break;
                }

                NSMutableArray *subsubItemsTemp = [[NSMutableArray alloc]initWithArray:subItem.subItems];
                for (ItemModel *subsubItem in subsubItemsTemp) {
                    if ([model.funcLocation isEqualToString:subsubItem.funcLocation] || [model.keyName isEqualToString:subsubItem.keyName]) {
                        [subItem.subItems removeObject:subsubItem];
                        break;
                    }
                }

            }
        }
    }

    [self updateAllBookmark:bookmarks];

    // 如果把default remove 掉了  就去第一个作为default
    if (![self fetchDefautlBookmark]) {
        NSMutableArray *bookmarks = [self fetchBookmarkOject];
        if (NSArrayCheck(bookmarks)) {
            ItemModel *item = (ItemModel *)bookmarks[0];
            item.isDefault = YES;
        }
        [self updateAllBookmark:bookmarks];
    }
}

+ (void)addDefaultBookmark:(ItemModel *)bookmarkModel {
    NSMutableArray *bookmarks = [self fetchBookmarkOject];
    NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:bookmarks];
    if (NSArrayCheck(temp)) {
        [bookmarks insertObject:bookmarkModel atIndex:0];
    } else {
        [bookmarks addObject:bookmarkModel];
    }
    
    [self updateAllBookmark:bookmarks];
}

+ (ItemModel *)fetchDefautlBookmark {
    NSMutableArray *temp = [self fetchBookmarkOject];
    ItemModel *defaultModel = nil;
    if (NSArrayCheck(temp)) {
        for (ItemModel *model in temp) {
            if (model.isDefault) {
                defaultModel = model;
                break;
            }
        }
    }
    return defaultModel;
}

+ (void)setDefaultBookmark:(ItemModel *)bookmarkModel {
    NSMutableArray *bookmarks = [self fetchBookmarkOject];
    if (NSArrayCheck(bookmarks)) {
        if (bookmarks.count == 1) {
            ItemModel *model = (ItemModel *)bookmarks[0];
            model.isDefault = YES;
        } else {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:bookmarks];
            for (int n = 0; n < temp.count; n++) {
                ItemModel *model = (ItemModel *)temp[n];
                if ([model.keyName isEqualToString:bookmarkModel.keyName]) {
                    model.isDefault = YES;
                    [bookmarks exchangeObjectAtIndex:n withObjectAtIndex:0];
                } else {
                    model.isDefault = NO;
                }
            }
        }

    }
    [self updateAllBookmark:bookmarks];
}

+ (void)changeBookmarWithSourceMode:(ItemModel *)bookmarkModel withKeyName:(NSString *)keyName{
    NSMutableArray *bookmarks = [self fetchBookmarkOject];
    NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:bookmarks];
    if (NSArrayCheck(temp)) {
        for (ItemModel *item in temp) {
            if ([bookmarkModel.funcLocation isEqualToString:item.funcLocation] || [bookmarkModel.keyName isEqualToString:item.keyName]) {
                if (![self isHaveSameNameBookmark:keyName]){
                    item.keyName = keyName;
                }
                
                break;
            }
            NSMutableArray *subItemsTemp = [[NSMutableArray alloc]initWithArray:item.subItems];
            for (ItemModel *subItem in subItemsTemp) {
                if ([bookmarkModel.funcLocation isEqualToString:subItem.funcLocation] || [bookmarkModel.keyName isEqualToString:subItem.keyName]) {
                    subItem.keyName = keyName;
                    break;
                }

                NSMutableArray *subsubItemsTemp = [[NSMutableArray alloc]initWithArray:subItem.subItems];
                for (ItemModel *subsubItem in subsubItemsTemp) {
                    if ([bookmarkModel.funcLocation isEqualToString:subsubItem.funcLocation] || [bookmarkModel.keyName isEqualToString:subsubItem.keyName]) {
                        subsubItem.keyName = keyName;
                        break;
                    }
                }

            }
        }
    }

    [self updateAllBookmark:bookmarks];
}

+ (BOOL)isHaveSameNameBookmark:(NSString *)keyName {
    BOOL isHave = NO;
    NSMutableArray *bookmarks = [self fetchBookmarkOject];
    for (ItemModel *item in bookmarks) {
        if ([item.keyName isEqualToString:keyName]) {
            isHave = YES;
        }
    }
    return isHave;
}


+ (void)updateAllBookmark:(NSMutableArray *)itemModels {
    NSMutableArray *bookmarks = [[NSMutableArray alloc] init];
    for (ItemModel *model in itemModels) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [bookmarks addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:kBookmarksInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
