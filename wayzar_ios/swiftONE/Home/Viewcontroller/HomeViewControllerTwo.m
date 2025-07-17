//
//  HomeViewController.m
//  THTAPP
//
//

#import "HomeViewController.h"
#import "ARPetRulesView.h"
#import "ARSpiritTitleView.h"
#import "ARGuideView.h"
#import "ContentMenuView.h"
#import "HLAlertViewBlock.h"
#import "UnityToiOSManger.h"
#import <UnityFramework/UnityFramework.h>
#import <UnityFramework/NativeCallProxy.h>
#import "swiftONE-Swift.h"
#import <CoreMotion/CoreMotion.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <ZipArchive.h>
#import "HWWaveView.h"
#import "ARSceneBean.h"
#import "MJExtension.h"
#import "THTNetWorkingManger.h"
#import "UIImageView+WebCache.h"
#import <Bugly/Bugly.h>

#import <QuartzCore/QuartzCore.h>
#import "Definition.h"
#import <CommonCrypto/CommonDigest.h>
#import "IFlyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "ARWebViewController.h"
NSString *const S3BucketName = @"pgv";

NSString *const cellIdf = @"UploadDemoCell_idf";

@interface HomeViewController ()<ARGuideViewDlegate,TopViewDlegate,BottomViewDlegate,NativeCallsProtocol,UnityFrameworkListener,MAMapViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,AMapLocationManagerDelegate,MyTouchViewDlegate,IFlySpeechRecognizerDelegate>
//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property(nonatomic , strong) ARSpiritTitleView *topView;
@property(nonatomic , strong) ARPetRulesView *bottomView;
/** mapd点位模型 */
@property(nonatomic,strong) NSArray *mapspotsArray;
@property(nonatomic,strong) NSMutableArray *ibakensArray;
@property (nonatomic, strong) CMMotionManager * motionManager;


