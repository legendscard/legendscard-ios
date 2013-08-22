//
//  UITextField+FigureOutSchool.m
//  LegendsCard
//
//  Created by Josh Sklar on 7/8/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "UITextField+FigureOutSchool.h"

static NSString * const UMICH_KEY = @"1";
static NSString * const IU_KEY = @"2";
static NSString * const STATE_KEY = @"3";

@implementation UITextField (FigureOutSchool)

-(NSString*)figureOutSchool {
    if ([self.text length] != 7) {
        return @"SHAKE!";
    }
    
    if ([[self.text substringToIndex:1] isEqualToString:UMICH_KEY]) {
        return @"umich";
    }
    if ([[self.text substringToIndex:1] isEqualToString:STATE_KEY]) {
        return @"state";
    }
    if ([[self.text substringToIndex:1] isEqualToString:IU_KEY]) {
        return @"iu";
    }
    return @"SHAKE!";
}

@end
