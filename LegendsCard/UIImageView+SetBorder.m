//
//  UIImageView+SetBorder.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/29/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "UIImageView+SetBorder.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (SetBorder)

-(void)setBorder {
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 4.0f;
    //self.clipsToBounds = YES;
}

@end
