//
//  ScriptRunner.h
//  GHWExtension
//
 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScriptRunner : NSObject
+ (ScriptRunner *)sharedInstane;
- (void)run:(NSString *)funcName;
@end

NS_ASSUME_NONNULL_END
