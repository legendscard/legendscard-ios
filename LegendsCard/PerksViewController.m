//
//  PerksViewController.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/18/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "PerksViewController.h"
#import "SinglePerkViewController.h"
#import "MapAllViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+SetBorder.h"
#import "UILabel+ConfigureLabelText.h"
#import "UIView+Animation.h"
#import "CacheController.h"
#import "JS7Button.h"
#import "SVProgressHUD.h"

#define BUFFER_ZONE 16
#define SQUARE_SIZE 86
#define SEARCH_BAR_BUFFER 5

#define EAT_TYPE @"1"
#define SHOP_TYPE @"2"
#define LIVE_TYPE @"3"

#define ESL_BUTTON_WIDTH 73
#define ESL_BUTTON_HEIGHT 29
#define BACKGROUND_GREY_COLOR [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0f]
#define ESL_BUTTON_BUFFER_HEIGHT 5

@interface PerksViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *ALLPERKS;
@property (strong, nonatomic) NSArray *viewablePerks;
@property (strong, nonatomic) NSMutableArray *filteredALLPERKS;
@property (strong, nonatomic) UISearchBar *mySearchBar;
@property (strong, nonatomic) UIActivityIndicatorView *act2;
@property (strong, nonatomic) CacheController *assets;
@property (strong, nonatomic) UIView *myView;
@property (strong, nonatomic) NSMutableArray *ESLButtons;

@property (strong, nonatomic) NSString *documentsDirectory;

@property NSInteger previousButtonPressed;

@end

@implementation PerksViewController
@synthesize scrollView, pCont;
@synthesize ALLPERKS;
@synthesize filteredALLPERKS;
@synthesize mySearchBar;
@synthesize act2;
@synthesize assets, myView;
@synthesize cameFromHome;
@synthesize documentsDirectory;
@synthesize viewablePerks;
@synthesize ESLButtons;
@synthesize previousButtonPressed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Perks";
        // Custom initialization
    }
    return self;
}


//caching assumes photos never change

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.previousButtonPressed = 0;
    
    self.view.backgroundColor = BACKGROUND_GREY_COLOR;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];

    //Show the hud
    
    [SVProgressHUD showWithStatus:@"Loading Perks" maskType:SVProgressHUDMaskTypeGradient];
    
    self.assets = [[CacheController alloc]init];
    self.ESLButtons = [[NSMutableArray alloc]initWithCapacity:4];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.cameFromHome) {
        [self setUpView];
        [self setUpEatShopLiveButtons];
    }
    
    self.cameFromHome = NO;
    
    [act2 removeFromSuperview];
    
    for (UIView *subView in [scrollView subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.alpha = 1.0f;
        }
    }
}

- (void)setUpEatShopLiveButtons
{
    NSInteger bufferSpace = self.view.frame.size.width - (ESL_BUTTON_WIDTH * 4);
    bufferSpace = bufferSpace / 5;
    
    
    UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
    [all setImage:[UIImage imageNamed:@"all-unpressed"] forState:UIControlStateHighlighted];
    [all setImage:[UIImage imageNamed:@"all-pressed"] forState:UIControlStateNormal];
    [all setHighlighted:YES];
    all.frame = CGRectMake(bufferSpace, ESL_BUTTON_BUFFER_HEIGHT, ESL_BUTTON_WIDTH, ESL_BUTTON_HEIGHT);
    all.tag = 0;
    [all addTarget:self action:@selector(eatShopLivePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:all];
    
    UIButton *eat = [UIButton buttonWithType:UIButtonTypeCustom];
    [eat setImage:[UIImage imageNamed:@"eat-unpressed"] forState:UIControlStateHighlighted];
    [eat setImage:[UIImage imageNamed:@"eat-pressed"] forState:UIControlStateNormal];
    eat.frame = CGRectMake(bufferSpace*2+ESL_BUTTON_WIDTH, ESL_BUTTON_BUFFER_HEIGHT, ESL_BUTTON_WIDTH, ESL_BUTTON_HEIGHT);
    eat.tag = 1;
    [eat addTarget:self action:@selector(eatShopLivePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eat];
    
    UIButton *shop = [UIButton buttonWithType:UIButtonTypeCustom];
    [shop setImage:[UIImage imageNamed:@"shop-unpressed"] forState:UIControlStateHighlighted];
    [shop setImage:[UIImage imageNamed:@"shop-pressed"] forState:UIControlStateNormal];
    shop.frame = CGRectMake(bufferSpace*3+ESL_BUTTON_WIDTH*2, ESL_BUTTON_BUFFER_HEIGHT, ESL_BUTTON_WIDTH, ESL_BUTTON_HEIGHT);
    shop.tag = 2;
    [shop addTarget:self action:@selector(eatShopLivePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shop];
    
    UIButton *live = [UIButton buttonWithType:UIButtonTypeCustom];
    [live setImage:[UIImage imageNamed:@"live-unpressed"] forState:UIControlStateHighlighted];
    [live setImage:[UIImage imageNamed:@"live-pressed"] forState:UIControlStateNormal];
    live.frame = CGRectMake(bufferSpace*4+ESL_BUTTON_WIDTH*3, ESL_BUTTON_BUFFER_HEIGHT, ESL_BUTTON_WIDTH, ESL_BUTTON_HEIGHT);
    live.tag = 3;
    [live addTarget:self action:@selector(eatShopLivePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:live];
    
    [self.ESLButtons addObject:all];
    [self.ESLButtons addObject:eat];
    [self.ESLButtons addObject:shop];
    [self.ESLButtons addObject:live];
}

- (void)eatShopLivePressed:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == self.previousButtonPressed) {
        return;
    }
    
    [self showHighlightedImage:button withString:@"unpressed"];
    
    if (button.tag == 0) {
        self.viewablePerks = ALLPERKS;
    }
    else if (button.tag == 1) {
        self.viewablePerks = [self getPerksFor:EAT_TYPE];
    }
    else if (button.tag == 2) {
        self.viewablePerks = [self getPerksFor:SHOP_TYPE];
    }
    else if (button.tag == 3) {
        self.viewablePerks = [self getPerksFor:LIVE_TYPE];
    }
    
    self.previousButtonPressed = button.tag;
    
    [self makeAllESLUnselectedBut:button.tag];
    [self setUpScrollView:self.viewablePerks];
     
}

- (void)showHighlightedImage:(UIButton*)button withString:(NSString*)str
{
    if (button.tag == 0) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"all-%@",str]] forState:UIControlStateNormal];
    }
    else if (button.tag == [EAT_TYPE integerValue]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"eat-%@",str]] forState:UIControlStateNormal];
    }
    else if (button.tag == [SHOP_TYPE integerValue]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shop-%@",str]] forState:UIControlStateNormal];
    }
    else if (button.tag == [LIVE_TYPE integerValue]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"live-%@",str]] forState:UIControlStateNormal];
    }
}

