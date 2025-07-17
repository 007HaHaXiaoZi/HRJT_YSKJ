//
//  THTNetWorkingManger.h
//  THTAPP
//
//  Created by LiuGaoSheng on 2021/8/23.
//
#import "GSNetWorking.h"

NS_ASSUME_NONNULL_BEGIN

@interface THTNetWorkingManger : GSNetWorking
///获取 随机openID
+ (void)PostRndUserSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///获取点位列表
+ (void)GetSpotsSettingSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///获取ibaken点位信息
+ (void)PostIbakenSettingWithSpotsUuid:(NSArray *)spotUuids SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///查询拼图寻宝配置信息
+ (void)GetPuzzleGameSettingSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///查询已拼图信息
+ (void)GetPuzzleGameCollectedSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///拼图打卡
+ (void)PostPuzzleGameCollectWithSn:(NSString *)sn SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///查询所有精灵信息
+ (void)GetSpriteGameSettingSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///查询所有萌宠信息
+ (void)GetPetGameSettingWithActivityUuid:(NSString *)activityUuid SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///2 收集萌宠
+ (void)PostPetGameCollectsWithPetId:(NSString *)petId SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///获取已收集的萌宠
+ (void)GetPetGameCollectsSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
///获取优惠券
+ (void)GetCouponSuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
+ (void)PatchAnswerQuestionSuccessHandler:(NSString *)questionId QuestionDescription:(NSString *)description SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler ;
+ (void)GetQuestionSuccessHandler:(NSString *)questionId SuccessHandler:(void(^)(NSDictionary *response))SuccessHandler FaildedHandler:(void(^)(NSString *error))FaildedHandler;
@end

NS_ASSUME_NONNULL_END
