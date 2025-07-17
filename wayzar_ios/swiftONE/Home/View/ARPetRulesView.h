//
//  ARPetRulesView.h
//  THTAPP
//
//  Created by LiuGaoSheng on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "ARSceneBean.h"
#import "UIImageUtil.h"
#import "MyTouchView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BottomViewDlegate <NSObject>

- (void)bottomViewClickItem:(ARSceneBean *)arSceneBean;

-(void)mapReset;

@end
@interface ARPetRulesView : UIView

@property(nonatomic,weak) id<BottomViewDlegate> delegate;
- (void) setDataList:(NSArray *)ardata;
- (void) hideListView;
@end

NS_ASSUME_NONNULL_END
