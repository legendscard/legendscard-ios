//
//  LCHomeViewController.m
//  LegendsCard
//
//  Created by Josh Sklar on 8/21/13.
//  Copyright (c) 2013 LegendsCard. All rights reserved.
//

#import "LCHomeViewController.h"
#import "UIView+Animation.h"
#import "PerksViewController.h"
#import "FeedViewController.h"
#import "JS7Button.h"
#import "LCChooseSchoolViewController.h"
#import "User.h"
#import "UIFont+LCFont.h"

#define IS_IPHONE_5 [UIScreen mainScreen].bounds.size.height == 568.0f

typedef void(^AnimationCompletionBlock)(BOOL finished);

static const NSInteger kFeedButtonTag = 1;
static const NSInteger kPerksButtonTag = 2;

@interface LCHomeViewController ()

@property (strong, nonatomic) UIButton *feedButton, *perksButton;

@property (strong, nonatomic) UIViewController *mainViewController;
@property (strong, nonatomic) UIViewController *backgroundViewController;

@property (strong, nonatomic) PerksViewController *perksViewController;
@property (strong, nonatomic) UINavigationController *perksNavController;

@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) UINavigationController *feedNavController;

@property (strong, nonatomic) LCChooseSchoolViewController *chooseSchoolVC;
@property (strong, nonatomic) JS7Button *chooseSchoolButton;

- (void)setupButtons;
- (void)animateButtonsOffScreen;
- (void)animateButtonsOnScreen;
- (void)createViewControllers;
- (void)createChooseSchoolButton;
- (void)formatNavControllers;
- (void)didTapButton:(id)sender;
- (void)updateMainViewController:(UIViewController*)vc;
- (void)resetMainViewController;

@end

@implementation LCHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    self.chooseSchoolVC = [[LCChooseSchoolViewController alloc]init];
    
//    __weak typeof(self) weakSelf = self;
//    [self.chooseSchoolVC setBlock:^{
//        [weakSelf.feedViewController fetchData];
//        [weakSelf.perksViewController fetchData];
//    }];
    
    [self setupButtons];
    [self createViewControllers];
//    [self createChooseSchoolButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // determine if the school code is stored yet
    NSString *schoolCode = [[NSUserDefaults standardUserDefaults] valueForKey:kNSUDSchoolCodeKey];
    if (!schoolCode) {
        [self presentViewController:self.chooseSchoolVC animated:NO completion:nil];
    }
    else {
        [[User sharedInstance] setSchool:schoolCode];
    }
}

#pragma mark - Internal methods

