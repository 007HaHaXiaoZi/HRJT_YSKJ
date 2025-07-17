//
//  ViewController.m
//  swiftONE
//
//  Created by admin on 2021/8/25.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "SinggleInstance.h"
#import "UserPrivacyViewController.h"
#import "SettingVC.h"
#import "Home/Viewcontroller/HomeViewController.h"
#import "iCarousel.h"
#import <Bugly/Bugly.h>
#import "UIView+Toast.h"
@import AVFoundation;
 
#import <ImageIO/ImageIO.h>

#import <ZipArchive.h>
#import <CoreMotion/CoreMotion.h>

#import "sys/utsname.h"
@interface ViewController () <iCarouselDelegate,iCarouselDataSource,AVCaptureVideoDataOutputSampleBufferDelegate>{
    UIView *view;
}
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UILabel *userPrivaty;
@property (weak, nonatomic) IBOutlet UIButton *userPrivatyAgree;

@property (strong, nonatomic) IBOutlet UIButton *btn9L2;
/** 文件句柄对象 */
@property (weak, nonatomic) IBOutlet UIView *viewEnterAr;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) BOOL locatingWithReGeocode;

@property(nonatomic,strong) id object;

@property (nonatomic, strong) iCarousel *filmCarousel;
@property (weak, nonatomic) IBOutlet UIImageView *checkedAgree;
@property (nonatomic, strong) NSMutableArray *filmImageNameArr;
@property (nonatomic, strong) NSMutableArray *filmNameArr;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UILabel *filmNameLab;
@property (weak, nonatomic) IBOutlet UILabel *userPrivacy1;
@property (weak, nonatomic) IBOutlet UILabel *userPrivacy2;
@property (weak, nonatomic) IBOutlet UIView *showChooseAgreeUser;
@property (weak, nonatomic) IBOutlet UIButton *settingPage;

@end
@implementation ViewController{
    bool agree;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

[self useGyroPush]; // 界面点击时就会调用陀螺仪

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSException* myException = [NSException
//            exceptionWithName:@"FileNotFoundException"
//            reason:@"File Not Found on System"
//            userInfo:nil];
//    @throw myException;
    [Bugly startWithAppId:@"969f8564ac"];
    struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"deviceModel:%@",deviceModel);

    NSArray *array = [deviceModel componentsSeparatedByString:@","]; //从字符,中分隔成2个元素的数组
    NSString *deviceModel2 = array[0];
    NSLog(@"deviceModel2:%@",[deviceModel2 substringFromIndex:4]);
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    double version = [sysVersion doubleValue];
    NSLog(@"deviceModel3:%@",sysVersion);

    
}
- (void)viewDidDisappear:(BOOL)animated {

// 该界面消失时一定要停止，不然会一直调用消耗内存

[self.motionManager stopDeviceMotionUpdates]; // 停止所有的设备

// [self.motionManager stopAccelerometerUpdates]; // 加速度计

// [self.motionManager stopMagnetometerUpdates]; // 磁力计

// [self.motionManager stopGyroUpdates]; // 陀螺

}

- (void)useGyroPush{
    
    //初始化全局管理对象
    
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    
    self.motionManager = manager;
    
    if ([self.motionManager isDeviceMotionAvailable]) {
        
        manager.deviceMotionUpdateInterval = 1;
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
         
                                                withHandler:^(CMDeviceMotion * _Nullable motion,
                                                              
                                                              NSError * _Nullable error) {
            
            // Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
            
            double gravityX = motion.gravity.x;
            
            double gravityY = motion.gravity.y;
            
            double gravityZ = motion.gravity.z;
            
            // 获取手机的倾斜角度(zTheta是手机与水平面的夹角， xyTheta是手机绕自身旋转的角度)：
            
            double zTheta = atan2(gravityZ,sqrtf(gravityX * gravityX + gravityY * gravityY)) / M_PI * 180.0;
            
            double xyTheta = atan2(gravityX, gravityY) / M_PI * 180.0;
            
            NSLog(@"手机与水平面的夹角 --- %.4f, 手机绕自身旋转的角度为 --- %.4f", zTheta, xyTheta);
            if(fabs(zTheta)>45){
                NSLog(@"角度不合适定位");
            }
        }];
        
    }
}
    
