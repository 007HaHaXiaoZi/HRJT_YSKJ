//
//  SinggleInstance.h
//  swiftONE
//
//  Created by admin on 2021/9/13.
//

#ifndef SinggleInstance_h
#define SinggleInstance_h


#endif /* SinggleInstance_h */

#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
@interface SinggleInstance : NSObject

@property (nonatomic, assign) CLLocation* mLocattion;
+ (instancetype)defaultPerson;
@end
