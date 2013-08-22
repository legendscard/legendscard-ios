//
//  RSSChannel.h
//  iLegendsCard
//
//  Created by matt on 11/9/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSChannel : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentString;
    
    NSString *title;
    NSString *shortDescription;
    NSMutableArray *items;
    
    NSMutableArray *currentItems;
    
   // NSMutableArray *type1; //eat
   // NSMutableArray *type2; //shop
   // NSMutableArray *type3; //do
}

@property (nonatomic, assign) id parentParserDelegate;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *shortDescription;
@property (nonatomic, readonly) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *currentItems;

-(void)itemsOfType:(NSString*)itemType;
-(void)useAllItems;

@end
