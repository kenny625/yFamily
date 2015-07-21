//
//  FriendsView.h
//  Backyard
//
//  Created by Cheng-Yuan Wu on 7/20/15.
//  Copyright (c) 2015 Kenny Chu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvisibleButtonDelegate.h"
@interface FriendsView : UIView
@property (weak, nonatomic) id <InvisibleButtonDelegate> delegate;
- (id)init:(CGRect)frame cellCount:(NSUInteger)cellCount images:(NSArray *)images names:(NSArray *)names;
- (id)init:(CGRect)frame cellCount:(NSUInteger)cellCount contacts:(NSArray *)contacts;
- (void) setupCells:(NSUInteger)cellCount contacts:(NSArray *)contacts;
@end
