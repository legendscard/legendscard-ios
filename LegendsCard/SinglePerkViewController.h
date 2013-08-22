//
//  SinglePerkViewController.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/28/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSItem.h"
#import "RSSChannel.h"

@interface SinglePerkViewController : UIViewController {
    RSSItem *item;
}

@property (strong, nonatomic) RSSItem *item;
@property (strong, nonatomic) UIImage *image;

@end
