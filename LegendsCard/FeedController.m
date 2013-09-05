//
//  FeedController.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/21/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "FeedController.h"
#import <Parse/Parse.h>
#import <Twitter/Twitter.h> 
#import <Accounts/Accounts.h>

#define MAXTWEETSPERACCOUNT 5
#define FB_FRIENDS_ARRAY_KEY @"fbFriendsArrayKey"

@interface FeedController()

/* fetching methods */
- (void)getUserPostsFromDateComponents:(NSDateComponents*)comps withDateFilter:(BOOL)filterDate;
- (void)getTweetsWithMention;

/* NSURLConnectionDelegate methods */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

/* helper methods */
- (BOOL)isAFriend:(NSString*)uID;

/* counters */
@property NSInteger numTwitterNames;
@property NSInteger numTwitterNamesProcessed;

/* in the case of an error from Twitter */
@property BOOL alreadyDisplayedErrorMessage;
@property BOOL alreadySwitchedToApplesWay;

@property (strong, nonatomic) NSMutableArray *twitterPosts;
@property (strong, nonatomic) NSMutableArray *usersPosts;

//For testing performance
@property (strong, nonatomic) NSTimer *performanceTimer;
@property NSInteger performanceTimerCounter;

@end

@implementation FeedController

@synthesize numTwitterNames, numTwitterNamesProcessed;
@synthesize delegate;
@synthesize twitterPosts, usersPosts;
@synthesize alreadyDisplayedErrorMessage, alreadySwitchedToApplesWay;
@synthesize performanceTimer, performanceTimerCounter;

#pragma mark - Public methods 

-(void)fetchAllPosts
{
#if DEBUG
    self.performanceTimerCounter = 0;
    self.performanceTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(performanceTimerFired) userInfo:nil repeats:YES];
#endif
    
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    comps.day = -5;
    
    /* get the users posts from parse */
    [self getUserPostsFromDateComponents:comps withDateFilter:NO];

    
    /* after the friends array is recieved, fetch the users posts, so they can be filtered based on who your friends are */
    numTwitterNamesProcessed = numTwitterNames;

    /* get the tweets containing a certain string */
    [self getTweetsWithMention];
}

-(NSArray*)mergeTwitterAndUsersPosts:(NSArray*)tweets
{
    if (numTwitterNames == numTwitterNamesProcessed) {
        [self.usersPosts addObjectsFromArray:tweets];
    }
    NSArray *result = self.usersPosts;
    return result;
}

#pragma mark - Private methods 

/* performance measure method, used strictly in testing */
- (void)performanceTimerFired
{
    self.performanceTimerCounter = self.performanceTimerCounter + 1;
}

- (void)getUserPostsFromDateComponents:(NSDateComponents*)comps withDateFilter:(BOOL)filterDate
{
    self.usersPosts = nil;
    
    User* user = [User sharedInstance];
    NSString *className = [NSString stringWithFormat:@"%@_feed",[user school]];
   
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *someDaysAgo = [gregorian dateByAddingComponents:comps toDate:today options:0];
    
    PFQuery *query = [PFQuery queryWithClassName:className];
    
    if (filterDate) {
        [query whereKey:@"date" greaterThan:someDaysAgo];
    }
        
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *tempResult = [[NSMutableArray alloc]init];
        if ([objects count] == 100) {
            NSDateComponents *comps = [[NSDateComponents alloc]init];
            comps.day = -5;
            [self getUserPostsFromDateComponents:comps withDateFilter:YES];
            NSLog(@"Went 5 days more back!");
        }
        
        else {
            /* serialize into FeedPost objects */
            for (PFObject *obj in objects) {
                /* only check if they are a friend if they are authenticated with facebook */
                if (![[[User sharedInstance] uID] isEqualToString:EMAIL_LOGIN_FB_ID]) {
                    if ([self isAFriend:[obj objectForKey:@"uID"]]) {
                        FeedPost *post = [[FeedPost alloc]initWithPFObject:obj];
                        [tempResult addObject:post];
                    }
                }
                /* otherwise, take all of the posts */
                else {
                    FeedPost *post = [[FeedPost alloc]initWithPFObject:obj];
                    [tempResult addObject:post];
                }
            }
            NSArray *result = tempResult;
            self.usersPosts = nil;
            self.usersPosts = [NSMutableArray arrayWithArray:result];
            [delegate didRecieveAllUsersPosts:result];
        }
    }];
}

- (void)getTweetsWithMention
{
    twitterPosts = [[NSMutableArray alloc] init];
    jsonResponse = [[NSMutableArray alloc] init];
    responseData = [NSMutableData data];
    
    
    [jsonResponse removeAllObjects];
    [responseData resetBytesInRange:NSMakeRange(0,[responseData length])];
    NSString *url = nil;
    User *user = [User sharedInstance];

    if ([user.school isEqualToString:@"umich"]) {
        url = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=&ands=legendscard&phrase=&rpp=100"];
    }
    if ([user.school isEqualToString:@"state"]) {
        url = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=&ands=claremontlegend&phrase=&rpp=100"];
    }
    if ([user.school isEqualToString:@"iu"]) {
        url = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=&ands=legendscardiu&phrase=&rpp=100"];
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops" 
														message:@"You are not connected to the internet"
													   delegate:self cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
	[alertView show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    if (responseData == nil) {
        return;
    }
    
    NSDictionary *dict   = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    
    NSMutableArray *allPostsMut = [[NSMutableArray alloc]init];
    
    NSArray *results = [dict objectForKey:@"results"];
    
    int timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT] / 3600);
    /* serialize into feed post objects */
    for (NSDictionary *result in results) {
        FeedPost *post = [[FeedPost alloc]initWithTweet:result andTimeZoneOffset:timezoneoffset];
        [allPostsMut addObject:post];   
    }
    NSArray *temp = allPostsMut;
    allPostsMut = nil;
    [delegate didRecieveAllTweets:temp];
}

#pragma mark - Helper methods

- (BOOL)isAFriend:(NSString*)uID
{
    return YES;
}

@end
