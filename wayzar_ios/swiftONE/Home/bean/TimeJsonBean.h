//
//  TimeJsonBean.h
//  swiftONE
//
//  Created by Candy.Yuan on 2022/6/16.
//

#ifndef TimeJsonBean_h
#define TimeJsonBean_h


#import <Foundation/Foundation.h>

@interface Parallesverselist : NSObject

@property(nonatomic, strong) NSString *id;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *remark;

@end



@interface TimeJsonBean : NSObject

@property(nonatomic, strong) NSArray *parallesverseList;

@end
#endif /* TimeJsonBean_h */