/** NSURLConnection下载大文件需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSMutableString  *pathHH;
/// Description
@property (nonatomic, assign) NSString *downloadUrl;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, weak) HWWaveView *waveView;
@property (nonatomic,strong) MAPolygon* Overpoly;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

/** 文件句柄对象 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@end
static const NSString *fileName;
static const NSString *fileNameZip;
static const UIButton *btnCurrent;
static const bool *downloading;
static const bool *canGetCoffee;

@implementation HomeViewController{
    UIImageView *dingweiTip;
    UIImageView *shoujiIcon;
    MAMapView *mapView;
    NSMutableArray *annotations;
    bool check;
    bool showPOI;
    NSArray *rangArr ;
    UIImageView *urlImageFather;
    UIImageView *urlImage;
    UIImageView *urlImageImageInfo;
    UIScrollView *uiScrollview;
    NSMutableArray *arSceneBeanList;
    NSMutableArray *currentArSceneBeanList;
    ARSceneBean *currentARSceneBean;
    StateType stateType;
    bool showWeilan;
    CLLocation *currentLocation;
    BallSportView *ballSportView;
    NSInteger dingweiTime;
    
    dispatch_block_t block1;
    
    NSDictionary *currentQuestion;
    
    NSMutableDictionary *questionList;
    NSString *currentDenglongID;

    MySwiftClass* getData;
    NSString *deviceType;
    
    MyTouchView *fatherView;
    UILabel *selectedUILabel;
    int currentMenuIndex;
    NSMutableArray *menuStringList;
    UISlider  *distanceSlider;
    UIView *rightUiView;
    UIImageView *uiImageViewZhanKai;
    bool showSceneMenu;
    UIButton *manualPosition;
    UISwitch *openDebugSwitch;
    UIView *menuView;
    
    UIView *uiViewTakePhoto;
    UIView *uiViewPicturePreview;
    UIImageView *ivPhotoPreview;
    UIImageView *ivUploading;
    UIView *uiErweimaFather;
    UIImageView *ivErweima;
    bool local;
    
    double deviceAgle;
    
    UIButton *openOrClosePosition;
    UIImageView *scanQRLine;
}

UIImageView *ivChangeTheme;
int a = 0;
int sum = 0;
bool blessingListening = false;
static NSString * orientationValue;
static NSArray *pois;
UIButton *QRPosition;
UIImageView *ivScanQRTip;
-(NSMutableArray *)ibakensArray {
    if (!_ibakensArray) {
        _ibakensArray = [NSMutableArray array];
    }
    return _ibakensArray;
}

-(void)openOrCloseQRPosition{
    if([QRPosition.titleLabel.text containsString:@"定位"]){
        //QRPosition.titleLabel.text = @"扫码模式";
        [QRPosition setTitle:@"扫码模式" forState:UIControlStateNormal];
        [[UnityToiOSManger sharedInstance]SetQRCodeVPSMode:@"1"];
        if(!dingweiTip.hidden){
            dingweiTip.hidden = true;
            ivScanQRTip.hidden = false;
        }
    }else{
        //QRPosition.titleLabel.text = @"定位模式";
        [QRPosition setTitle:@"定位模式" forState:UIControlStateNormal];
        [[UnityToiOSManger sharedInstance]SetQRCodeVPSMode:@"0"];
        if(!ivScanQRTip.hidden){
            dingweiTip.hidden = false;
            ivScanQRTip.hidden = true;
        }
    }
}

- (void)loadView {
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    dingweiTip = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-176, self.view.frame.size.height/2-127, 352, 254)];
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"1.app名称: %@",app_Name);
    dingweiTip.image = [UIImage imageNamed:@"ic_dingwei_tip"];
    if([app_Name containsString:@"沙盘"]){
        dingweiTip.image = [UIImage imageNamed:@"ic_dingwei_tip_sanbox"];
    }
    if([app_Name containsString:@"张江"]){
        dingweiTip.image = [UIImage imageNamed:@"ic_dingwei_tip_kexuehui"];
    }
    dingweiTip.contentMode = UIViewContentModeScaleAspectFit;
    [dingweiTip setHidden:true];
    [self.view addSubview:dingweiTip];
    shoujiIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 254/2-65, 73, 129)];
    shoujiIcon.image = [UIImage imageNamed:@"ic_shouji"];
    shoujiIcon.contentMode = UIViewContentModeScaleAspectFit;
    [dingweiTip addSubview:shoujiIcon];
    [self startDingweiAnim];
    [self startMotionManager];
    
}


-(void)startDingweiAnim{
    [UIView animateWithDuration:2 animations:^{
        [self->shoujiIcon setFrame:CGRectMake(352-73, 254/2-65, 73, 129)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            [self->shoujiIcon setFrame:CGRectMake(0, 254/2-65, 73, 129)];
        } completion:^(BOOL finished) {
            [self startDingweiAnim];
        }];
    }];
}
#pragma marke bottomBView
- (void)bottomViewClickItem:(ARSceneBean *)arSceneBean{
    //[self.topView setModel:arSceneBean];
    [self enterAR:arSceneBean];
}

- (void)mapReset{
    [mapView setZoomLevel:18.5 animated:YES];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude) animated:YES];
    //mapView
    NSLog(@"mapReset");
}

#pragma marke topview
-(void)enterAR:(ARSceneBean *) arSceneBean{
    NSLog(@"view 的点击事件");
    [self initARFromAnnotation:arSceneBean];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    canGetCoffee = true;
    showSceneMenu = true;
    local = false;
    //每次进来默认非debug模式
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:false forKey:@"debug"];
    
    [Bugly startWithAppId:@"969f8564ac"];
    ballSportView = [[BallSportView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-100, 200, 200)];
    [self.view addSubview:ballSportView];
    [ballSportView showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initUI];
    });
}

-(void)requetData{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSString *url = @"https://aimap.newayz.com/aimap/ora/v1/scenes?device_type=ios";
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"1.app名称: %@",app_Name);
    if([app_Name containsString:@"沙盘"]){
        url = @"https://aimap.newayz.com/aimap/ora/v1/scenes?device_type=iosSanbox";
    }
    if([app_Name containsString:@"张江"]){
        url = @"https://aimap.newayz.com/aimap/ora/v1/scenes?device_type=iosKexuehui";
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"yuan%@", error);
            NSString *toast = [[NSString alloc]initWithFormat:@"yuandevice_type error%@",error];
            //[YPLogTool YPWLogInfo:toast];
            dispatch_semaphore_signal(sema);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view makeToast:@"网络异常！"];
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            self->arSceneBeanList = [ARSceneBean mj_objectArrayWithKeyValuesArray:responseDictionary];
            //[self shuffle];
            NSLog(@"yuan%@",responseDictionary);
            NSString *toast = [[NSString alloc]initWithFormat:@"yuandevice_type response%@",responseDictionary];
            //[YPLogTool YPWLogInfo:toast];
            dispatch_semaphore_signal(sema);
            if(DEBUG&&false){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self requetTestData];
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self initData];
                });
            }
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(void)requetTestData{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://aimap.newayz.com/aimap/ora/v1/scenes?device_type=iosTest"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"yuan%@", error);
            dispatch_semaphore_signal(sema);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view makeToast:@"网络异常！"];
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSMutableArray *arSceneBeanTestList = [ARSceneBean mj_objectArrayWithKeyValuesArray:responseDictionary];
            [arSceneBeanList addObjectsFromArray:arSceneBeanTestList];
            //[self shuffle];
            NSLog(@"yuan%@",responseDictionary);
            dispatch_semaphore_signal(sema);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self initData];
            });
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)shuffle
{
    NSUInteger count = [arSceneBeanList count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [arSceneBeanList exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
-(void)showMaker{
    for(int i=0;i<arSceneBeanList.count;i++){
        ARSceneBean *arSceneBean = arSceneBeanList[i];
        //添加point点
        MAPointAnnotation *pointAnnotationJiuJiang = [[MAPointAnnotation alloc] init];
        pointAnnotationJiuJiang.coordinate = CLLocationCoordinate2DMake(arSceneBean.coordinate.latitude.doubleValue,arSceneBean.coordinate.longitude.doubleValue);
        pointAnnotationJiuJiang.title = arSceneBean.name;
        NSDictionary *file = arSceneBean.package.files[0];
        NSLog(file[@"link"]);
        pointAnnotationJiuJiang.subtitle = [NSString stringWithFormat:@"%d",i];
        [mapView addAnnotation:pointAnnotationJiuJiang];
    }
}

-(void)showSceneWeilan{
    //rangArr = @[@"31.180111,121.603801",@"31.180276,121.605346",@"31.179294,121.605464",@"31.179165,121.603994"];
    //[self DrawingGraphics:rangArr];
    NSMutableArray *boundaryIdList = [[NSMutableArray alloc]init];
    for (ARSceneBean *arSceneBean in arSceneBeanList) {
        if(![boundaryIdList containsObject:arSceneBean.boundaryId]){
            NSMutableArray *rangArray = [[NSMutableArray alloc]init];
            for(NSArray *aa in arSceneBean.boundary.coordinates[0]){
                NSString *pointLocation = [NSString stringWithFormat:@"%@,%@",aa[1],aa[0]];
                [rangArray addObject:pointLocation];
            }
            [self DrawingGraphics:rangArray];
            [boundaryIdList addObject:arSceneBean.boundaryId];
        }
    }
}

-(void)checkARSceneByLocation:(double *)lat longitude:(double *)lon{
    //rangArr = @[@"31.180111,121.603801",@"31.180276,121.605346",@"31.179294,121.605464",@"31.179165,121.603994"];
    //[self DrawingGraphics:rangArr];
    [currentArSceneBeanList removeAllObjects];
    for (ARSceneBean *arSceneBean in arSceneBeanList) {
        NSMutableArray *rangArray = [[NSMutableArray alloc]init];
        for(NSArray *aa in arSceneBean.boundary.coordinates[0]){
            NSString *pointLocation = [NSString stringWithFormat:@"%@,%@",aa[1],aa[0]];
            [rangArray addObject:pointLocation];
        }
        CLLocationCoordinate2D aaa = CLLocationCoordinate2DMake(*lat, *lon);
        NSValue *bbb = [NSValue valueWithMACoordinate:aaa];
        bool a = [self containPoint:bbb array:rangArray];
        if (local) {
            a = true;
        }
        if (a) {
            [currentArSceneBeanList addObject:arSceneBean];
        }
    }
    NSLog(@"size yuan %lu",(unsigned long)currentArSceneBeanList.count);
    if (currentArSceneBeanList.count==1) {
        //[_topView setHidden:false];
        [_topView setModel:currentArSceneBeanList[0]];
        [self.bottomView setHidden:false];
        [self.bottomView setDataList:currentArSceneBeanList];
        [_bottomView setHidden:true];
        [uiImageViewZhanKai setHidden:true];
        if (stateType==inited) {
            [self bottomViewClickItem:currentArSceneBeanList[0]];
        }
    }else if(currentArSceneBeanList.count>1){
        //[_topView setHidden:false];
        [_topView setModel:currentArSceneBeanList[0]];
        [self.bottomView setHidden:false];
        [self.bottomView setDataList:currentArSceneBeanList];
    }else{
        if(mapView.hidden){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前位置无AR体验点，是否前往体验WAYZooM微信小程序" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定");
                [self goWXMiniProgram];
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            //[self.view makeToast:@"当前位置无AR体验点，请前往AR体验点！"  duration:2 position:CSToastPositionCenter];
        }
        [_topView setHidden:true];
        [_bottomView setHidden:true];
    }
}

-(void)goWXMiniProgram{
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = @"gh_3f4900d20a2f";  //拉起的小程序的username
    //launchMiniProgramReq.path = path;    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(bool aaa){
        NSLog(@"yuan completion");
    }];
}

-(void)DrawingGraphics:(NSArray *)rangeArr
{
    CLLocationCoordinate2D points[rangeArr.count];
    for (int i = 0; i< rangeArr.count; i++) {
        NSString *str =  rangeArr[i];
        NSArray *array = [str componentsSeparatedByString:@","];
        NSString *one = [NSString stringWithFormat:@"%@",array[1]];
        NSString *two = [NSString stringWithFormat:@"%@",array[0]];
        
        points[i] =CLLocationCoordinate2DMake([two doubleValue], [one doubleValue]);
    }
    self.Overpoly = [MAPolygon polygonWithCoordinates:points count:rangeArr.count];
    [mapView addOverlay:self.Overpoly];
    NSValue *value = [NSValue valueWithMACoordinate:points[0]];
}
-(BOOL)containPoint:(NSValue *)p array:(NSArray *)rangeArr{
    NSValue *points[rangeArr.count];
    NSArray *arr = [NSArray array];
    for (int i = 0; i< rangeArr.count; i++) {
        NSString *str =  rangeArr[i];
        NSArray *array = [str componentsSeparatedByString:@","];
        NSString *one = [NSString stringWithFormat:@"%@",array[1]];
        NSString *two = [NSString stringWithFormat:@"%@",array[0]];
        arr  = [arr arrayByAddingObject:[NSValue valueWithMACoordinate:CLLocationCoordinate2DMake([two doubleValue], [one doubleValue])]];
    }
    NSArray *arr5 = [NSArray arrayWithArray:arr];
    bool containPoint = [self rayCasting:p array:arr];
    return containPoint;
}
- (BOOL)rayCasting:(NSValue *)p array:(NSArray *)poly{
    CLLocationDegrees px = [p MACoordinateValue].longitude;
    CLLocationDegrees py = [p MACoordinateValue].latitude;
    BOOL flag = false;
    
    
    NSInteger j ;//= poly.count - 1;
    for (int i = 0; i < poly.count ; i ++) {
        CLLocationCoordinate2D point = [poly[i] MACoordinateValue];
        j = i - 1;
        if (i == 0) {
            j = poly.count - 1;
        }
        CLLocationCoordinate2D comparePoint = [poly[j] MACoordinateValue];
        CLLocationDegrees sx = point.longitude;
        CLLocationDegrees sy = point.latitude;
        CLLocationDegrees tx = comparePoint.longitude;
        CLLocationDegrees ty = comparePoint.latitude;
        
        // 点与多边形顶点重合
        if((sx == px && sy == py) || (tx == px && ty == py)) {
            return YES;
        }
        
        // 判断线段两端点是否在射线两侧
        if((sy < py && ty >= py) || (sy >= py && ty < py)) {
            // 线段上与射线 Y 坐标相同的点的 X 坐标
            CLLocationDegrees x = sx + (py - sy) * (tx - sx) / (ty - sy);
            
            // 点在多边形的边上
            if(x == px) {
                return YES;
            }
            
            // 射线穿过多边形的边界
            if(x > px) {
                flag = !flag;
            }
        }
    }
    
    // 射线穿过多边形边界的次数为奇数时点在多边形内
    return flag ? YES : NO;
}

-(void) hideMapView{
    NSLog(@"yuan  hideMapView");
    //    [mapView setHidden:true];
    //    [hideView setHidden:true];
    //    [_topView setHidden:true];
    //    [_bottomView setHidden:true];
}

-(void) hideImageView{
    NSLog(@"yuan  hideImageView");
    [urlImageFather setHidden:true];
    [uiScrollview setHidden:true];
}

- (void)requestPOIData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://location-project.newayz.com/wayzoom/poi/list"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        NSDictionary *headers = @{
            @"Content-Type": @"application/json"
        };
        
        [request setAllHTTPHeaderFields:headers];
        //121.604187,31.179615
        //        double lon  = 121.604187;
        //        double lat  = 31.179615;
        double lon  = currentLocation.coordinate.longitude;
        double lat  = currentLocation.coordinate.latitude;
        NSString *requestJson = [NSString stringWithFormat:@"{\n    \"longitude\":%f,\n    \"latitude\":%f,\n    \"radius\":1500,\n    \"geometry_type\": \"point\",\n    \"place_type\": \"Tower\",\n    \"province\": \"\",\n    \"city\": \"\",\n    \"district\": \"\",\n    \"keyword\":\"\"\n}",lon,lat ];
        NSLog(@"yuan poirequestJson%@", requestJson);
        NSData *postData = [[NSData alloc] initWithData:[requestJson dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postData];
        
        [request setHTTPMethod:@"POST"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"yuan poi%@", error);
                dispatch_semaphore_signal(sema);
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                pois = responseDictionary[@"data"];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //[self requestPOIConvertTest];
                    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
                    [requestDic setValue:pois forKey:@"POIList"];
                    NSMutableDictionary *currentLocationD = [[NSMutableDictionary alloc]init];
                    [currentLocationD setValue:@(lon) forKey:@"lon"];
                    [currentLocationD setValue:@(lat) forKey:@"lat"];
                    [requestDic setValue:currentLocationD forKey:@"currentLocation"];
                    NSError *parseError = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDic options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", jsonString);
                    //jsonString = @"{\"POIList\":[{\"placeId\":\"7hJzyYaLaBt\",\"name\":\"申江花苑\",\"lon\":121.340892,\"lat\":31.259101,\"hight\":null,\"distance\":200,\"type\":\"Tower\",\"classId\":20000,\"className\":\"企业商务\"},{\"placeId\":\"嘉年华商场\",\"lon\":121.345291,\"lat\":31.260587,\"hight\":null,\"distance\":100,\"type\":\"Tower\",\"classId\":20000,\"className\":\"企业商务\"},{\"placeId\":\"7hJfARLzjSQ\",\"name\":\"江桥佳苑\",\"lon\":121.343811,\"lat\":31.256203,\"hight\":null,\"distance\":300,\"type\":\"Tower\",\"classId\":20000,\"className\":\"企业商务\"}],\"currentLocation\":{\"lon\":121.344857,\"lat\":31.258711}}";
                    NSLog(@"jsonSt  %@",jsonString);
                    //[[UnityToiOSManger sharedInstance]sendMsgToUnityGetPOIInfoFromPhone:jsonString];
                    NSString *jsonString3DText = @"{\"ThreeDTextList\":[{\"placeId\":\"7hJzyYaLaBt\",\"text\":\"维智科技欢迎您！\",\"lon\":121.344953,\"lat\":31.259122},{\"placeId\":\"1233\",\"lon\":121.345457,\"lat\":31.258388,\"text\":\"维智科技欢迎您！\"},{\"placeId\":\"7hJfARLzjSQ\",\"lon\":121.344594,\"lat\":31.258819,\"text\":\"维智科技欢迎您！\"}],\"currentLocation\":{\"lon\":121.344932,\"lat\":31.258743}}";
                    //[[UnityToiOSManger sharedInstance]send3DTextMsgToUnity:jsonString3DText];
                    
                });
                NSLog(@"yuan poi%@",responseDictionary[@"data"]);
                dispatch_semaphore_signal(sema);
            }
        }];
        [dataTask resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
}

//把多个json字符串转为一个json字符串

- (NSString *)objArrayToJSON:(NSArray *)array {
    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    return jsonStr;
    
}

//x1,y1 点1的坐标 x2,y2点2的坐标

-(double) gps2m:(double)x1 _y1:(double)y1 _x2:(double)x2 _y2:(double)y2{
    
    double radLat1 = (x1 * 3.1416 / 180.0);
    
    double radLat2 = (x2 * 3.1416 / 180.0);
    
    double a = radLat1 - radLat2;
    
    double b = (y1 - y2) * 3.1416 / 180.0;
    
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2)
                             
                             + cos(radLat1) * cos(radLat2)
                             
                             * pow(sin(b / 2), 2)));
    
    s = s * 6378137.0;
    
    s = round(s * 10000) / 10000;
    
    return s;
    
}
-(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}
-(void) singleTapZhankai:(UITapGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:1 animations:^{
        if (self->showSceneMenu) {
            CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI*1);
            [self->uiImageViewZhanKai setTransform:transform];
            self.bottomView.frame = CGRectMake(self.view.frame.size.width,self.view.frame.size.height-190, self.view.frame.size.width-80,  190);
        }else{
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*0);
            [self->uiImageViewZhanKai setTransform:transform];
            self.bottomView.frame = CGRectMake(0,self.view.frame.size.height-190, self.view.frame.size.width-80,  190);
        }
    } completion:^(BOOL finished) {
        if (self->showSceneMenu) {
            self->showSceneMenu = false;
        }else{
            self->showSceneMenu = true;
        }
    }];
}

- (void)initUI{
    uiViewTakePhoto = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height/2-70, 80, 140)];
    UIImageView *iconTakePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    iconTakePhoto.image = [UIImage imageNamed:@"ic_take_photo"];
    iconTakePhoto.contentMode = UIViewContentModeScaleAspectFill;
    [iconTakePhoto setUserInteractionEnabled:YES];
    [iconTakePhoto setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [iconTakePhoto addGestureRecognizer:singleTap3];
    [uiViewTakePhoto addSubview:iconTakePhoto];
    UILabel *uiLabelTakePhoto = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 40, 30)];
    uiLabelTakePhoto.text = @"拍照";
    uiLabelTakePhoto.textColor = [UIColor whiteColor];
    uiLabelTakePhoto.font = [UIFont systemFontOfSize:18];
    [uiViewTakePhoto addSubview:uiLabelTakePhoto];
    [self.view addSubview:uiViewTakePhoto];
    
    uiViewPicturePreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    uiViewPicturePreview.backgroundColor = [[UIColor alloc]initWithRed:0.847 green:0.847 blue:0.847 alpha:0.7];
    UIImageView *uiImageUpload = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 103, self.view.frame.size.height-140, 206, 90)];
    uiImageUpload.image = [UIImage imageNamed:@"ic_upload_photo"];
    uiImageUpload.contentMode = UIViewContentModeScaleAspectFill;
    [uiImageUpload setUserInteractionEnabled:YES];
    [uiImageUpload setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPhoto)];
    [uiImageUpload addGestureRecognizer:singleTap5];
    [uiViewPicturePreview addSubview:uiImageUpload];
    ivPhotoPreview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.height-230)*self.view.frame.size.width/self.view.frame.size.height/2, 50,(self.view.frame.size.height-230)*self.view.frame.size.width/self.view.frame.size.height, self.view.frame.size.height-230)];
    ivPhotoPreview.layer.cornerRadius = 20;
    ivPhotoPreview.clipsToBounds = true;
    ivPhotoPreview.backgroundColor = [UIColor grayColor];
    ivPhotoPreview.contentMode = UIViewContentModeScaleAspectFit;
    [uiViewPicturePreview addSubview:ivPhotoPreview];
    [uiViewPicturePreview setHidden:true];
    [self.view addSubview:uiViewPicturePreview];
    ivUploading = [[UIImageView alloc]initWithFrame:CGRectMake(ivPhotoPreview.frame.size.width/2-192.5, ivPhotoPreview.frame.size.height/2-15.5,385, 35)];
    ivUploading.contentMode = UIViewContentModeScaleAspectFit;
    NSMutableArray *imagesArray = [NSMutableArray array];
    [imagesArray addObject:[UIImage imageNamed:@"ic_uploading_one"]];
    [imagesArray addObject:[UIImage imageNamed:@"ic_uploading_two"]];
    [imagesArray addObject:[UIImage imageNamed:@"ic_uploading_three"]];
    ivUploading.animationImages = imagesArray;
    ivUploading.animationRepeatCount = 0;
    ivUploading.animationDuration = 1;
    [ivUploading startAnimating];
    [ivUploading setHidden:true];
    [ivPhotoPreview addSubview:ivUploading];
    uiErweimaFather = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //展示
    ivErweima = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-325/2, self.view.frame.size.height/2 - 704/2, 650/2, 1408/2)];
    uiErweimaFather.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    ivErweima.contentMode = UIViewContentModeScaleAspectFit;
    uiErweimaFather.userInteractionEnabled = YES;
    [uiErweimaFather addSubview:ivErweima];
    [uiViewPicturePreview addSubview:uiErweimaFather];
    [uiErweimaFather setHidden:true];
    
    UIImageView *ivClosePhotoPreview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-230, 50, 60, 60)];
    ivClosePhotoPreview.image = [UIImage imageNamed:@"ic_close_photo_preview"];
    ivClosePhotoPreview.contentMode = UIViewContentModeScaleAspectFit;
    ivClosePhotoPreview.contentMode = UIViewContentModeScaleAspectFill;
    [ivClosePhotoPreview setUserInteractionEnabled:YES];
    [ivClosePhotoPreview setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePhotoPreview)];
    [ivClosePhotoPreview addGestureRecognizer:singleTap6];
    [uiViewPicturePreview addSubview:ivClosePhotoPreview];
    
    
    menuStringList = [[NSMutableArray alloc]init];
    [menuStringList addObject:@"时间"];
    [menuStringList addObject:@"距离"];
    [menuStringList addObject:@"滤镜"];
    [menuStringList addObject:@"兴趣点"];
    rightUiView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160, self.view.frame.size.height/2-125, 150, 250)];
    [rightUiView setClipsToBounds:YES];
    fatherView = [[MyTouchView alloc]initWithFrame:CGRectMake(0, 0, 150, 250)];
    fatherView.delegate = self;
    UIImageView *bgSelected = [[UIImageView alloc]initWithFrame:CGRectMake(30, 107, 90, 36)];
    bgSelected.backgroundColor = [UIColor blackColor];
    bgSelected.layer.cornerRadius = 18;
    [rightUiView addSubview:bgSelected];
    [rightUiView addSubview:fatherView];
    [self.view addSubview:rightUiView];
    [rightUiView setHidden:true];
    
    for (int a = 0; a<menuStringList.count; a++) {
        UILabel *uiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, a*50, 150, 50)];
        NSString *text = menuStringList[a];
        uiLabel.text = text;
        if (a==0) {
            currentMenuIndex = 0;
            selectedUILabel = uiLabel;
            uiLabel.textColor = [UIColor yellowColor];
        }else{
            uiLabel.textColor = [UIColor whiteColor];
        }
        uiLabel.font = [UIFont systemFontOfSize:16];
        [uiLabel setUserInteractionEnabled:YES];
        [uiLabel setMultipleTouchEnabled:YES];
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenu:)];
        //NSNumber a = [NSNumber numberWithInt:i] ;
        [uiLabel setTag:a];
        [uiLabel addGestureRecognizer:singleTap1];
        uiLabel.textAlignment = NSTextAlignmentCenter;
        [fatherView addSubview:uiLabel];
    }
    [self->fatherView setFrame:CGRectMake(0, (2-currentMenuIndex)*50, 150, 10*50)];
    
    distanceSlider = [[UISlider alloc]initWithFrame:CGRectMake(-100, self.view.frame.size.height/2-15, 300, 30)];
    distanceSlider.minimumValue = 0;//指定可变最小值
    distanceSlider.maximumValue = 100;//指定可变最大值
    distanceSlider.value = 50;//指定初始值
    [distanceSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];//设置响应事件
    [self.view addSubview:distanceSlider];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*0.5);
    [distanceSlider setTransform:transform];
    
    [self setCurrentSelected:currentMenuIndex];
    /*方法1*/
    //    UILabel* testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 400, 50)];
    //        testLabel.text = @"label上渐变方法1";
    //        testLabel.font = [UIFont systemFontOfSize:30];
    //        [self.view addSubview:testLabel];
    //        [self TextGradientview:testLabel bgVIew:self.view gradientColors:@[ (id)[UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:0.0].CGColor, (id)[UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:1].CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    
    currentArSceneBeanList = [[NSMutableArray alloc]init];
    showWeilan = true;
    stateType = initing;
    check = false;
    showPOI = false;
    
    
    // Do any additional setup after loading the view.
    [self initSubViews];
    
    //
    //[self requestPOIConvert:@"11"];
    
    
    [AMapServices sharedServices].apiKey = @"3b82166a3f233457fe9f4c02e485837d";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //self.locationManager.distanceFilter:2;
    
    //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    //开始持续定位
    [self.locationManager startUpdatingLocation];
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    //初始化地图
    mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width,  self.view.frame.size.height/2)];
    
    ///把地图添加至view
    [self.view addSubview:mapView];
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:mapView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = mapView.bounds;
    maskLayer.path = maskPath.CGPath;
    mapView.layer.mask = maskLayer;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
    mapView.showsCompass= NO; // 设置成NO表示关闭指南针；YES表示显示指南针
    [mapView setZoomLevel:18.5 animated:YES];
    mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
    mapView.rotateCameraEnabled= NO;    //NO表示禁用倾斜手势，YES表示开启
    mapView.delegate = self;
    UIImageView *mapReset = [[UIImageView alloc]initWithFrame:CGRectMake(mapView.frame.size.width-63, mapView.frame.size.height-60, 43, 43)];
    [mapReset setImage:[UIImage imageNamed:@"ic_map_reset"]];
    [mapReset setUserInteractionEnabled:YES];
    [mapReset setMultipleTouchEnabled:YES];
    mapReset.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapReset)];
    singleTap1.numberOfTapsRequired = 1;
    singleTap1.numberOfTouchesRequired = 1;
    [mapReset addGestureRecognizer:singleTap1];
    [mapView addSubview:mapReset];
    
    [mapView setHidden:true];
    
    //下载动画UI
    //波浪
    HWWaveView *waveView = [[HWWaveView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/2-self.view.frame.size.width/4, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    [self.view addSubview:waveView];
    self.waveView = waveView;
    [self.waveView setHidden:true];
    
    
    urlImageFather = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //展示
    urlImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-325/2, self.view.frame.size.height/2 - 704/2, 650/2, 1408/2)];
    urlImageFather.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    urlImage.contentMode = UIViewContentModeScaleAspectFit;
    //NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https:\/\/aimap.newayz.com\/aimap\/lantern_riddle\/lantern-riddle-auth-image\/010.png"]];
    [urlImage sd_setImageWithURL:@"https://aimap.newayz.com/aimap/lantern_riddle/lantern-riddle-auth-image/0000.png"];
    //CGAffineTransform transform2 = CGAffineTransformMakeRotation(M_PI*0.5);
    //[urlImage setTransform:transform2];
    
    urlImageFather.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView)];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    [urlImageFather addGestureRecognizer:singleTap];
    [urlImageFather addGestureRecognizer:longTap];
    [urlImageFather addSubview:urlImage];
    [self.view addSubview:urlImageFather];
    [urlImageFather setHidden:true];
    
    uiScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(150, 0, self.view.frame.size.width-300, self.view.frame.size.height)];
    urlImageImageInfo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-300, self.view.frame.size.height)];
