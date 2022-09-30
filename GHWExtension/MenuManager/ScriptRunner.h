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
- (void)run:(NSString *)funcName params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
