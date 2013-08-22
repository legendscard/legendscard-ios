//
//  User.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/18/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name, uID, school, photo, email, legendsNumber, twitterAddition;

+(id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc]init];
    }
    return sharedInstance;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Name: %@\n, uID: %@\n, school: %@\n, photo: %@\n, email: %@\n, legendsNumber: %@\n, twitterAddition: %@\n", self.name, self.uID, self.school, self.photo, self.email, self.legendsNumber, self.twitterAddition];
}

@end
