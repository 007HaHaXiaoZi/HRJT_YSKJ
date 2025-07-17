//
//  HLAlertViewBlock.h
//  swiftONE
//
//  Created by Candy.Yuan on 2021/12/1.
//

//.h

#import <UIKit/UIKit.h>
@interface HLAlertViewBlock : UIView

@property(nonatomic, copy) void (^buttonBlock) (NSInteger index);

- (instancetype)initWithTittle:(NSString *)tittle message:(NSString *)message block:(void (^) (NSInteger index))block;

- (void)show;

@end

