//
//  MapViewAllLocationsController.h
//  iLegendsCard
//
//  Created by nolan on 11/10/11.
//  Copyright (c) 2011 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>

#import "iCodeBlogAnnotation.h"
#import "iCodeBlogAnnotationView.h"

@class RSSChannel;

@interface MapAllViewController : UIViewController<NSURLConnectionDelegate, NSXMLParserDelegate>{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    RSSChannel *channel;
    NSString *storeType;
    
    NSMutableArray *searchedData;
    NSMutableArray *tableData;
    
    CLLocationManager *locmanager;
    CLLocationCoordinate2D loc;
    IBOutlet MKMapView *mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) NSString *school;

-(void)loadOurAnnotations;
-(void)fetchEntries;
-(void)findMe;

@end
