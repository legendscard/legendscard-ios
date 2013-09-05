//
//  LCChooseSchoolViewController.m
//  LegendsCard
//
//  Created by Josh Sklar on 9/4/13.
//  Copyright (c) 2013 LegendsCard. All rights reserved.
//

#import "LCChooseSchoolViewController.h"
#import "User.h"

@implementation UIView (Positioning)

- (CGFloat)getPositionOfBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

@end

@implementation LCChooseSchoolViewController

- (id)init
{
    if (self = [super init]) {
        self.block = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [self setupView];
}

- (void)setupView
{
    UILabel *cs = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    [cs setTextAlignment:NSTextAlignmentCenter];
    [cs setBackgroundColor:[UIColor clearColor]];
    [cs setTextColor:[UIColor colorWithRed:91./255. green:91./255. blue:91./255. alpha:1.]];
    [cs setFont:[UIFont fontWithName:@"Cubano-Regular" size:35]];
    [cs setText:@"Choose School"];
    [self.view addSubview:cs];
    
    static CGFloat btnSize = 100.;
    CGFloat buffer = 40.;
    
    if ([UIScreen mainScreen].bounds.size.height == 480.) // iPhone 4
        buffer = 20.;
    
    CGFloat originX = self.view.frame.size.width/2. - btnSize/2.;
    
    UIButton *mich = [[UIButton alloc]initWithFrame:CGRectMake(originX, [cs getPositionOfBottom] + buffer, btnSize, btnSize)];
    [mich setTag:0];
    [mich setBackgroundImage:[UIImage imageNamed:@"block-m"] forState:UIControlStateNormal];
    
    UIButton *claremont = [[UIButton alloc]initWithFrame:CGRectMake(originX, [mich getPositionOfBottom] + buffer, btnSize, btnSize)];
    [claremont setTag:1];
    [claremont setBackgroundImage:[UIImage imageNamed:@"claremont"] forState:UIControlStateNormal];
    
    UIButton *iu = [[UIButton alloc]initWithFrame:CGRectMake(originX, [claremont getPositionOfBottom] + buffer, btnSize, btnSize)];
    [iu setTag:2];
    [iu setBackgroundImage:[UIImage imageNamed:@"IU-logo"] forState:UIControlStateNormal];
    
    for (UIButton *b in @[mich, claremont, iu]) {
        [b addTarget:self action:@selector(didTapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
    }
}

- (void)didTapBtn:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    NSString *schoolCode;
    switch (tag) {
        case 0:
            schoolCode = @"umich";
            break;
        case 1:
            schoolCode = @"state";
            break;
        case 2:
            schoolCode = @"iu";
            break;
        default:
            break;
    }
    
    [[User sharedInstance] setSchool:schoolCode];
    
    [[NSUserDefaults standardUserDefaults] setValue:schoolCode forKey:kNSUDSchoolCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:self.block];
}

@end
