//
//  ARSpiritTitleView.m
//  THTAPP
//
//

#import "ARSpiritTitleView.h"
#import "Macro.h"
@interface ARSpiritTitleView()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *locationDetail;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UIButton *enterAR;
@property (weak, nonatomic) IBOutlet UIView *toViewContent;
@property (weak, nonatomic) IBOutlet UIButton *guideLocation;
@property (weak, nonatomic) IBOutlet UIView *share;
@property (weak, nonatomic) IBOutlet UIImageView *shouchangIcon;

@end

@implementation ARSpiritTitleView{
    ARSceneBean *arSceneBean;
    NSString *deviceType;
}
- (IBAction)hhhh:(id)sender {
    NSLog(@"dianjile11");
}
- (IBAction)hahhaha:(id)sender {
    NSLog(@"dianjile");
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"ARSpiritTitleView" owner:self options:nil] lastObject];
    //self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    
    [self.toViewContent setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    deviceType = [UIDevice currentDevice].model;
    NSLog(@"yuan  shebei:%@", deviceType);
    
    if ([deviceType isEqualToString:@"iPad"]) {
        [_titleImageView setFrame:CGRectMake(50, 50, 150, 150)];
        [_name setFrame:CGRectMake(250, 50, 300, 50)];
        _name.font = [UIFont systemFontOfSize:22];
        [_type setFrame:CGRectMake(250, 100, 300, 50)];
        _type.font = [UIFont systemFontOfSize:20];
        [_locationDetail setFrame:CGRectMake(250, 150, 400, 50)];
        _locationDetail.font = [UIFont systemFontOfSize:20];
        [_testBtn setFrame:CGRectMake(self.frame.size.width/8-40, 220, 80, 59)];
        [_guideLocation setFrame:CGRectMake(self.frame.size.width*3/8-40, 220, 80, 59)];
        [_share setFrame:CGRectMake(self.frame.size.width*7/8-40, 220, 80, 59)];
        [_enterAR setFrame:CGRectMake(self.frame.size.width*5/8-45, 235, 90, 30)];
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.toViewContent.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    self.toViewContent.frame = self.toViewContent.bounds;
    maskLayer.path = maskPath.CGPath;
    self.toViewContent.layer.mask = maskLayer;
    self.toViewContent.backgroundColor = [UIColor whiteColor];
    _testBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView)];
    [_testBtn addGestureRecognizer:singleTap];
    _enterAR.overrideUserInterfaceStyle = YES;
    _enterAR.layer.cornerRadius = 15;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAR)];
    [_enterAR addGestureRecognizer:singleTap1];
    self.titleImageView.layer.cornerRadius = 13;
    
    _guideLocation.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideLocation)];
    [_guideLocation addGestureRecognizer:singleTap2];
    _share.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareWX)];
    [_share addGestureRecognizer:singleTap3];
    
    //向微信注册
    [WXApi registerApp:@"wxdb3cfc666ef3cd17" universalLink:@"https://wayzoom/"];
    return self;
}
-(void) hideImageView{
    NSLog(@"yuan  hideImageView");
    if (arSceneBean.shouCang) {
        arSceneBean.shouCang = false;
        [_shouchangIcon setImage:[UIImage imageNamed:@"ic_style_item_shouchang_normal"]];
    }else{
            arSceneBean.shouCang = true;
            [_shouchangIcon setImage:[UIImage imageNamed:@"ic_style_item_shouchang"]];
    }
}
-(void) shareWX{
//    [UIAlertView requestWithTitle:@"请输入谜底" message:nil defaultText:@"" sure:^(UIAlertView * , NSString *text) {
//        WXNontaxPayReq *req = [[WXNontaxPayReq alloc] init];
//        req.urlString = text;
//        [WXApi sendReq:req completion:nil];
//    }];
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixinULAPI://"]]){
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = @"分享的内容";
        req.scene = WXSceneSession;
        [WXApi sendReq:req completion:nil];
    }else{
        [[UIApplication sharedApplication].keyWindow makeToast:@"请先安装app！"];
    }
    NSLog(@"yuan  shareWX");
}
-(void) guideLocation{
    //UIImageWriteToSavedPhotosAlbum(self.titleImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSLog(@"yuan  guideLocation");
    [self creatActionSheet];
}
-(void) enterAR{
    NSLog(@"yuan  enterAR22");
    if ([self.delegate respondsToSelector:@selector(enterAR:)]) {
        [self.delegate enterAR:arSceneBean];
    }
}
- (IBAction)enterAR:(id)sender {
    NSLog(@"yuan  enterAR");
    UIImageWriteToSavedPhotosAlbum(self.titleImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

     
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error  contextInfo:(void *)contextInfo{

 if (error) {
         [[UIApplication sharedApplication].keyWindow makeToast:@"保存至相册失败！"];
    }else{
         [[UIApplication sharedApplication].keyWindow makeToast:@"保存至相册成功！"];
    }
}
- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}


- (void)setModel:(ARSceneBean *)model {
    arSceneBean = model;
    self.name.text = model.name;
    self.type.text = model.type;
    self.locationDetail.text = model.address;
    [self.titleImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"ic_scene_aveter"]];
    if (!arSceneBean.shouCang) {
        [_shouchangIcon setImage:[UIImage imageNamed:@"ic_style_item_shouchang_normal"]];
    }else{
            [_shouchangIcon setImage:[UIImage imageNamed:@"ic_style_item_shouchang"]];
    }
}
- (NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYY-MM-dd"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    NSLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}
-(void)creatActionSheet {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"请选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.popoverPresentationController.sourceView = self;
    actionSheet.popoverPresentationController.sourceRect = self.bounds;
    float latitude1 = [arSceneBean.coordinate.latitude floatValue];
    float longitude1 = [arSceneBean.coordinate.longitude floatValue];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=walking&coord_type=gcj02", latitude1, longitude1,arSceneBean.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            [[UIApplication sharedApplication].keyWindow makeToast:@"请先安装app！"];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&dlat=%f&dlon=%f&dname=%@&dev=0&t=2",latitude1,longitude1,arSceneBean.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            [[UIApplication sharedApplication].keyWindow makeToast:@"请先安装app！"];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    UIViewController *con = [self viewController:self];
    //相当于之前的[actionSheet show];
    [con presentViewController:actionSheet animated:YES completion:nil];
}
- (UIViewController*)viewController:(UIView *)view {

    for (UIView* next = [view superview]; next; next = next.superview) {

        UIResponder* nextResponder = [next nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]]) {

            return (UIViewController*)nextResponder;

        }

    }

    return nil;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