- (void)setupButtons
{
    static CGFloat buffer = 3;
    
    UIButton *feed = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - buffer, self.view.frame.size.height)];
    feed.tag = kFeedButtonTag;
    
    if (IS_IPHONE_5)
        [feed setBackgroundImage:[UIImage imageNamed:@"feed-pannel-i5"] forState:UIControlStateNormal];
    else
        [feed setBackgroundImage:[UIImage imageNamed:@"feed-pannel-i4"] forState:UIControlStateNormal];
    
    [self.view addSubview:feed];
    // add the label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, feed.frame.size.width, 200)];
    [label setText:@"FEED"];
    [feed addSubview:label];
    self.feedButton = feed;
    
    UIButton *perks = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 + buffer, 0, self.view.frame.size.width/2 - buffer, self.view.frame.size.height)];
    perks.tag = kPerksButtonTag;
    
    if (IS_IPHONE_5)
        [perks setBackgroundImage:[UIImage imageNamed:@"perks-pannel-i5"] forState:UIControlStateNormal];
    else
        [perks setBackgroundImage:[UIImage imageNamed:@"perks-pannel-i4"] forState:UIControlStateNormal];
    
    [self.view addSubview:perks];
    // add label
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, perks.frame.size.height - 20 - 200, perks.frame.size.width, 200)];
    [label2 setText:@"PERKS"];
    [perks addSubview:label2];
    self.perksButton = perks;
    
    for (UILabel *l in @[label, label2]) {
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor clearColor]];
        [l setTextColor:[UIColor whiteColor]];
        [l setFont:[UIFont fontWithName:@"Cubano-Regular" size:30]];
    }
    
    [feed addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [perks addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)animateButtonsOffScreen
{
    [self.chooseSchoolButton partialFadeWithDuration:0.3 afterDelay:0. withFinalAlpha:0. completionBlock:nil];
    [self.feedButton move:UIViewMoveDirectionLeft by:self.view.frame.size.width/2 withDuration:0.3 completionBlock:nil];
    [self.perksButton move:UIViewMoveDirectionRight by:self.view.frame.size.width/2 withDuration:0.3 completionBlock:nil];
}

- (void)animateButtonsOnScreen
{
    [self.chooseSchoolButton partialFadeWithDuration:0.3 afterDelay:0. withFinalAlpha:.7 completionBlock:nil];
    [self.feedButton move:UIViewMoveDirectionRight by:self.view.frame.size.width/2 withDuration:0.3 completionBlock:nil];
    [self.perksButton move:UIViewMoveDirectionLeft by:self.view.frame.size.width/2 withDuration:0.3 completionBlock:nil];
}

- (void)createViewControllers
{
    self.backgroundViewController = [[UIViewController alloc]init];
    self.backgroundViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.mainViewController = self.backgroundViewController;
    self.mainViewController.view.frame = self.view.bounds;
    [self resetMainViewController];
    
    self.perksViewController = [[PerksViewController alloc]init];
    [self.perksViewController setCameFromHome:YES];
    self.perksNavController = [[UINavigationController alloc]initWithRootViewController:self.perksViewController];
    
    self.feedViewController = [[FeedViewController alloc]init];
    self.feedNavController = [[UINavigationController alloc]initWithRootViewController:self.feedViewController];
    
    for (UIViewController *viewController in @[self.perksViewController, self.feedViewController]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Back"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(didTapBackButtonOnNavigationBar:)];

        viewController.navigationItem.leftBarButtonItem = backButton;
    }
    
    [self formatNavControllers];
}

- (void)createChooseSchoolButton
{
    static CGFloat btnHeight = 40., btnWidth = 100.;
    self.chooseSchoolButton = [[JS7Button alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - btnHeight, btnWidth, btnHeight)];
    [self.chooseSchoolButton setTitle:@"Choose School"];
    [self.chooseSchoolButton setBackgroundColor:[UIColor colorWithWhite:0. alpha:0.7]];
    [self.chooseSchoolButton.titleLabel setFont:[UIFont fontWithName:@"Cubano-Regular" size:13]];
    [self.chooseSchoolButton performBlockOnTouchUpInside:^(id sender) {
        [self presentViewController:self.chooseSchoolVC animated:YES completion:nil];
    }];
    
    [self.view addSubview:self.chooseSchoolButton];
}

- (void)formatNavControllers
{
    for (UINavigationController *navController in @[self.perksNavController, self.feedNavController]) {
        navController.navigationBar.barTintColor = [UIColor lightGrayColor];
        navController.navigationBar.translucent = NO;
        navController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)didTapBackButtonOnNavigationBar:(id)sender
{
    [self resetMainViewController];
    [self animateButtonsOnScreen];
}

- (void)didTapButton:(id)sender
{
    UIButton *b = (UIButton*)sender;
    switch (b.tag) {
        case kFeedButtonTag:
            [self updateMainViewController:self.feedNavController];
            break;
        case kPerksButtonTag:
            [self updateMainViewController:self.perksNavController];
            break;
        default:
            break;
    }
    [self animateButtonsOffScreen];
}

- (void)updateMainViewController:(UIViewController*)vc
{
    CGRect oldFrame = self.mainViewController.view.frame;
    [self.mainViewController.view removeFromSuperview];
    self.mainViewController = vc;
    self.mainViewController.view.frame = oldFrame;
    [self.view addSubview:self.mainViewController.view];
    [self.view sendSubviewToBack:self.mainViewController.view];
}

- (void)resetMainViewController
{
    [self updateMainViewController:self.backgroundViewController];
}

@end