- (void)makeAllESLUnselectedBut:(int)tag
{
    for (UIButton *button in self.ESLButtons) {
        [button setHighlighted:NO];
        if (button.tag != tag) {
            [self showHighlightedImage:button withString:@"pressed"];
        }
    }
}

- (NSArray*)getPerksFor:(NSString*)str
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (RSSItem *item in ALLPERKS) {
        if ([[item storeType] isEqualToString:str]) {
            [tempArray addObject:item];
        }
    }
    
    return (NSArray*)tempArray;
}

-(void)setUpView {
    [self fetchData];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Map"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(mapAll)];
    
    self.navigationItem.rightBarButtonItem = mapButton;
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0 + SEARCH_BAR_BUFFER, 320, 40)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"Search #perks";
    mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)fetchData
{
    for (UIView *v in [self.view subviews]) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            for (UIView *b in [v subviews]) {
                if ([b isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton*)b;
                    if ([btn.titleLabel.text isEqualToString:@"perk"]) {
                        [btn removeFromSuperview];
                        __strong UIButton *strongBtn = btn;
                        strongBtn = nil;
                    }
                }

            }
        }
    }
    pCont = [[PerksController alloc]init];
    pCont.delegate = self;
    [pCont fetchEntries];
}


-(void)didRecieveXML:(NSMutableArray*)results {
    [SVProgressHUD dismiss];
    NSLog(@"Recieved xml");
    ALLPERKS = results;
    
    [self setUpScrollView:results];
}

- (void)setUpScrollView:(NSArray*)results
{
    self.viewablePerks = results;
    double totalPerks = (double)[results count];
    NSInteger ROWS = ceil(totalPerks / 3.0);
    
    CGFloat lengthOfScrollView = ROWS * (BUFFER_ZONE + SQUARE_SIZE) + mySearchBar.frame.size.height;
    
    CGFloat totalESLDifference = ESL_BUTTON_HEIGHT + ESL_BUTTON_BUFFER_HEIGHT * 2;
    CGFloat heightOfScrollView = self.view.frame.size.height - totalESLDifference;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, totalESLDifference, self.view.frame.size.width, heightOfScrollView)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, lengthOfScrollView);
    
    scrollView.backgroundColor = BACKGROUND_GREY_COLOR;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [self.scrollView addSubview:mySearchBar];
    
    [self setUpButtons:results];
}

