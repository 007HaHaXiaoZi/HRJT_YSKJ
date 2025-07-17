//
//  MapSpotsModel.h
//  THTAPP
//
//  Created by LiuGaoSheng on 2021/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapSpotsModel : NSObject
/** 原 id */
@property(nonatomic,copy) NSString *spotsId;
@property(nonatomic,assign) NSInteger isShowName;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger payStatus;
@property(nonatomic,assign) NSInteger settingId;
@property(nonatomic,copy) NSString *uuid;
@property(nonatomic,assign) float x;
@property(nonatomic,assign) float y;
@end

NS_ASSUME_NONNULL_END
