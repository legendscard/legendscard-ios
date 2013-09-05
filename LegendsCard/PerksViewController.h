//
//  PerksViewController.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/18/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerksController.h"

@interface PerksViewController : UIViewController <PerksControllerDelgate, UISearchBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) PerksController *pCont;
@property BOOL cameFromHome;

-(void)didRecieveXML:(NSMutableArray*)results;
- (void)fetchData;

@end
