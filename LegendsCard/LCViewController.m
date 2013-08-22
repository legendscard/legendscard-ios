//
//  LCViewController.m
//  LegendsCard
//
//  Created by Josh Sklar on 8/21/13.
//  Copyright (c) 2013 LegendsCard. All rights reserved.
//

#import "LCViewController.h"
#import "UIView+Animation.h"
#import "PerksViewController.h"
#import "FeedViewController.h"
#import "JS7Button.h"

typedef void(^AnimationCompletionBlock)(BOOL finished);

static const NSInteger kFeedButtonTag = 1;
static const NSInteger kPerksButtonTag = 2;

@interface LCViewController ()

@property (strong, nonatomic) UIButton *feedButton, *perksButton;

@property (strong, nonatomic) UIViewController *mainViewController;
@property (strong, nonatomic) UIViewController *backgroundViewController;

@property (strong, nonatomic) PerksViewController *perksViewController;
@property (strong, nonatomic) UINavigationController *perksNavController;

@property (strong, nonatomic) FeedViewController *feedViewController;
@property (strong, nonatomic) UINavigationController *feedNavController;

- (void)setupButtons;
- (void)animateButtonsOffScreen;
- (void)animateButtonsOnScreen;
- (void)createViewControllers;
- (void)formatNavControllers;
- (void)didTapButton:(id)sender;
- (void)updateMainViewController:(UIViewController*)vc;
- (void)resetMainViewController;

@end

@implementation LCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupButtons];
    [self createViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal methods

- (void)setupButtons
{
    static CGFloat buffer = 3;
    
    UIButton *feed = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2 - buffer, self.view.frame.size.height)];
    feed.tag = kFeedButtonTag;
    [feed setBackgroundImage:[UIImage imageNamed:@"feed-pannel"] forState:UIControlStateNormal];
    [self.view addSubview:feed];
    self.feedButton = feed;
    
    UIButton *perks = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 + buffer, 0, self.view.frame.size.width/2 - buffer, self.view.frame.size.height)];
    perks.tag = kPerksButtonTag;
    [perks setBackgroundImage:[UIImage imageNamed:@"perks-pannel"] forState:UIControlStateNormal];
    [self.view addSubview:perks];
    self.perksButton = perks;
    
    [feed addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [perks addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)animateButtonsOffScreen
{
    [self.feedButton move:UIViewMoveDirectionLeft by:self.view.frame.size.width/2 withDuration:0.3 completionBlock:nil];
    [self.perksButton move:UIViewMoveDirectionRight by:self.view.frame.size.width/2 withDuration:0.3 completionBlock:nil];
}

- (void)animateButtonsOnScreen
{
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
        JS7Button *btn = [[JS7Button alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [btn setTitle:@"Back" forState:UIControlStateNormal];
        
        [btn performBlockOnTouchUpInside:^(id sender) {
            [self resetMainViewController];
            [self animateButtonsOnScreen];
        }];
        
        [btn setTextColor:[UIColor whiteColor] highlightedTextColor:[UIColor grayColor]];
        UIBarButtonItem *bbI = [[UIBarButtonItem alloc]initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = bbI;
    }
    
    [self formatNavControllers];
}

- (void)formatNavControllers
{
    for (UINavigationController *navController in @[self.perksNavController, self.feedNavController])
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor], UITextAttributeTextColor,
                                                              [UIColor clearColor], UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(1, 0)], UITextAttributeTextShadowOffset,
                                                              [UIFont fontWithName:@"Helvetica-Light" size:22], UITextAttributeFont,
                                                              nil]];
        
        [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    }
    
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
