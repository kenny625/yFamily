//
//  Employee.h
//  Backyard
//
//  Created by Kenny Chu on 2015/7/13.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"


@interface Employee : NSObject
@property (strong, nonatomic) NSString *backyardId;
@property (strong, nonatomic) NSString * username;
@property (strong, nonatomic) NSString *profileImgUrl;
@property (strong, nonatomic) NSString *tumblrUrl;
@property (assign, nonatomic) NSInteger browseCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray*)employeesWithArray:(NSArray*)array;
@end