//    [urlImageImageInfo sd_setImageWithURL:@"https://aimap.newayz.com/aimap/lantern_riddle/lantern-riddle-auth-image/0000.png"];
    UITapGestureRecognizer *singleTapInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView)];
    [urlImageImageInfo addGestureRecognizer:singleTapInfo];
    urlImageImageInfo.userInteractionEnabled = YES;
    urlImageImageInfo.contentMode = UIViewContentModeScaleAspectFit;
    [uiScrollview addSubview:urlImageImageInfo];
    [self.view addSubview:uiScrollview];
    [uiScrollview setHidden:true];
    
    deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        self.topView = [[ARSpiritTitleView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,  300)];
    }else{
        self.topView = [[ARSpiritTitleView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,  243)];
    }
    self.topView.delegate = self;
    [self.view addSubview:_topView];
    [self.topView setHidden:true];
    
    self.bottomView = [[ARPetRulesView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-190, self.view.frame.size.width-80,  190)];
    self.bottomView.delegate = self;
    [self.bottomView setHidden:true];
    //self.bottomView.userInteractionEnabled = false;
    [self.view addSubview:_bottomView];
    
    
    
    uiImageViewZhanKai = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, self.view.frame.size.height-150, 60, 60)];
    [uiImageViewZhanKai setImage:[UIImage imageNamed:@"zhankai_menu"]];
    [self.view addSubview:uiImageViewZhanKai];
    [uiImageViewZhanKai setUserInteractionEnabled:YES];
    [uiImageViewZhanKai setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTapZhankai = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapZhankai:)];
    [uiImageViewZhanKai addGestureRecognizer:singleTapZhankai];
    
    
    menuView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 100, 100, 500)];
    [self.view addSubview:menuView];
    menuView.hidden = true;
    manualPosition = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [manualPosition setTitle:@"定位" forState:UIControlStateNormal];
    manualPosition.titleLabel.text = @"定位";
    manualPosition.backgroundColor = [UIColor redColor];
    manualPosition.hidden = true;
    [menuView addSubview:manualPosition];
    UITapGestureRecognizer *singleTapDingwei = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dingwei)];
    [manualPosition addGestureRecognizer:singleTapDingwei];
    
    UILabel *debugText = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 100, 20)];
    debugText.text = @"debug模式";
    debugText.textColor = [UIColor whiteColor];
    [menuView addSubview:debugText];
    openDebugSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 70, 50, 30)];
    [openDebugSwitch addTarget:self action:@selector(openDebugMode:) forControlEvents:UIControlEventValueChanged];
    [menuView addSubview:openDebugSwitch];
    
    UIButton *clearData = [[UIButton alloc]initWithFrame:CGRectMake(0, 130, 100, 20)];
    [clearData setTitle:@"清理缓存" forState:UIControlStateNormal];
    clearData.titleLabel.text = @"清理缓存";
    clearData.backgroundColor = [UIColor redColor];
    [menuView addSubview:clearData];
    UITapGestureRecognizer *singleTapClearDatai = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearData)];
    [clearData addGestureRecognizer:singleTapClearDatai];
    
    UIButton *setDingweiTime = [[UIButton alloc]initWithFrame:CGRectMake(0, 180, 100, 20)];
    [setDingweiTime setTitle:@"设置定位间隔" forState:UIControlStateNormal];
    setDingweiTime.titleLabel.text = @"设置定位间隔";
    setDingweiTime.backgroundColor = [UIColor redColor];
    setDingweiTime.hidden = true;
    [menuView addSubview:setDingweiTime];
    UITapGestureRecognizer *singleTapDingweiTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDingweiTimeO)];
    [setDingweiTime addGestureRecognizer:singleTapDingweiTime];
    
    UIView *showDebugView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.view addSubview:showDebugView];
    [showDebugView setUserInteractionEnabled:YES];
    [showDebugView setMultipleTouchEnabled:YES];
    UILongPressGestureRecognizer *showDebugViewSingleTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapShowDebugView:)];
    [showDebugView addGestureRecognizer:showDebugViewSingleTap];
    
    ivChangeTheme = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-31-40, 177, 40, 40)];
    ivChangeTheme.image = [UIImage imageNamed:@"ic_change_theme"];
    ivChangeTheme.contentMode = UIViewContentModeScaleAspectFit;
    [ivChangeTheme setUserInteractionEnabled:YES];
    [ivChangeTheme setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *changeTheme = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme)];
    [ivChangeTheme addGestureRecognizer:changeTheme];
    [ivChangeTheme setHidden:true];
    [self.view addSubview:ivChangeTheme];
    
    ivScanQRTip = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //ivScanQRTip.image = [UIImage imageNamed:@"ic_scan_qr_tip"];
    //ivScanQRTip.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *scanQRKuang = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-227/2, self.view.frame.size.height/2-229/2, 227, 229)];
    scanQRKuang.image = [UIImage imageNamed:@"ic_scan_qr_kuang"];
    scanQRKuang.contentMode = UIViewContentModeScaleAspectFit;
    [ivScanQRTip addSubview:scanQRKuang];
    scanQRLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-225/2, self.view.frame.size.height/2-229/2-116, 225, 116)];
    scanQRLine.image = [UIImage imageNamed:@"ic_scan_qr_line"];
    scanQRLine.contentMode = UIViewContentModeScaleAspectFit;
    [self startScanQRAnima];
    [ivScanQRTip addSubview:scanQRLine];
    UILabel *scanQRText = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-222/2, self.view.frame.size.height/2+229/2+10, 222, 30)];
    scanQRText.text = @"扫一扫二维码进入场景";
    scanQRText.textColor = [UIColor whiteColor];
    scanQRText.font = [UIFont systemFontOfSize:18];
    scanQRText.textAlignment = NSTextAlignmentCenter;
    [ivScanQRTip addSubview:scanQRText];
    
    ivScanQRTip.hidden = true;
    [self.view addSubview:ivScanQRTip];
    
    UIView *menuPosition = [[UIView alloc]initWithFrame:CGRectMake(30, 38, 306, 48)];
    menuPosition.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.6800];
    menuPosition.layer.cornerRadius = 24;
    [self.view addSubview:menuPosition];
    
    QRPosition = [[UIButton alloc]initWithFrame:CGRectMake(12, 10, 84, 28)];
    [QRPosition setTitle:@"定位模式" forState:UIControlStateNormal];
    UIImage *whiteImage = [UIImage yy_imageWithColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2000]];
    [QRPosition setBackgroundImage:whiteImage forState:UIControlStateNormal];
    UIImage *grayImage = [UIImage yy_imageWithColor: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9000]];
    [QRPosition setBackgroundImage:grayImage forState:UIControlStateHighlighted];
    [QRPosition setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QRPosition setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    QRPosition.titleLabel.font = [UIFont systemFontOfSize:16];
    QRPosition.layer.cornerRadius = 14;
    QRPosition.layer.masksToBounds = YES;
    [menuPosition addSubview:QRPosition];
    UITapGestureRecognizer *singleTapQRPosition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseQRPosition)];
    [QRPosition addGestureRecognizer:singleTapQRPosition];
    
    openOrClosePosition = [[UIButton alloc]initWithFrame:CGRectMake(111, 10, 84, 28)];
    [openOrClosePosition setTitle:@"关闭定位" forState:UIControlStateNormal];
    [openOrClosePosition setBackgroundImage:whiteImage forState:UIControlStateNormal];
    [openOrClosePosition setBackgroundImage:grayImage forState:UIControlStateHighlighted];
    [openOrClosePosition setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openOrClosePosition setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    openOrClosePosition.titleLabel.font = [UIFont systemFontOfSize:16];
    openOrClosePosition.layer.cornerRadius = 14;
    openOrClosePosition.layer.masksToBounds = YES;
    [menuPosition addSubview:openOrClosePosition];
    UITapGestureRecognizer *singleTapopenOrClosePosition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrClosePosition)];
    [openOrClosePosition addGestureRecognizer:singleTapopenOrClosePosition];
    
    UIButton *handPositon = [[UIButton alloc]initWithFrame:CGRectMake(211, 10, 84, 28)];
    [handPositon setTitle:@"手动定位" forState:UIControlStateNormal];
    [handPositon setBackgroundImage:whiteImage forState:UIControlStateNormal];
    [handPositon setBackgroundImage:grayImage forState:UIControlStateHighlighted];
    [handPositon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [handPositon setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    handPositon.titleLabel.font = [UIFont systemFontOfSize:16];
    handPositon.layer.cornerRadius = 14;
    handPositon.layer.masksToBounds = YES;
    [menuPosition addSubview:handPositon];
    UITapGestureRecognizer *singleTaphandPositon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handPositon)];
    [handPositon addGestureRecognizer:singleTaphandPositon];
    
    //    UIButton *add3DText = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 40, 100, 30)];
    //    [add3DText setTitle:@"文字转图片" forState:UIControlStateNormal];
    //    add3DText.titleLabel.text = @"文字转图片";
    //    add3DText.titleLabel.textColor = [UIColor whiteColor];
    //    add3DText.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    add3DText.layer.cornerRadius = 5;
    //    add3DText.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.2];
    //    //add3DText.hidden = true;
    //    [self.view addSubview:add3DText];
    //    UITapGestureRecognizer *singleTapAdd3DText = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add3DText)];
    //    [add3DText addGestureRecognizer:singleTapAdd3DText];
    //
    //    UIButton *startLinstening = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 120, 80, 100, 30)];
    //    [startLinstening setTitle:@"语音转图片" forState:UIControlStateNormal];
    //    startLinstening.titleLabel.text = @"语音转图片";
    //    startLinstening.titleLabel.textColor = [UIColor whiteColor];
    //    startLinstening.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    startLinstening.layer.cornerRadius = 5;
    //    startLinstening.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.2];
    //    //add3DText.hidden = true;
    //    [self.view addSubview:startLinstening];
    //    UITapGestureRecognizer *singleTapStartLinstening = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startListening)];
    //    [startLinstening addGestureRecognizer:singleTapStartLinstening];
    //    if(defined(DEBUG)||defined(_DEBUG)){
    //    [uiButton setHidden:true];
    //    }
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (local) {
            NSString *localJson = @"[{\"id\":\"wayz_000063\",\"name\":\"绿地缤纷广场\",\"description\":\"元宇宙AR（室内11）\",\"avatar\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/picture/lvdi_showcase.png?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1725363827&Signature=CQPDuuIUIf6oEEMusuaAkpIk2uo%3D\",\"type\":\"SceneAR\",\"deviceType\":\"iosShowCase\",\"style\":\"wayz9L_1\",\"place\":\"绿炬人\",\"coordinate\":{\"longitude\":121.603962,\"latitude\":31.179835},\"boundary\":{\"type\":\"Polygon\",\"coordinates\":[[[121.602234,31.179854],[121.605442,31.180157],[121.606032,31.176604],[121.60246,31.176256]]]},\"boundaryId\":\"2\",\"city\":\"上海市\",\"township\":\"浦东区\",\"address\":\"浦东新区祥科路58号\",\"package\":{\"files\":[{\"id\":\"f147811b-2ec9-4a7d-9b36-f92dce9e90f4\",\"name\":\"miscs/9l.zip\",\"type\":\"zip\",\"link\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/ARData/test/ios/%E7%BB%BF%E5%9C%B0/%E7%BB%BF%E5%9C%B0%E5%B9%BF%E5%9C%BA/0908/SuperDemo_lvdi.zip?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1724831839&Signature=zV7NvZwxnuBrLXjsolWOqhxC2iA%3D\",\"size\":120851120,\"createTime\":\"2021-11-23T16:53:42+08:00\",\"updateTime\":\"2021-11-23T16:53:49+08:00\"}]},\"createTime\":\"2021-12-28T16:05:54+08:00\",\"updateTime\":\"2021-11-28T16:05:54+08:00\"},{\"id\":\"wayz_000062\",\"name\":\"炬创芯园区\",\"description\":\"元宇宙AR（室内11）\",\"avatar\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/picture/juxin.jpeg?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1719889696&Signature=aIaHVBV2gJjvKuJlRxr%2FN8p3t8c%3D\",\"type\":\"SceneAR\",\"deviceType\":\"iosShowCase\",\"style\":\"wayz9L_1\",\"place\":\"绿炬人\",\"coordinate\":{\"longitude\":121.603962,\"latitude\":31.179835},\"boundary\":{\"type\":\"Polygon\",\"coordinates\":[[[121.602234,31.179854],[121.605442,31.180157],[121.606032,31.176604],[121.60246,31.176256]]]},\"boundaryId\":\"2\",\"city\":\"上海市\",\"township\":\"浦东区\",\"address\":\"浦东新区祥科路58号\",\"package\":{\"files\":[{\"id\":\"f147811b-2ec9-4a7d-9b36-f92dce9e90f4\",\"name\":\"miscs/9l.zip\",\"type\":\"zip\",\"link\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/ARData/test/ios/%E7%BB%BF%E5%9C%B0/%E7%82%AC%E5%88%9B%E8%8A%AF%E5%9B%AD%E5%8C%BA/0730/superdemo.zip?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1721384331&Signature=GOPvQz6UbopclpRzWm1CdTsUMho%3D\",\"size\":110851120,\"createTime\":\"2021-11-23T16:53:42+08:00\",\"updateTime\":\"2021-11-23T16:53:56+08:00\"}]},\"createTime\":\"2021-12-28T16:05:54+08:00\",\"updateTime\":\"2021-11-28T16:05:54+08:00\"},{\"id\":\"wayz_000083\",\"name\":\"VT_showcase\",\"description\":\"元宇宙AR（室内11）\",\"avatar\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/picture/VT_showcase.JPG?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1725364937&Signature=rCDYTmPqLH0D2q%2B50SgZH21WPd0%3D\",\"type\":\"SceneAR\",\"deviceType\":\"iosShowCase\",\"style\":\"wayz9L_1\",\"place\":\"维智9楼\",\"coordinate\":{\"longitude\":121.603962,\"latitude\":31.179835},\"boundary\":{\"type\":\"Polygon\",\"coordinates\":[[[121.603801,31.180111],[121.605346,31.180276],[121.605464,31.179294],[121.603994,31.179165]]]},\"boundaryId\":\"1\",\"city\":\"上海市\",\"township\":\"浦东区\",\"address\":\"浦东新区祥科路58号\",\"package\":{\"files\":[{\"id\":\"f147811b-2ec9-4a7d-9b36-f92dce9e90f4\",\"name\":\"miscs/9l.zip\",\"type\":\"zip\",\"link\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/ARData/test/ios/test/0914/VT/9L_VT.zip?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1725346281&Signature=kDnEGI6cNfxIb5v5e3xfRLFvQT4%3D\",\"size\":20258488,\"createTime\":\"2021-11-23T16:53:42+08:00\",\"updateTime\":\"2021-11-23T16:53:15+08:00\"}]},\"createTime\":\"2021-12-28T16:05:54+08:00\",\"updateTime\":\"2021-11-28T16:05:54+08:00\"},{\"id\":\"wayz_000055\",\"name\":\"9L_showcase\",\"description\":\"元宇宙AR（室内11）\",\"avatar\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/picture/9L_showcase.jpeg?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1725365173&Signature=AFNjL4yzkuRKNPEBJQcnVBFGiKY%3D\",\"type\":\"SceneAR\",\"deviceType\":\"iosShowCase\",\"style\":\"wayz9L_1\",\"place\":\"维智9楼\",\"coordinate\":{\"longitude\":121.603962,\"latitude\":31.179835},\"boundary\":{\"type\":\"Polygon\",\"coordinates\":[[[121.603801,31.180111],[121.605346,31.180276],[121.605464,31.179294],[121.603994,31.179165]]]},\"boundaryId\":\"1\",\"city\":\"上海市\",\"township\":\"浦东区\",\"address\":\"浦东新区祥科路58号\",\"package\":{\"files\":[{\"id\":\"f147811b-2ec9-4a7d-9b36-f92dce9e90f4\",\"name\":\"miscs/9l.zip\",\"type\":\"zip\",\"link\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/ARData/test/ios/9l/showcase/9L_showcase/0804/9L_Showcase.zip?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1721819478&Signature=7F4svYVgzCdkPC3EQsVct6wBThU%3D\",\"size\":20258488,\"createTime\":\"2021-11-23T16:53:42+08:00\",\"updateTime\":\"2021-11-23T16:53:15+08:00\"}]},\"createTime\":\"2021-12-28T16:05:54+08:00\",\"updateTime\":\"2021-11-28T16:05:54+08:00\"},{\"id\":\"wayz_000038\",\"name\":\"vip_showcase\",\"description\":\"元宇宙AR（室内）\",\"avatar\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/picture/vipshowcase.jpg?AWSAccessKeyId=D9CCB23C99FCD04A1195FAA92BF26B86&Expires=1718187207&Signature=F6kgy3a1uLilqFtzvsx4exM%2FvdA%3D\",\"type\":\"SceneAR\",\"deviceType\":\"iosShowCase\",\"style\":\"wayz9L_1\",\"place\":\"维智9楼\",\"coordinate\":{\"longitude\":121.603962,\"latitude\":31.179835},\"boundary\":{\"type\":\"Polygon\",\"coordinates\":[[[121.603801,31.180111],[121.605346,31.180276],[121.605464,31.179294],[121.603994,31.179165]]]},\"boundaryId\":\"1\",\"city\":\"上海市\",\"township\":\"浦东区\",\"address\":\"浦东新区祥科路58号\",\"package\":{\"files\":[{\"id\":\"f147811b-2ec9-4a7d-9b36-f92dce9e90f4\",\"name\":\"miscs/9l.zip\",\"type\":\"zip\",\"link\":\"https://zjar-rawdata.s3.cn-north-1.jdcloud-oss.com/ARData/test/ios/9l/showcase/VIPshowcase/0724/VIPshowcase.zip?AWSAccessKeyId=JDC_6D0BA40C9CFBD5114AD6D797F095&Expires=1720878725&Signature=E%2FJak6WtaxSZJ7QsNSA5zKNYPgo%3D\",\"size\":20258488,\"createTime\":\"2021-11-23T16:53:42+08:00\",\"updateTime\":\"2021-11-23T16:53:56+08:00\"}]},\"createTime\":\"2021-11-28T16:05:54+08:00\",\"updateTime\":\"2021-11-28T16:05:54+08:00\"}]\n";
            NSData *jsonData = [localJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parseError];
            self->arSceneBeanList = [ARSceneBean mj_objectArrayWithKeyValuesArray:responseDictionary];
            //[self shuffle];
            NSLog(@"yuan bendi%@",responseDictionary);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self initData];
            });
        }else{
            [self requetData];
        }
        //[self getCoffeeOrder:@"a"];
        //        [self requestPOIData];
    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (true) {
//            [NSThread sleepForTimeInterval: 20];
//            [UIDevice currentDevice].batteryMonitoringEnabled = YES;
//            double deviceLevel = [UIDevice currentDevice].batteryLevel;
//            NSString *info = [[NSString alloc]initWithFormat:@"当前电量:%f",deviceLevel];
//            //[YPLogTool YPWLogInfo:info];
//        }
//        
//    });
}

