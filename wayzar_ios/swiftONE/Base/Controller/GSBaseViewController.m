//
//  GSBaseViewController.m
//  QingProduct
//
//

#import "GSBaseViewController.h"

@interface GSBaseViewController ()

@end

@implementation GSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingup];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)settingup {
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:215/255.0 blue:169/255.0 alpha:1];
//    self.view.backgroundColor = [UIColor clearColor];
    
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleDefault;
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
