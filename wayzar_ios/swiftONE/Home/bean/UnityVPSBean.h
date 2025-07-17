//
//  UnityVPSBean.h
//  swiftONE
//
//  Created by Candy.Yuan on 2023/3/20.
//

#import <Foundation/Foundation.h>
#import "Compass.h"
#import "Gnss.h"
#import "Priorrotation.h"
#import "Resolution.h"
#import "EquipmentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnityVPSBean : NSObject
@property(nonatomic, strong) NSNumber *timestamp;

@property(nonatomic, strong) Priorrotation *focalLength;

@property(nonatomic, strong) Resolution *resolution;

@property(nonatomic, strong) Priorrotation *principalPoint;

@property(nonatomic, strong) Priorrotation *unityPosition;

@property(nonatomic, strong) Priorrotation *unityRotation;

@property(nonatomic, strong) Priorrotation *priorPosition;

@property(nonatomic, strong) Priorrotation *priorRotation;

@property(nonatomic, strong) NSNumber *deviceOrientation;

@property(nonatomic, strong) Gnss *gnss;

@property(nonatomic, strong) Compass *compass;

@property(nonatomic, strong) NSString *mapName;

@property(nonatomic, strong) EquipmentInfo *equipmentInfo;

@end

NS_ASSUME_NONNULL_END
