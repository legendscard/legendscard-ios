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

typedef void(^AnimationCompletionBlock)(BOOL finished);

static const NSInteger kFeedButtonTag = 1;
static const NSInteger kPerksButtonTag = 2;

@interface LCViewController ()

@property (strong, nonatomic) UIButton *feedButton, *perksButton;

@property (strong, nonatomic) UIViewController *mainViewController;

@property (strong, nonatomic) PerksViewController *perksViewController;
@property (strong, nonatomic) UINavigationController *perksNavController;

- (void)setupButtons;
- (void)animateButtonsOffScreen;
- (void)animateButtonsOnScreen;
- (void)createViewControllers;
- (void)didTapButton:(id)sender;

@end

@implementation LCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupButtons];
    [self createViewControllers];
	// Do any additional setup after loading the view, typically from a nib.
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
    
}

- (void)createViewControllers
{
    self.mainViewController = [[UIViewController alloc]init];
    self.mainViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.mainViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.mainViewController.view];
    [self.view sendSubviewToBack:self.mainViewController.view];
    
    self.perksViewController = [[PerksViewController alloc]init];
    [self.perksViewController setCameFromHome:YES];
    self.perksNavController = [[UINavigationController alloc]initWithRootViewController:self.perksViewController];
}

- (void)didTapButton:(id)sender
{
    UIButton *b = (UIButton*)sender;
    switch (b.tag) {
        case kFeedButtonTag:
            //show the feed view controller
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

@end
