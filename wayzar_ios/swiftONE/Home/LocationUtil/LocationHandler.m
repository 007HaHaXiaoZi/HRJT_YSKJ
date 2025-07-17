//
//  LocationHandler.m
//  PGVerseTestUnity
//
//  Created by Candy.Yuan on 2022/12/1.
//

#import "LocationHandler.h"
#import "JZLocationConverter.h"
static LocationHandler *DefaultManager = nil;

@interface LocationHandler()<CLLocationManagerDelegate>

@end

@implementation LocationHandler

+(id)getSharedInstance{
    if (!DefaultManager) {
        DefaultManager = [[self allocWithZone:NULL]init];
        [DefaultManager initiate];
    }
    return DefaultManager;
}
-(void)initiate{
    CMMotionManager *cmm = [[CMMotionManager alloc]init];
    cmm.deviceMotion.attitude.rotationMatrix;
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    if(locationManager.accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy){
        [locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"newLocation" completion:^(NSError *error){
            NSLog(@"yuan  new Location%@",error.userInfo);
        }];
    }
}

-(void)startUpdating{
    NSLog(@"startUpdating");
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];
}

-(void) stopUpdating{
    [locationManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:
 (CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"yuan");
    NSLog(@"经度:%f,纬度%f,海拔:%f,速度%f,航向%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude,newLocation.altitude,newLocation.speed,newLocation.course);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//注意 CLLocation类是 位置类 专门存储位置信息
CLLocation * location = [locations firstObject];
//因为 此方法会执行很多次 所以存储位置的是一个数组容器 会吧最新的位置信息存储为第一个对象
//存储经纬度的是一个结构体
    CLLocationCoordinate2D coordinate =   [JZLocationConverter wgs84ToGcj02:location.coordinate];
NSLog(@"经度:%f,纬度%f,海拔:%f,速度%f,航向%f",coordinate.longitude,coordinate.latitude,location.altitude,location.speed,location.course);
    
    if ([self.delegate respondsToSelector:@selector
    (didUpdateToLocation:fromLocation:)])
    {
        [self.delegate didUpdateToLocation:&coordinate
                              fromLocation:&coordinate];

    }
//最后一遍 所有跟位置有关的都是 CLLocation存储的

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"yuan%@", error.description);
    NSLog(@"yuan%@", error.userInfo);
}
@end
