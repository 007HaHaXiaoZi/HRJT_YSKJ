//
//  PictureBean.h
//  swiftONE
//
//  Created by Candy.Yuan on 2023/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PictureBean : NSObject
@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) id data;

@property(nonatomic, strong) NSNumber *is_file;
@end

NS_ASSUME_NONNULL_END
