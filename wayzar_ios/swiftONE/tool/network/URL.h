//
//  URL.h
//  QingProduct
//
//  Created by LiuGaoSheng on 2021/7/19.
//  Copyright © 2021 刘高升. All rights reserved.
//

#ifndef URL_h
#define URL_h


#pragma mark - 网络环境配置

///测试环境
NSString *Base_Test_Url = @"http://10.10.51.68:8080";
///生产环境
NSString *Base_Product_Url = @"https://wenlv-staging.easyar.com";
///优惠券
NSString *Base_Product_Coupon_Url = @"http://220.197.187.4:8000";
/**
 1.获取用户id' post
 */
NSString *THT_Openid_Url = @"/api/games/user/rnd-user";
/**
 1.获取点位列表
 2.获取点位详情(不同点位类型返回的结构不同)
 */
NSString *THT_Spots_Url = @"/api/project/spots";
#pragma mark - 拼图游戏
/**
 GET
 1.查询所有拼图配置信息
 */
NSString *THT_Puzzle_Setting = @"/api/photo-collection/";
/**
 1.已打卡列表 get
 1.打卡 post
 */
NSString *THT_Puzzle_collectioned = @"/api/photo-collection/photos";

#pragma mark - 召唤精灵
/**
 GET
 1.查询所有精灵信息
 */
NSString *THT_Sprite_Setting = @"/api/games/sprite/setting";

#pragma mark - 抓萌宠

/**
 GET
 1.查询所有萌宠信息
 */
NSString *THT_Pet_Setting = @"/api/games/pet/setting";

/**
 POST
 1.收集萌宠
 2. 获取已收集的萌宠
 */
NSString *THT_Pet_Collects = @"/api/games/pet/collects";
/**
 POST
 1. 获取奖品列表
 2.. 更新抽奖的状态
 */
NSString *THT_Pet_Prizes = @"/api/game/pet/prizes";
/**
 GET
 1.获取优惠券
 */
NSString *THT_Coupon_Prizes =@"/ARStorecouponOpe/ARCouponHandler.ashx";

#endif /* URL_h */
