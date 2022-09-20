//
//  ItemModel.h
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/19.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *startLine;
@property (nonatomic, copy) NSString *endLine;
@property (nonatomic, copy) NSString *startColumn;
@property (nonatomic, copy) NSString *endColumn;
@property (nonatomic, copy) NSString *funName;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *funcLocation;

@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, strong) NSMutableArray *subItems;
@end

NS_ASSUME_NONNULL_END
