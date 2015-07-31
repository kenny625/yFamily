//
//  RotationVC.m
//  RotationTest
//
//  Created by Cheng-Yuan Wu on 7/14/15.
//  Copyright (c) 2015 Kimi. All rights reserved.
//

#import "RotationVC.h"
#import "RotationCell.h"
#import "RotationLayout.h"
#import "FriendsView.h"
#import "DetailViewController.h"
#import "BackyardClient.h"
#import "Employee.h"
#import "InvisibleButtonDelegate.h"
#import <SDWebImage/SDWebImageManager.h>
#import "SettingTableVC.h"
#import "AppDelegate.h"

@interface RotationVC ()  <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, InvisibleButtonDelegate, UISearchBarDelegate>
@property (strong, nonatomic) FriendsView *friendsView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) NSMutableArray *employees;
@property (strong, nonatomic) Employee *focusedEmployee;
@property (strong, nonatomic) UICollectionViewCell *focusedCell;
@property (strong, nonatomic) NSMutableArray *focusedContacts;
@property (strong, nonatomic) IBOutlet UICollectionView *rotationCollectionView;
@property (assign, nonatomic) BOOL isDragging;
@property (assign, nonatomic) CGRect friendsViewFrame;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImageView *bgView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (assign, nonatomic) BOOL doUpdate;
@end

@implementation RotationVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.doUpdate = YES;
    self.isDragging = YES;
    self.title = @"yFamily";
    //setup setting icon
    [self setupSettingIcon];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    self.friendsViewFrame = CGRectMake(0.0f, 400.0f, width, height-380.0f);
    
    
    
    //initial the collecitonView
    self.rotationCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, 400.0f) collectionViewLayout:[[RotationLayout alloc] init]];

    //call api

    

    //add background view
    CGRect bgFrame = CGRectMake(-40, 0, self.rotationCollectionView.frame.size.width+40, self.rotationCollectionView.frame.size.height);
    if (self.bgView != nil) {
        [self.bgView removeFromSuperview];
    }
    self.bgView = [[UIImageView alloc] initWithFrame:bgFrame];

    UIImage *bgImg = [self blurryImage:[UIImage imageNamed:@"Img-Background4.png"] withBlurLevel:10];
    [self.bgView setBackgroundColor:[[UIColor alloc] initWithPatternImage:bgImg]];
    [self.view addSubview:self.bgView];

    [self.rotationCollectionView setBackgroundColor:[UIColor clearColor]];
    // Register cell classes
    [self.rotationCollectionView registerNib:[UINib nibWithNibName:@"RotationCell" bundle:nil] forCellWithReuseIdentifier:@"RotationCell"];
    
    self.rotationCollectionView.delegate = self;
    self.rotationCollectionView.dataSource = self;
    [self.view addSubview:self.rotationCollectionView];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didUpSwipe:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    [panGestureRecognizer requireGestureRecognizerToFail:swipeGestureRecognizer];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.searchBar.showsCancelButton = YES;

}

