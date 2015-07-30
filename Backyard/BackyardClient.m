//
//  BackyardClient.m
//  Backyard
//
//  Created by Kenny Chu on 2015/7/13.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "BackyardClient.h"
#import "AFNetworking.h"
#import "Employee.h"
#import "Contact.h"

@interface BackyardClient()
@property (assign, nonatomic) NSInteger currentEmployeesPage;
@end

NSInteger const employeeOffset = 0;
NSInteger const employeeLimit = 20;
NSInteger const contactOffset = 0;
NSInteger const contactLimit = 5;

@implementation BackyardClient
+ (BackyardClient *)sharedInstance {
    static BackyardClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[BackyardClient alloc] init];
            instance.currentEmployeesPage = 1;
        }
    });
    return instance;
}

- (void)getEmployeesWithParams:(NSDictionary*) params completion:(void (^)(NSArray *employees, NSError *error))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://build2.adp.corp.tw1.yahoo.com:3000/v1/users"
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *result = responseObject[@"result"];
             NSArray *employees = [Employee employeesWithArray:result];
             completion(employees, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
             NSLog(@"getEmployeesError: %@", error);
         }];
}

- (void)getContactsWithParams:(NSDictionary*) params completion:(void (^)(NSArray *contacts, NSError *error))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *contactUrl = [NSString stringWithFormat:@"http://build2.adp.corp.tw1.yahoo.com:3000/v1/users/%@/contacts", params[@"backyardId"]];
    [manager GET:contactUrl
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *result = responseObject[@"contacts"];
             NSArray *contacts = [Contact contactsWithArray:result andOfWhom:params[@"backyardId"]];
             completion(contacts, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(nil, error);
             NSLog(@"getContactsError: %@", error);
         }];
}

- (void)postInterestedWithBackyardId:(NSString*)backyardId completion:(void (^)(id response, NSError *error))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *positiveUrl = [NSString stringWithFormat:@"http://build2.adp.corp.tw1.yahoo.com:3000/v1/users/%@/positiveRating", backyardId];
    [manager POST:positiveUrl
       parameters:@{@"backyardId": backyardId}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"postInterestedResponse: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];

}

- (void)getEmployeesWithCompletion:(void (^)(NSArray *employees, NSError *error))completion {
    NSString *currentpage = [NSString stringWithFormat:@"%ld", self.currentEmployeesPage];
    NSString *limit = [NSString stringWithFormat:@"%ld", employeeLimit];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:currentpage, @"current_page", limit, @"per_page", nil];
    [self getEmployeesWithParams:dic completion:^(NSArray *employees, NSError *error) {
        completion(employees, error);
    }];
}

- (void)getNextEmployeesWithCompletion:(void (^)(NSArray *employees, NSError *error))completion {
    self.currentEmployeesPage = self.currentEmployeesPage + 1;
    [self getEmployeesWithCompletion:^(NSArray *employees, NSError *error) {
        completion(employees, error);
    }];
}

- (void)getPreviousEmployeesWithCompletion:(void (^)(NSArray *employees, NSError *error))completion {
    if (self.currentEmployeesPage > 1) {
        self.currentEmployeesPage = self.currentEmployeesPage - 1;
    }
    [self getEmployeesWithCompletion:^(NSArray *employees, NSError *error) {
        completion(employees, error);
    }];
}

- (void)getContactsWithId:(NSString*) backyardId andCompletion:(void (^)(NSArray *contacts, NSError *error))completion {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:backyardId, @"backyardId", nil];
    [self getContactsWithParams:dic completion:^(NSArray *contacts, NSError *error) {
        completion(contacts, error);
    }];
}
@end
