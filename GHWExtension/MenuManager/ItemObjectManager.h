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
+ (void)addBookmarkObject:(NSMutableDictionary *)modelDic;
+ (void)removeBookmark:(ItemModel *)model;

+ (void)setDefaultBookmark:(ItemModel *)bookmarkModel;
+ (ItemModel *)fetchDefautlBookmark;



@end

NS_ASSUME_NONNULL_END
