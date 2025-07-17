//
//  THTNetWorkingManger.m
//  THTAPP
//
//  Created by LiuGaoSheng on 2021/8/23.
//

#import "THTNetWorkingManger.h"
#import "SVProgressHUD.h"
#import "URL.h"
#import "Macro.h"

@implementation THTNetWorkingManger
+ (void)PostRndUserSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self PostAuthorizationWithURL:[NSString stringWithFormat:@"%@%@",Base_Product_Url,THT_Openid_Url] Params:params success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}

+ (void)GetSpotsSettingSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self getAuthorizationWithURL:[NSString stringWithFormat:@"%@%@",Base_Product_Url,THT_Spots_Url] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
    
}
+ (void)GetPuzzleGameSettingSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self getAuthorizationWithURL:[NSString stringWithFormat:@"%@%@%@",Base_Product_Url,THT_Puzzle_Setting,THT_Puzzle_AppActivityUuid] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}

+ (void)GetPuzzleGameCollectedSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self getAuthorizationWithURL:[NSString stringWithFormat:@"%@%@?activityUuid=%@&openId=%@",Base_Product_Url,THT_Puzzle_collectioned,THT_Puzzle_AppActivityUuid,[[NSUserDefaults standardUserDefaults] objectForKey:THT_Test_AppOpenId]] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}

+ (void)PostPuzzleGameCollectWithSn:(NSString *)sn SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"activityUuid"] = THT_Puzzle_AppActivityUuid;
    params[@"openId"] = [[NSUserDefaults standardUserDefaults] objectForKey:THT_Test_AppOpenId];
    params[@"sn"] = sn;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self PostAuthorizationWithURL:[NSString stringWithFormat:@"%@%@",Base_Product_Url,THT_Puzzle_collectioned] Params:params success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}
///获取ibaken点位信息
+ (void)PostIbakenSettingWithSpotsUuid:(NSArray *)spotUuids SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"spotUuids"] = spotUuids;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self PostAuthorizationWithURL:[NSString stringWithFormat:@"%@%@",Base_Product_Url,THT_Spots_Url] Params:params success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}
+ (void)GetSpriteGameSettingSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self getAuthorizationWithURL:[NSString stringWithFormat:@"%@%@?activityUuid=%@",Base_Product_Url,THT_Sprite_Setting,THT_Spirit_AppActivityUuid] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}

+ (void)GetPetGameSettingWithActivityUuid:(NSString *)activityUuid SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self getAuthorizationWithURL:[NSString stringWithFormat:@"%@%@?activityUuid=%@",Base_Product_Url,THT_Pet_Setting,activityUuid] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
    
}

+ (void)PostPetGameCollectsWithPetId:(NSString *)petId SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"activityUuid"] = THT_Pet_AppActivityUuid;
        params[@"openId"] = [[NSUserDefaults standardUserDefaults] objectForKey:THT_Test_AppOpenId];
        params[@"petId"] = petId;
    //
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [SVProgressHUD show];
        [self PostAuthorizationWithURL:[NSString stringWithFormat:@"%@%@",Base_Product_Url,THT_Pet_Collects] Params:params success:^(id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                SuccessHandler(responseObject);
            });
        } failure:^(NSString * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                FaildedHandler(error);
            });
        }];
        
}
+ (void)GetPetGameCollectsSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [self getAuthorizationWithURL:[NSString stringWithFormat:@"%@%@?activityUuid=%@&openId=%@",Base_Product_Url,THT_Pet_Collects,THT_Pet_AppActivityUuid,[[NSUserDefaults standardUserDefaults] objectForKey:THT_Test_AppOpenId]] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
//    [self PostAuthorizationWithURL:[NSString stringWithFormat:@"%@%@?activityUuid=%@&openId=%@",Base_Product_Url,THT_Pet_Collects,THT_Pet_AppActivityUuid,THT_Test_AppOpenId] Params:@{} success:^(id  _Nonnull responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            SuccessHandler(responseObject);
//        });
//    } failure:^(NSString * _Nonnull error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            FaildedHandler(error);
//        });
//    }];
}
+ (void)GetCouponSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [GSNetWorking  postCouponWithURL:[NSString stringWithFormat:@"%@%@",Base_Product_Coupon_Url,THT_Coupon_Prizes] Params:@{} success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}

+ (void)GetAnswerQuestionSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"answer"] = @"我想你了";
    params[@"id"] = @1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [GSNetWorking  patchCouponWithURL:[NSString stringWithFormat:@"%@%@",@"https://aimap.newayz.com/aimap/",@"lantern/v1/ar_riddles/1"] Params:params  success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}
+ (void)PatchAnswerQuestionSuccessHandler:(NSString *)questionId QuestionDescription:(NSString *)description SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"answer"] = description;
    params[@"id"] = questionId;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [GSNetWorking  patchCouponWithURL:[NSString stringWithFormat:@"%@%@",@"https://aimap.newayz.com/aimap/lantern/v1/ar_riddles/",questionId] Params:params  success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}
+ (void)GetQuestionSuccessHandler:(NSString *)questionId SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"lantern_id"] = questionId;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
    [GSNetWorking  getWithURL:[NSString stringWithFormat:@"%@%@",@"https://aimap.newayz.com/aimap/lantern/v1/ar_riddles/:id?lantern_id=",questionId] Params:nil  success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            SuccessHandler(responseObject);
        });
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            FaildedHandler(error);
        });
    }];
}
@end
