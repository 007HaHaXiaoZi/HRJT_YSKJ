//
//  ARWebViewController.m
//  UnityFramework
//
//  Created by LiuGaoSheng on 2022/6/2.
//
#pragma mark - 常用色值
#define ARNomalBlackColor RGB(51,51,51)
#define ARNomalLightBlackColor RGB(102,102,102)
#define ARNomalGrayColor RGB(132,132,132)
#define ARNomalRedColor  RGB(223, 55, 54)
#define GSNavBarColor RGB(37, 125, 202)
#define GSARNavInfoTextColor RGB(245, 162, 0)
#define ARNomalTranslucentColor RGBA(0,0,0,0.7)
#define QN_MAIN_COLOR RGB(6.0, 130.0, 255.0)

#pragma mark - 尺寸
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// iPhone X 宏定义
#define  iPhoneX (kScreenWidth >= 375.f && kScreenHeight >= 812.f ? YES : NO)
#define  iPhoneLow5s (kScreenWidth == 320.f ? YES : NO)
#define  GS_NavHeight  (iPhoneX ? 88.f : 64.f)

#import "ARWebViewController.h"
#import <WebKit/WebKit.h>
#import "ARBaseNavView.h"

@interface ARWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
/** 导航栏 */
@property(nonatomic,strong) ARBaseNavView *navView;

@end

@implementation ARWebViewController
- (ARBaseNavView *)navView {
    if (!_navView) {
        _navView = [[ARBaseNavView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, GS_NavHeight)];
    }
    return _navView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}
- (void)initSubViews {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, GS_NavHeight, self.view.frame.size.width, self.view.frame.size.height - GS_NavHeight)];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.URLStr]]];
    //url链接版本
//    self.URLStr = @"http://ldhc-pano.newayz.cn/?1f";
    NSString *basePath = [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] bundlePath], @"testHtml"];
    NSURL *baseUrl = [NSURL fileURLWithPath: basePath isDirectory: YES];
    NSString *filePath = [NSString stringWithFormat: @"file://%@/Not Found.html", basePath];
    NSURL *fileUrl = [NSURL URLWithString: filePath];
    [_webView loadFileURL: fileUrl allowingReadAccessToURL: baseUrl];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLStr]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    //开了支持滑动返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    // KVO，监听webView属性值得变化(estimatedProgress,title为特定的key)
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.navView];
    self.navView.backBlock = ^{
    ///移除控制器
        [self backNative];
    };
    // UIProgressView初始化
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, GS_NavHeight, self.webView.frame.size.width, 2);
    self.progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
    self.progressView.progressTintColor = [UIColor redColor];
    // 设置初始的进度，防止用户进来就懵逼了（微信大概也是一开始设置的10%的默认值）
    [self.progressView setProgress:0.1 animated:YES];
    [self.view addSubview:self.progressView];
}

#pragma mark - KVO监听
// 第三部：完成监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条

        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        NSLog(@"打印测试进度值：%f", newprogress);
        
        if (newprogress == 1) { // 加载完成
            
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if ([object isEqual:self.webView] && [keyPath isEqualToString:@"title"]) { // 标题
        
        self.title = self.webView.title;
        self.navView.title = self.webView.title;
    } else { // 其他
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark WKUIDelegate
// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    self.title = webView.title;

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    self.title = webView.title;
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {//判断是返回类型
        
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮 这里可以监听左滑返回事件，仿微信添加关闭按钮。
        //可以在这里找到指定的历史页面做跳转
        //        if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
        //            DLog(@"%@",webView.backForwardList.backList);
        //            DLog(@"%@",webView.backForwardList.currentItem);
        //            WKBackForwardListItem * item = webView.backForwardList.currentItem;          //得到现在加载的list
        //            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
        //                //添加判断条件
        //                [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
        //            }
        //        }
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

#pragma mark WKUIDelegate
//显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
 
}

//弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //这里必须执行不然页面会加载不出来
        completionHandler(@"");
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        completionHandler([alert.textFields firstObject].text);
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)backNative{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
    } else {
        ///移除自控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)dealloc {
    
    // 最后一步：移除监听
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
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
