//
//  UIView+BottomSceneItemView.m
//  swiftONE
//
//  Created by Candy.Yuan on 2021/12/8.
//

#import "BottomSceneItemView.h"
@interface BottomSceneItemView()

@end

@implementation BottomSceneItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]loadNibNamed:@"BottomSceneItemView" owner:self options:nil]lastObject];
    if (self) {
        self.frame = frame;
    }
    
    return self;
}
- (IBAction)click3:(UIButton *)sender {
    NSLog(@"点击了AR");
    printf("hhhh点击了");
}
- (IBAction)click2:(UIButton *)sender {
    NSLog(@"点击了AR");
    printf("hhhh点击了");
}
- (IBAction)click1:(UIButton *)sender {
    NSLog(@"点击了AR");
    printf("hhhh点击了");
}

@end
