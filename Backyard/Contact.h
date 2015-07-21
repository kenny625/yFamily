//
//  Contact.h
//  Backyard
//
//  Created by Kenny Chu on 2015/7/14.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property (strong, nonatomic) NSString *backyardId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *tumblrUrl;
@property (strong, nonatomic) NSString *contactOfWhom;

- (id)initWithDictionary:(NSDictionary *)dictionary andOfWhom:(NSString*)contactOfWhom;
+ (NSArray*)contactsWithArray:(NSArray*)array andOfWhom:(NSString*)contactOfWhom;
@end
