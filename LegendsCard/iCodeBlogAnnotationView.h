#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "iCodeBlogAnnotation.h"

@interface iCodeBlogAnnotationView : MKAnnotationView 
{
	UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;

@end
