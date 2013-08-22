//
//  RSSChannel.m
//  iLegendsCard
//
//  Created by matt on 11/9/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel
@synthesize items, title, shortDescription, parentParserDelegate, currentItems;


-(id)init
{
    self = [super init];
    
    if (self){
        //create container for rss items this channel has
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"\t%@ found a %@ element", self, elementName);
    currentString = [[NSMutableString alloc] init];

    if ([elementName isEqual:@"title"]){
        [self setTitle:currentString];
    }
    else if ([elementName isEqual:@"description"]){
        [self shortDescription];
    }else if ([elementName isEqual:@"item"]){
        RSSItem *entry = [[RSSItem alloc] init];
        [entry setParentParserDelegate:self];
        [parser setDelegate:entry];
        [items addObject:entry];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    currentString = nil;
    
    if ([elementName isEqual:@"channel"])
        [parser setDelegate:parentParserDelegate];
}

-(void)itemsOfType:(NSString*)itemType
{
    NSMutableArray *myItems = [[NSMutableArray alloc] init];
    
    for (id item in items){
        RSSItem *anItem = (RSSItem*)item;
        if([[anItem storeType] isEqualToString:itemType]){
            [myItems addObject:anItem];
            //NSLog(@"added %@", [anItem title]);
        }
    }
    
    currentItems = myItems;
}

-(void)useAllItems
{
    currentItems = items;
}


@end
