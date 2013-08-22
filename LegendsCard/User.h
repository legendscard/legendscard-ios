//
//  User.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/18/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString *uID;
@property (strong, nonatomic) NSString *school;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString *legendsNumber;
@property (strong, nonatomic) NSString *twitterAddition;

@property (strong, nonatomic) NSString *description;

+(id)sharedInstance;

@end
