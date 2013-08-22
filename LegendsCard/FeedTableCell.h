//
//  FeedTableCell.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/26/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedPost.h"

@interface FeedTableCell : UITableViewCell

@property (weak, nonatomic) UIColor *cellTextColor;
@property (strong, nonatomic) FeedPost *cellPost;

-(void)setName:(NSString*)name;
-(void)setDate:(NSDate*)date;
-(void)setText:(NSString*)text;
-(void)setPicture:(UIImage*)img;
-(void)showIndicator:(BOOL)flag;

@end
