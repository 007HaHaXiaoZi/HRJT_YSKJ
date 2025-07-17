//
//  ARBaseView.h
//  VientianeProduct
//
//  Created by LiuGaoSheng on 2022/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARBaseView : UIView
- (void)contentSizeToFitWithTextView:(UITextView *)textView;
- (BOOL)valiMobile:(NSString *)mobile;
@end

NS_ASSUME_NONNULL_END
