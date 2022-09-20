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
- (NSMutableArray *)getBookmarkOject;
- (void)addBookmarkObject:(ItemModel *)model;
- (void)setDefaultBookmark:(ItemModel *)bookmarkModel;
- (ItemModel *)getDefautlBookmark;
@end

NS_ASSUME_NONNULL_END
