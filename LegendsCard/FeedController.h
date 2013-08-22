//
//  FeedController.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/21/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedPost.h"

@protocol FeedControllerDelegate <NSObject>

@optional
-(void)didRecieveAllTweets:(NSArray*)results;
-(void)didRecieveAllUsersPosts:(NSArray*)results;
-(void)showTheHud;
-(void)displayErrorMessage;
-(void)informUserAboutSwitch;

@end

@interface FeedController : NSObject{
    NSMutableArray *timeStamp;
    NSMutableData *responseData;
    NSMutableArray *jsonResponse;
}

@property (weak, nonatomic) id <FeedControllerDelegate> delegate;

/* public methods called by FeedViewController */
/* fetches all of the user's posts as well as the tweets containing the certain string */
-(void)fetchAllPosts;
-(NSArray*)mergeTwitterAndUsersPosts:(NSArray*)tweets;

@end
