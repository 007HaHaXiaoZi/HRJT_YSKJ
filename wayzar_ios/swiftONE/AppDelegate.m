//
//  AppDelegate.m
//  iOSSample
//
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UnityToiOSManger.h"
#import <Bugly/Bugly.h>
#import "YPLogTool.h"
#import "IFlyMSC/IFlyMSC.h"
#import "Definition.h"
#import <AWSCore.h>


// 配置自己应用的accessKey和secretKey，demo中这样做不安全，应该从加密接口中获取accessKey和secretKey
NSString *const accessKey = @"JDC_5ADC199B0C4F9077E474CA3B514D";
NSString *const secretKey = @"1A6A04DAA846FE2DE15E2A0CC747DDEF";

// 服务器地址
NSString *const serverUrl = @"http://s3.cn-east-2.jdcloud-oss.com";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[[UnityToiOSManger sharedInstance] applicationDidFinishLaunching:application];
    [AWSDDLog addLogger:AWSDDTTYLogger.sharedInstance];
    AWSDDLog.sharedInstance.logLevel = AWSDDLogLevelInfo;
    
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:accessKey secretKey:secretKey];
    AWSEndpoint *endPoint = [[AWSEndpoint alloc] initWithURLString:serverUrl];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                                    endpoint:endPoint
                                                                         credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    printf("application\n");
    [Bugly startWithAppId:@"969f8564ac"];
    
    [YPLogTool yp_setWriteToFileOn:YES bindUserId:@""];
    // 为了真机调试，直接看效果 - - - 开启了强制写入文件, 不用切环境了就~~~偷懒😄
    [YPLogTool yp_setForceWirteToFile:YES];
    // Override point for customization after application launch.
    //Set log level
    [IFlySetting setLogFile:LVL_ALL];
    
    //Set whether to output log messages in Xcode console
    [IFlySetting showLogcat:YES];

    //Set the local storage path of SDK
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation API_DEPRECATED_WITH_REPLACEMENT("application:openURL:options:", ios(4.2, 9.0)) API_UNAVAILABLE(tvos){
    return YES;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    printf("applicationWillResignActive\n");
    [[UnityToiOSManger sharedInstance] applicationWillResignActive:application];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    printf("applicationDidEnterBackground\n");
    [[UnityToiOSManger sharedInstance] applicationDidEnterBackground:application];
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    printf("applicationWillEnterForeground\n");
    [[UnityToiOSManger sharedInstance] applicationWillEnterForeground:application];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("applicationDidBecomeActive\n");
    [[UnityToiOSManger sharedInstance] applicationDidBecomeActive:application];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    printf("applicationWillTerminate\n");
    [[UnityToiOSManger sharedInstance] applicationWillTerminate:application];
}
@end
