//
//  GSBaseNavViewController.m
//  QingProduct
//

#import "GSBaseNavViewController.h"

@interface GSBaseNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation GSBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingup];
}


- (void)settingup {
    [self setNavigationBarHidden:YES];
    self.interactivePopGestureRecognizer.delegate = self;
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBtn.frame = CGRectMake(0, 0, 44 , 55);
        [leftBtn setImage:[[UIImage imageNamed:@"back_nav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)leftBarBtnClicked:(UIButton *)btn
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return  self.childViewControllers.count > 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
