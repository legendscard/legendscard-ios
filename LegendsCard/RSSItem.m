//
//  RSSItem.m
//  iLegendsCard
//
//  Created by matt on 11/9/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

@synthesize title, link, link2, parentParserDelegate, deal, perk, address, storeType, lattitude, longitude, phoneno, realDistance;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"\t\t%@ found a %@ element", self, elementName);
    currentString = [[NSMutableString alloc] init];

    if ([elementName isEqual:@"title"]){
        [self setTitle:currentString];
    }else if ([elementName isEqual:@"link"]){
        [self setLink:currentString];
    }else if ([elementName isEqual:@"link2"]){
        [self setLink2:currentString];
    }else if ([elementName isEqual:@"deal"]){
        [self setDeal:currentString];
    }else if ([elementName isEqual:@"perk"]){
        [self setPerk:currentString];
    }else if ([elementName isEqual:@"address"]){
        [self setAddress:currentString];
    }else if ([elementName isEqual:@"type"]){
        [self setStoreType:currentString];
    }else if ([elementName isEqual:@"lat"]){
        [self setLattitude:currentString];
    }else if ([elementName isEqual:@"long"]){
        [self setLongitude:currentString];
    }else if ([elementName isEqual:@"phone"]){
        [self setPhoneno:currentString];
    }
}

- (NSComparisonResult)compare:(RSSItem *)otherItem {
    NSNumber *d1 = [NSNumber numberWithDouble:distance];
    NSNumber *d2 = [NSNumber numberWithDouble:otherItem.getDistance];
    return [d1 compare:d2];
}

-(double)getDistance{
    return distance;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    currentString = nil;
    
    if ([elementName isEqual:@"item"])
        [parser setDelegate:parentParserDelegate];
}

-(void)findDistanceTo:(CLLocationCoordinate2D)loc{
    double myLat = [lattitude doubleValue];
    double myLong = [longitude doubleValue];
    distance = (acos((cos(myLat) * cos(myLong) * cos(loc.latitude) * cos(loc.longitude)) + (cos(myLat) * sin(myLong) * cos(loc.latitude) * sin(loc.longitude)) + (sin(myLat) * sin(loc.latitude)))/360) * (2 * 3.14159) * 6371;    
    //distance = (pow((myLat - loc.latitude), 2) + pow((myLong-loc.longitude),2) * 6371);
    realDistance = [[NSDecimalNumber alloc]initWithDouble:distance];
    
    //NSLog(@"distance to %@: %f", title, distance);
}

@end