- (void) startScanQRAnima{
    [self->scanQRLine setFrame:CGRectMake(self.view.frame.size.width/2-225/2, self.view.frame.size.height/2-229/2-116, 225, 116)];
    [UIView animateWithDuration:2 animations:^{
        [self->scanQRLine setFrame:CGRectMake(self.view.frame.size.width/2-225/2, self.view.frame.size.height/2+229/2-116, 225, 116)];
    } completion:^(BOOL finished) {
        [self startScanQRAnima];
    }];
}

- (void) startListening{
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    //设置识别参数
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //set recognition domain
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    _iFlySpeechRecognizer.delegate = self;
    //启动识别服务
    [self.iFlySpeechRecognizer startListening];
    NSLog(@"yuan startListening");
    [self.view makeToast:@"开始监听，请说话!" duration:2 position:CSToastPositionCenter];
}

//IFlySpeechRecognizerDelegate协议实现
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSLog(@"yuan onResults");
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  nil;
    
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
                                    [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [ISRDataHelper stringFromJson:resultString];
    }
    
    //[YPLogTool YPWLogInfo:[[NSString alloc]initWithFormat:@"resultFromJson %@",resultFromJson]];
    if([resultFromJson containsString:@"。"]||[resultFromJson containsString:@"."]){
        return;
    }
    resultFromJson = [resultFromJson stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([resultFromJson isEqualToString:@""]){
        [[UIApplication sharedApplication].keyWindow makeToast:@"输入字符无效，请重新输入！" duration:2 position:CSToastPositionCenter];
        [UnityToiOSManger.sharedInstance GetImgUrl:@""];
        return;
    }
    //    [self.view makeToast:resultFromJson];
    if(blessingListening){
        [[UnityToiOSManger sharedInstance]GetVoiceStr:resultFromJson];
        [self.view makeToast:resultFromJson];
        blessingListening = false;
        return;
    }
    [self.view makeToast:resultFromJson];
    if([resultFromJson containsString:@"拍照"]){
        [self takePhoto];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self requestBaiduTranslate:resultFromJson];
            
        });
    }
}
//识别会话结束返回代理
- (void)onCompleted: (IFlySpeechError *) error{
    NSLog(@"yuan onCompleted%@",error.errorDesc);
    NSString *msg = [[NSString alloc]initWithFormat:@"语音监听 %@",error.errorDesc ];
    //    [self.view makeToast:msg];
}
//停止录音回调
- (void) onEndOfSpeech{
    NSLog(@"yuan onEndOfSpeech");
    //    [self.view makeToast:@"yuan onEndOfSpeech"];
}
//开始录音回调
- (void) onBeginOfSpeech{
    NSLog(@"yuan onBeginOfSpeech");
    //    [self.view makeToast:@"yuan onBeginOfSpeech"];
}
//音量回调函数
- (void) onVolumeChanged: (int)volume{
    NSLog(@"yuan onVolumeChanged");
}
//会话取消回调
- (void) onCancel{
    NSLog(@"yuan onCancel");
    //    [self.view makeToast:@"yuan onCancel"];
}

-(void)closePhotoPreview{
    [uiViewPicturePreview setHidden:true];
    [ivUploading setHidden:true];
    [uiErweimaFather setHidden:true];
}

-(void)uploadPhoto{
    NSLog(@"上传图片");
    if (!ivUploading.hidden) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"图片上传中，请稍后！" duration:2 position:CSToastPositionCenter];
        return;
    }
    [ivUploading setHidden:false];
    [self saveImageToFile:ivPhotoPreview.image];
}

-(void)takePhoto{
    [[UnityToiOSManger sharedInstance]TackePicFromNative];
    //    ivPhotoPreview.image = [HomeViewController getImageViewWithView:[UnityToiOSManger sharedInstance].unityView];
    //    UIImageWriteToSavedPhotosAlbum(ivPhotoPreview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //    [uiViewPicturePreview setHidden:false];
    //    ivPhotoPreview.layer.cornerRadius = 20;
}
- (void)JinJiang_TakePhoto:(NSData *)imageData {
    ivPhotoPreview.image = [[UIImage alloc]initWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(ivPhotoPreview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [uiViewPicturePreview setHidden:false];
    ivPhotoPreview.layer.cornerRadius = 20;
}

- (void)JinJiang_TakePhotoURL:(NSString *)url {
    //url = @"https://aimap.newayz.com/aimap/user/waic_file/eccbe82c-eb08-4212-b726-dedb6cea2d73.jpg";
    NSString *subStr2 = [url substringWithRange:NSMakeRange(1, url.length-2)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:subStr2]];//加载图片;
            dispatch_async(dispatch_get_main_queue(), ^{
                self->ivPhotoPreview.image = [[UIImage alloc]initWithData:imgData];
                UIImageWriteToSavedPhotosAlbum(self->ivPhotoPreview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                [self->uiViewPicturePreview setHidden:false];
                self->ivPhotoPreview.layer.cornerRadius = 20;
            });//异步从网络加载图片
        });
    });
}

-(void)setDingweiTimeO{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    dingweiTime = [userDefaults integerForKey:@"dingweiTime"];
    [UIAlertView requestWithTitle:@"请输入整数时间（1~500）" message:nil defaultText:[[NSString alloc]initWithFormat:@"%d",dingweiTime] sure:^(UIAlertView * , NSString *text) {
        NSLog(@"===123%@",text);
        int dingweiTime1 = [text intValue];
        if (dingweiTime1<1) {
            dingweiTime1 = 1;
        }else if(dingweiTime1>500){
            dingweiTime1 = 500;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:dingweiTime1 forKey:@"dingweiTime"];
        self->dingweiTime = dingweiTime1;
        //NSLog(@"===%d",[userDefaults integerForKey:@"dingweiTime"]);
    }];
}

-(void)clearData{
    // 获取Library文件夹路径
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    // 获取Library下Caches文件夹路径
    //NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    // 实例化NSFileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取Caches文件夹下的所有文件及文件夹
    NSArray *array = [fileManager contentsOfDirectoryAtPath:libPath error:nil];
    // 循环删除Caches下的所有文件及文件夹
    for (NSString *fileName in array) {
        NSLog(@"%@", fileName);
        [fileManager removeItemAtPath:[libPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

- (IBAction)openDebugMode:(UISwitch *)sender {
    NSLog(@"===%@",sender.on?@"YES":@"NO");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sender.on forKey:@"debug"];
    [userDefaults boolForKey:@"debug"];
}

-(void) singleTapShowDebugView:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (menuView.isHidden) {
            [[UnityToiOSManger sharedInstance]SetFPSVisible:@"1"];
            menuView.hidden = false;
        }else{
            [[UnityToiOSManger sharedInstance]SetFPSVisible:@"0"];
            menuView.hidden = true;
        }
    }
}
- (void) openOrClosePosition{
    NSLog(@"openOrClosePosition");
    if([openOrClosePosition.currentTitle containsString:@"关闭"]){
        [openOrClosePosition setTitle:@"开启定位" forState:UIControlStateNormal];
        [[UnityToiOSManger sharedInstance]StartOpen:@"0"];
    }else{
        [openOrClosePosition setTitle:@"关闭定位" forState:UIControlStateNormal];
        [[UnityToiOSManger sharedInstance]StartOpen:@"1"];
    }
}

- (void) handPositon{
    NSLog(@"handPositon");
    [[UnityToiOSManger sharedInstance]sendMsgToUnityForPicture];
}

-(IBAction) updateValue:(id)sender{
    float f = distanceSlider.value; //读取滑块的值
    NSLog(@"updateValued%",f);
    NSString *string = [[NSString alloc]initWithFormat:@"%f",f];
    [[UnityToiOSManger sharedInstance]VisibleDistanceChanged:string];
}

-(void)moveUp{
    NSLog(@"moveeUP123");
    currentMenuIndex--;
    if (currentMenuIndex<0) {
        currentMenuIndex = 0;
        return;
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self->fatherView setFrame:CGRectMake(0, (2-self->currentMenuIndex)*50, 150, self->menuStringList.count*50)];
    } completion:^(BOOL finished) {
        self->selectedUILabel.textColor = [UIColor whiteColor];
        self->selectedUILabel = self->fatherView.subviews[self->currentMenuIndex];
        self->selectedUILabel.textColor = [UIColor yellowColor];
        [self setCurrentSelected:self->currentMenuIndex];
    }];
}
-(void)moveDown{
    NSLog(@"moveDown123");
    currentMenuIndex++;
    if (currentMenuIndex>=menuStringList.count) {
        currentMenuIndex = menuStringList.count-1;
        return;
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self->fatherView setFrame:CGRectMake(0, (2-self->currentMenuIndex)*50, 150,self->menuStringList.count*50)];
    } completion:^(BOOL finished) {
        self->selectedUILabel.textColor = [UIColor whiteColor];
        self->selectedUILabel = self->fatherView.subviews[self->currentMenuIndex];
        self->selectedUILabel.textColor = [UIColor yellowColor];
        [self setCurrentSelected:self->currentMenuIndex];
    }];
}
-(void) clickMenu:(UITapGestureRecognizer *)gestureRecognizer{
    currentMenuIndex = gestureRecognizer.view.tag;
    NSLog(@"点击了第%d张图片", currentMenuIndex);
    [UIView animateWithDuration:0.5f animations:^{
        [self->fatherView setFrame:CGRectMake(0, (2-self->currentMenuIndex)*50, 150, self->menuStringList.count*50)];
    } completion:^(BOOL finished) {
        self->selectedUILabel.textColor = [UIColor whiteColor];
        self->selectedUILabel = gestureRecognizer.view;
        self->selectedUILabel.textColor = [UIColor yellowColor];
        [self setCurrentSelected:self->currentMenuIndex];
    }];
}

-(void)setCurrentSelected:(int) index{
    if (index == 1) {
        [distanceSlider setHidden:false];
    }else{
        [distanceSlider setHidden:true];
    }
}


-(void)add3DText{
    [UIAlertView requestWithTitle:@"请输入中(英)文" message:nil defaultText:@"a tree on Mt. Everest" sure:^(UIAlertView * , NSString *text) {
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([text isEqualToString:@""]){
            [[UIApplication sharedApplication].keyWindow makeToast:@"输入字符无效，请重新输入！" duration:2 position:CSToastPositionCenter];
            [UnityToiOSManger.sharedInstance GetImgUrl:@""];
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self requestBaiduTranslate:text];
            
        });
        //        NSString *json = [[NSString alloc]initWithFormat: @"{\"placeId\":\"7hJzyYaLaBt\",\"text\":\"%@\",\"lon\":%.6f,\"lat\":%.6f}",text,currentLocation.coordinate.longitude,currentLocation.coordinate.latitude ];
        //        [[UnityToiOSManger sharedInstance]add3DTextMsgToUnity:json];
        //NSLog(@"===%d",[userDefaults integerForKey:@"dingweiTime"]);
    }];
}

