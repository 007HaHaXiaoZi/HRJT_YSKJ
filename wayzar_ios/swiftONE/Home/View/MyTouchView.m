//
//  MyTouchView.m
//  swiftONE
//
//  Created by Candy.Yuan on 2022/6/30.
//

#import "MyTouchView.h"

@implementation MyTouchView{
    int startY;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"触摸点击");
        //通过读取touches创建新的UITouch对象
        UITouch *touch = [touches anyObject];
        //取出当前点击的坐标点
        CGPoint location = [touch locationInView:self];
    startY = [[NSString stringWithFormat:@"%g",location.y] intValue];
        //取出上一个坐标点（适用于移动情况下，如果只是纯粹的两次触摸点击，无效果）
        CGPoint previousLocation = [touch previousLocationInView:self];
        //打印输出坐标点
        NSLog(@"touchesBegan%@,%@",NSStringFromCGPoint(location),NSStringFromCGPoint(previousLocation));

    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"触摸点击");
    if(startY==0){
        return;
    }
        //通过读取touches创建新的UITouch对象
        UITouch *touch = [touches anyObject];
        //取出当前点击的坐标点
        CGPoint location = [touch locationInView:self];
    int stopY =  [[NSString stringWithFormat:@"%g",location.y] intValue];
     int aa = startY +50;
     int bb = startY -50;
     if (stopY>aa) {
         startY = 0;
         NSLog(@"zheng偏移量足够进行偏移操作");
         if ([self.delegate respondsToSelector:@selector(moveUp)]) {
             [self.delegate moveUp];
         }
     }
     else if (stopY<bb){
         startY = 0;
             NSLog(@"fu偏移量足够进行偏移操作");
         if ([self.delegate respondsToSelector:@selector(moveDown)]) {
             [self.delegate moveDown];
         }
     }
        //取出上一个坐标点（适用于移动情况下，如果只是纯粹的两次触摸点击，无效果）
        CGPoint previousLocation = [touch previousLocationInView:self];
        //打印输出坐标点
        NSLog(@"touchesMoved%@,%@",NSStringFromCGPoint(location),NSStringFromCGPoint(previousLocation));
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"触摸点击");
        //通过读取touches创建新的UITouch对象
        UITouch *touch = [touches anyObject];
        //取出当前点击的坐标点
        CGPoint location = [touch locationInView:self];
//   int stopY =  [[NSString stringWithFormat:@"%g",location.y] intValue];
//    int aa = startY +50;
//    int bb = startY -50;
//    if (stopY>aa) {
//        NSLog(@"zheng偏移量足够进行偏移操作");
//        if ([self.delegate respondsToSelector:@selector(moveUp)]) {
//            [self.delegate moveUp];
//        }
//    }
//    else if (stopY<bb){
//            NSLog(@"fu偏移量足够进行偏移操作");
//        if ([self.delegate respondsToSelector:@selector(moveDown)]) {
//            [self.delegate moveDown];
//        }
//    }
        //取出上一个坐标点（适用于移动情况下，如果只是纯粹的两次触摸点击，无效果）
        CGPoint previousLocation = [touch previousLocationInView:self];
        //打印输出坐标点
        NSLog(@"touchesEnded%@,%@",NSStringFromCGPoint(location),NSStringFromCGPoint(previousLocation));
    
}
@end
