//
//  FeedTableCell.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/26/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "FeedTableCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FeedTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *personsPicture;
@property (weak, nonatomic) IBOutlet UIImageView *personsPic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation FeedTableCell

@synthesize cellPost;
@synthesize personsPic;
@synthesize activityIndicator;
@synthesize deleteButton;
@synthesize nameLabel;
@synthesize textLabel;
@synthesize dateLabel;
//@synthesize personsPicture;
@synthesize cellTextColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    personsPic.clipsToBounds = YES;
}

-(void)setName:(NSString*)name {
    self.nameLabel.text = name;
    [self.nameLabel setAppFont:20];
    self.nameLabel.minimumFontSize = 5;
    self.nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.nameLabel.textColor = self.cellTextColor;
    
    [self bringSubviewToFront:nameLabel];
}

-(void)setDate:(NSDate*)date {
    //formate the date
    [self.dateLabel setAppFont:15];    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"HH:mm MM/dd/yyyy"];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [formatter stringFromDate:date];
    self.dateLabel.textColor = self.cellTextColor;
    
    [self bringSubviewToFront:dateLabel];
}

-(void)setText:(NSString*)text {
    NSInteger fontSize = 19;
    if ([text length] > 65) {
        fontSize -= 5;
    }
//    if ([text length] > 125) {
//        fontSize -= 5;
//    }
    
    [self.textLabel setAppFont:fontSize];
    self.textLabel.minimumFontSize = 5;
    [self.textLabel adjustsFontSizeToFitWidth];
    self.textLabel.text = text;
    self.textLabel.textColor = self.cellTextColor;
    
    [self bringSubviewToFront:textLabel];
}

-(void)setPicture:(UIImage*)img {
    [self sendSubviewToBack:personsPic];
    self.personsPic.image = img;
}

-(void)showIndicator:(BOOL)flag {
    if (flag == YES) {
        self.activityIndicator.hidden = NO;
    }
    else {
        self.activityIndicator.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