- (void)requestBaiduTranslate:(NSString *)msg{
    NSString *q = msg;
    NSString *appid = @"20230215001562384";
    NSString *salt = @"1676444667611";
    NSString *scret = @"tQv6X12qzUlq7LsQ6pdm";
    NSString *signString = [[NSString alloc]initWithFormat:@"%@%@%@%@",appid,q,salt,scret];
    NSString *sign = [self calcStringMD5:signString];
    NSLog(@"yuan %@",signString);
    NSLog(@"yuan %@",sign);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/translate?q=%@&from=auto&to=en&appid=%@&salt=%@&sign=%@",q,appid,salt,sign ];
    NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSDictionary *headers = @{
        @"Cookie": @"BAIDUID=721DAB7B443BC52F2FB39051BEC9A138:FG=1"
    };
    
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            dispatch_semaphore_signal(sema);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow makeToast:@"网络异常！" duration:2 position:CSToastPositionCenter];
            });
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@",responseDictionary);
            NSString *response = [[NSString alloc]initWithFormat:@"%@",responseDictionary];
            if([response containsString:@"dst"]){
                NSArray *result = responseDictionary[@"trans_result"];
                NSLog(@"%@",result[0][@"dst"]);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self requestImagefromString:result[0][@"dst"]];
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"网络异常！" duration:2 position:CSToastPositionCenter];
                });
            }
            dispatch_semaphore_signal(sema);
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(NSString *)calcStringMD5:(NSString *)srcStr{
    const char* str = [srcStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

-(void)requestImagefromString:(NSString *)keyWord{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://diffusion.newayz.com/run/predict/"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSDictionary *headers = @{
        @"Authorization": @"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI1MDlubVV1NXB3UDRpSlpuTDBvZnFnYU52Wk5tYXZsMCJ9.2If_Ng9UJTti7f1uMNwZp66UeY8fzYueOf0SPuCkso4",
        @"Content-Type": @"application/json",
        @"Cookie": @"jcloud_alb_route=9d8986f7b9dec19fd5dd7f0f01569bc3"
    };
    
    [request setAllHTTPHeaderFields:headers];
    NSString *datastring = [[NSString alloc]initWithFormat:@"{\"fn_index\":51,\"data\":[\"best quality, high quality,%@, sun\",\"low quality\",\"None\",\"None\",40,\"DDIM\",false,false,1,1,7,-1,-1,0,0,0,false,512,512,false,0.7,0,0,\"None\",false,false,false,\"\",\"Seed\",\"\",\"Nothing\",\"\",true,false,false,null,\"\"],\"session_hash\":\"19y8shqfk43\"}",keyWord ];
    NSData *postData = [[NSData alloc] initWithData:[datastring dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow makeToast:@"网络异常！" duration:2 position:CSToastPositionCenter];
            });
            dispatch_semaphore_signal(sema);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"%@",responseDictionary);
            NSString *response = [[NSString alloc]initWithFormat:@"%@",responseDictionary];
            if([response containsString:@"name"]){
                PictureResponseBean *dataBean = [PictureResponseBean mj_objectWithKeyValues:responseDictionary];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(dataBean.data.count>0&&dataBean.data[0].count>0){
                        NSDictionary *datataaaaa = dataBean.data[0][0];
                        NSString *picture = datataaaaa[@"name"];
                        NSString *url = [[NSString alloc]initWithFormat:@"https://diffusion.newayz.com/file=%@",picture];
                        NSString *newUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication].keyWindow makeToast:newUrl duration:2 position:CSToastPositionCenter];
                            [UnityToiOSManger.sharedInstance GetImgUrl:newUrl];
                            //                                        [urlImageImageInfo sd_setImageWithURL:newUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            //                                            // 原始图片的宽
                            //                                            CGFloat imageYW = CGImageGetWidth(image.CGImage);
                            //                                            // iamgeView的H = imageView的宽 / （原始图片的宽 / 原始图片的高）---根据宽高比得出imageView的宽
                            //                                            int imageH = self.view.frame.size.width/3 / (imageYW / CGImageGetHeight(image.CGImage));
                            //                                            int top = 0;
                            //                                            if(imageH<self.view.frame.size.height){
                            //                                                top = (self.view.frame.size.height-imageH)/2;
                            //                                            }
                            //                                            int imageW = self.view.frame.size.width/3;
                            //                                            urlImageImageInfo.frame = CGRectMake(0,top, imageW, imageH);
                            //                                            urlImageImageInfo.image = image;
                            //                                            uiScrollview.contentSize = urlImageImageInfo.frame.size;
                            //                                            uiScrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                            //                                        }];
                            //                                        uiScrollview.hidden = false;
                        });
                    }else{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication].keyWindow makeToast:@"网络异常！" duration:2 position:CSToastPositionCenter];
                        });
                    }
                    
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"网络异常！" duration:2 position:CSToastPositionCenter];
                });
            }
            dispatch_semaphore_signal(sema);
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
-(void)dingwei{
    [[UnityToiOSManger sharedInstance]StartNavigate:@"Entrance"];
    //  if ([UnityToiOSManger getRequest]) {
    //        [[UIApplication sharedApplication].keyWindow makeToast:@"定位中，请稍后！" duration:2 position:CSToastPositionCenter];
    //        return;
    //    }
    //    [UnityToiOSManger setRequest:true];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [UnityToiOSManger setRequest:false];
    //     });
    //        NSLog(@"yuan***拍照定位");
    //        [[UnityToiOSManger sharedInstance]sendMsgToUnityForPicture];
}
+ (UIImage *)getImageViewWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)saveImageToFile:(UIImage*)image {
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"show.jpg"]];// 保存文件的名
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    if(result ==YES) {
        NSLog(@"保存成功,开始上传图片");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //               [self uploadImageFile:filePath];
                MySwiftClass *mySwift = [[MySwiftClass alloc]init];
                [mySwift requestUploadImageTwoWithFilePath:filePath homeViewC:self ];
            });
        });
        
    }
}

- (IBAction)saveImage:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSLog(@"yuan  saveImage");
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"yuan  saveImage2");
        UIImageWriteToSavedPhotosAlbum(urlImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error  contextInfo:(void *)contextInfo{
    
    if (error) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"保存至相册失败！" duration:2 position:CSToastPositionCenter];
    }else{
        [[UIApplication sharedApplication].keyWindow makeToast:@"保存至相册成功！" duration:2 position:CSToastPositionCenter];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addChildViewController:[UnityToiOSManger sharedInstance].unityViewController];
        [self.view insertSubview:[UnityToiOSManger sharedInstance].unityView atIndex:0];
        [[UnityToiOSManger sharedInstance].unityViewController didMoveToParentViewController:self];
    });
    
    
}
- (void)PhoneMethodForUnityInitComplete {
    stateType = inited;
    [[UnityToiOSManger sharedInstance]SetFPSVisible:@"0"];
    //    if (DEBUG) {
    //        [[UnityToiOSManger sharedInstance]SetFPSVisible:@"1"];
    //    }else{
    //    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"recording"]) {
        [[UnityToiOSManger sharedInstance]SetFPSVisible:@"0"];
    }
    //[ballSportView setHidden:true];
    if (currentArSceneBeanList.count==1) {
        [self bottomViewClickItem:currentArSceneBeanList[0]];
    }
    NSLog( @"接受到Unity 发来的 消息 PhoneMethodForUnityInitComplete 携带参数");
}

-(void)setDingweiTime:(NSString *)time
{
    NSLog(@"===setDingweiTime  time%@",time);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    dingweiTime = [userDefaults integerForKey:@"dingweiTime"];
    NSLog(@"===setDingweiTime%d",dingweiTime);
}

- (void)PhoneMethodForStartVoice:(NSString *)key{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *aaa = [[NSString alloc]initWithFormat:@"PhoneMethodForStartVoice%@",@""];
        if([key isEqual:@"1"]){
            [self.view makeToast:@"请说出你的祝福语！"];
            blessingListening = true;
        }else{
            blessingListening = false;
        }
        
        [self startListening];
    });
}

-(void)changeTheme{
    a++;
    NSString *index = [[NSString alloc]initWithFormat:@"%d",a%sum];
    [[UnityToiOSManger sharedInstance] ChangeTheme:index];
}

- (void)PhoneMethodForLoadingAreaAssetsDone{
    NSString *result = @"1";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *aaa = [[NSString alloc]initWithFormat:@"PhoneMethodForLoadingAreaAssetsDone%@",result];
        //[self.view makeToast:aaa];
        sum =  [result intValue];
        if(sum > 1){
            ivChangeTheme.hidden = false;
        }else{
            ivChangeTheme.hidden = true;
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *aaa = [[NSString alloc]initWithFormat:@"PhoneMethodForLoadingAreaAssetsDone%@",result];
        //[self.view makeToast:aaa];
    });
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"openFilter"]) {
        [[UnityToiOSManger sharedInstance]EnableConsistencyCheck:@"1"];
    }else{
        [[UnityToiOSManger sharedInstance]EnableConsistencyCheck:@"0"];
    }
    dingweiTime = 5;
    stateType = loadedAR;
    if (self->getData==nil) {
        self->getData = [[MySwiftClass alloc]init];
    }
    if([currentARSceneBean.type isEqual:@"SceneAR"]){
        self-> getData.maptile_name = @"";
    }else if([currentARSceneBean.type isEqual:@"anyLocation"]){
        return;
    }else{
        self-> getData.maptile_name = currentARSceneBean.type;
    }
    [YPLogTool YPWLogInfo:currentARSceneBean.name];
    NSLog( @"yuan接受到Unity 发来的 消息 PhoneMethodForLoadingAreaAssetsDone 携带参数");
    // 此处需要写一个异步任务，是因为需要开辟一个新的线程去反复执行你的代码块，否则会阻塞主线程
    dispatch_queue_t queue = dispatch_queue_create("com.gcdtest.www", DISPATCH_QUEUE_CONCURRENT);
    
    block1 = dispatch_block_create(0, ^{
        while (TRUE&&stateType==loadedAR) {
            [NSThread sleepForTimeInterval: 1];
            // 这里写你要反复处理的代码，如网络请求
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            if ([UnityToiOSManger getRequest]) {
                NSLog(@"网络请求中，本次不进行拍照定位，下次再进行");
            }else if (state  == UIApplicationStateInactive) {//说明是锁屏
                NSLog(@"yuan锁屏了");
            }else if(state  == UIApplicationStateBackground){//说明进入后台
                NSLog(@"yuan进入后台了");
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"yuan***拍照定位");
                    [[UnityToiOSManger sharedInstance]sendMsgToUnityForPicture];
                });
                //UnitySendMessage("GameManager", "SendCurrentViewToAndroid", "");
            }
            // 每隔5秒执行一次（当前线程阻塞5秒）
            int *dingweiTimeLast = dingweiTime;
            NSLog(@"yuan***每%d秒输出一次这段文字***",dingweiTime);
            for(int i = 0 ;i<dingweiTime-1;i++){
                if (stateType==loadedAR) {
                    [NSThread sleepForTimeInterval:1];
                }else{
                    return;
                }
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            int dingweiTimeNew = [userDefaults integerForKey:@"dingweiTime"];
            if (dingweiTimeLast!=dingweiTime&&dingweiTime==dingweiTimeNew&&stateType==loadedAR) {
                NSLog(@"yuan***定位时间调整补足睡眠时间%d***",dingweiTimeNew-5);
                for(int i = 0 ;i<dingweiTimeNew-5;i++){
                    if (stateType==loadedAR) {
                        [NSThread sleepForTimeInterval:1];
                    }else{
                        return;
                    }
                }
            }
        };
    });
    if (currentARSceneBean.type!=nil&&[currentARSceneBean.type isEqualToString:@"anyLocation"]) {
    }else{
        //不要打开，已经改到unity中控制了dispatch_async(queue, block1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [QRPosition setTitle:@"扫码模式" forState:UIControlStateNormal];
            [[UnityToiOSManger sharedInstance]SetQRCodeVPSMode:@"1"];
            [self->ballSportView setHidden:true];
            if([QRPosition.titleLabel.text containsString:@"定位"]){
                self->dingweiTip.hidden = false;
            }else{
                ivScanQRTip.hidden = false;
            }
        });
    }
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
    double z = deviceMotion.gravity.z;
    deviceAgle = atan2(z,sqrtf(x * x + y * y)) / M_PI * 180.0;
    //NSLog(@"手机与水平面的夹角 --- %.4f", deviceAgle);
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            //NSLog(@"handleDeviceMotion: %@",@"1");
            orientationValue = @"2";
            // UIDeviceOrientationPortraitUpsideDown;
        }
        else{
            //NSLog(@"handleDeviceMotion: %@",@"2");
            // UIDeviceOrientationPortrait;
            orientationValue = @"1";
        }
    }
    else
    {
        if (x >= 0){
            // NSLog(@"handleDeviceMotion: %@",@"3");
            // UIDeviceOrientationLandscapeRight;
            orientationValue = @"4";
        }
        else{
            //NSLog(@"handleDeviceMotion: %@",@"4");
            // UIDeviceOrientationLandscapeLeft;
            orientationValue = @"3";
        }
    }
}


- (void)PhoneMethodForSendModelList:(NSString *)json{
    NSLog(json);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [self.view makeToast:json duration:2 position:CSToastPositionCenter];
        //        ARGuideView *arGuideView = [[ARGuideView alloc]initWithFrame:CGRectMake(0,0, 200,  400)];
        //        arGuideView.delegate = self;
        //        [self.view addSubview:arGuideView];
        //        NSArray *dataArry = [self toArrayOrNSDictionary:json];
        //        [arGuideView loadData:dataArry];
    });
    //[[UnityToiOSManger sharedInstance]StartNavigate:@"LvDi"];
}
-(void)itemClick:(NSString *)name{
    NSLog(@"itemClick：%@",name);
    [[UnityToiOSManger sharedInstance]StartNavigate:name];
}
//字符串转数组x
- (id)toArrayOrNSDictionary:(NSString *)jsonData{
    if (jsonData != nil) {
        NSData* data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject != nil){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    return nil;
}
- (void)JinJiang_ShotGameScore:(NSString *)score {
}

-(void)PhoneMethodForEndNavigate{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view makeToast:@"结束导航！" duration:2 position:CSToastPositionCenter];
     });
}

- (void)PhoneMethodForOpenUrlFromUnity:(NSString *)result {
    
if (result==nil||[result isEqualToString:@""]||[result isEqualToString:@"null"]) {
    return;
}
    
    NSLog( @"接受到Unity 发来的 消息 PhoneMethodForOpenUrlFromUnity 携带参数%@",result);
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSString *type =  [dic objectForKey:@"type"];
    NSString *url =  [dic objectForKey:@"url"];
    if (type==nil||[type isEqualToString:@""]||[type isEqualToString:@"null"]) {
        return;
    }
    if ([type isEqualToString:@"2"]) {
        if([url containsString:@"http"]){
        [urlImageImageInfo sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 原始图片的宽
            CGFloat imageYW = CGImageGetWidth(image.CGImage);
            // iamgeView的H = imageView的宽 / （原始图片的宽 / 原始图片的高）---根据宽高比得出imageView的宽
            int imageH = self.view.frame.size.width/3 / (imageYW / CGImageGetHeight(image.CGImage));
            int top = 0;
            if(imageH<self.view.frame.size.height){
                top = (self.view.frame.size.height-imageH)/2;
            }
            int imageW = self.view.frame.size.width/3;
            urlImageImageInfo.frame = CGRectMake(0,top, imageW, imageH);
            urlImageImageInfo.image = image;
            uiScrollview.contentSize = urlImageImageInfo.frame.size;
            uiScrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        }];
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // 读取数据
            NSString *fileName = [userDefaults valueForKey:@"fileName"];
            NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
            NSString *imagePath = [[NSString alloc]initWithFormat:@"%@/%@",destinationPath,url];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            // 原始图片的宽
            CGFloat imageYW = CGImageGetWidth(image.CGImage);
            // iamgeView的H = imageView的宽 / （原始图片的宽 / 原始图片的高）---根据宽高比得出imageView的宽
            int imageH = self.view.frame.size.height / (imageYW / CGImageGetHeight(image.CGImage));
            int top = 0;
            if(imageH<self.view.frame.size.height){
                top = (self.view.frame.size.height-imageH)/2;
            }
            int imageW = self.view.frame.size.height/3;
            urlImageImageInfo.frame = CGRectMake(0,top, imageW, imageH);
            urlImageImageInfo.image = image;
            uiScrollview.contentSize = urlImageImageInfo.frame.size;
            uiScrollview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            NSLog(@"yuan imagePath%@",imagePath);
        }
        [uiScrollview setHidden:false];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];//加载图片;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    urlImageImageInfo.image = [UIImage imageWithData:imgData];
