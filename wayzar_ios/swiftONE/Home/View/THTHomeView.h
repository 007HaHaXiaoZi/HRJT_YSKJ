//
//  HomeView.h
//  THTAPP
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HomeViewDlegate <NSObject>
/**
 首页
 */
///搜索
- (void)closeAR;

///AR
- (void)showMap;

///AR
- (void)homeViewdidClickAR;

///360全景
- (void)homeViewdidClick360VR;

///拼图寻宝
- (void)homeViewdidClickjigsawGame;

///一起捉萌宠
- (void)homeViewdidClickpetGame;

///召唤精灵
- (void)homeViewdidClickelvesGame;


@end

@interface THTHomeView : UIView
/** 代理 */
@property(nonatomic,weak) id<HomeViewDlegate> delegate;
- (void)hideScanTip;
- (void)showScanTip;
///AR
- (void)showDingweiSuccess;
///AR
- (void)hideDingweiSuccess;
@end

NS_ASSUME_NONNULL_END
