//
//  FeedViewController.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/21/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedController.h"

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FeedControllerDelegate>
{}

- (void)showTheHud;
- (void)fetchData;

/* a reference to the FeedController so that the home view controller can begin the loading process early */
@property (strong, nonatomic) FeedController *feedCont;
@property BOOL didReceiveFirstDataSet;

@end
