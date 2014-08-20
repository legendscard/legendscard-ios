//
//  MapViewAllLocationsController.m
//  iLegendsCard
//
//  Created by nolan on 11/10/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import "MapAllViewController.h"

#import "iCodeBlogAnnotation.h"

#import "RSSItem.h"
#import "RSSChannel.h"

@implementation MapAllViewController
@synthesize mapView, school;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [channel useAllItems];
        searchedData = [[NSMutableArray alloc] init];
        tableData = [[NSMutableArray alloc] init];
        
        locmanager = [[CLLocationManager alloc] init];
        [locmanager setDelegate:self];
        [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locmanager startUpdatingLocation];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    loc = [newLocation coordinate];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"channel"]) {
        channel = [[RSSChannel alloc] init];
        [channel setParentParserDelegate:self];
        [parser setDelegate:channel];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchEntries];
    UIBarButtonItem *locate = [[UIBarButtonItem alloc] initWithTitle:@"Find Me" style:UIBarButtonItemStylePlain target:self action:@selector(findMe)];
    [[self navigationItem] setRightBarButtonItem:locate];
}

-(void)findMe{
    [mapView setRegion:MKCoordinateRegionMake(loc, MKCoordinateSpanMake(.01, .01)) animated:YES]; 
    [mapView setShowsUserLocation:YES];
}

-(void)loadOurAnnotations
{
    for (id item in tableData) {
        RSSItem *currItem = (RSSItem*)item;
        
        CLLocationCoordinate2D workingCoordinate;
        workingCoordinate.latitude = [[currItem lattitude] doubleValue];
        workingCoordinate.longitude = [[currItem longitude] doubleValue];
        iCodeBlogAnnotation *itemAnnotation = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
        [itemAnnotation setTitle:[item title]];
        [itemAnnotation setSubtitle:[item deal]];
        
        if ([[item storeType] isEqual:@"1"]){
            [itemAnnotation setAnnotationType:iCodeBlogAnnotationTypeTaco];
        }else if ([[item storeType] isEqual:@"2"]){
            [itemAnnotation setAnnotationType:iCodeBlogAnnotationTypeApple];
        }else
            [itemAnnotation setAnnotationType:iCodeBlogAnnotationTypeEDU];
        
        [mapView addAnnotation:itemAnnotation];
        NSLog(@"mapping %@", [item title]);
    }
    
    //have two modes, one for 
    /*
     CLLocationCoordinate2D workingCoordinate;
     
     workingCoordinate.latitude = [[item lattitude] doubleValue];
     workingCoordinate.longitude = [[item longitude] doubleValue];
     iCodeBlogAnnotation *appleStore1 = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
     [appleStore1 setTitle:[item title]];
     [appleStore1 setSubtitle:[item deal]];
     [appleStore1 setAnnotationType:iCodeBlogAnnotationTypeApple];
     
     [mapView addAnnotation:appleStore1];
     */
	
}

#pragma mark - uimapviewdelegate

- (iCodeBlogAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:MKUserLocation.class]) 
        return nil;
	iCodeBlogAnnotationView *annotationView = nil;
	
	// determine the type of annotation, and produce the correct type of annotation view for it.
	iCodeBlogAnnotation* myAnnotation = (iCodeBlogAnnotation *)annotation;
	
	if(myAnnotation.annotationType == iCodeBlogAnnotationTypeApple)
	{
		NSString* identifier = @"Apple";
		iCodeBlogAnnotationView *newAnnotationView = (iCodeBlogAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(nil == newAnnotationView)
		{
			newAnnotationView = [[iCodeBlogAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier];
		}
		
		annotationView = newAnnotationView;
	}
	else if(myAnnotation.annotationType == iCodeBlogAnnotationTypeEDU)
	{
		NSString* identifier = @"School";
		
		iCodeBlogAnnotationView *newAnnotationView = (iCodeBlogAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(nil == newAnnotationView)
		{
			newAnnotationView = [[iCodeBlogAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier];
		}
		
		annotationView = newAnnotationView;
	}
	else if(myAnnotation.annotationType == iCodeBlogAnnotationTypeTaco)
	{
		NSString* identifier = @"Taco";
		
		iCodeBlogAnnotationView *newAnnotationView = (iCodeBlogAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(nil == newAnnotationView)
		{
			newAnnotationView = [[iCodeBlogAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier];
		}
		
		annotationView = newAnnotationView;
	}
	
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

- (void)viewDidUnload
{
    mapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)fetchEntries
{
    xmlData = [[NSMutableData alloc] init];
    
    //URL where xml data is located
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
    
    NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel shortDescription]);
    
    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSLog(@"xmlcheck = %@", xmlCheck);
    
    [channel useAllItems];
    [tableData addObjectsFromArray:[channel currentItems]];
    NSLog(@"reloading data2");
    [self loadOurAnnotations];
    
    CLLocationCoordinate2D coord;
    if([school isEqualToString:@"umich"]){
        coord.latitude = 42.273842;
        coord.longitude = -83.735806;
    }
    else if([school isEqualToString:@"state"]){
        coord.latitude = 42.735348;
        coord.longitude = -84.480389;
    }
    else if([school isEqualToString:@"iu"]){
        coord.latitude = 39.166532;
        coord.longitude = -86.527786;
    }
    
    NSLog(@"%f,%f", coord.latitude, coord.longitude);
    [mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(.03, .03)) animated:YES];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    connection = nil;
    
    xmlData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"fetch failed %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [av show];
}


@end
