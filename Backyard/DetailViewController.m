//
//  DetailViewController.m
//  Backyard
//
//  Created by Cheng-Yuan Wu on 7/20/15.
//  Copyright (c) 2015 Kenny Chu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipe;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.downSwipe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didDownSwipe:(UISwipeGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"swipe down");

    
}

@end
