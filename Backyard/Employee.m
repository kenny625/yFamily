//
//  Employee.m
//  Backyard
//
//  Created by Kenny Chu on 2015/7/13.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "Employee.h"

@implementation Employee
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.backyardId = dictionary[@"username"];
        self.username = dictionary[@"name"];
        self.profileImgUrl = [NSString stringWithFormat:@"http://build2.adp.corp.tw1.yahoo.com:3000/v1/users/%@/image", self.backyardId];
        self.tumblrUrl = dictionary[@"tumblrUrl"];
        self.browseCount = [[NSString stringWithFormat:@"%@", dictionary[@"positiveRating"]] integerValue];
    }
    return self;
}

+ (NSArray*)employeesWithArray:(NSArray*)array {
    NSMutableArray *employees = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        [employees addObject:[[Employee alloc] initWithDictionary:dic]];
    }
    return employees;
}
@end
