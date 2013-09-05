//
//  LCChooseSchoolViewController.h
//  LegendsCard
//
//  Created by Josh Sklar on 9/4/13.
//  Copyright (c) 2013 LegendsCard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissViewControllerCompletionBlock)();

@interface LCChooseSchoolViewController : UIViewController

@property (strong) DismissViewControllerCompletionBlock block;

@end
