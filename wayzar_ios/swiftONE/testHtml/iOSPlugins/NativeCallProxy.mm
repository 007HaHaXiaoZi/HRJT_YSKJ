//
//  NativeCallProxy.m
//  testUnityToiOS
//
//  Created by LiuGaoSheng on 2020/12/11.
//

#import "NativeCallProxy.h"
#include "multi_location_fusion_interface.hpp"

@implementation FrameworkLibAPI
id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
    //dummy(10, 10);
}

@end


extern "C" {
int dummy_native(int32_t a, int32_t b)
   {
    NSLog(@"dummy_native:%d,%d,%d",a,b,dummy(a,b));
       return dummy(a,b);

   }

bool init_system_native(std::string log_path)
{
    return init_system(log_path);
}

void logs_callback_native(LogCallback log_callback){
    logs_callback(log_callback);
}

void status_callback_native(StatusCallback status_callback1){
    status_callback(status_callback1);
}

bool get_realtime_transform_native(double* aa,double* bb,double* cc,double* dd){
    return get_realtime_transform(aa, bb, cc, dd);
}

bool feed_location_pair_native(double*aa, double*bb, double*cc, double*dd, int32_t e, int32_t f){
    return feed_location_pair(aa, bb, cc, dd, false,true);
}

void PhoneMethodForSendVPSRequestC(char*value, uint8_t* imageData, unsigned long imageSize){
    
    return [api PhoneMethodForSendVPSRequest:[NSString stringWithUTF8String:value] image:[[NSData alloc]initWithBytes:imageData length:imageSize] size:imageSize];
}

void PhoneMethodForSendQRCodeVPSRequest(char*value, char*value2){
    
    return [api PhoneMethodForSendQRCodeVPSRequest:[NSString stringWithUTF8String:value] qrcodeJson:[NSString stringWithUTF8String:value2]];
}

void PhoneMethodForUnityInitComplete() {
    printf("yuan PhoneMethodForUnityInitComplete");
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    // 读取数据
//    NSString *fileName = [userDefaults valueForKey:@"fileName"];
//    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
//    NSLog(@"yuan File downloaded to i2: %@",fileName);
//    NSString * str3 =[[NSString alloc]initWithFormat:@"{\"contentPath\":\"%@\",\"id\":\"%@\"}",destinationPath,fileName];
//    NSLog(@"yuan send unity json: %@",str3);
//    //UnitySendMessage("GameManager", "GetCurrentAreaAssets", "{\"contentPath\":\"/storage/emulated/0/Android/data/com.wayz.armaptest/files/ar/9L/\",\"id\":\"lvdi\"}");
//    UnitySendMessage("GameManager", "GetCurrentAreaAssets", str3.UTF8String);
    return [api PhoneMethodForUnityInitComplete];
}
void PhoneMethodForLoadingAreaAssetsDone() {
    //会卡住主线程
    return [api PhoneMethodForLoadingAreaAssetsDone];
}

void PhoneMethodForGetCurrentView(const char *value) {
    //会卡住主线程
    
    NSLog(@"11111");
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"22222");
    //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
    return [api PhoneMethodForGetCurrentView:[NSString stringWithUTF8String:value]];
}

void PhoneMethodForOpenUrlFromUnity(const char *value) {
    //会卡住主线程
    
    NSLog(@"11111  PhoneMethodForOpenUrlFromUnity");
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"22222");
    //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
    return [api PhoneMethodForOpenUrlFromUnity:[NSString stringWithUTF8String:value]];
}

void PhoneMethodForProcessDone(const char *value) {
    NSLog(@"11111  PhoneMethodForProcessDone");
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"22222");
    //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
    return [api PhoneMethodForProcessDone:[NSString stringWithUTF8String:value]];
}

void PhoneMethodForSendParallelverseInfo(const char *value) {
    NSLog(@"11111  PhoneMethodForSendParallelverseInfo");
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"22222");
    //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
    return [api PhoneMethodForSendParallelverseInfo:[NSString stringWithUTF8String:value]];
}

void OnNativeInvoke() {
    return [api onNativeInvoke];
}
void LeftDistance(const char *value) {
    
}

void PhoneMethodForUnloadAssetsComplete() {
    return [api onNativeInvoke];
}
void PhoneMethodForStartVoice(const char *value) {
    return [api PhoneMethodForStartVoice:[NSString stringWithUTF8String:value]];
}
    void OnNativeStringInvoke(const char *value) {
        return [api onNativeStringInvokeWithResult:[NSString stringWithUTF8String:value]];
    }
    const char* OnUnityGetStringInvoke() {
        return strdup([[api onUnityGetStringInvoke] cStringUsingEncoding:NSUTF8StringEncoding]);
    }

void PhoneMethodForShowHideCamera(const char *value) {
    return [api ShowCameraIcon:[NSString stringWithUTF8String:value]];
}

void CoffeeOrder(const char *value) {
    NSLog(@"11111  CoffeeOrder");
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"22222");
    //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
    return [api CoffeeOrder:[NSString stringWithUTF8String:value]];
}
void PhoneMethodForSendModelList(const char *value) {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api PhoneMethodForSendModelList:[NSString stringWithUTF8String:value]];
}

void PhoneMethodForEndNavigate() {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api PhoneMethodForEndNavigate];
}

void JinJiang_TakePhotoC(uint8_t* imageData, unsigned long imageSize) {
    NSLog(@"11111  JinJiang_TakePhoto");
    return [api JinJiang_TakePhoto:[[NSData alloc]initWithBytes:imageData length:imageSize]];
}

void JinJiang_TakePhotoURL(const char *value) {
    NSLog(@"11111  JinJiang_TakePhotoURL");
    return [api JinJiang_TakePhotoURL:[NSString stringWithUTF8String:value]];
}

void JinJiang_SignUp() {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api JinJiang_SignUp];
}

void OpenImageURL(const char *value) {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api OpenImageURL:[NSString stringWithUTF8String:value]];
}

void JinJiang_RecommendRank(const char *value) {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api JinJiang_RecommendRank:[NSString stringWithUTF8String:value]];
}

void JinJiang_UseCoupon(const char *value) {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api JinJiang_UseCoupon:[NSString stringWithUTF8String:value]];
}


void JinJiang_ShotGameScore(const char *value) {
    NSLog(@"11111  PhoneMethodForSendModelList");
    return [api JinJiang_ShotGameScore:[NSString stringWithUTF8String:value]];
}

}

