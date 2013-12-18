//
//  ListViewController.h
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
#import <MapKit/MapKit.h>
#import "City.h"

@interface ListViewController : UITableViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet ListCell *cell;
@property (nonatomic, retain) NSMutableArray* choosedObjects;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString* lang;
@property (nonatomic, retain) City* city;
@property (nonatomic, retain) City *closestCity;

-(void)showListOnMap;

@end
