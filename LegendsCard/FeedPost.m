//
//  FeedPost.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/21/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "FeedPost.h"

@implementation FeedPost

@synthesize type, name, uID, text, pic, date, picURL, postID;

-(id)init {
    self = [super init];
    if (self) {
        type = @"";
        name = @"";
        uID = @"";
        text = @"";
        pic = nil;
        picURL = nil;
        date = nil;
        postID = @"";
    }
    return self;
}

- (id)initWithPFObject:(PFObject*)obj
{
    self = [super init];
    if (self) {
        type = @"facebook";
        name = [obj objectForKey:@"name"];
        uID = [obj objectForKey:@"uID"];
        date = [obj objectForKey:@"date"];
        text = [obj objectForKey:@"post_text"];
        postID = [obj objectId];
    }
    return self;
}

- (id)initWithTweet:(NSDictionary*)tweet andTimeZoneOffset:(NSInteger)timezoneoffset
{
    self = [super init];
    if (self) {
        type = @"twitter";
        name = [tweet objectForKey:@"from_user_name"];
        text = [tweet objectForKey:@"text"];
        NSDateComponents *comps = [[NSDateComponents alloc]init];
        [comps setHour:timezoneoffset];
        date = [[[NSCalendar alloc]initWithCalendarIdentifier:@"gregorian"]
                     dateByAddingComponents:comps
                     toDate:[self stringToDate:[tweet objectForKey:@"created_at"]] options:0];
        picURL = [self getTwitterPictureURL:[tweet objectForKey:@"profile_image_url"]];
    }
    return self;
}

- (NSComparisonResult)compareDates:(FeedPost *)otherObject {
    return [self.date compare:otherObject.date];
}

- (NSDate*)stringToDate:(NSString*)dateStr
{
    NSString *month = [dateStr substringWithRange:NSMakeRange(8, 4)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(5, 3)];
    NSString *time = [dateStr substringWithRange:NSMakeRange(17, 9)];
    NSString *year = [dateStr substringWithRange:NSMakeRange(12, 5)];
    
    NSString *dateString = [NSString stringWithFormat:@""];
    dateString = [dateString stringByAppendingString:month];
    dateString = [dateString stringByAppendingString:day];
    dateString = [dateString stringByAppendingString:year];
    dateString = [dateString stringByAppendingString:time];
    
    // NSLog(@"dateString is %@",dateString);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    NSDate *newDate = [dateFormatter dateFromString:dateString];
    return newDate;
}

- (NSURL*)getTwitterPictureURL:(NSString*)urlString
{
    NSString *improvedurlString = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    
    NSURL *url = [NSURL URLWithString:improvedurlString];
    
    return url;
}

@end
