//
//  mapViewController.h
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "City.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *mapView;
    NSMutableArray *wayPointFields;
}

@property (nonatomic) NSMutableArray* choosedObjects;
@property (nonatomic) CLLocation* userLocation;
@property (nonatomic) CLLocation* scrollTo;
@property (nonatomic) NSString* lang;
@property (nonatomic) NSString* where;
@property (nonatomic) City* city;
@property (nonatomic) City *closestCity;
@property (nonatomic) MapAnnotation *objectOnMap;

- (void)initAnnotations;
- (void)initMapWithZoomOnObject:(MapAnnotation *)object;
- (IBAction)findMyLocation:(id)sender;
- (void)backToList;
//-(IBAction)openCompas:(id)sender;

@end
