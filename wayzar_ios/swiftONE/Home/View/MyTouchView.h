//
//  MyTouchView.h
//  swiftONE
//
//  Created by Candy.Yuan on 2022/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MyTouchViewDlegate <NSObject>

- (void)moveUp;

-(void)moveDown;

@end
@interface MyTouchView : UIView
@property(nonatomic,weak) id<MyTouchViewDlegate> delegate;

@end

NS_ASSUME_NONNULL_END
