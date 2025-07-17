//
//  UnityToiOSManger.h
//  testUnityToiOS
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnityToiOSManger : NSObject
+ (instancetype)sharedInstance;
+ (BOOL)getRequest;
+ (void)setRequest:(BOOL)request;
@property (nonatomic, assign) int gArgc;
@property (nonatomic, assign) char*_Nullable* _Nullable gArgv;

- (void)appLaunchOpts:(NSDictionary *)appLaunchOpt;
- (bool)unityIsInitialized;
- (void)startUnityView;
- (UIView *)unityView;
- (UIViewController *)unityViewController;
/**
 注册unity相关回调
 */
- (void)registerUnityPtotocolWithObject:(id)object;
/// 退出Unity
- (void)exitUnity;
/**
 发送消息 无参数
 */
- (void)TackePicFromNative;
- (void)sendMsgToUnityForUnloadAssets;
- (void)sendMsgToUnityForPicture;
/**
 发送消息 携带参数
 */
- (void)GetImgUrl:(NSString *)msg;
/**
 发送消息 携带参数
 */
- (void)SetDataRecorderStatus:(NSString *)msg;
- (void)StartOpen:(NSString *)msg;
- (void)SetQRCodeVPSMode:(NSString *)msg;
- (void)ChangeTheme:(NSString *)msg;
- (void)GetVoiceStr:(NSString *)msg;
- (void)TestCall:(NSString *)msg;
- (void)StartNavigate:(NSString *)msg;
- (void)VisibleDistanceChanged:(NSString *)msg;
- (void)SwitchParallelUniverse:(NSString *)msg;
- (void)sendMsgToUnityGetPOIInfoFromPhone:(NSString *)msg;
- (void)SetFPSVisible:(NSString *)msg;
- (void)EnableConsistencyCheck:(NSString *)msg;
- (void)sendMsgToUnityWithMsg:(NSString *)msg;
- (void)sendMsgToUnityNewWithMsg:(NSString *)msg;

- (void)send3DTextMsgToUnity:(NSString *)msg;
- (void)add3DTextMsgToUnity:(NSString *)msg;
/**
 发送消息 携带参数
 */
- (void)sendMsgToUnityWithMothWhthMsg:(NSString *)msg;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager;
- (void)applicationDidFinishLaunching:(UIApplication *)application ;
@end

NS_ASSUME_NONNULL_END
