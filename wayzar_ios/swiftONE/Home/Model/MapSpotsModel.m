//
//  MapSpotsModel.m
//  THTAPP
//
//  Created by LiuGaoSheng on 2021/8/26.
//

#import "MapSpotsModel.h"
#import <MJExtension/MJExtension.h>

@implementation MapSpotsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"spotsId":@"id"
    };
}
@end
