
//
//  UnityToiOSManger.m
//  testUnityToiOS
//

#import "UnityToiOSManger.h"
#import <UnityFramework/UnityFramework.h>
#import <UnityFramework/NativeCallProxy.h>
#import "swiftONE-Swift.h"
#import <CoreMotion/CoreMotion.h>



UnityFramework* UnityFrameworkLoad(void)
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    
    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];
    
    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}


@interface UnityToiOSManger ()
@property (nonatomic, strong) UnityFramework *ufw;
/** UIApplication */
@property(nonatomic,strong) NSDictionary *appLaunchOpts;

@property (nonatomic, strong) CMMotionManager * motionManager;

@property(nonatomic,strong) id object;

@end
@implementation UnityToiOSManger
static UnityToiOSManger *_singleInstance = nil;
static NSString * orientationValue;
static bool volatile * backgraound;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleInstance == nil) {
            _singleInstance = [[self alloc]init];
        }
    });
    return _singleInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [super allocWithZone:zone];
    });
    return _singleInstance;
}

+ (BOOL)getRequest{
    return backgraound;
}

+(void)setRequest:(BOOL *)request{
    backgraound = request;
}
-(id)copyWithZone:(NSZone *)zone{
    return _singleInstance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _singleInstance;
}

- (void)appLaunchOpts:(NSDictionary *)appLaunchOpts {
    self.appLaunchOpts = appLaunchOpts;
}
- (bool)unityIsInitialized { return [self ufw] && [[self ufw] appController]; }
- (void)startUnityView
{
    [self setUfw: UnityFrameworkLoad()];
    // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and uncomment call to setDataBundleId
    // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    
    [[self ufw] runEmbeddedWithArgc:self.gArgc argv: self.gArgv appLaunchOpts: self.appLaunchOpts];
    
}
- (void)registerUnityPtotocolWithObject:(id)object {
    [[self ufw] registerFrameworkListener: object];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:object];
    self.object = object;
}
- (UIView *)unityView {
    return  [[[self ufw] appController] rootView];
}
- (UIViewController *)unityViewController {
    return [[self ufw] appController].rootViewController;
}
/// 退出Unity
- (void)exitUnity
{
    if(![self unityIsInitialized]) {
       NSLog(@"Unity is not initialized , Initialize Unity first");
    } else {
        [UnityFrameworkLoad() unloadApplication];
    }
    [self unityDidUnload];
}
/// 退出Unity
- (void)unityDidUnload
{
    NSLog(@"unityDidUnloaded called");
    
    [[self ufw] unregisterFrameworkListener:self.object];
    [self setUfw: nil];
    
}

- (void) TackePicFromNative{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "TackePicFromNative" message: ""];
}


- (void) StartOpen:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "StartCloseOpen" message: [msg UTF8String]];
}

- (void)SetQRCodeVPSMode:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "SetQRCodeVPSMode" message: [msg UTF8String]];
}

- (void) GetImgUrl:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "GetImgUrl" message: [msg UTF8String]];
}
- (void)GetVoiceStr:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "GetVoiceStr" message: [msg UTF8String]];
}
- (void)ChangeTheme:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "ChangeTheme" message: [msg UTF8String]];
}
- (void)TestCall:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "TestCall" message: [msg UTF8String]];
}

- (void)StartNavigate:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "StartNavigate" message: [msg UTF8String]];
}

- (void)VisibleDistanceChanged:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "VisibleDistanceChanged" message: [msg UTF8String]];
}

- (void)SwitchParallelUniverse:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "SwitchParallelUniverse" message: [msg UTF8String]];
}

- (void)SetFPSVisible:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "SetFPSVisible" message: [msg UTF8String]];
}

- (void)EnableConsistencyCheck:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "EnableConsistencyCheck" message: [msg UTF8String]];
}

- (void)sendMsgToUnityNewWithMsg:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "ReceiveMessageFromPhone" message: [msg UTF8String]];
}

- (void)sendMsgToUnityForUnloadAssets{
    [[self ufw] sendMessageToGOWithName: "GameManager" functionName: "UnloadUnityAssets" message: ""];
}

- (void)sendMsgToUnityGetPOIInfoFromPhone:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager" functionName: "GetPOIInfoFromPhone" message: [msg UTF8String]];
}

- (void)sendMsgToUnityForPicture{
    [[self ufw] sendMessageToGOWithName: "GameManager" functionName: "SendCurrentViewToAndroid" message: ""];
}
- (void)sendMsgToUnityWithMsg:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "GetVPSResponseFromPhone" message: [msg UTF8String]];
}
- (void)sendMsgToUnityWithMothWhthMsg:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "GetCurrentAreaAssets" message: [msg UTF8String]];
}

