//
//  SinggleInstance.m
//  swiftONE
//
//  Created by admin on 2021/9/13.
//

#import "SinggleInstance.h"
#import <Foundation/Foundation.h>
@interface SinggleInstance()

@end
@implementation SinggleInstance

static SinggleInstance *person;

+ (instancetype)defaultPerson{
    if (person == nil) {
        person = [[SinggleInstance alloc] init];
    }
    return person;
}
@end
