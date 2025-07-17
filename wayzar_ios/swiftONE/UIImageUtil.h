//
//  NSObject+ImageUtil.h
//  swiftONE
//
//  Created by Candy.Yuan on 2021/12/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};
NS_ASSUME_NONNULL_BEGIN

@interface UIImageUtil : NSObject 

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