- (bool)deviceCanEnter{
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    double version = [sysVersion doubleValue];
    NSLog(@"deviceModel3:%f",version);
    if(version<13.6){
        return false;
    }
    
    struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"deviceModel:%@",deviceModel);
    if ([deviceModel containsString:@"iPhone"]) {
        NSArray *array = [deviceModel componentsSeparatedByString:@","]; //从字符,中分隔成2个元素的数组
        NSString *deviceModel2 = array[0];
        int a =[[deviceModel2 substringFromIndex:6] intValue];
        NSLog(@"deviceModel2:%@",[deviceModel2 substringFromIndex:6]);
        if(a>=8){
            return true;
        }
    }
    if ([deviceModel containsString:@"iPad"]) {
        NSArray *array = [deviceModel componentsSeparatedByString:@","]; //从字符,中分隔成2个元素的数组
        NSString *deviceModel2 = array[0];
        int a =[[deviceModel2 substringFromIndex:4] intValue];
        NSLog(@"deviceModel2:%@",[deviceModel2 substringFromIndex:6]);
        if(a>=10){
            return true;
        }
    }
    return false;
}

- (void)initSubViews {
   // [[UnityToiOSManger sharedInstance] startUnityView];
    view = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 100, 200)];
    view.backgroundColor = [UIColor redColor];
    //[self.view addSubview:view];

}


