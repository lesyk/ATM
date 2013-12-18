//
//  mapViewController.m
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"
#import "Database.h"
#import "ListViewController.h"
#import "LocalizationSystem.h"
#import "City.h"
#import "MapDirectionsViewController.h"
#import "FiltersViewController.h"
#import "ServicesCategories.h"

@implementation MapViewController

@synthesize choosedObjects, userLocation, lang, city, closestCity, scrollTo, objectOnMap, where;

-(void)viewDidLoad
{
    lang = LocalizationGetLanguage;
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (![LocalizationGetCity isEqualToString:city.code]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if ([closestCity.name isEqualToString:city.name]) {
        scrollTo = userLocation;
    }else {
        scrollTo = [[CLLocation alloc]initWithLatitude:city.latitude longitude:city.longitude];
    }
    
//    if (LocalizationGetLanguage != lang) {
//    NSArray *annotations = mapView.annotations;
//        for (MapAnnotation *annotation in annotations){
//            // Handle any custom annotations.
//            if ([annotation isKindOfClass:[MapAnnotation class]])
//            {
//               if ([LocalizationGetLanguage isEqualToString: @"ru"]) {
//                    annotation.title = annotation.title_ru;
//                    annotation.subtitle = annotation.subtitle_ru;
//                    annotation.description = annotation.description_ru;
//                    annotation.address = annotation.address_ru;
//                }else{
//                    annotation.title = annotation.title_en;
//                    annotation.subtitle = annotation.subtitle_en;
//                    annotation.description = annotation.description_en;
//                    annotation.address = annotation.address_en;
//                }
//            }
//        }
//    }
    
    [self getFromDB];
    
    [self changeTitle];
}

-(void)getFromDB
{
    if(where == @"atms")
    {
        [self getFromDBHelper:LocalizationGetAtmsFilter];
    }else if(where == @"branches"){
        [self getFromDBHelper:LocalizationGetBranchesFilter];
    }
}

-(void)getFromDBHelper:(NSMutableArray*)filter
{
    Database *db = [Database database];
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for(ServicesCategories *cat in filter)
    {
        for(Service *b in cat.elements)
        {
            if (b.checked) {
                [a addObject:b];
            }
        }
    }
    
//    NSMutableArray *newObjects = [db getAllWithWhereArray:a:where];

//    if(![self.choosedObjects isEqual:newObjects])
//    {
        self.choosedObjects = [db getAllWithWhereArray:a:where];
        [self initAnnotations];
//    }
}

-(void)changeTitle
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	navTitle.backgroundColor = [UIColor clearColor];
	navTitle.font = [UIFont boldSystemFontOfSize:14.0];
	navTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	navTitle.textAlignment = UITextAlignmentCenter;
	navTitle.textColor =[UIColor whiteColor];
	navTitle.text = [NSMutableString stringWithFormat: @"%@", AMLocalizedString(@"title_map")];
	self.navigationItem.titleView = navTitle;		
}

- (void)initAnnotations
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:10];
    for (id annotation in mapView.annotations)
        if (annotation != mapView.userLocation)
        [toRemove addObject:annotation];
    [mapView removeAnnotations:toRemove];
    
    for(MapAnnotation *entry in self.choosedObjects){
        MKCoordinateRegion region;
        region.center.latitude = entry.latitude;
        region.center.longitude= entry.longitude;

        
        MapAnnotation *ann = [[MapAnnotation alloc] init];
        
        if ([LocalizationGetLanguage isEqualToString: @"ru"]) {
            ann.title = entry.title_ru;
            ann.subtitle = entry.subtitle_ru;
            ann.description = entry.description_ru;
            ann.address = entry.address_ru;
        }else{
            ann.title = entry.title_en;
            ann.subtitle = entry.subtitle_en;
            ann.description = entry.description_en;
            ann.address = entry.address_en;
        }
        
        ann.title_en = entry.title_en;
        ann.subtitle_en = entry.subtitle_en;
        ann.coordinate = region.center;
        ann.description_en = entry.description_en;
        ann.image = entry.image;
        ann.address_en = entry.address_en;
        ann.phone = entry.phone;
        ann.photo = entry.photo;
        ann.phoneS = entry.phoneS;
        ann.title_ru = entry.title_ru;
        ann.subtitle_ru = entry.subtitle_ru;
        ann.description_ru = entry.description_ru;
        ann.address_ru = entry.address_ru;
        [mapView addAnnotation:ann];
    }
    
    MKCoordinateRegion region;
    region.center = scrollTo.coordinate;
    region.span.longitudeDelta = 0.06;
    region.span.latitudeDelta = 0.06;
    [mapView setRegion:region animated:YES];
    
    [self changeTitle];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(showFilters)];          
    UIImage *filterButtonImage = [UIImage imageNamed:@"funnel.png"];
    [filterButton setImage:filterButtonImage];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToList)];          
    UIImage *newButtonImage = [UIImage imageNamed:@"list.png"];
    [anotherButton setImage:newButtonImage];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)showFilters
{   
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    
    if(where == @"atms")
    {
            if (LocalizationGetAtmsFilter==nil) {
                filters = [self showFiltersHelper];
                LocalizationSetAtmsFilter(filters);
            }else {
                filters = LocalizationGetAtmsFilter;
            }
    }else if(where == @"branches")
    {
            if (LocalizationGetBranchesFilter==nil) {
                filters = [self showFiltersHelper];
                LocalizationSetBranchesFilter(filters);
            }else {
                filters = LocalizationGetBranchesFilter;
            }
    }
    
    FiltersViewController *l = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle:nil];
    [l initWithArray:filters];
    
    [self.navigationController pushViewController:l animated:YES];
}

