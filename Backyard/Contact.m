//
//  Contact.m
//  Backyard
//
//  Created by Kenny Chu on 2015/7/14.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "Contact.h"

@implementation Contact
- (id)initWithDictionary:(NSDictionary *)dictionary andOfWhom:(NSString*)contactOfWhom {
    self = [super init];
    if (self) {
        self.backyardId = dictionary[@"username"];
        self.username = dictionary[@"name"];
        self.imgUrl = [NSString stringWithFormat:@"http://build2.adp.corp.tw1.yahoo.com:3000/v1/users/%@/image", self.backyardId];
        self.tumblrUrl = dictionary[@"tumblrUrl"];
        self.contactOfWhom = contactOfWhom;
    }
    return self;
}
+ (NSArray*)contactsWithArray:(NSArray*)array andOfWhom:(NSString*)contactOfWhom {
    NSMutableArray *contacts = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        if (![dic[@"username"] isEqualToString:contactOfWhom]) {
            [contacts addObject:[[Contact alloc] initWithDictionary:dic andOfWhom:contactOfWhom]];
        }
    }
    return contacts;
}
@end
