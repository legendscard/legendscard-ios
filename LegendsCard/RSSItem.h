//
//  RSSItem.h
//  iLegendsCard
//
//  Created by matt on 11/9/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RSSItem : NSObject <NSXMLParserDelegate>
{
    NSString *title;
    NSString *link;
    NSString *link2;
    NSString *deal;
    NSString *perk;
    NSString *address;
    NSString *storeType;
    NSString *lattitude;
    NSString *longitude;
    NSString *phoneno;
    NSMutableString *currentString;
    
    NSDecimalNumber *realDistance;
    double distance;
    
    id parentParserDelegate;
}

@property (nonatomic, strong) id parentParserDelegate;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *link2;
@property (nonatomic, retain) NSString *deal;
@property (nonatomic, retain) NSString *perk;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *storeType;
@property (nonatomic, retain) NSString *lattitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *phoneno;
@property (nonatomic, retain) NSDecimalNumber *realDistance;

-(void)findDistanceTo:(CLLocationCoordinate2D)loc;
-(double)getDistance;

@end
