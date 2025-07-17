//
//  Gnss.h
//  swiftONE
//
//  Created by Candy.Yuan on 2023/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Gnss : NSObject
@property(nonatomic, assign) NSString *isValid;

@property(nonatomic, assign) NSString *isSimulated;

@property(nonatomic, strong) NSNumber *latitude;

@property(nonatomic, strong) NSNumber *longitude;

@property(nonatomic, strong) NSNumber *altitude;

@property(nonatomic, strong) NSNumber *horizontalAccuracy;

@property(nonatomic, strong) NSNumber *verticalAccuracy;
@end

NS_ASSUME_NONNULL_END
