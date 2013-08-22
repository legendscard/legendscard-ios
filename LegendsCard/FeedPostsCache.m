//
//  FeedPostsCache.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/26/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "FeedPostsCache.h"

@implementation FeedPostsCache
@synthesize array;

+(id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc]init];
    }
    return sharedInstance;
}
    

@end