-(void)userPrivatyClick{
    UserPrivacyViewController *ickImageViewController = [[UserPrivacyViewController alloc] init];
    ickImageViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:ickImageViewController animated:YES];
    NSLog(@"userPrivaty");
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"======debug");
    }else{
        NSLog(@"======release");
    }
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPrivatyClick)];
    [_userPrivaty addGestureRecognizer:singleTap];
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    // 保存数据
    [userDefaults1 setValue:@"1" forKey:@"isFirstInit"];
    [userDefaults1 synchronize];
    // 保存数据
    NSString *i1 = [userDefaults1 valueForKey:@"isFirstInit"];
    BOOL a3 = [i1 boolValue];
    if(a3){
        printf("a3");
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    printf(@"copyFile111");
   [self copyFile];
   [userDefault setValue:@"2021-11-28 16:05:54.448934+08" forKey:@"wayz_000062"];
   [userDefault setValue:@"2021-11-28 16:05:54.448934+08" forKey:@"wayz_000063"];
   [userDefault setValue:@"2021-11-28 16:05:54.448934+08" forKey:@"wayz_000038"];
   [userDefault setValue:@"2021-11-28 16:05:54.448934+08" forKey:@"wayz_000083"];
    self.navigationItem.title = @"NSURLConnection下载大文件";
    [AMapLocationManager updatePrivacyShow:true privacyInfo:true];
    [AMapLocationManager updatePrivacyAgree:true];
    [AMapServices sharedServices].apiKey =@"3b82166a3f233457fe9f4c02e485837d";
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
   
    //_btn9L2.titleLabel.text = @"进入Phy-Gital™World";
    //_viewEnterAr.layer.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:255.0].CGColor;
    _viewEnterAr.layer.cornerRadius = 12;
    
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《隐私权政策》《用户政策》"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
//
//    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.000000]} range:NSMakeRange(0, 7)];
//
//    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:61/255.0 green:92/255.0 blue:255/255.0 alpha:1.000000]} range:NSMakeRange(7, 13)];

    //_userPrivaty.attributedText = string;
    //_userPrivaty.textAlignment = NSTextAlignmentLeft;
    
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(self.view.frame.size.width/2-164,self.view.frame.size.height-110,328,50);
//
//    view.layer.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0].CGColor;
//    view.layer.cornerRadius = 12;
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(83.5,13,161,22.5);
//    label.numberOfLines = 0;
//    [self.view addSubview:label];
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"进入Phy-Gital™World"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//
//    label.attributedText = string;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.alpha = 1.0;
//    [view addSubview:label];
//    [self.view addSubview:view];
    UILabel *uiLabel;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        uiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-328, self.view.frame.size.height - 200 ,656, 100)];
        uiLabel.font = [UIFont systemFontOfSize:25];
    } else {
        uiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-164, self.view.frame.size.height - 130,328, 50)];
        uiLabel.font = [UIFont systemFontOfSize:17];
    }
    UITapGestureRecognizer *singleTapEnter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAR)];
    uiLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    [uiLabel addGestureRecognizer:singleTapEnter];
    uiLabel.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:255.0];
    uiLabel.layer.backgroundColor = [UIColor colorWithRed:61/255.0 green:92/255.0 blue:255/255.0 alpha:1.0].CGColor;
    uiLabel.layer.masksToBounds = YES;
    uiLabel.layer.cornerRadius = 12;
    [uiLabel setText:@"进入Phy-Gital™World"];
    uiLabel.textColor = [UIColor whiteColor];
    uiLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:uiLabel];
    _viewEnterAr = uiLabel;
    agree = false;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // 读取数据
        bool *i = [userDefaults boolForKey:@"userPrivacy"];
        if (i) {
            agree = true;
            [self.showChooseAgreeUser setHidden:true];
            _viewEnterAr.backgroundColor = [UIColor colorWithRed:61/255.0 green:92/255.0 blue:255/255.0 alpha:1.0];
        }
    
    [self.view addSubview:self.filmCarousel];
    
    self.filmNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.filmCarousel.frame), self.view.frame.size.width, 44)];
    self.filmNameLab.font = [UIFont systemFontOfSize:20];
    self.filmNameLab.textAlignment = NSTextAlignmentCenter;
    self.filmNameLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.filmNameLab];
    
    
    [_userPrivacy1 setUserInteractionEnabled:YES];
    [_userPrivacy1 setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPrivatyClick)];
    [_userPrivacy1 addGestureRecognizer:singleTap1];
    
    [_userPrivacy2 setUserInteractionEnabled:YES];
    [_userPrivacy2 setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPrivatyClick)];
    [_userPrivacy2 addGestureRecognizer:singleTap2];
    UIImageView *title;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        title = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-277, 100 ,555, 132)];
    } else {
        title = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-138.5, 60 ,277, 66)];
    }
    title.image = [UIImage imageNamed:@"ic_welcome"];
    title.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:title];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self lightSensitive];
    //[UIDevice currentDevice].
    
    if (DEBUG) {
        [_settingPage setHidden:false];
    }else{
        [_settingPage setHidden:true];
    }
    [_settingPage setHidden:false];
    
    NSString *serverIP = [userDefault stringForKey:@"serverIP"];
    if(serverIP==nil||[serverIP isEqualToString:@""] ){
        [userDefaults setValue:@"114.67.225.7" forKey:@"serverIP"];
        [userDefaults setInteger:35 forKey:@"dingweiTime"];
        [userDefaults setBool:false forKey:@"debug"];
        [userDefaults setBool:false forKey:@"recording"];
        [userDefaults setBool:false forKey:@"openFilter"];
    }
    [self.view setHidden:true];
