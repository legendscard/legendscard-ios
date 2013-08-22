//
//  FeedPost.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/21/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedPost : NSObject {
    NSString *type;
    NSString *name;
    NSString *uID;
    NSString *text;
    UIImage *pic;
    NSDate *date;
    NSURL *picURL;
    NSString *postID;
}

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *pic;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSURL *picURL;
@property (strong, nonatomic) NSString *postID;

- (id)initWithPFObject:(PFObject*)obj;
- (id)initWithTweet:(NSDictionary*)tweet andTimeZoneOffset:(NSInteger)timezoneoffset;

- (NSComparisonResult)compareDates:(FeedPost *)otherObject;


@end
