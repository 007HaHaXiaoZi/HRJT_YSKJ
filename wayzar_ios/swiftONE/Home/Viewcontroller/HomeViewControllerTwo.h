//
//  HomeViewController.h
//  THTAPP
//
//

#import "GSBaseViewController.h"
#import "BallSportView.h"
#import "UIView+Toast.h"
#import "UIImageUtil.h"
#import "Macro.h"
#import "YPLargeImageView.h"
#import "UIAlertView+WX.h"
#import "YPLogTool.h"
#import "PictureResponseBean.h"
#import "UnityVPSBean.h"
#import "UUID.h"
#import "JZLocationConverter.h"
#import <AWSCore.h>
#import <AWSS3.h>
typedef NS_ENUM(NSUInteger, StateType) {
    initing = 0,//初始化中
    inited = 1,//初始化完成
    loadingAR = 2,//左上到右下
    loadedAR = 3,//右上到左下
};
NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : GSBaseViewController
-(void)setDingweiTime:(NSString *)time;
-(void)requestPOIConvert:(NSString *)maptile_name;
-(void)requestPOIConvertTest;
-(void)sendUnityPOIJson:(NSString *)buidingLocationString;
- (void)requestPOIData;
-(void)showLeftUIView:(NSString *)result;
@end

NS_ASSUME_NONNULL_END
