//
//  HDBaseNavView.m
//  HDVideoKitDemok
//
//  Created by liugaosheng on 2021/7/14.
//  Copyright © 2021 刘高升. All rights reserved.
//
#pragma mark - 尺寸
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// iPhone X 宏定义
#define  iPhoneX (kScreenWidth >= 375.f && kScreenHeight >= 812.f ? YES : NO)
#define  iPhoneLow5s (kScreenWidth == 320.f ? YES : NO)

#define  GS_SAFEAREA_TOP                 (iPhoneX ? 24.0f : 0.0f)
// 适配iPhone X 状态栏高度
#define  GS_StatusBarHeight      (iPhoneX ? 44.f : 20.f)
// 适配iPhone X Tabbar高度
#define  GS_TabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// 适配iPhone X Tabbar距离底部的距离
#define  GS_TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// 适配iPhone X 导航栏高度
#define  GS_NavHeight  (iPhoneX ? 88.f : 64.f)

#define kScaleWidth     kScreenWidth/375.0
#define kScaleHeight    kScreenHeight/667.0

#import "ARBaseNavView.h"
@interface ARBaseNavView()
///返回按钮
@property(nonatomic,strong)UIButton *backButtn;
///导航标题
@property(nonatomic,strong)UILabel  *titleLabel;

@end


@implementation ARBaseNavView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self.title = title;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubVeiws];
    }
    return self;
}

- (void)initSubVeiws {
    
    UIColor *pageColor = [UIColor whiteColor];
    self.backgroundColor = pageColor;
    self.backButtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButtn.frame = CGRectMake(10, GS_StatusBarHeight + 8, 33, 33);
    [self.backButtn setImage:[UIImage imageNamed:@"ar_nav_back"] forState:UIControlStateNormal];
    [self.backButtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButtn];

    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backButtn.frame), self.backButtn.center.y - 13, self.frame.size.width - CGRectGetMaxX(self.backButtn.frame) * 2, 26);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = [UIColor whiteColor];;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.title;
    [self addSubview:self.titleLabel];

    
    
}

- (void)backAction {
    !self.backBlock ? : self.backBlock();
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
