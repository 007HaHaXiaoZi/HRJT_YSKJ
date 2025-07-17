//
//  LocationHandler.h
//  PGVerseTestUnity
//
//  Created by Candy.Yuan on 2022/12/1.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreMotion/CoreMotion.h"

@protocol LocationHandlerDelegate <NSObject>

@required
-(void) didUpdateToLocation:(CLLocationCoordinate2D *)newLocation
 fromLocation:(CLLocationCoordinate2D *)oldLocation;
@end

@interface LocationHandler : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
}
@property(nonatomic,strong) id<LocationHandlerDelegate> delegate;

+(id)getSharedInstance;
-(void)startUpdating;
-(void)stopUpdating;

@end
