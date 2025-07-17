//
//  ARGuideView.h
//  swiftONE
//
//  Created by Candy.Yuan on 2022/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ARGuideViewDlegate <NSObject>

-(void)itemClick:(NSString *)name;

@end
@interface ARGuideView : UIView
@property(nonatomic,weak) id<ARGuideViewDlegate> delegate;
-(void)loadData:(NSArray *)newDataList;
@end


NS_ASSUME_NONNULL_END