//    UIImageView *uiguide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    uiguide.image = [UIImage imageNamed:@"bg_waic_guid"];
//    uiguide.contentMode = UIViewContentModeScaleToFill;
//    [self.view addSubview:uiguide];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setHidden:false];
        UIImageView *uiguide = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        uiguide.image = [UIImage imageNamed:@"bg_waic_guid.jpg"];
        uiguide.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:uiguide];
        UIImageView *enterAR = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -160, self.view.frame.size.height/2, 319, 109)];
        enterAR.image = [UIImage imageNamed:@"ic_waic_enterar"];
        enterAR.contentMode = UIViewContentModeScaleAspectFill;
        [enterAR setUserInteractionEnabled:YES];
        [enterAR setMultipleTouchEnabled:YES];
        UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterARNew)];
        [enterAR addGestureRecognizer:singleTap3];
        [self.view addSubview:enterAR];
        
        UIImageView *waicText = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -348, self.view.frame.size.height/2-132, 696, 64)];
        waicText.image = [UIImage imageNamed:@"ic_waic_text"];
        waicText.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:waicText];
        UIImageView *pgvLogo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -264, self.view.frame.size.height-112, 528, 86)];
        pgvLogo.image = [UIImage imageNamed:@"ic_pgv_logo"];
        pgvLogo.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:pgvLogo];
     });
}
- (void)copyFile{
    NSLog(@"copyFile");
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [resourcePath stringByAppendingString:@"/ARData123"];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 创建一个文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [[pathArray firstObject] stringByAppendingPathComponent:@"/ARData"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"copyFile");
        //文件夹已存在
        // [SVProgressHUD showImage:nil status:@"文件夹已经存在"];
        return;
    } else {
        NSError *e = nil;
        BOOL isCopy = [manager copyItemAtPath:resourcePath toPath:filePath error:&e];
        if (e) {
            NSLog(@"move failed:%@",[e localizedDescription]);
        }
        if (isCopy) {
            printf(@"拷贝成功");
        } else {
            printf(@"拷贝失败");
        }
    }
}
- (void)copyFileFromResourceTOSandbox
{
    
    //文件类型
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"guangdianAndroid" ofType:@"zip"];
    
    // 沙盒Documents目录
    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 沙盒Library目录
    //NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    //appLib  Library/Caches目录
    //NSString *appLib = [appDir stringByAppendingString:@"/Caches"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [appDir stringByAppendingPathComponent:@"guangdianAndroid.zip"];
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        BOOL filesPresent = [self copyMissingFile:docPath toPath:appDir];
        if (filesPresent) {
            NSLog(@"Copy Success");
        }
        else
        {
            NSLog(@"Copy Fail");
        }
    }
    else
    {
        NSLog(@"文件已存在");
    }
}

/**
 *    @brief    把Resource文件夹下的area.db拷贝到沙盒
 *
 *    @param     sourcePath     Resource文件路径
 *    @param     toPath     把文件拷贝到XXX文件夹
 *
 *    @return    BOOL
 */
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}
- (void) enterARNew{
    
//        ARWebViewController *webVc = [[ARWebViewController alloc]init];
//        webVc.modalPresentationStyle = UIModalPresentationFullScreen;
//        webVc.URLStr = @"";
//        [self presentViewController:webVc animated:YES completion:nil];
    HomeViewController *arVC = [[HomeViewController alloc]init];
    arVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:arVC animated:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
 
#pragma mark- 光感
- (void)lightSensitive {
 
  // 1.获取硬件设备
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
 
  // 2.创建输入流
  AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
 
  // 3.创建设备输出流
  AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
  [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
 
 
  // AVCaptureSession属性
  self.session = [[AVCaptureSession alloc]init];
  // 设置为高质量采集率
  [self.session setSessionPreset:AVCaptureSessionPresetHigh];
  // 添加会话输入和输出
  if ([self.session canAddInput:input]) {
    [self.session addInput:input];
  }
  if ([self.session canAddOutput:output]) {
    [self.session addOutput:output];
  }
 
  // 9.启动会话
  [self.session startRunning];
 
}
 
#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
 
  CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
  NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
  CFRelease(metadataDict);
  NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
  float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
 
  NSLog(@"%f",brightnessValue);
}

#pragma mark - iCarouselDataSource
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.filmImageNameArr.count;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UIImage *image = [UIImage imageNamed:[self.filmImageNameArr objectAtIndex:index]];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height/3+4, self.view.frame.size.height*2/3+4)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.view.frame.size.height/3, self.view.frame.size.height*2/3)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 1000+index;
        [view addSubview:imageView];
    }
    UIImageView *imageView = [view viewWithTag:1000+index];
    imageView.image = image;
    
    return view;
}

