//
//  BackyardClient.h
//  Backyard
//
//  Created by Kenny Chu on 2015/7/13.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackyardClient : NSObject
+ (BackyardClient *)sharedInstance;
- (void)getEmployeesWithCompletion:(void (^)(NSArray *employees, NSError *error))completion;
- (void)getNextEmployeesWithCompletion:(void (^)(NSArray *employees, NSError *error))completion;
- (void)getPreviousEmployeesWithCompletion:(void (^)(NSArray *employees, NSError *error))completion;
- (void)postInterestedWithBackyardId:(NSString*)backyardId completion:(void (^)(id response, NSError *error))completion;
- (void)getContactsWithId:(NSString*) backyardId andCompletion:(void (^)(NSArray *contacts, NSError *error))completion;
- (void)queryEmployeesWithName:(NSString*)name andCompletion:(void (^)(NSArray *employees, NSError *error))completion;
@end
