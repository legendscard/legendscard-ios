//
//  MapViewController.m
//  iLegendsCard
//
//  Created by nolan on 11/2/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import "MapViewController.h"
#import "iCodeBlogAnnotation.h"

#import "RSSItem.h"

@implementation MapViewController

@synthesize mapView, item, school;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadOurAnnotations];
    
    CLLocationCoordinate2D coord;
    
    coord.latitude = [[item lattitude] doubleValue];
    coord.longitude = [[item longitude] doubleValue];
    
    NSLog(@"%f,%f", coord.latitude, coord.longitude);
    NSLog(@"%@", [item title]);
    
    //[mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(.25, .25)) animated:YES];
    [mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(.01, .01)) animated:YES];
}

-(void)loadOurAnnotations
{
	CLLocationCoordinate2D workingCoordinate;
	
	workingCoordinate.latitude = [[item lattitude] doubleValue];
	workingCoordinate.longitude = [[item longitude] doubleValue];
	iCodeBlogAnnotation *appleStore1 = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
	[appleStore1 setTitle:[item title]];
	[appleStore1 setSubtitle:[item deal]];
	[appleStore1 setAnnotationType:iCodeBlogAnnotationTypeApple];
    
	[mapView addAnnotation:appleStore1];
}

#pragma mark - uimapviewdelegate

- (iCodeBlogAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
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

@end
