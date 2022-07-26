//
//  MenuManager.h
//  GHWExtension
//
 

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>
#import "MenuInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuManager : NSObject

+ (MenuManager *)sharedInstane;

@property (nonatomic, strong) NSArray *menuArray;

- (MenuInfo *)findMenuInfo:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