//                    [urlImageImageInfo setHidden:false];
//                                              });//异步从网络加载图片
//            });
    }else if([type isEqualToString:@"4"]){
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:url
                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        urlImageImageInfo.image = image;
        [uiScrollview setHidden:false];
    }else if([type isEqualToString:@"5"]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [self getTheQuestion:url];
         });
    }else if([type isEqualToString:@"6"]){
        currentDenglongID = url;
        NSDictionary *nsdictionary = questionList[url];
        if (nsdictionary!=nil) {
            currentQuestion = nsdictionary;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *showInfo = [[NSString alloc]initWithFormat:@"%@(%@)",[self->currentQuestion objectForKey:@"description"],[self->currentQuestion objectForKey:@"puzzle"]];
            NSString *msg = [[NSString alloc]initWithFormat:@"%@\n\n请输入谜底",showInfo];
                [UIAlertView requestWithTitle:msg message:nil defaultText:@"" sure:^(UIAlertView * , NSString *text) {
                    NSString *answer = [currentQuestion objectForKey:@"answer"];
                    if ([text isEqualToString:answer]) {
                        [self answerTheQuestion:text];
                    }else{
                        [self.view makeToast:@"回答错误，谢谢！" duration:2 position:CSToastPositionCenter];
                    }
                }];
         });
    }else if([type isEqualToString:@"7"]){
        ARWebViewController *webVc = [[ARWebViewController alloc]init];
        webVc.modalPresentationStyle = UIModalPresentationFullScreen;
        webVc.URLStr = url;
        [self presentViewController:webVc animated:YES completion:nil];
    }
}

-(void)getTheQuestion:(NSString *)questionId{
    [THTNetWorkingManger GetQuestionSuccessHandler:questionId SuccessHandler:^(NSDictionary * _Nonnull response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *jsonData;
                    @try {
                        NSError *error = nil;
                        jsonData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
                        if (error) {
                         NSLog(@"AnswerQuestion->%@",error);
                            return;
                         }
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception.reason);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.view makeToast:@"该灯笼题目题目已答完！" duration:2 position:CSToastPositionCenter];
                        });
                        return;
                    } @finally {
                        
                    }
                        NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"AnswerQuestion%@",strJson);
                    if (strJson!=nil&&![strJson isEqualToString:@""]&&![strJson isEqualToString:@"null"]) {
                        self->currentQuestion = response;
                        if (self->questionList==nil) {
                            self->questionList = [[NSMutableDictionary alloc]init];
                        }
                        [questionList setValue:response forKey:questionId];
                        NSNumber *questionId =  [currentQuestion objectForKey:@"id"];
                        NSString *description =  [currentQuestion objectForKey:@"description"];
                        NSString * str3;
                        if (questionId!=NULL&&[[questionId stringValue]  isEqualToString:@"-1"]) {
                            str3 =[[NSString alloc]initWithFormat:@"{\"type\":\"3\",\"url\":\"%@\"}",description];
                        }else{
                            NSString *showInfo = [[NSString alloc]initWithFormat:@"%@︵%@︶",description,[self->currentQuestion objectForKey:@"puzzle"]];
                            str3 =[[NSString alloc]initWithFormat:@"{\"type\":\"1\",\"url\":\"%@\"}",showInfo];
                        }
                [[UnityToiOSManger sharedInstance]sendMsgToUnityNewWithMsg:str3];
                return;
                    }else{
                        [self.view makeToast:@"该灯笼题目题目已答完！" duration:2 position:CSToastPositionCenter];
                    }
                });
            } FaildedHandler:^(NSString * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"AnswerQuestion%@",error);
                    [self.view makeToast:@"网络异常！"];
                });
            }];
}

-(void)answerTheQuestion:(NSString *)answer{
    NSString *questionId = [currentQuestion objectForKey:@"id"];
    [THTNetWorkingManger PatchAnswerQuestionSuccessHandler:questionId QuestionDescription:answer SuccessHandler:^(NSDictionary * _Nonnull response) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response options:0 error:nil];
                        NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"AnswerQuestion%@",strJson);
                        
                        NSString *imageUrl = [response objectForKey:@"imageUrl"];
                        if (imageUrl!=nil&&![imageUrl isEqualToString:@""]&&![imageUrl isEqualToString:@"null"]) {
                            
//                            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//                            urlImage.image = [UIImage imageWithData:imgData];
                            [self->urlImage sd_setImageWithURL:imageUrl];
//                            [urlImage yy_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@""]];
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];//加载图片;
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        urlImage.image = [UIImage imageWithData:imgData];
//                                        [urlImage setHidden:false];
//                                                                  });//异步从网络加载图片
//                                });
                            //[self.view makeToast:@"请长按保存图片，兑换礼品！" duration:2 position:CSToastPositionCenter];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请长按保存图片，兑换礼品！"  preferredStyle:UIAlertControllerStyleAlert];
                                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                                // 弹出对话框
                                [self presentViewController:alert animated:true completion:nil];
                        }else{
                            //[urlImage yy_setImageWithURL:[NSURL URLWithString:@"https://aimap.newayz.com/aimap/lantern_riddle/lantern-riddle-auth-image/0000.png"] placeholder:[UIImage imageNamed:@""]];
                            [self->urlImage sd_setImageWithURL:@"https://aimap.newayz.com/aimap/lantern_riddle/lantern-riddle-auth-image/0000.png"];
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://aimap.newayz.com/aimap/lantern_riddle/lantern-riddle-auth-image/0000.png"]];//加载图片;
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        urlImage.image = [UIImage imageWithData:imgData];
//                                        [urlImage setHidden:false];
//                                                                  });//异步从网络加载图片
//                                });
                            [self.view makeToast:@"题目已被抢答！" duration:2 position:CSToastPositionCenter];
                        }
                        [self->urlImageFather setHidden:false];
                        NSString * str3 =[[NSString alloc]initWithFormat:@"{\"type\":\"2\",\"url\":\"%@\"}",currentDenglongID];
                        [[UnityToiOSManger sharedInstance]sendMsgToUnityNewWithMsg:str3];
                    });
                } FaildedHandler:^(NSString * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"AnswerQuestion%@",error);
                        [self.view makeToast:@"网络异常！"];
                    });
                }];
}

- (void)PhoneMethodForSendQRCodeVPSRequest:(NSString *)requestJson qrcodeJson:(NSString *)qrcodeJson {
    if (stateType!=loadedAR) {
        return;
    }
    NSString *toast =[[NSString alloc]initWithFormat:@"requestJson:%@",requestJson];
    //[YPLogTool YPWLogInfo:toast];
    dispatch_async(dispatch_get_main_queue(), ^{
       // [self.view makeToast:toast];
    });
    UnityVPSBean *unityVpsBean = [UnityVPSBean mj_objectWithKeyValues:requestJson];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *focalLength = [unityVpsBean.focalLength mj_JSONString];
        NSString *resolution = [unityVpsBean.resolution mj_JSONString];
        NSString *principalPoint = [unityVpsBean.principalPoint mj_JSONString];
        NSString *toast = [[NSString alloc]initWithFormat:@"focalLength:%@  resolution:%@ principalPoint:%@",focalLength,resolution ,principalPoint];
        //[self.view makeToast:toast duration:2 position:CSToastPositionCenter];
    });
    if(currentARSceneBean!=nil){
        unityVpsBean.mapName = currentARSceneBean.type;
    }
    //unityVpsBean.mapName = @"f9_QRCode_0508";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *lat = [userDefaults valueForKey:@"lat"];
    NSLog(@"11111读出来的数据: %@",lat);
    // 读取数据
    NSString *lon = [userDefaults valueForKey:@"lon"];
    
    unityVpsBean.gnss.longitude =  [[NSNumber alloc]initWithDouble:[lon doubleValue]];
    unityVpsBean.gnss.latitude =  [[NSNumber alloc]initWithDouble:[lat doubleValue]];
    
    EquipmentInfo *uuid = [[EquipmentInfo alloc]init];
    uuid.uuid = [UUID getUUID];
    unityVpsBean.equipmentInfo = uuid;
    NSString *data6 = [[NSString alloc]initWithFormat:@"%@",[unityVpsBean mj_JSONString]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestQRPosition:data6 qrcodeJson:qrcodeJson];
    });
    //[YPLogTool YPWLogInfo:data6];
}

-(void)requestQRPosition:(NSString *)data qrcodeJson:(NSString *)json{
    [YPLogTool YPWLogInfo:@"data123:"];
    [YPLogTool YPWLogInfo:data];
    [YPLogTool YPWLogInfo:json];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://visual-positioning.newayz.com/wayzoom/v1.2/vps/single/qrcode"]
  cachePolicy:NSURLRequestUseProtocolCachePolicy
  timeoutInterval:10.0];
    
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    NSString *headkey = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSDictionary *headers = @{
  @"Cookie": @"jcloud_alb_route=e105e2047ba2d34977c20096b22067c3",
  @"Content-Type":headkey
};

[request setAllHTTPHeaderFields:headers];
NSArray *parameters = @[
  @{ @"name": @"data", @"value":data },
  @{ @"name": @"qrcode", @"value": json }
];

NSError *error;
NSMutableData *body = [NSMutableData data];

for (NSDictionary *param in parameters) {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  //[body appendFormat:@"--%@\r\n", boundary];
  if (param[@"fileName"]) {
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
      [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"image/jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
    //[body appendData:imagedata];
    //[body appendString:imagedata];
    if (error) {
      NSLog(@"error %@", error);
          
    }
  } else {
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"%@\r\n\r\n", param[@"value"]] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
    //[body appendFormat:@"%@", param[@"value"]];
  }
}
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendFormat:@"\r\n--%@--\r\n", boundary];
NSData *postData = body;
[request setHTTPBody:postData];

[request setHTTPMethod:@"POST"];

NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
  if (error) {
    NSLog(@"error2 %@", error);
      dispatch_async(dispatch_get_main_queue(), ^{
          NSString *rotationti = [[NSString alloc]initWithFormat:@"error2 request6dof:%@",error];
          [self.view makeToast:rotationti];
      });
    dispatch_semaphore_signal(sema);
  } else {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    NSLog(@"respons:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
          NSString *rotationti = [[NSString alloc]initWithFormat:@"respons:%@",responseDictionary];
          //[self.view makeToast:rotationti];
      });
      dispatch_async(dispatch_get_main_queue(), ^{
          NSString *rotationti = [[NSString alloc]initWithFormat:@"respons request6dof:%@",responseDictionary];
//          [self.view makeToast:rotationti];
          NSString *resposeJson = [[NSString alloc]initWithFormat:@"%@",responseDictionary];
          if([resposeJson containsString:@"succ"]){
    
              self->dingweiTip.hidden = true;
              ivScanQRTip.hidden = true;
              NSError *parseError = nil;
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:&parseError];
              NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
              [[UnityToiOSManger sharedInstance]sendMsgToUnityWithMsg:jsonString];
//              [self.view makeToast:jsonString];
              [self.view makeToast:@"定位成功！"];
          }else{
          }
          //[YPLogTool YPWLogInfo:resposeJson];
      });
    dispatch_semaphore_signal(sema);
  }
}];
[dataTask resume];
dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)PhoneMethodForSendVPSRequest:(NSString *)key image:(NSData *)imageData size:(unsigned int) size{
    if (stateType!=loadedAR) {
        return;
    }
//    UIImage *image1 = [UIImage imageWithData:imageData];
//    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self getCurrentTimes]]];// 保存文件的名
//    [UIImagePNGRepresentation(image1)writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    UnityVPSBean *unityVpsBean = [UnityVPSBean mj_objectWithKeyValues:key];                     //dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *data = [[NSString alloc]initWithFormat:@"deviceOrientation:%@",unityVpsBean.deviceOrientation ];
//        [self.view makeToast:data];
//    });//异步从网络加载图片
    
    if([currentARSceneBean.type isEqual:@"SceneAR"]){
        self-> getData.maptile_name = @"";
    }else if([currentARSceneBean.type isEqual:@"anyLocation"]){
        return;
    }else{
        unityVpsBean.mapName = currentARSceneBean.type;
    }
    if(fabs(deviceAgle)>45){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"当前角度不适合定位！"];
        });
        return;
    }
    //unityVpsBean.mapName = @"f5_1107";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *lat = [userDefaults valueForKey:@"lat"];
    NSLog(@"11111读出来的数据: %@",lat);
    // 读取数据
    NSString *lon = [userDefaults valueForKey:@"lon"];
    
    unityVpsBean.gnss.longitude =  [[NSNumber alloc]initWithDouble:[lon doubleValue]];
    unityVpsBean.gnss.latitude =  [[NSNumber alloc]initWithDouble:[lat doubleValue]];
    
    EquipmentInfo *uuid = [[EquipmentInfo alloc]init];
    uuid.uuid = [UUID getUUID];
    unityVpsBean.equipmentInfo = uuid;
    unityVpsBean.deviceOrientation = orientationValue;
    NSString *data6 = [[NSString alloc]initWithFormat:@"%@",[unityVpsBean mj_JSONString]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request6dofPosition:data6 image:imageData];
    });
    //[YPLogTool YPWLogInfo:data6];
}

-(void)request6dofPosition:(NSString *)data image:(NSData *)imagedata{

dispatch_semaphore_t sema = dispatch_semaphore_create(0);

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://visual-positioning.newayz.com/wayzoom/v1.2/vps/single"]
  cachePolicy:NSURLRequestUseProtocolCachePolicy
  timeoutInterval:10.0];
    
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    NSString *headkey = [[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
NSDictionary *headers = @{
  @"Cookie": @"jcloud_alb_route=e105e2047ba2d34977c20096b22067c3",
  @"Content-Type":headkey
};

[request setAllHTTPHeaderFields:headers];
NSArray *parameters = @[
  @{ @"name": @"data", @"value":data },
  @{ @"name": @"file", @"fileName": @"image.jpg" }
];

NSError *error;
NSMutableData *body = [NSMutableData data];

for (NSDictionary *param in parameters) {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  //[body appendFormat:@"--%@\r\n", boundary];
  if (param[@"fileName"]) {
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
      [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"image/jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
    [body appendData:imagedata];
    //[body appendString:imagedata];
    if (error) {
      NSLog(@"error %@", error);
        NSString *toast = [[NSString alloc]initWithFormat:@"error %@", error];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *rotationti = [[NSString alloc]initWithFormat:@"error2 request6dof:%@",error];
            NSDictionary *aa = [[NSBundle mainBundle].infoDictionary objectForKey:@"Config"];
            NSString *uploadLocationPoint = aa[@"locationInfo"];
            bool cc = [uploadLocationPoint boolValue];
            if(cc){
                [self.view makeToast:toast];
            }
        });
    }
  } else {
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"%@\r\n\r\n", param[@"value"]] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
    //[body appendFormat:@"%@", param[@"value"]];
  }
}
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendFormat:@"\r\n--%@--\r\n", boundary];
NSData *postData = body;
[request setHTTPBody:postData];

