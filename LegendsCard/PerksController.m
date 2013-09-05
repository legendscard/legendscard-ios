//
//  PerksController.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/28/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "PerksController.h"
//#import "LocationViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "User.h"

@implementation PerksController
@synthesize school;
@synthesize delegate;

-(id)init {
    self = [super init];
    if (self) {
        [channel useAllItems];
        searchedData = [[NSMutableArray alloc] init];
        tableData = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"channel"]) {
        channel = [[RSSChannel alloc] init];
        [channel setParentParserDelegate:self];
        [parser setDelegate:channel];
    }
}

#pragma mark - Fetching All of the perks

-(void)fetchEntries
{
    xmlData = [[NSMutableData alloc] init];
    
    User *user = [User sharedInstance];
    school = user.school;

    //URL where xml data is located
    //NSURL *url = [NSURL URLWithString:@"http://localhost/michigan.xml"];
    if([school isEqualToString:@"umich"]){
        NSURL *url = [NSURL URLWithString:@"http://legendscard.com/images/iphoneapp/michigan.xml"];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    }
    else if([school isEqualToString:@"state"]){
        NSURL *url2 = [NSURL URLWithString:@"http://legendscard.com/images/iphoneapp/state.xml"];
        NSURLRequest *req2 = [NSURLRequest requestWithURL:url2];
        connection = [[NSURLConnection alloc] initWithRequest:req2 delegate:self startImmediately:YES];
    }
    else if([school isEqualToString:@"iu"]){
        NSURL *url3 = [NSURL URLWithString:@"http://legendscard.com/images/iphoneapp/indiana.xml"];
        NSURLRequest *req3 = [NSURLRequest requestWithURL:url3];
        connection = [[NSURLConnection alloc] initWithRequest:req3 delegate:self startImmediately:YES];
    }
}

-(void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

-(void)connectionDidFinishLoading: (NSURLConnection*)conn
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];
    
    [parser parse];
    
    xmlData = nil;
    connection = nil;
    
    
    
   // NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    
    [channel useAllItems];
    [tableData addObjectsFromArray:[channel currentItems]];
    
    [delegate didRecieveXML:tableData];

    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    connection = nil;
    
    xmlData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed. %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Whoops" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [av show];
}

@end
