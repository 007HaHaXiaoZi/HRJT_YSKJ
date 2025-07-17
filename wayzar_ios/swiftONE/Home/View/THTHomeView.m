//
//  HomeView.m
//  THTAPP
//
//

#import "THTHomeView.h"

@interface THTHomeView()
@property (weak, nonatomic) IBOutlet UIButton *ivScanTip;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseAr;
@property (weak, nonatomic) IBOutlet UIButton *ivShowMap;
@property (weak, nonatomic) IBOutlet UIButton *ivDingweiSuccess;

@end

@implementation THTHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]loadNibNamed:@"THTHomeView" owner:self options:nil]lastObject];
    if (self) {
        self.frame = frame;
    }
    
    [self.btnCloseAr setHidden:true];
    _ivShowMap.contentMode = UIViewContentModeScaleAspectFit;
    [_ivShowMap setFrame:CGRectMake(self.frame.size.width-57, self.frame.size.height -77, 42, 42)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bool *recordingMode = [userDefaults boolForKey:@"recording"];
    if (recordingMode) {
        [self.ivShowMap setHidden:true];
    }
    [self.ivShowMap setHidden:true];
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI*0.5);
//    [self.ivScanTip setTransform:transform];
//    CGAffineTransform transform2 = CGAffineTransformMakeRotation(M_PI*0.5);
//   [self.ivDingweiSuccess setTransform:transform2];
    [self.ivDingweiSuccess setHidden:true];
    [self.ivScanTip setHidden:true];
    return self;
}
- (IBAction)closeAR:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeViewdidClick360VR)]) {
        [self.delegate closeAR];
    }
}
- (IBAction)showMap:(id)sender {
    NSLog(@"showmap  hhhh");
    if ([self.delegate respondsToSelector:@selector(showMap)]) {
        [self.delegate showMap];
    }
}

- (void)hideScanTip {
    
    [self.ivScanTip setHidden:true];
}

- (void)showScanTip {
    
    [self.ivScanTip setHidden:false];
}

- (void)showDingweiSuccess {
    
    [self.ivDingweiSuccess setHidden:false];
}
- (void)hideDingweiSuccess {
    
    [self.ivDingweiSuccess setHidden:true];
}

///360全景
- (IBAction)panoramicClick:(UIButton *)sender {
    //[self.ivScanTip setHidden:true];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
