//
//  SinglePerkViewController.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/28/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "SinglePerkViewController.h"
#import "MapViewController.h"
#import "CacheController.h"

@interface SinglePerkViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UILabel *perkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIView *dealBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *perkBackgroundView;
@property (strong, nonatomic) CacheController *cache;
@property (strong, nonatomic) UIActivityIndicatorView *act;

@end

@implementation SinglePerkViewController
@synthesize addressLabel;
@synthesize dealLabel;
@synthesize addressButton;
@synthesize perkLabel;
@synthesize coverPhoto;
@synthesize dealBackgroundView;
@synthesize perkBackgroundView;
@synthesize image;
@synthesize item;
@synthesize cache;
@synthesize act;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)fetchImage {
    NSURL *imgURL = [NSURL URLWithString:[item link2]];
    if ([self.cache localURLForAssetURL:imgURL]) {
        NSData *imgData = [NSData dataWithContentsOfURL:[self.cache localURLForAssetURL:imgURL]];
        [act removeFromSuperview];
        [self.coverPhoto setImage:[UIImage imageWithData:imgData]];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [act removeFromSuperview];
                [self.coverPhoto setImage:[UIImage imageWithData:imgData]];
                [self.cache queueAssetForRetrievalFromURL:imgURL withData:imgData];
            });
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cache = [[CacheController alloc]init];
    
    act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.center = CGPointMake(160, 100);
    [act startAnimating];
    [self.view addSubview:act];
    
    [self fetchImage];
    
    [self.view bringSubviewToFront:addressButton];
    [self.view bringSubviewToFront:addressLabel];
    [self.view bringSubviewToFront:dealBackgroundView];
    [self.view bringSubviewToFront:perkBackgroundView];
    [self.view bringSubviewToFront:perkLabel];
    [self.view bringSubviewToFront:dealLabel];
    
    [dealLabel setAppFont:18];
    [addressLabel setAppFont:20];
    [perkLabel setAppFont:18];
    
    perkLabel.textColor = [UIColor whiteColor];
    [perkLabel setText:[item perk]];
       
    addressLabel.textColor = [UIColor whiteColor];
    addressButton.backgroundColor = [UIColor blackColor];
    addressButton.alpha = 0.77f;    
    addressLabel.text = [NSString stringWithFormat:@"%@ (Touch For Map)",[item address]];

    dealLabel.textColor = [UIColor whiteColor];
    dealBackgroundView.backgroundColor = [UIColor blackColor];
    dealBackgroundView.alpha = 0.55f;
    dealLabel.text = [item deal];
    
    perkBackgroundView.backgroundColor = [UIColor blackColor];
    perkBackgroundView.alpha = 0.33f;
    
    // configure call button, if possible
    if (![[item phoneno] isEqualToString:@"0"]) {
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn setTitle:@"Call" forState:UIControlStateNormal];
        [callBtn setFrame:CGRectMake(self.view.frame.size.width - 80, 0, 80, 40)];
        [callBtn addTarget:self action:@selector(callVenue) forControlEvents:UIControlEventTouchUpInside];
        [callBtn.titleLabel setAppFont:20];
        callBtn.backgroundColor = [UIColor blackColor];
        [callBtn addTarget:self action:@selector(fadeOutCallBtn:) forControlEvents:(UIControlEventTouchDown |
                                                                                    UIControlEventTouchDragEnter)];
        [callBtn addTarget:self action:@selector(fadeInCallBtn:) forControlEvents:(UIControlEventTouchUpInside |
                                                                                   UIControlEventTouchDragExit)];
        callBtn.alpha = 0.77f;
        [self.view addSubview:callBtn];
    }
}

- (void)fadeOutCallBtn:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.alpha = 0.33f;
}

- (void)fadeInCallBtn:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    btn.alpha = 0.77f;
}

-(IBAction)didPressAddress {
    MapViewController *map = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    [map setItem:item];
    [[self navigationController] pushViewController:map animated:YES];
}

- (void)callVenue
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *urlStr = [NSString stringWithFormat:@"tel:%@", [item phoneno]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (void)viewDidUnload
{
    [self setAddressLabel:nil];
    [self setDealLabel:nil];
    [self setCoverPhoto:nil];
    [self setAddressButton:nil];
    [self setDealBackgroundView:nil];
    [self setPerkBackgroundView:nil];
    [self setPerkLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
