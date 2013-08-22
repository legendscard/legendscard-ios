//
//  MapViewController.h
//  iLegendsCard
//
//  Created by nolan on 11/2/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>

#import "iCodeBlogAnnotation.h"
#import "iCodeBlogAnnotationView.h"

@class RSSItem;

@interface MapViewController : UIViewController<MKMapViewDelegate>{
    
    IBOutlet MKMapView *mapView;
    RSSItem *item;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) RSSItem *item;

@property (nonatomic, retain) NSString *school;

-(void)loadOurAnnotations;

@end
