//
//  PictureResponseBean.h
//  swiftONE
//
//  Created by Candy.Yuan on 2023/2/3.
//

#import <Foundation/Foundation.h>
#import "PictureBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureResponseBean : NSObject
@property(nonatomic, strong) NSArray<NSArray<PictureBean *> *> *data;

@property(nonatomic, strong) NSNumber *is_generating;

@property(nonatomic, strong) NSNumber *duration;

@property(nonatomic, strong) NSNumber *average_duration;
@end

NS_ASSUME_NONNULL_END
