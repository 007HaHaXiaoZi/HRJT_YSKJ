//
//  HLAlertViewBlock.m
//  swiftONE
//
//  Created by Candy.Yuan on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import "HLAlertViewBlock.h"
//.m
@interface HLAlertViewBlock()

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;

/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;

/** message */
@property (nonatomic,copy)   NSString *message;

/** 确认按钮 */
@property (nonatomic,copy)   UIButton *sureButton;

@end


@implementation HLAlertViewBlock

- (instancetype)initWithTittle:(NSString *)tittle message:(NSString *)message block:(void (^)(NSInteger))block{
    if (self = [super init]) {
        self.title = tittle;
        self.message = message;
        self.buttonBlock = block;
        //[self sutUpView];
    }
    return self;
}

@end