-(void)setUpButtons:(NSArray*)allPerks {
    NSInteger totalPerks = [allPerks count];
    
    NSInteger ROWS = totalPerks / 3 + 1;
    NSInteger COLS = 3;
    NSInteger BASE = 1;
    
    NSInteger defaultXpos = BUFFER_ZONE;
    NSInteger defaultYpos = BUFFER_ZONE + mySearchBar.frame.size.height;
    
    for (NSInteger row = 0; row < ROWS; row++) {
        for (NSInteger col = 0; col < COLS; col++) {
            if (BASE + row * COLS + col - 1 < [allPerks count]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.text = @"perk";
                [button.titleLabel setHidden:YES];
                button.layer.borderColor = [UIColor blackColor].CGColor;
                button.layer.borderWidth = 1.0f;
                button.frame = CGRectMake(defaultXpos, defaultYpos, SQUARE_SIZE, SQUARE_SIZE);
                button.tag = BASE + row * COLS + col;
               
                UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [act startAnimating];
                act.center = CGPointMake(SQUARE_SIZE/2, SQUARE_SIZE/2);
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SQUARE_SIZE/2, SQUARE_SIZE, SQUARE_SIZE/2 - 1)];
                titleLabel.text = [[allPerks objectAtIndex:button.tag-1] title];
                [titleLabel configurePerkLabel];
                [titleLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.55f]];
                titleLabel.textColor = [UIColor whiteColor];
                [button addSubview:titleLabel];
                [button addSubview:act];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^ {
                    
                    NSString *url = [[allPerks objectAtIndex:button.tag-1] link];
                    
                    __block NSString *titleString = [[allPerks objectAtIndex:button.tag-1]title];
                    
                    if ([self imageExistsAtPath:titleString]) {
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            UIImage *image = nil;
                            image = [self loadImage:titleString];
                            [act removeFromSuperview];
                            [button setBackgroundImage:image forState:UIControlStateNormal];
                        });
                    }
                    
                    else {                        
                        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

                        if (imgData == nil) {
                            dispatch_async(dispatch_get_main_queue(), ^ {
                                [act removeFromSuperview];
                                UIImage *image = [UIImage imageNamed:@"LC-logo"];
                                [button setBackgroundImage:image forState:UIControlStateNormal];
                            });
                        }
                        
                        else {
                            [self saveImage:imgData :[[allPerks objectAtIndex:button.tag-1]title]];
                            dispatch_async(dispatch_get_main_queue(), ^ {
                                [act removeFromSuperview];
                                UIImage *image = [[UIImage alloc]initWithData:imgData];
                                [button setBackgroundImage:image forState:UIControlStateNormal];
                            });
                        }
                    }
                });

                
                [self.scrollView addSubview:button];
                [button addTarget:self action:@selector(didPushButton:) forControlEvents:UIControlEventTouchUpInside];

                                
                defaultXpos += 100;
                if (defaultXpos > 320) {
                    col = COLS;
                }
            }
        }
        defaultXpos = BUFFER_ZONE;
        defaultYpos += 100;
    }
}

-(void)didPushButton:(id)sender {
    UIButton *btn = (UIButton*)sender;
    
    [Flurry logEvent:@"user-looked-at-perk-from-PerksViewController"];
    SinglePerkViewController *perk = [[SinglePerkViewController alloc]init];
    perk.item = [self.viewablePerks objectAtIndex:btn.tag-1];
    perk.title = [[self.viewablePerks objectAtIndex:btn.tag-1] title];
    perk.image = [btn backgroundImageForState:UIControlStateNormal];
    
    [self.navigationController pushViewController:perk animated:YES];
}

-(void)mapAll {
    User *user = [User sharedInstance];
    MapAllViewController *viewAllStoresController = [[MapAllViewController alloc] init];
    viewAllStoresController.school = user.school;
    [[self navigationController] pushViewController:viewAllStoresController animated:YES];
}

#pragma mark - SearchBar Delegate methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText == nil || [searchText length] == 0) {
        for (UIView *subView in [scrollView subviews]) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *newBtn = (UIButton*)subView;
                [newBtn partialFadeWithDuration:0.2 afterDelay:0 withFinalAlpha:1.0 completionBlock:^(BOOL finished){}];
            }
        }
        return;
    }
    
    for (UIView *subView in [scrollView subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *newBtn = (UIButton*)subView;
            NSRange searchRange = [[[self.viewablePerks objectAtIndex:newBtn.tag-1] title] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (searchRange.length > 0) {
                [newBtn partialFadeWithDuration:0.2 afterDelay:0 withFinalAlpha:1.0 completionBlock:^(BOOL finished){}];
            }
            else {
                [newBtn partialFadeWithDuration:0.2 afterDelay:0 withFinalAlpha:0.25 completionBlock:^(BOOL finished){}];
            }
        }
    }    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Done clicked: %@",searchBar.text);
    [self.mySearchBar resignFirstResponder];

}

#pragma mark - ScrollView delgate methods


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.mySearchBar resignFirstResponder];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Caching methods

- (void)saveImage:(NSData*)imageData :(NSString*)imageName {
    
    //NSLog(@"Saving %i bytes to cache", imageData.length);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    //NSLog(@"----  writing to %@",fullPath);
    //NSLog(@"image saved");
    
}

- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
            
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", fileName]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    //NSLog(@"image removed");
    
}

- (BOOL)imageExistsAtPath:(NSString*)imagePath
{
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imagePath]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    return [fileManager fileExistsAtPath:fullPath];
}

- (UIImage*)loadImage:(NSString*)imageName {
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    //NSLog(@"******   Tryign to fetch %@",fullPath);
    return [UIImage imageWithContentsOfFile:fullPath];
    
}

@end
