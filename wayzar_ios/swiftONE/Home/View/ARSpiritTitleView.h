//
//  ARSpiritTitleView.h
//  THTAPP
//

#import <UIKit/UIKit.h>
#import "ARSceneBean.h"
#import "UIView+Toast.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "UIAlertView+WX.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TopViewDlegate <NSObject>

- (void)enterAR:(ARSceneBean *)arSceneBean;


@end
@interface ARSpiritTitleView : UIView
@property(nonatomic,weak) id<TopViewDlegate> delegate;
- (void)setModel:(ARSceneBean *)model;
@end

NS_ASSUME_NONNULL_END