#pragma mark - iCarouselDelegate
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSLog(@"___1 %lu",carousel.currentItemIndex);
    UIView *view = carousel.currentItemView;
    view.backgroundColor = [UIColor clearColor];
    self.selectView = view;
    self.filmNameLab.text = self.filmNameArr[carousel.currentItemIndex];
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    NSLog(@"___2 %lu",carousel.currentItemIndex);
    if (self.selectView != carousel.currentItemView) {
        self.selectView.backgroundColor = [UIColor clearColor];
        UIView *view = carousel.currentItemView;
       view.backgroundColor = [UIColor clearColor];
        
        self.filmNameLab.text = self.filmNameArr[carousel.currentItemIndex];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    NSLog(@"___3 %lu",carousel.currentItemIndex);
    self.selectView = carousel.currentItemView;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return CATransform3DTranslate(transform, offset * self.filmCarousel.itemWidth * 1.4, 0.0, 0.0);
    } else {
        return CATransform3DTranslate(transform, offset * self.filmCarousel.itemWidth * 1.05, 0.0, 0.0);
    }
}

#pragma mark - LazyLoad
-(iCarousel *)filmCarousel{
    if (_filmCarousel == nil) {
        _filmCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 - self.view.frame.size.height/3-2, self.view.frame.size.width, self.view.frame.size.height*2/3+4)];
        _filmCarousel.delegate = self;
        _filmCarousel.dataSource = self;
        _filmCarousel.backgroundColor = [UIColor clearColor];
        _filmCarousel.bounces = NO;
        _filmCarousel.pagingEnabled = YES;
        _filmCarousel.type = iCarouselTypeCustom;
    }
    return _filmCarousel;
}

- (NSMutableArray *)filmImageNameArr{
    if (!_filmImageNameArr) {
        _filmImageNameArr = [NSMutableArray array];
        for (int i = 1; i<= 3; i++) {
            [_filmImageNameArr addObject:[NSString stringWithFormat:@"guide%d",i]];
            //[_filmImageNameArr addObject:@"one"];
        }
    }
    return _filmImageNameArr;
}

- (NSMutableArray *)filmNameArr{
    if (!_filmNameArr) {
        _filmNameArr = [NSMutableArray array];
        for (int i = 1; i<= 3; i++) {
            //[_filmNameArr addObject:[NSString stringWithFormat:@"guide%d",i]];
            [_filmNameArr addObject:@""];
        }
    }
    return _filmNameArr;
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager
{
    [locationManager requestAlwaysAuthorization];
}


- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    printf("amapLocationManager");
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 保存数据
    NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    [userDefaults setValue:lat forKey:@"lat"];
    // 保存数据
    NSString *lon = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    [userDefaults setValue:lon forKey:@"lon"];
    [userDefaults synchronize];
    // 读取数据
    NSString *i = [userDefaults valueForKey:@"lat"];
    NSLog(@"读出来的数据: %@",i);
    SinggleInstance.defaultPerson.mLocattion = location;
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

- (IBAction)requestList:(UIButton *)sender {
    printf("清除缓存");
    
    SettingVC *settingVC = [[SettingVC alloc] init];
    settingVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:settingVC animated:YES];
}
- (IBAction)enterAR {
    NSLog(@"enterAR");
    if (!agree) {
        return;
    }
    if(![self deviceCanEnter]){
        [self.view makeToast:@"抱歉，当前设备不支持！" duration:2 position:CSToastPositionCenter];
        return;
    }
    HomeViewController *arVC = [[HomeViewController alloc]init];
    arVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:arVC animated:YES];
}
- (IBAction)agree:(id)sender {
    if (agree) {
        agree = false;
        [_userPrivatyAgree setImage:[UIImage imageNamed:@"ic_unchecked.png"] forState:(UIControlStateNormal)];
        _viewEnterAr.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:255.0];
    }else{
        agree = true;
        [_userPrivatyAgree setImage:[UIImage imageNamed:@"ic_checked.png"] forState:(UIControlStateNormal)];
        _viewEnterAr.backgroundColor = [UIColor colorWithRed:61/255.0 green:92/255.0 blue:255/255.0 alpha:1.0];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:agree forKey:@"userPrivacy"];
}

@end
