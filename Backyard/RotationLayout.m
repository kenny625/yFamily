//
//  RotationLayout.m
//  RotationTest
//
//  Created by Cheng-Yuan Wu on 7/15/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "RotationLayout.h"

@implementation RotationLayout

-(CGSize)collectionViewContentSize
{
    float width = self.collectionView.frame.size.width *([self.collectionView numberOfItemsInSection:0 ]+2);
    float height= self.collectionView.frame.size.height;
    CGSize  size = CGSizeMake(width, height);
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - UICollectionViewLayout
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //3D代码
    UICollectionViewLayoutAttributes* attributes = attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    UICollectionView *collection = self.collectionView;
    float width = collection.frame.size.width;
    float x = collection.contentOffset.x;
    CGFloat arc = M_PI * 2.0f;
    
    int numberOfVisibleItems = [self.collectionView numberOfItemsInSection:0];
    
    //cell position
    //circule center
    attributes.center = CGPointMake(x+200,240.0f);
    //cell size
    attributes.size = CGSizeMake(100.0f, 100.0f);
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0f/700.0f;
    
    
    //    numberOfVisibleItems = 5;
    CGFloat radius = attributes.size.width/2/ tanf(arc/2.0f/numberOfVisibleItems);
    CGFloat angle = (indexPath.row-x/width+1)/ numberOfVisibleItems * arc;
    transform = CATransform3DRotate(transform, angle, 0.0f, 1.0f, 0.0f);
    transform = CATransform3DTranslate(transform, 0.f, 0.0f, radius);
    attributes.transform3D = transform ;
    
    
    
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    if ([arr count] >0) {
        return arr;
    }
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:0 ]; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end
