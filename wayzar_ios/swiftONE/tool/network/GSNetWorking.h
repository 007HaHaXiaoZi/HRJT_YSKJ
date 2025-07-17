//
//  GSNetWorking.h
//  QingProduct
//
//  Created by LiuGaoSheng on 2021/7/19.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);


@interface GSNetWorking : NSObject

//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//原生携带token请求 GET网络请求
+ (void)getAuthorizationWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostAuthorizationWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getCouponWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)postCouponWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)patchCouponWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