-(NSMutableArray*)showFiltersHelper
{
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    Database *db = [Database database];
    filters = [db getAllServicesCategories:[NSString stringWithFormat:@"%@_service_categories", where]];
    
    for(ServicesCategories *cat in filters)
    {
        cat.elements = [db getAllServices:[NSString stringWithFormat:@"%@_services", where]:cat.uniqId];
    }
    return filters;
}

- (IBAction)findMyLocation:(id)sender {
    MKCoordinateRegion region;
    region.center.latitude = mapView.userLocation.location.coordinate.latitude;
    region.center.longitude= mapView.userLocation.location.coordinate.longitude;
    region.span.longitudeDelta = 0.02;
    region.span.latitudeDelta = 0.02;
    [mapView setRegion:region animated:YES];
}

-(void)backToList
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.45];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapViewI
            viewForAnnotation:(MapAnnotation *)annotation
{
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView* pinView = (MKAnnotationView*)[mapViewI
                                                        dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotation"];
            pinView.canShowCallout = YES;
//            pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"opacity_%@", annotation.image]];
            pinView.image = [UIImage imageNamed:[NSString stringWithFormat:@"marker.png"]];

            if (annotation.description) {
                // Add a detail disclosure button to the callout.
                UIButton* rightButton = [UIButton buttonWithType:
                                         UIButtonTypeDetailDisclosure];
                pinView.rightCalloutAccessoryView = rightButton;
            }
        }
        else
            pinView.annotation = annotation;
                
        return pinView;
    }
    
    return nil;
}

- (void)initMapWithZoomOnObject:(MapAnnotation *)object
{
        MKCoordinateRegion region;
        region.center.latitude = object.latitude;
        region.center.longitude= object.longitude;
        region.span.longitudeDelta = 0.02;
        region.span.latitudeDelta = 0.02;
        [mapView setRegion:region animated:YES];
        
        MapAnnotation *ann = [[MapAnnotation alloc] init];
        if ([LocalizationGetLanguage isEqualToString: @"ru"]) {
            ann.title = object.title_ru;
            ann.subtitle = object.subtitle_ru;
        }else {
            ann.title = object.title_en;
            ann.subtitle = object.subtitle_en;
        }
        ann.title_en = object.title_en;
        ann.subtitle_en = object.subtitle_en;
        ann.title_ru = object.title_ru;
        ann.subtitle_ru = object.subtitle_ru;
        ann.coordinate = region.center;
        ann.image = object.image;
        [mapView addAnnotation:ann];
    
    objectOnMap = object;
    
    UIBarButtonItem *btnMap = [[UIBarButtonItem alloc]
                               initWithTitle:AMLocalizedString(@"Navigate") 
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(openCompas:)];
    UIImage *newButtonImage = [UIImage imageNamed:@"compass_button.png"];
    [btnMap setImage:newButtonImage];
    self.navigationItem.rightBarButtonItem = btnMap;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
calloutAccessoryControlTapped:(UIControl *)control
{
//    MapAnnotation *ann = (MapAnnotation *)view.annotation;
//    ann.latitude = [view.annotation coordinate].latitude;
//    ann.longitude = [view.annotation coordinate].longitude;
//    DetailViewController *detailViewController =  [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    detailViewController.ann = ann;
//    detailViewController.city = self.city;
//    detailViewController.closestCity = self.closestCity;
//    [self.navigationController pushViewController:detailViewController animated:YES];
    MapDirectionsViewController *controller = [[MapDirectionsViewController alloc] init];
    
    controller.startPoint = [NSString stringWithFormat: @"%f %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    controller.endPoint = [NSString stringWithFormat: @"%f %f", [view.annotation coordinate].latitude, [view.annotation coordinate].longitude];
    NSMutableArray *wayPoints = [NSMutableArray arrayWithCapacity:[wayPointFields count]];
    for (UITextField *pointField in wayPointFields) {
        if ([pointField.text length] > 0) {
            [wayPoints addObject:pointField.text];
        }
    }
    controller.wayPoints = wayPoints;
    
    //                 if (travelModeSegment.selectedSegmentIndex == 0) {
    controller.travelMode = UICGTravelModeDriving;
    //                 } else {
    //                     controller.travelMode = UICGTravelModeWalking;
    //                 }
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end