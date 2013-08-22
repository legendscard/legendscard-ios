//
//  StaticViewAllStoresController.h
//  iLegendsCard
//
//  Created by nolan on 11/9/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSChannel;

@protocol PerksControllerDelgate <NSObject>
-(void)didRecieveXML:(NSMutableArray*)results;
@end

@interface PerksController : NSObject<NSURLConnectionDelegate, NSXMLParserDelegate>
{
    //data feed vars
    NSURLConnection *connection;
    NSMutableData *xmlData;
    RSSChannel *channel;
    NSString *storeType;
    
    NSMutableArray *searchedData;
    NSMutableArray *tableData;
}

- (void)fetchEntries;

@property (nonatomic, retain) NSString *school;
@property (weak, nonatomic) id <PerksControllerDelgate> delegate;


@end
