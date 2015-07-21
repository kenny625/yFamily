//
//  FriendsView.m
//  RotationTest
//
//  Created by Cheng-Yuan Wu on 7/16/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "FriendsView.h"
#import "Contact.h"
#import <UIImageView+AFNetworking.h>


@interface FriendsView ()
@property NSArray *contacts;
@end
@implementation FriendsView


- (id)init:(CGRect)frame cellCount:(NSUInteger)cellCount images:(NSArray *)images names:(NSArray *)names{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Img-Background8.png"]]];
        self.frame = frame;
        [self setupCells:cellCount images:images names:names];
    }
    return self;
}


- (id)init:(CGRect)frame cellCount:(NSUInteger)cellCount contacts:(NSArray *)contacts {
    self = [super init];
    
    if (self) {
        
       CGRect bgFrame = CGRectMake(-40, -40, frame.size.width+40, frame.size.height+40);
        UIView *bgView = [[UIView alloc] initWithFrame:bgFrame];
        UIImage *bgImg = [self blurryImage:[UIImage imageNamed:@"Img-Background10.png"] withBlurLevel:10];
        //[self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Img-Background10.png"]]];
        [bgView setBackgroundColor:[[UIColor alloc] initWithPatternImage:bgImg]];
        [self addSubview:bgView];
        
        self.contacts = [[NSArray alloc] initWithArray: contacts];

        self.frame = frame;
        cellCount = cellCount > [contacts count] ? [contacts count] : cellCount;
        
        [self setupCells:cellCount contacts:contacts];
        [self setupInvisibleButtons:cellCount];
    }
    return self;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur), nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil]; // save it to self.context
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

- (void) setupCells:(NSUInteger)cellCount contacts:(NSArray *)contacts {
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    
    for (Contact *contact in contacts) {
        [imgArr addObject: contact.imgUrl];
        [nameArr addObject: contact.username];
    }
    
    cellCount = cellCount > [contacts count] ? [contacts count] : cellCount;
    NSLog(@"contactCount = %ld", [contacts count]);
    [self setupCells:cellCount images:imgArr names:nameArr];
}

- (void) setupCells:(NSUInteger)cellCount images:(NSArray *)images names:(NSArray *)names{
    NSUInteger maxCellsInRow = 3;
    NSUInteger totalRow = cellCount < maxCellsInRow ? 1 : 2;
    NSUInteger maxTotalRow = 2;
    NSInteger totalCells;
    CGFloat h_spacing = 15.0f;
    CGFloat v_spacing = 10.0f;
    CGFloat leading_spacing = 10.0f;
    CGFloat trailing_spacing = 10.0f;
    CGFloat top_spacing = 10.0f;
    CGFloat bottom_spacing = 10.0f;
    CGFloat cell_img_width = (self.frame.size.width - leading_spacing - trailing_spacing - h_spacing*(maxCellsInRow-1))/maxCellsInRow;
    CGFloat cell_txt_width = cell_img_width;
    CGFloat cell_txt_height = 15.0f;
    CGFloat cell_img_height = (self.frame.size.height - top_spacing - bottom_spacing - v_spacing*(totalRow-1))/maxTotalRow - cell_txt_height;
    
    
    UIImageView *tempImgView;
    UILabel *tempLabel;
    
    for (int i=0;i<totalRow;i++){
        
        totalCells = cellCount >= maxCellsInRow ? maxCellsInRow : cellCount % maxCellsInRow;
        
        for (int j=0; j<totalCells; j++) {
            CGFloat x = leading_spacing + j * (cell_img_width + h_spacing);
            CGFloat y = top_spacing + i * (cell_img_height + cell_txt_height + v_spacing);
            
            //add UIImageView
            tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cell_img_width, cell_img_height)];
            tempImgView.image = [UIImage imageNamed:images[i*maxCellsInRow + j]];
            tempImgView.layer.cornerRadius = tempImgView.frame.size.width/2;
            tempImgView.clipsToBounds = YES;
            
            //set image
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:images[i*maxCellsInRow + j]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
            [tempImgView setImageWithURLRequest:imageRequest
                                                        placeholderImage:[UIImage imageNamed:@"placeHolder.png"]
                                                                 success:nil
                                                                 failure:nil];
            
            //add UILabel
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y + cell_img_height, cell_txt_width, cell_txt_height)];
            tempLabel.text = names[i*maxCellsInRow + j];
            tempLabel.textColor = [UIColor purpleColor];
            [tempLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:tempImgView];
            [self addSubview:tempLabel];
        }
        
        cellCount -= maxCellsInRow;
    }
}

- (void)setupInvisibleButtons:(NSUInteger)cellCount {
    NSUInteger maxCellsInRow = 3;
    NSUInteger totalRow = cellCount < maxCellsInRow ? 1 : 2;
    NSUInteger maxTotalRow = 2;
    NSInteger totalCells;
    CGFloat h_spacing = 15.0f;
    CGFloat v_spacing = 10.0f;
    CGFloat leading_spacing = 10.0f;
    CGFloat trailing_spacing = 10.0f;
    CGFloat top_spacing = 10.0f;
    CGFloat bottom_spacing = 10.0f;
    CGFloat cell_img_width = (self.frame.size.width - leading_spacing - trailing_spacing - h_spacing*(maxCellsInRow-1))/maxCellsInRow;
    CGFloat cell_txt_width = cell_img_width;
    CGFloat cell_txt_height = 15.0f;
    CGFloat cell_img_height = (self.frame.size.height - top_spacing - bottom_spacing - v_spacing*(totalRow-1))/maxTotalRow - cell_txt_height;
    
    for (int i=0;i<totalRow;i++){
        
        totalCells = cellCount >= maxCellsInRow ? maxCellsInRow : cellCount % maxCellsInRow;
        
        for (int j=0; j<totalCells; j++) {
            CGFloat x = leading_spacing + j * (cell_img_width + h_spacing);
            CGFloat y = top_spacing + i * (cell_img_height + cell_txt_height + v_spacing);
            
            CGRect frame = CGRectMake(x, y, cell_img_width, cell_img_height + cell_txt_height);
            [self setupInvisibleButton:frame index:i*maxCellsInRow + j];
        }
    }
    
}

- (void) setupInvisibleButton:(CGRect)frame index:(NSInteger)index {
    UIButton *invisibleButton = [[UIButton alloc] initWithFrame:frame];
    [invisibleButton setBackgroundColor:[UIColor clearColor]];
    
    invisibleButton.tag = index;
    [invisibleButton addTarget:self action:@selector(invisibleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:invisibleButton];
}

//delegate to main view (RotationVC)
- (void) invisibleButtonAction:(UIButton *)sender {
    [self.delegate invisibleButtonAction:sender];
    
    //sender.tag; // index of the touched button
    /*
    NSLog(@"%ld", sender.tag);
    
    NSLog(@"url =====%@", [self.contacts[sender.tag] tumblrUrl]);
    UIWebView *view = [[UIWebView alloc] initWithFrame:self.frame];
    */
    
}

@end