- (void)setupSettingIcon {
    UIButton *settingButton = [[UIButton alloc] init];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"Icon-Setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onTapSettingButton) forControlEvents:UIControlEventTouchUpInside];
    [settingButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
}

- (void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    if (velocity.y > 50) {
        self.navigationItem.titleView = self.searchBar;
        [self.searchBar becomeFirstResponder];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.navigationItem.titleView = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", searchBar.text);
    self.navigationItem.titleView = nil;
    self.navigationItem.title = searchBar.text;
    [[BackyardClient sharedInstance] queryEmployeesWithName:searchBar.text andCompletion:^(NSArray *employees, NSError *error) {
        //        employees
        for (int i=0; i<[employees count]; i++) {
            self.employees[i] = employees[i];
        }
        self.focusedEmployee = self.employees[0];
        [self shiftEmployeeData];
        [self.rotationCollectionView reloadData];
        
        //init with index 19
        [[BackyardClient sharedInstance] getContactsWithId:[self.employees[19] backyardId] andCompletion:^(NSArray *contacts, NSError *error) {
            //update friends view
            self.focusedContacts = [[NSMutableArray alloc] initWithArray: contacts];
            self.friendsView = [[FriendsView alloc] init:self.friendsViewFrame cellCount:6 contacts:contacts];
            self.friendsView.delegate = self;
            [self.view addSubview:self.friendsView];
            //initial and add maskView in front of friendsView
            self.maskView = [[UIView alloc] initWithFrame:self.friendsViewFrame];
            [self.view addSubview:self.maskView];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    //update count
    if (self.doUpdate) {
        self.doUpdate = YES;
        [[BackyardClient sharedInstance] getEmployeesWithCompletion:^(NSArray *employees, NSError *error) {
            //        employees
            self.employees = [[NSMutableArray alloc] initWithArray:employees];
            [self shiftEmployeeData];
            [self.rotationCollectionView reloadData];
            /*
             [[BackyardClient sharedInstance] getContactsWithId:@"" andCompletion:^(NSArray *contacts, NSError *error) {
             // get contact
             }];
             */
            
            //init with index 19
            [[BackyardClient sharedInstance] getContactsWithId:[self.employees[19] backyardId] andCompletion:^(NSArray *contacts, NSError *error) {
                //update friends view
                self.focusedContacts = [[NSMutableArray alloc] initWithArray: contacts];
                self.friendsView = [[FriendsView alloc] init:self.friendsViewFrame cellCount:6 contacts:contacts];
                self.friendsView.delegate = self;
                [self.view addSubview:self.friendsView];
                //initial and add maskView in front of friendsView
                self.maskView = [[UIView alloc] initWithFrame:self.friendsViewFrame];
                [self.view addSubview:self.maskView];
            }];
        }];
    }
    
    [self updateBrowseCount];
    ((RotationCell *)self.focusedCell).countLabel.text = [NSString stringWithFormat:@"%ld", self.focusedEmployee.browseCount];
}

-(void)updateBrowseCount {

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
     
- (void)addFriendMaskView {
    self.maskView.backgroundColor = [UIColor grayColor];
    self.maskView.alpha = 0.5f;
}
- (void)removeFriendMaskView {
    self.maskView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.employees count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //cell size
    return CGSizeMake(120.0f, 120.0f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell;
    RotationCell *cell;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RotationCell" forIndexPath:indexPath];

    if ([self.employees count] > 0) {
    //setusername
    ((RotationCell *)cell).nameLabel.text = [self.employees[indexPath.row] username];
    //set browse count
    ((RotationCell *)cell).countLabel.text = [NSString stringWithFormat:@"%ld", [self.employees[indexPath.row] browseCount]];

    //set image
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.employees[indexPath.row] profileImgUrl]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [((RotationCell *)cell).profileImage  setImageWithURLRequest:imageRequest
               placeholderImage:[UIImage imageNamed:@"placeHolder.png"]
                        success:nil
                        failure:nil];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    int numCount = [self.collectionView numberOfItemsInSection:0];
    float ITEM_WIDTH = scrollView.frame.size.width;
    int index = (targetX + 0.5 * ITEM_WIDTH)/ITEM_WIDTH - 1;
    
    if (numCount>=3)
    {
        if (targetX < ITEM_WIDTH/2) {
            [scrollView setContentOffset:CGPointMake(targetX+ITEM_WIDTH *numCount, 0)];
        }
        else if (targetX >ITEM_WIDTH/2+ITEM_WIDTH *numCount)
        {
            [scrollView setContentOffset:CGPointMake(targetX-ITEM_WIDTH *numCount, 0)];
        }
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //user only drag, no automatic scrolling created
    if (velocity.x == 0) {
        [self scrollDidStopped:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self addFriendMaskView];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.contentOffset = scrollView.contentOffset;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollDidStopped:scrollView];
}

- (void)scrollDidStopped:(UIScrollView *)scrollView {
    float targetX = scrollView.contentOffset.x;
    float ITEM_WIDTH = scrollView.frame.size.width;
    [self removeFriendMaskView];
    //Move to the center
    int index = (targetX + 0.5 * ITEM_WIDTH)/ITEM_WIDTH - 1;
    index = index % 20;
    if(index == 18) {
        targetX = 0;
        //load next
        [[BackyardClient sharedInstance] getNextEmployeesWithCompletion:^(NSArray *employees, NSError *error) {
            self.employees = [[NSMutableArray alloc] initWithArray:employees];
            [self shiftEmployeeData];
            [self.rotationCollectionView reloadData];
        }];
        
    }
    [scrollView setContentOffset:CGPointMake((index+1) * ITEM_WIDTH, 0)];
    
    NSIndexPath *focusedIndex = [NSIndexPath indexPathForRow:index inSection:0];
    
    self.focusedCell = [self.rotationCollectionView cellForItemAtIndexPath:focusedIndex];
    
    self.focusedEmployee = self.employees[index];
    //for debugging
    NSLog(@"byid = %@",[self.employees[index] backyardId]);


    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *backgroundImageURL = (NSURL *)[NSString stringWithFormat:@"http://build2.adp.corp.tw1.yahoo.com:3000/v1/users/%@/backgroundImage",
     self.focusedEmployee.backyardId];
    [manager downloadImageWithURL:backgroundImageURL
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                               
                                  self.backgroundImage = [self blurryImage:image withBlurLevel:2];
                                
                          
                                    [self.bgView setImage:self.backgroundImage];
                                   self.bgView.contentMode = UIViewContentModeScaleAspectFill;
                        
                                self.bgView.clipsToBounds = YES;
                                
                                CATransition *transition = [CATransition animation];
                                transition.duration = 0.5f;
                                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                transition.type = kCATransitionFade;
                                
                                [self.bgView.layer addAnimation:transition forKey:nil];
                            }
                        }];
    
    //call api for contact
    [[BackyardClient sharedInstance] getContactsWithId:[self.employees[index] backyardId] andCompletion:^(NSArray *contacts, NSError *error) {
        //update friends view
        [self.friendsView removeFromSuperview];
        self.focusedContacts = [[NSMutableArray alloc] initWithArray: contacts];

        self.friendsView = [[FriendsView alloc] init:self.friendsViewFrame cellCount:6 contacts:contacts];
        if (self.backgroundImage) {
            [self.friendsView setBackgroundColor:[[UIColor alloc] initWithPatternImage:self.backgroundImage]];
        }
        self.friendsView.delegate = self;
        [self.view addSubview:self.friendsView];
    }];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (IBAction)didUpSwipe:(UISwipeGestureRecognizer *)sender {
    //add 1 to the browse count
    self.focusedEmployee.browseCount++;
    self.doUpdate = NO;
    [[BackyardClient sharedInstance] postInterestedWithBackyardId:self.focusedEmployee.backyardId completion:^(id response, NSError *error) {
        NSLog(@"%@", response);
    }];
    
    //present detail view
    NSString *urlStr = [self.focusedEmployee tumblrUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    //for debugging
    NSLog(@"url========%@", urlStr);
    if ([urlStr length] > 17) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [webView loadRequest:request];
        UIViewController *webViewController = [[UIViewController alloc] init];
        [webViewController.view addSubview:webView];

        //custom animation from bottom to top
        CATransition *transition = [CATransition animation];
        transition.duration = 0.8f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal; // kCATransitionFade, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        
        //custom animation for presentVC
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma mark - InvisibleButtonDelegate
- (void) invisibleButtonAction:(UIButton *)sender {
    //sender.tag; // index of the touched button
    self.doUpdate = NO;
    NSString *urlStr = [self.focusedContacts[sender.tag] tumblrUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([urlStr length] > 17) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [webView loadRequest:request];
        UIViewController *webViewController = [[UIViewController alloc] init];
        [webViewController.view addSubview:webView];
        
        //custom animation from bottom to top
        CATransition *transition = [CATransition animation];
        transition.duration = 0.8f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; // kCATransitionFade, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom

        //custom animation for presentVC
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (void) shiftEmployeeData {
    
    if (self.employees.count >0) {
        Employee *tempEmployee = self.employees[0];
        for (int i=0; i<self.employees.count-1; i++) {
            [self.employees replaceObjectAtIndex:i withObject:self.employees[i+1]];
        }
        [self.employees replaceObjectAtIndex:self.employees.count-1 withObject:tempEmployee];
    }
}

- (void) onTapSettingButton {
    SettingTableVC *settingView = [[SettingTableVC alloc] init];
    [self.navigationController pushViewController:settingView animated:YES];
}


@end