[request setHTTPMethod:@"POST"];

NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
  if (error) {
    NSLog(@"error2 %@", error);
      dispatch_async(dispatch_get_main_queue(), ^{
          NSString *rotationti = [[NSString alloc]initWithFormat:@"error2 request6dof:%@",error];
          NSDictionary *aa = [[NSBundle mainBundle].infoDictionary objectForKey:@"Config"];
          NSString *uploadLocationPoint = aa[@"locationInfo"];
          bool cc = [uploadLocationPoint boolValue];
          if(cc){
              [self.view makeToast:rotationti];
          }
      });
    dispatch_semaphore_signal(sema);
  } else {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    NSLog(@"respons:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
          NSString *rotationti = [[NSString alloc]initWithFormat:@"respons:%@",responseDictionary];
          //[self.view makeToast:rotationti];
      });
      dispatch_async(dispatch_get_main_queue(), ^{
          NSString *rotationti = [[NSString alloc]initWithFormat:@"respons request6dof:%@",responseDictionary];
//          [self.view makeToast:rotationti];
          NSString *resposeJson = [[NSString alloc]initWithFormat:@"%@",responseDictionary];
          if([resposeJson containsString:@"succ"]){
              self->dingweiTip.hidden = true;
              NSError *parseError = nil;
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:&parseError];
              NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
              [[UnityToiOSManger sharedInstance]sendMsgToUnityWithMsg:jsonString];
              NSDictionary *aa = [[NSBundle mainBundle].infoDictionary objectForKey:@"Config"];
              NSString *uploadLocationPoint = aa[@"locationInfo"];
              bool cc = [uploadLocationPoint boolValue];
              if(cc){
                  [self.view makeToast:jsonString];
              }
              [self.view makeToast:@"定位成功！"];
          }
          //[YPLogTool YPWLogInfo:resposeJson];
      });
    dispatch_semaphore_signal(sema);
  }
}];
[dataTask resume];
dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *aa = [[NSBundle mainBundle].infoDictionary objectForKey:@"Config"];
        NSString *uploadLocationPoint = aa[@"uploadLocationPoint"];
        bool cc = [uploadLocationPoint boolValue];
        if (cc) {
            NSLog(@"启动定位是上传点位信息功能");
            [self ossUpload];
        }
     });
}

-(void)ossUpload{
            UIImage *image = [HomeViewController getImageViewWithView:[UnityToiOSManger sharedInstance].unityView];
//            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        NSString *pictureName = [NSString stringWithFormat:@"share%d.jpg",(int)[NSDate date].timeIntervalSince1970];
           NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
           NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:pictureName];// 保存文件的名
           [UIImagePNGRepresentation(image)writeToFile:filePath  atomically:YES];
        NSLog(@"%@", filePath);
        [self uploadFile:filePath];
}


NSString *uploadFileName;
- (void)uploadFile:(NSString *)filePath {
    NSString *fileName = filePath.lastPathComponent;
    uploadFileName = fileName;
    NSString *contentType;
    if ([fileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
        contentType = @"application/pdf";
    } else if ([fileName.pathExtension.lowercaseString isEqualToString:@"txt"]) {
        contentType = @"text/plain";
    } else {
        // demo中仅三种文件，若需要上传其他文件需配置相应的contentType，参见: http://tool.oschina.net/commons
        contentType = @"application/octet-stream";
    }
    
    contentType = @"image/jpeg";
    // 当前用户的ID
    NSString *const currentUserId = @"6ddbc4ca25fa13676763746a6caa5409";
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = [currentUserId stringByAppendingPathComponent:fileName];
    uploadRequest.bucket = S3BucketName;
    uploadRequest.contentType = contentType;
    
    __weak typeof(self) weakSelf = self;
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        [weakSelf onUploadProgressUpdated:fileName bytesSent:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    };
    
    [self upload:uploadRequest];
}

- (void)onUploadProgressUpdated:(NSString *)fileName bytesSent:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t) totalBytesExpectedToSend {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

-(void)getUrl:(NSString *)imageName{
    AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
    getPreSignedURLRequest.bucket = S3BucketName;
    getPreSignedURLRequest.key = [NSString stringWithFormat:@"%@/%@",  @"6ddbc4ca25fa13676763746a6caa5409", imageName];
    getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodGET;
     getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:604800];
    //S3函数调用
     AWSS3PreSignedURLBuilder *S3PreSignedURLBuilder =
     [AWSS3PreSignedURLBuilder S3PreSignedURLBuilderForKey:@"USWest2S3PreSignedURLBuilder"];
    S3PreSignedURLBuilder = [AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] ;
     [[S3PreSignedURLBuilder getPreSignedURL:getPreSignedURLRequest] continueWithBlock:^id(AWSTask *task) {
           if (task.error) {//get image URL false
                NSLog(@"Error: %@",task.error);
               NSString *toast = [[NSString alloc]initWithFormat:@"Error: %@",task.error ];
//               [self.view makeToast:toast];
                NSData *data = task.error.userInfo[@"com.alamofire.serialization.response.error.data"];
                //[self getErrorString:data withUrl:@"" withSatusCode:0];
            } else { //get image URL successed
                NSURL *presignedURL = task.result;
                NSLog(@"download presignedURL is: \n%@", presignedURL);
                NSString *url = [[NSString alloc]initWithFormat:@"%@", presignedURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[YPLogTool YPWLogInfo:url];
                    NSArray *aar = [url componentsSeparatedByString:@"?"];
                    [self requestUpdata:aar[0]];
                    //[YPLogTool YPWLogInfo:aar[0]];
//                    [self.view makeToast:url];
                });
//                callBack(presignedURL);
            }
            return nil;
        }];
}

- (void)upload:(AWSS3TransferManagerUploadRequest *)uploadRequest {
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused: {
                    }
                        break;
                        
                    default:
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            [self getUrl:uploadFileName];
        }
        
        return nil;
    }];
}
- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

-(void)requestUpdata:(NSString *)url{
dispatch_semaphore_t sema = dispatch_semaphore_create(0);

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://trajectory.newayz.cn/trajectory/api/v1/report"]
  cachePolicy:NSURLRequestUseProtocolCachePolicy
  timeoutInterval:10.0];
NSDictionary *headers = @{
  @"Content-Type": @"application/json"
};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *lat = [userDefaults valueForKey:@"lat"];
    NSLog(@"11111读出来的数据: %@",lat);
    // 读取数据
    NSString *lon = [userDefaults valueForKey:@"lon"];
    NSLog(@"11111读出来的数据: %@",lon);
    CLLocationCoordinate2D latlon = (CLLocationCoordinate2D){[lat doubleValue], [lon doubleValue]};
    CLLocationCoordinate2D coordinate = [JZLocationConverter gcj02ToWgs84:latlon];
    NSString *toward = [userDefaults valueForKey:@"toward"];
    NSLog(@"11111读出来的数据: %@",lon);
    if (@available(iOS 13.0, *)) {
        NSLog(@"时间：%@", [self getCurrentTimes]);
    } else {
        // Fallback on earlier versions
    }
[request setAllHTTPHeaderFields:headers];
    NSString *dataString = [[NSString alloc]initWithFormat:@"{\n    \"seq\": \"c071105d-04d3-4262-8a2d-4984e41fe4e5\",\n    \"lon\": %f,\n    \"lat\": %f,\n    \"altitude\": 87.1,\n    \"speed\": 91.5,\n    \"toward\": \"%@\",\n    \"compass\": 96.1,\n    \"yaw\": 1,\n    \"pitch\": 5,\n    \"roll\": 87,\n    \"image\": \"%@\",\n    \"IMEI\": \"itest imei\",\n    \"report_time\":\"%@\"\n}",coordinate.latitude,coordinate.longitude,toward,url,[self getCurrentTimes]];
NSData *postData = [[NSData alloc] initWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
[request setHTTPBody:postData];

[request setHTTPMethod:@"POST"];

NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
  if (error) {
    NSLog(@"%@", error);
    dispatch_semaphore_signal(sema);
  } else {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    NSLog(@"%@",responseDictionary);
      [YPLogTool YPWLogInfo:responseDictionary];
    dispatch_semaphore_signal(sema);
  }
}];
[dataTask resume];
dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)ShowCameraIcon:(NSString *)result {
    NSLog( @"接受到Unity 发来的 消息 ShowCameraIcon 携带参数%@",result);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([result isEqual:@"1"]){
            uiViewTakePhoto.hidden = false;
        }else{
            uiViewTakePhoto.hidden = true;
        }
    });
}

- (void)PhoneMethodForGetCurrentView:(NSString *)result {
    NSLog( @"yuan接受到Unity 发来的 消息 PhoneMethodForGetCurrentView 携带参数%@",@"result");
    
    if(fabs(deviceAgle)>45){
        [self.view makeToast:@"当前角度不适合定位！"];
        return;
    }
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state  == UIApplicationStateInactive) {//说明是锁屏
        NSLog(@"yuan锁屏了");
        return;
    }else if(state  == UIApplicationStateBackground){//说明进入后台
        NSLog(@"yuan进入后台了");
        return;
    }
    

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *lat = [userDefaults valueForKey:@"lat"];
    NSLog(@"11111读出来的数据: %@",lat);
    // 读取数据
    NSString *lon = [userDefaults valueForKey:@"lon"];
    NSLog(@"11111读出来的数据: %@",lon);
    
    
    NSLog( @"orientationValue%@",orientationValue);

    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    NSString * image =  [dic objectForKey:@"path"];
//
//        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:image
//                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        UIImage *image1 = [UIImage imageWithData:imageData];
//
//    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self getCurrentTimes]]];// 保存文件的名
//    [UIImagePNGRepresentation(image1)writeToFile:filePath  atomically:YES];// 保存成功会返回YES
    NSString * focalLength =  [dic objectForKey:@"focalLength"];
    NSString * principalPoint =  [dic objectForKey:@"principalPoint"];
    NSString  *deviceOrientation =  [dic objectForKey:@"deviceOrientation"];
    dispatch_async(dispatch_get_main_queue(), ^{
//    NSString *imageSiz3 = [[NSString alloc]initWithFormat:@"width:%f,height:%f  deviceOrientation:%@",image1.size.width,image1.size.height,deviceOrientation];
        //[self.view makeToast:imageSiz3];
    });
    NSDictionary * rotation =  [dic objectForKey:@"rot"];
    NSString *x = [rotation objectForKey:@"x"];
    NSString *y = [rotation objectForKey:@"y"];
    NSString *z = [rotation objectForKey:@"z"];
    NSString *w = [rotation objectForKey:@"w"];
    NSString *x1 = [[NSString alloc]initWithFormat:@"%@",x];
    NSString *y1 = [[NSString alloc]initWithFormat:@"%@",y];
    NSString *z1 = [[NSString alloc]initWithFormat:@"%@",z];
    NSString *w1 = [[NSString alloc]initWithFormat:@"%@",w];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSString *rotationti = [[NSString alloc]initWithFormat:@"rotation:%@",rotation];
        //[self.view makeToast:[self convertToJsonData:rotation] ];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self->getData==nil) {
            self->getData = [[MySwiftClass alloc]init];
            self-> getData.maptile_name = @"";
        }
        NSString *deviceOrientation1 = [[NSString alloc]initWithFormat:@"%@",deviceOrientation];
        [getData showSwiftLogWithStr:image abc:focalLength bcd:principalPoint orentation:deviceOrientation1 lat:lat lon:lon homeView:dingweiTip homeViewC:self x:x1 y:y1 z:z1 w:w1];
     });
}
-(NSString*)getCurrentTimes{
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
 //现在时间,你可以输出来看下是什么格式
 NSDate *datenow = [NSDate date];
 //----------将nsdate按formatter格式转成nsstring
 NSString *currentTimeString = [formatter stringFromDate:datenow];
 NSLog(@"currentTimeString = %@",currentTimeString);
 return currentTimeString;
}

-(void)showLeftUIView:(NSString *)result{
    if(![result containsString:@"error"]&&!uiViewPicturePreview.hidden){
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *imageString = [userDefaults valueForKey:@"imageString"];
    //[rightUiView setHidden:false];
    printf("1111%s", imageString);
    NSURL *baseImageUrl = [NSURL URLWithString:imageString];
    NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    ivErweima.image = image;
    [uiErweimaFather setHidden:false];
    [ivUploading setHidden:true];
    }
}

- (void)PhoneMethodForProcessDone:(NSString *)result {
    NSLog( @"yuan接受到Unity 发来的 消息 PhoneMethodForProcessDone 携带参数%@",result);
}
- (void)PhoneMethodForSendParallelverseInfo:(NSString *)result {
    NSLog( @"yuan接受到Unity 发来的 消息 PhoneMethodForSendParallelverseInfo 携带参数%@",result);
        dispatch_async(dispatch_get_main_queue(), ^{
            //json示例  {"parallesverseList":[{"id":"1","name":"one","remark":"\u6E05\u6668"},{"id":"2","name":"two","remark":"\u767D\u5929"}]}
            //NSString *string = [[NSString alloc]initWithFormat:@"收到消息%@",result];
            NSLog(@"yuan收到消息%@",result);
            //[self.view makeToast:string];
        });
}


-(void)CoffeeOrder:(NSString *)result {
    NSLog( @"yuan接受到Unity 发来的 消息 CoffeeOrder 携带参数%@",result);
    if (!canGetCoffee) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            canGetCoffee = true;
         });
        dispatch_async(dispatch_get_main_queue(), ^{
            //json示例  {"parallesverseList":[{"id":"1","name":"one","remark":"\u6E05\u6668"},{"id":"2","name":"two","remark":"\u767D\u5929"}]}
            NSString *string = @"10s内请勿重复点击";
            [self.view makeToast:string];
        });
        return;
    }
    canGetCoffee = false;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCoffeeOrder:result];
     });
}

-(void) getCoffeeOrder:(NSString *)coffee{

dispatch_semaphore_t sema = dispatch_semaphore_create(0);

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://aimap.newayz.com/aimap/waic/v1/coffee"]
  cachePolicy:NSURLRequestUseProtocolCachePolicy
  timeoutInterval:10.0];
NSDictionary *headers = @{
  @"Content-Type": @"application/json"
};

[request setAllHTTPHeaderFields:headers];
    NSString *json = [[NSString alloc]initWithFormat:@"{\"waic\":\"%@\"}",coffee];
NSData *postData = [[NSData alloc] initWithData:[json dataUsingEncoding:NSUTF8StringEncoding]];
   // NSData *postData = [[NSData alloc] initWithData:[@"{\n    \"waic\":\"a\"\n}" dataUsingEncoding:NSUTF8StringEncoding]];
[request setHTTPBody:postData];

[request setHTTPMethod:@"POST"];

NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
  if (error) {
    NSLog(@"%@", error);
    dispatch_semaphore_signal(sema);
      dispatch_async(dispatch_get_main_queue(), ^{
      canGetCoffee = true;
      [self.view makeToast:@"网络异常！"];
      });
  } else {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSError *parseError = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    NSLog(@"%@",responseDictionary);
      NSString *response = [responseDictionary description];
      NSLog(@"yuan%@",response);
      if ([response containsString:@"id"]) {
          dispatch_async(dispatch_get_main_queue(), ^{
              //json示例  {"parallesverseList":[{"id":"1","name":"one","remark":"\u6E05\u6668"},{"id":"2","name":"two","remark":"\u767D\u5929"}]}
              NSString *string = [[NSString alloc]initWithFormat:@"成功订购%@咖啡",coffee];
              [self.view makeToast:string duration:2 position:CSToastPositionCenter];
          });
      }else{
          dispatch_async(dispatch_get_main_queue(), ^{
          canGetCoffee = true;
          [self.view makeToast:@"网络异常！"];
          });
      }
    dispatch_semaphore_signal(sema);
  }
}];
[dataTask resume];
dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UnityToiOSManger sharedInstance] sendMessageExit3DMap];
    [[UnityToiOSManger sharedInstance].unityViewController willMoveToParentViewController:nil]; //1
    [[UnityToiOSManger sharedInstance].unityView removeFromSuperview]; //2
    [[UnityToiOSManger sharedInstance].unityViewController removeFromParentViewController]; //3
}

- (void)initSubViews {
    if(![[UnityToiOSManger sharedInstance]unityIsInitialized]){
        [[UnityToiOSManger sharedInstance] startUnityView];
    }
    [[UnityToiOSManger sharedInstance] registerUnityPtotocolWithObject:self];

}

#pragma mark - HomeViewDlegate

///搜索
- (void)closeAR {
    printf("点击了关闭");
    [self dismissViewControllerAnimated:YES completion:nil];
    //[[UnityToiOSManger sharedInstance] exitUnity];
}
///AR
- (void)homeViewdidClickAR {

}


///360全景
- (void)homeViewdidClick360VR {
//    GSWebViewController *webVc = [[GSWebViewController alloc]init];
//    webVc.URLStr = @"https://720yun.com/t/5evkclq7z8y?scene_id=61461264";
//    webVc.title = @"全景";
//    [self.navigationController pushViewController:webVc animated:NO];
}

///拼图寻宝
- (void)homeViewdidClickjigsawGame {
}

///一起捉萌宠
- (void)homeViewdidClickpetGame {
}

///召唤精灵
- (void)homeViewdidClickelvesGame {
}


#pragma mark - NativeCallsProtocol
-(void)unity2Native_SendMapSelectSpotPosition:(int)spotID {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    NSLog(@"mapDidMoveByUser");
    NSLog(@"地图缩放yuan:%@", [NSString stringWithFormat:@"%3.1f",mapView.zoomLevel ]);
}

/**
* @brief 地图将要发生缩放时调用此接口
* @param mapView       地图view
* @param wasUserAction 标识是否是用户动作
*/
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction{
    NSLog(@"mapWillZoomByUser");
    NSLog(@"地图缩放yuan:%@", [NSString stringWithFormat:@"%3.1f",mapView.zoomLevel ]);
    
    
}
/**
 * @brief 单击地图回调，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    NSLog(@"location:{lat:%f; lon:%f}", coordinate.latitude, coordinate.longitude);
    if (showWeilan) {
        [self checkARSceneByLocation:&coordinate.latitude longitude:&coordinate.longitude];
    }else{
        [self.topView setHidden:true];
        [_bottomView setHidden:true];
    }
}

- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    NSLog(@"mapDidZoomByUser");
    NSLog(@"地图缩放yuan:%@", [NSString stringWithFormat:@"%3.1f",mapView.zoomLevel ]);
    if(mapView.zoomLevel>19&&showWeilan){
        [mapView removeOverlays:mapView.overlays];
        //[mapView removeAnnotations:mapView.annotations];
        [self showMaker];
        showWeilan = false;
    }
    
    if(mapView.zoomLevel<18&&!showWeilan){
        //[mapView removeOverlays:mapView.overlays];
        [mapView removeAnnotations:mapView.annotations];
        [self showSceneWeilan];
        showWeilan = true;
    }
    
    //mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.showsCompass = NO; // 设置成NO表示关闭指南针；YES表示显示指南针
    mapView.rotateEnabled = NO;    //NO表示禁用旋转手势，YES表示开启
    mapView.rotateCameraEnabled = NO;    //NO表示禁用倾斜手势，YES表示开启
}
#pragma mark - MAMapViewDelegate
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *OverlayRenderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];

        return OverlayRenderer;
    }

    if([overlay isKindOfClass:[MAPolygon class]])

    {

        MAPolygonRenderer *polygon = [[MAPolygonRenderer alloc]initWithPolygon:(MAPolygon*)overlay];
        //边线宽度
        polygon.lineWidth = 0;
        //边线颜色
        polygon.strokeColor = [UIColor colorWithRed:60/255.0 green:200/255.0 blue:168/255.0 alpha:1];
        //填充颜色
        polygon.fillColor = [UIColor colorWithRed:60/255.0 green:200/255.0 blue:168/255.0 alpha:0.5];
        return polygon;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"ic_map_mylocation"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]]&&![annotation.title isEqual:@"当前位置"])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"ic_maker_c"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
}
#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    currentLocation = location;
    [self initData];
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if(currentLocation.coordinate.longitude !=0 &&!showPOI){
        showPOI = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self requestPOIData];
         });
    }
};

- (void) initData{
    if (!check&&currentLocation!=nil&&arSceneBeanList!=nil) {
        double lat = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude].doubleValue;
        double lon = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude].doubleValue;
        @try {
            [self checkARSceneByLocation:&lat longitude:&lon];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception.description);
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络异常！"];
            });
        } @finally {
        }
        [self showSceneWeilan];
        [ballSportView setHidden:true];
        check = true;
    }
}

typedef enum : NSUInteger {
    AlertCauseButtonClick = 0,
    AlertSureButtonClick
} AlertButtonClickIndex;

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"%@", view.annotation.title);
    int index = view.annotation.subtitle.intValue;
    //[self.topView setHidden:false];
    [self.topView setModel:arSceneBeanList[index]];
    // ios8.0 之前
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Tittle" message:@"This is message" delegate:self
//    cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//    [alertView show];
    [Singleton doSomething];
}

-(void) loadARContent{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[_homeView showScanTip];
        [self->ballSportView setHidden:false];
     });
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取数据
    NSString *fileName = [userDefaults valueForKey:@"fileName"];
    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"ARData/%@", fileName]];
    NSLog(@"yuan File downloaded to i2: %@",fileName);
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSArray *orientations = info[@"UISupportedInterfaceOrientations"];
    NSString *orientationsJson = [orientations mj_JSONString];
    NSLog(@"====%@", orientationsJson );
    NSString * str3;
    NSString *aaa = [[NSString alloc]initWithFormat:@"%@:动态加载模式！",currentARSceneBean.name];
    if([currentARSceneBean.name containsString:@"动态"]){
        aaa = [[NSString alloc]initWithFormat:@"%@:动态加载模式！",currentARSceneBean.name];
        str3 =[[NSString alloc]initWithFormat:@"{\"contentPath\":\"%@\",\"id\":\"%@\",\"loadMode\":\"1\"}",destinationPath,fileName];
    }else{
        aaa = [[NSString alloc]initWithFormat:@"%@:静态加载模式！",currentARSceneBean.name];
        str3 =[[NSString alloc]initWithFormat:@"{\"contentPath\":\"%@\",\"id\":\"%@\",\"loadMode\":\"0\",\"PostGetURL\":\"%@\",\"token\":\"%@\"}",destinationPath,fileName,@"https://pgv-gateway.newayz.cn/pgvers/api",@"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJidXllciIsImlhdCI6MTY5OTI0ODMzNiwianRpIjoiODE4MzU1NDQxMDI2MDMyMDIxNzAwNjQ0MiIsImV4cCI6MTcwMTg0MDMzNn0.n2GjOGXIWN__euZDjh3SkJa46V7nn1jskycu3GBuELXVe2aKNK-C1OLj4EgLP1GQ06uzREQKE0TmMvLXYLUvnQ"];
    }
    //[self.view makeToast:aaa duration:2 position:CSToastPositionBottom];
    NSLog(@"yuan send unity json: %@",str3);
    [[UnityToiOSManger sharedInstance]sendMsgToUnityWithMothWhthMsg:str3];
}

-(void) initARFromAnnotation:(ARSceneBean *)arSceneBean{
    if (stateType==initing) {
        [self.view makeToast:@"AR环境初始化中，请稍后再试!" duration:2 position:CSToastPositionCenter];
        return;
    }
    if (stateType==loadingAR) {
        [self.view makeToast:@"当前正在加载AR，请稍后再试！" duration:2 position:CSToastPositionCenter];
        return;
    }
    if (stateType==loadedAR&&currentARSceneBean!=nil&&[currentARSceneBean.id isEqual:arSceneBean.id]) {
        [self.view makeToast:@"内容已加载,请观赏！" duration:2 position:CSToastPositionCenter];
        return;
    }
    NSDictionary *file = arSceneBean.package.files[0];
    NSLog(@"%@", file[@"link"]);
    NSString *btn9L2Url = file[@"link"];
    NSString *updateTime = file[@"updateTime"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cacheUpdetaTime = [userDefaults stringForKey:arSceneBean.id];
    [self saveCurrentScene:btn9L2Url];
    NSURL *url = [NSURL URLWithString:btn9L2Url];
    bool *isDownload = [self isFileExist:fileName];
    bool *update = ![updateTime isEqualToString:cacheUpdetaTime];
    if (local) {
        update = false;
    }
    if (isDownload&&!update) {
        [self hideMapView];
        dingweiTip.hidden = true;
        ivScanQRTip.hidden = true;
        if (stateType==loadedAR) {
            [self.view makeToast:@"正在切换资源场景！" duration:2 position:CSToastPositionCenter];
            dispatch_block_cancel(block1);
            [[UnityToiOSManger sharedInstance]sendMsgToUnityForUnloadAssets];
            [uiScrollview setHidden:true];
            stateType = inited;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->currentARSceneBean = arSceneBean;
                [self loadARContent];
             });
        }else{
            currentARSceneBean = arSceneBean;
            [self loadARContent];
            [self.view makeToast:@"已有缓存，开始加载内容！" duration:2 position:CSToastPositionCenter];
        }
        stateType = loadingAR;
        [self singleTapZhankai:nil];
    }else{
    // ios8.0 之后
        NSString *sizeString = file[@"size"];
        long size = [sizeString longLongValue];
        NSString *sizeStringTwo = [NSString stringWithFormat:@"%.2f", size/(1024.0*1024.0)];
        NSString *tishi ;
        if(isDownload&&update){
            tishi = [NSString stringWithFormat:@"更新%@AR资源需要%@M，是否下载？",arSceneBean.name,sizeStringTwo];
        }else{
        tishi = [NSString stringWithFormat:@"体验%@AR资源需要%@M，是否下载？",arSceneBean.name,sizeStringTwo];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"资源下载" message:tishi preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            self->dingweiTip.hidden = true;
            ivScanQRTip.hidden = true;
            [self singleTapZhankai:nil];
            [userDefaults setValue:updateTime forKey:arSceneBean.id];
            if (isDownload) {
                NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"ARData/%@", fileName]];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager removeItemAtPath:destinationPath error:NULL]) {
                NSLog(@"yuan删除成功");
                }else{
                NSLog(@"yuan删除失败");
                }
            }
            if (self->stateType==loadedAR) {
                [self.view makeToast:@"正在切换资源场景！" duration:2 position:CSToastPositionCenter];
                dispatch_block_cancel(block1);
                dingweiTip.hidden = true;
                [[UnityToiOSManger sharedInstance]sendMsgToUnityForUnloadAssets];
                self->stateType = inited;
                [self->uiScrollview setHidden:true];
            }
            self->stateType = loadingAR;
            self->currentARSceneBean = arSceneBean;
            [self hideMapView];
            downloading = true;
            [self.waveView initInfo];
            [self.waveView setHidden:false];
//            CGAffineTransform transform2 = CGAffineTransformMakeRotation(M_PI*0.5);
//           [self.waveView setTransform:transform2];
            [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
            
            [self.view makeToast:@"开始下载内容！"];
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//保存当前场景信息
-(void) saveCurrentScene:(NSString *)url
{
    fileName = [[url lastPathComponent] stringByDeletingPathExtension];
    fileNameZip = [url lastPathComponent];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 保存数据
    [userDefaults setValue:fileName forKey:@"fileName"];
    // 保存数据
    [userDefaults setValue:fileNameZip forKey:@"fileNameZip"];
    [userDefaults synchronize];
    
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"ARData/%@", fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}
#pragma mark <NSURLConnectionDataDelegate> 实现方法


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"下载失败");
    [self.view makeToast:@"网络异常，请检查网络重新下载！"];
    stateType = inited;
    [self.waveView setHidden:true];
}
/**
 * 接收到响应的时候：创建一个空的沙盒文件
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 获得下载文件的总长度
    self.fileLength = response.expectedContentLength;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileNameZip];
   
    // 创建一个空的文件到沙盒中
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
}

/**
 * 接收到具体数据：把数据写入沙盒文件中
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    
    // 拼接文件总长度
    self.currentLength += data.length;
    
    // 下载进度
    self.waveView.progress =  1.0 * self.currentLength / self.fileLength;
    //self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",100.0 * self.currentLength / self.fileLength];
    //self.progressLabel.sizeToFit;
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
    NSString *fileNameZip1 = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileNameZip];
    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"ARData/%@", fileName]];
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
       
       dispatch_sync(queue, ^{
           // 追加任务 1
           [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
           
           NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
       });
    
    ZipArchive *zip = [[ZipArchive alloc] init];
   
    printf(@"解压至：%@",fileNameZip1 );
    if ([zip UnzipOpenFile:fileNameZip1]) {
            downloading = false;
        if ([zip UnzipFileTo:destinationPath overWrite:YES]) {
            printf("解压成功");
            //self.progressLabel.text = [NSString stringWithFormat:@"解压成功"];
            //self.progressLabel.sizeToFit;
            [self.waveView setHidden:true];
            NSLog(@"File downloaded to i2: %@",destinationPath);
            [self loadARContent];
            //UnitySendMessage("GameManager", "GetCurrentAreaAssets", "{\"contentPath\":\"/storage/emulated/0/Android/data/com.wayz.armaptest/files/ar/9L/\",\"id\":\"lvdi\"}");
            //UnitySendMessage("GameManager", "GetCurrentAreaAssets", str3.UTF8String);
            //切回主线程执行任务
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[_homeView showScanTip];
                [mapView setHidden:true];
             });
        }
    }else {
        downloading = false;
        NSLog(@"解压失败");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showResourceView" object:nil];
    }
 //[self unzipWithFilePath:i destinationPath:@"ar" unzipFileName:@"iOS_9"];
}
/**
 解压文件到指定的路径
 
 @param filePath 将要解压文件的全路径
 @param destinationPath 解压目标路径
 @param fileName 解压文件名
 @return 是否解压完成
 */
- (BOOL)unzipWithFilePath:(NSString *)filePath
          destinationPath:(NSString *)destinationPath
            unzipFileName:(NSString *)fileName {
    printf("1234");
    __block BOOL unzipSucceed = NO;
    NSString *unzipPath = [destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", fileName, @"-unzip"]];
    NSString *unzipCompletePath = [destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ARData/%@", fileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:destinationPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            unzipSucceed = NO;
            printf("12345");
            return unzipSucceed;
        }
    }
    
   
    printf("unzipsucceed");
    return unzipSucceed;
}
@end
