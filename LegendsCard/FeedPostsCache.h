//
//  FeedPostsCache.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/26/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedPostsCache : NSObject

@property (strong, nonatomic) NSArray *array;

+(id)sharedInstance;

@end
