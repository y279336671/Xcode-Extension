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
+ (ItemObjectManager *)sharedInstane;

@property (nonatomic, strong) NSMutableArray *bookmarkModels;

- (void)addBookmarkObject:(ItemModel *)model;
- (void)removeBookmark:(ItemModel *)model;
- (void)setDefaultBookmark:(ItemModel *)bookmarkModel;
- (ItemModel *)getDefautlBookmark;
- (void)updateAllBookmark;
@end

NS_ASSUME_NONNULL_END
