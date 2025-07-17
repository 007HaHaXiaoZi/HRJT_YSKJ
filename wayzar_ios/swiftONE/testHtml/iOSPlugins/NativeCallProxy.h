 //
//  NativeCallProxy.h
//  testUnityToiOS
//
//

#import <Foundation/Foundation.h>

// NativeCallsProtocol defines protocol with methods you want to be called from managed
@protocol NativeCallsProtocol
@required
/**
 将要调用的Unity中的方法 该代理方法应该在Appdelegate 文件中实现
 当然也可以在该代理中 添加其他方法
 */
- (void)ShowCameraIcon:(NSString *)key;

- (void)PhoneMethodForSendVPSRequest:(NSString *)key image:(NSData *)imageData size:(unsigned int)size;
- (void)PhoneMethodForSendQRCodeVPSRequest:(NSString *)requestJson qrcodeJson:(NSString *)json;
- (void)PhoneMethodForStartVoice:(NSString *)key;
- (void)PhoneMethodForUnityInitComplete;
- (void)PhoneMethodForLoadingAreaAssetsDone;
- (void)PhoneMethodForGetCurrentView:(NSString *)result;
- (void)PhoneMethodForOpenUrlFromUnity:(NSString *)result;
- (void)PhoneMethodForProcessDone:(NSString *)result;
- (void)PhoneMethodForSendParallelverseInfo:(NSString *)result;
- (void)PhoneMethodForUnloadAssetsComplete;
- (void)onNativeInvoke;
- (void)onNativeStringInvokeWithResult:(NSString *)result;
- (NSString *)onUnityGetStringInvoke;


- (void)CoffeeOrder:(NSString *)json;
- (void)PhoneMethodForSendModelList:(NSString *)json;
- (void)PhoneMethodForEndNavigate;
- (void)JinJiang_TakePhoto:(NSData *)imageData;
- (void)JinJiang_SignUp;
- (void)OpenImageURL:(NSString *)url;
- (void)JinJiang_RecommendRank:(NSString *)json;
- (void)JinJiang_UseCoupon:(NSString *)json;
- (void)JinJiang_ShotGameScore:(NSString *)json;
- (void)JinJiang_TakePhotoURL:(NSString *)url;
@end

__attribute__ ((visibility("default")))
@interface FrameworkLibAPI : NSObject
// call it any time after UnityFrameworkLoad to set object implementing NativeCallsProtocol methods
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi;

@end
