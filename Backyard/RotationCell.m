//
//  RotationCell.m
//  Backyard
//
//  Created by Cheng-Yuan Wu on 7/20/15.
//  Copyright (c) 2015 Kenny Chu. All rights reserved.
//

#import "RotationCell.h"

@implementation RotationCell

- (void)awakeFromNib {
    self.profileImage.layer.cornerRadius = 10.0f;//self.profileImage.frame.size.width/9;
    self.profileImage.clipsToBounds = YES;
    
    self.leftTopBackground.layer.cornerRadius = self.leftTopBackground.frame.size.width/2;
    self.leftTopBackground.clipsToBounds = YES;
    
    
    // Initialization code
    //把後面的東西擋起來
    //cell 數量少或size小時才需要
    //self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 120.0f)];
    //[self.backgroundView setBackgroundColor:[UIColor redColor]];
    //[self.profileImage setContentMode:UIViewContentModeScaleAspectFit];
}

@end
