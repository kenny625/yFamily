//
//  SettingTableVC.m
//  Backyard
//
//  Created by Cheng-Yuan Wu on 7/30/15.
//  Copyright (c) 2015 Kenny Chu. All rights reserved.
//

#import "SettingTableVC.h"
#import "SettingTableCell.h"
#import "AppDelegate.h"

@interface SettingTableVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *settingOptions;
@end

@implementation SettingTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Locale";
    //init setting options
    self.settingOptions = [[NSMutableArray alloc] initWithObjects:@"Taiwan", @"US", @"All", nil];
    UIImage *bgImage = [self blurryImage:[UIImage imageNamed:@"Img-Background11.png"] withBlurLevel:2];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:bgImage]];
    self.tableView.delegate = self;
    UINib *settingCellNib = [UINib nibWithNibName:@"SettingTableCell" bundle:nil];
    [self.tableView registerNib:settingCellNib forCellReuseIdentifier:@"SettingTableCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settingOptions count] > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    ((SettingTableCell *)cell).cellTitle.text = self.settingOptions[indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO

    switch (indexPath.row) {
        case 0: //TW
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).localeKey = @"TW";
            break;
        case 1: //US
            break;
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).localeKey = @"US";
        case 2: //ALL
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).localeKey = @"";
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
