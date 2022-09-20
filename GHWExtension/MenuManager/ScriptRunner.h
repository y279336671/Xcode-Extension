//
//  ScriptRunner.h
//  GHWExtension
//
 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScriptRunner : NSObject
+ (ScriptRunner *)sharedInstane;
- (void)run:(NSString *)funcName;
- (void)run:(NSString *)funcName inputString:(NSString *)inputString;
@end

NS_ASSUME_NONNULL_END
