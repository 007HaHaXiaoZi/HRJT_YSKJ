//
//  KeyChainStore.h
//  swiftONE
//
//  Created by Candy.Yuan on 2023/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject
+ (void)save:(NSString*)service data:(id)data;
+ (id)load:(NSString*)service;
+ (void)deleteKeyData:(NSString*)service;
@end

NS_ASSUME_NONNULL_END
