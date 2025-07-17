
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Files : NSObject

@property(nonatomic, strong) NSString *link;

@end



@interface Package : NSObject

@property(nonatomic, strong) NSArray *files;

@end



@interface Boundary : NSObject

@property(nonatomic, strong) NSString *type;

@property(nonatomic, strong) NSArray<NSArray *>*coordinates;

@end



@interface Coordinate : NSObject

@property(nonatomic, strong) NSNumber *longitude;

@property(nonatomic, strong) NSNumber *latitude;

@end



@interface ARSceneBean : NSObject

@property(nonatomic, strong) NSString *id;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *description;

@property(nonatomic, strong) NSString *place;

@property(nonatomic, strong) NSString *avatar;

@property(nonatomic, strong) NSString *type;

@property(nonatomic, strong) Coordinate *coordinate;

@property(nonatomic, strong) NSString *boundaryId;

@property(nonatomic, strong) Boundary *boundary;

@property(nonatomic, strong) NSString *city;

@property(nonatomic, strong) NSString *township;

@property(nonatomic, strong) NSString *address;

@property(nonatomic, strong) Package *package;

@property(nonatomic, strong) NSString *createTime;

@property(nonatomic, strong) NSString *updateTime;

@property(nonatomic, assign) BOOL shouCang;

@end

NS_ASSUME_NONNULL_END
