//
//  ItemModel.m
//  GHWXcodeExtension
//
//  Created by yanghe04 on 2022/9/19.
//  Copyright © 2022 Jingyao. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel



- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.startLine forKey:@"startLine"];
    [coder encodeObject:self.endLine forKey:@"endLine"];
    [coder encodeObject:self.startColumn forKey:@"startColumn"];
    [coder encodeObject:self.endColumn forKey:@"endColumn"];
    [coder encodeObject:self.funName forKey:@"funName"];
    [coder encodeObject:self.className forKey:@"className"];
    [coder encodeObject:self.funcLocation forKey:@"funcLocation"];
    [coder encodeObject:self.keyName forKey:@"keyName"];
    [coder encodeObject:self.subItems forKey:@"subItems"];
    [coder encodeObject:self.filePath forKey:@"filePath"];
    [coder encodeObject:[NSNumber numberWithBool:self.isDefault] forKey:@"isDefault"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.startLine = [coder decodeObjectForKey:@"startLine"];
        self.endLine = [coder decodeObjectForKey:@"endLine"];
        self.startColumn = [coder decodeObjectForKey:@"startColumn"];
        self.endColumn = [coder decodeObjectForKey:@"endColumn"];
        self.funName = [coder decodeObjectForKey:@"funName"];
        self.className = [coder decodeObjectForKey:@"className"];
        self.funcLocation = [coder decodeObjectForKey:@"funcLocation"];
        self.keyName = [coder decodeObjectForKey:@"keyName"];
        self.subItems = [coder decodeObjectForKey:@"subItems"];
        self.filePath = [coder decodeObjectForKey:@"filePath"];
        self.isDefault = [[coder decodeObjectForKey:@"isDefault"] boolValue];
    }
    return self;
}
@end
