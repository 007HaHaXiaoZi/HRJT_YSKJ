//
//  Compass.h
//  swiftONE
//
//  Created by Candy.Yuan on 2023/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Compass : NSObject
@property(nonatomic, assign) NSString *isValid;

@property(nonatomic, strong) NSNumber *trueHeading;

@property(nonatomic, strong) NSNumber *headingAccuracy;

@end

NS_ASSUME_NONNULL_END
