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

+ (void)addBookmarkObject:(ItemModel *)newModel {
//    ItemModel *newModel = [ItemModel mj_objectWithKeyValues:modelDic];
    NSMutableArray *temp = [self fetchBookmarkOject];
    ItemModel *defaultBookmark = nil;
    if (NSArrayCheck(temp)) {
        for (ItemModel *model in temp) {
            if (model.isDefault) {
                defaultBookmark = model;
                break;
            }
        }
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
                NSMutableArray *modelFor = [[NSMutableArray alloc] initWithArray:tempModel.subItems];
                for (ItemModel *subModel in modelFor) {
                    if (![subModel.funcLocation isEqualToString:newModel.funcLocation]) {
                        [tempModel.subItems addObject:newModel];
                    }
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
    [ItemObjectManager updateAllBookmark:temp];
}

+ (void)removeBookmark:(ItemModel *)model{
    NSMutableArray *temp = [self fetchBookmarkOject];
    if (NSArrayCheck(temp)) {
        for (ItemModel *item in temp) {
            if ([model.funcLocation isEqualToString:item.funcLocation] || [model.keyName isEqualToString:item.keyName]) {
                [temp removeObject:item];
            }
        }
    }
    [self updateAllBookmark:temp];
}

+ (void)setDefaultBookmark:(ItemModel *)bookmarkModel {
    NSMutableArray *temp = [self fetchBookmarkOject];
    if (NSArrayCheck(temp)) {
        BOOL isDefaultIn = NO;
        for (ItemModel *model in temp) {
            if (NSStringCheck(model.keyName) && [model.keyName isEqualToString:bookmarkModel.keyName]) {
                model.isDefault = YES;
                isDefaultIn = YES;
            }
        }
        if (!isDefaultIn) {
            [temp insertObject:bookmarkModel atIndex:0];
        }
    }else {
        bookmarkModel.isDefault = YES;
        [temp addObject:bookmarkModel];
    }
    [self updateAllBookmark:temp];
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
