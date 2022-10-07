//
//  ItemObjectManager.h
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/20.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ItemObjectManager : NSObject
+ (NSMutableArray *)fetchBookmarkOject;
+ (void)addBookmarkObject:(ItemModel *)modelDic;
+ (void)removeBookmark:(ItemModel *)model;


+ (void)addDefaultBookmark:(ItemModel *)bookmarkModel;
+ (void)setDefaultBookmark:(ItemModel *)bookmarkModel;
+ (ItemModel *)fetchDefautlBookmark;

+ (void)updateAllFilePath;

+ (void)changeBookmarkWithSourceMode:(ItemModel *)bookmarkModel withKeyName:(NSString *)keyName;


@end

NS_ASSUME_NONNULL_END
