//
//  RotationCell.h
//  Backyard
//
//  Created by Cheng-Yuan Wu on 7/20/15.
//  Copyright (c) 2015 Kenny Chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotationCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *leftTopBackground;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
