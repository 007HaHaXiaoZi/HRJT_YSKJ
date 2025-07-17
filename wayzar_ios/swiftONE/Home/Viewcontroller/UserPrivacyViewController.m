//
//  UserPrivacyViewController.m
//  swiftONE
//
//  Created by Candy.Yuan on 2021/12/21.
//

#import "UserPrivacyViewController.h"

@interface UserPrivacyViewController ()

@end

@implementation UserPrivacyViewController
- (void)loadView {
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 25, self.view.frame.size.width,self.view.frame.size.height)];
        [self.view addSubview:textView];
    textView.editable = NO;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"string" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString *string1 = [dict objectForKey:@"userprivacy"];
    //NSString *strHtml = @"<b>提示</b><br/>1、测试测试测试测试测试测试测试测试测试测试测试测试<br/>2、测试测试测试测试测试测试测试测试测试测试";
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[string1 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        textView.attributedText = attributedString;
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 22, 15)];
    [imageView setImage:[UIImage imageNamed:@"ic_back"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setUserInteractionEnabled:YES];
    [imageView setMultipleTouchEnabled:YES];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backPress:)];
    [imageView addGestureRecognizer:singleTap1];
    [self.view addSubview:imageView];
    
}
-(void)backPress:(UITapGestureRecognizer *)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:false];
    //[self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