- (void)send3DTextMsgToUnity:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "GetThreeDText" message: [msg UTF8String]];
}
- (void)add3DTextMsgToUnity:(NSString *)msg{
    [[self ufw] sendMessageToGOWithName: "GameManager"  functionName: "CreateAThreeDText" message: [msg UTF8String]];
}
- (void)applicationWillResignActive:(UIApplication *)application { [[[self ufw] appController] applicationWillResignActive: application]; }
- (void)applicationDidEnterBackground:(UIApplication *)application { [[[self ufw] appController] applicationDidEnterBackground: application]; }
- (void)applicationWillEnterForeground:(UIApplication *)application { [[[self ufw] appController] applicationWillEnterForeground: application]; }
- (void)applicationDidBecomeActive:(UIApplication *)application { [[[self ufw] appController] applicationDidBecomeActive: application]; }
- (void)applicationWillTerminate:(UIApplication *)application { [[[self ufw] appController] applicationWillTerminate: application]; }
- (void)applicationDidFinishLaunching:(UIApplication *)application { [[[self ufw] appController] applicationDidFinishLaunching: application]; }

#pragma mark - NativeCallsProtocol


- (void)PhoneMethodForUnityInitComplete {
    NSLog( @"接受到Unity 发来的 消息 PhoneMethodForUnityInitComplete 携带参数");
}

- (void)PhoneMethodForLoadingAreaAssetsDone {
    NSLog( @"接受到Unity 发来的 消息 PhoneMethodForLoadingAreaAssetsDone 携带参数");
}

- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                       withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                           [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
 
                                       }];
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            NSLog(@"handleDeviceMotion: %@",@"1");
            orientationValue = @"4";
            // UIDeviceOrientationPortraitUpsideDown;
        }
        else{
            NSLog(@"handleDeviceMotion: %@",@"2");
            // UIDeviceOrientationPortrait;
            orientationValue = @"4";
        }
    }
    else
    {
        if (x >= 0){
            NSLog(@"handleDeviceMotion: %@",@"3");
            // UIDeviceOrientationLandscapeRight;
            orientationValue = @"1";
        }
        else{
            NSLog(@"handleDeviceMotion: %@",@"4");
            // UIDeviceOrientationLandscapeLeft;
            orientationValue = @"3";
        }
    }
}



- (void)PhoneMethodForGetCurrentView:(NSString *)result {
    NSLog( @"接受到Unity 发来的 消息 PhoneMethodForGetCurrentView 携带参数%@",result);

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *lat = [userDefaults valueForKey:@"lat"];
    NSLog(@"11111读出来的数据: %@",lat);
    // 读取数据
    NSString *lon = [userDefaults valueForKey:@"lon"];
    NSLog(@"11111读出来的数据: %@",lon);
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    
    NSLog( @"orientationValue%@",orientationValue);

    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSString * image =  [dic objectForKey:@"path"];
    NSString * focalLength =  [dic objectForKey:@"focalLength"];
    NSString * principalPoint =  [dic objectForKey:@"principalPoint"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       MySwiftClass* getData = [[MySwiftClass alloc]init];
//        [getData showSwiftLogWithStr:image abc:focalLength bcd:principalPoint orentation:orientationValue lat:lat lon:lon];
     });
    //[1]    (null)    @"focalLength" : @"1641.271,1641.271"
    //
    //[1]    (null)    @"focalLength" : @"1522.207,1522.207"
    //[2]    (null)    @"principalPoint" : @"958.8134,718.5364"
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://116.196.107.117:50052/wayzoom/v1/vps/single"]
//      cachePolicy:NSURLRequestUseProtocolCachePolicy
//      timeoutInterval:10.0];
//    NSArray *parameters = @[
//      @{ @"name": @"data", @"value": @"{\"timestamp\":\"1630393036\",\"intrinsic\":\"[494.4375, 498.5292, 319.8089, 241.4202]\",\"distortion\":\"[0.0, 0.0, 0.0, 0.0]\",\"prior_translation\":\"{\\\"alt\\\":10.0,\\\"lat\\\":31.17940571727986,\\\"lon\\\":121.60382399757607}\",\"prior_rotation\":\"{x=0, y=0, z=0, w=1}\"}" },
//      @{ @"name": @"image", @"value": image }
//    ];
//
//    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//
//    for (NSDictionary *param in parameters) {
//      [body appendFormat:@"--%@\r\n", boundary];
//      [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//      [body appendFormat:@"%@", param[@"value"]];
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:postData];
//
//    [request setHTTPMethod:@"POST"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//      if (error) {
//        NSLog(@"%@22222", error);
//        dispatch_semaphore_signal(sema);
//      } else {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        NSError *parseError = nil;
//        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//        NSLog(@"%@1111",responseDictionary);
//        dispatch_semaphore_signal(sema);
//      }
//    }];
//    [dataTask resume];
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)onNativeInvoke {
    NSLog(@"接受到Unity 发来的 消息 onNativeInvoke");
}

- (void)onNativeStringInvokeWithResult:(NSString *)result {
    NSLog( @"接受到Unity 发来的 消息 onNativeStringInvokeWithResult 携带参数 ：%@",result);
    
}

- (NSString *)onUnityGetStringInvoke{
    NSLog( @"接受到Unity 发来的 消息 onUnityGetStringInvoke 返回参数 ：hello world");
    return @"hello world";
}
@end
