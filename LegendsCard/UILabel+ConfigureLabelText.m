//
//  UILabel+ConfigurePerkLabel.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/29/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "UILabel+ConfigureLabelText.h"

@implementation UILabel (ConfigureLabelText)

-(void)configurePerkLabel {
    self.backgroundColor = [UIColor clearColor];
    self.numberOfLines = 2;
    self.lineBreakMode = NSLineBreakByWordWrapping;;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.minimumFontSize = 2;
    if ([self.text length] >= 20) {
        self.font = [UIFont fontWithName:@"GillSans" size:10.0f];
    }
    else {
        self.font = [UIFont fontWithName:@"GillSans" size:13.0f];
    }
    self.numberOfLines = 2;
}

-(void)setAppFont:(NSInteger)size {
    self.font = [UIFont fontWithName:@"GillSans" size:size];
}

-(void)setAppFontBold:(NSInteger)size {
    self.font = [UIFont fontWithName:@"GillSans-Bold" size:size];
}

-(void)setAppFontLight:(NSInteger)size {
    self.font = [UIFont fontWithName:@"GillSans-Light" size:size];
}
@end
