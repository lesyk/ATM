//
//  ListViewController.m
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BranchViewController.h"
#import "ListCell.h"
#import "MapAnnotation.h"
#import "mapViewController.h"
#import "LocalizationSystem.h"
#import "City.h"
#import "Database.h"
#import "FiltersViewController.h"
#import "ServicesCategories.h"

@interface BranchViewController ()

@end

@implementation BranchViewController

@synthesize choosedObjects, table, cell, lang, city, closestCity, location;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lang = LocalizationGetLanguage;
    city = [[City alloc] init];
    
    Database *db = [Database database];
    city = [db getCityByCode:LocalizationGetCity];
    
    //get user location for list
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    self.choosedObjects = [[NSMutableArray alloc] init];
        
    //not showing empty rows in table
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(showListOnMap)];          
    UIImage *newButtonImage = [UIImage imageNamed:@"map.png"];
    [anotherButton setImage:newButtonImage];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(showFilters)];          
    UIImage *filterButtonImage = [UIImage imageNamed:@"funnel.png"];
    [filterButton setImage:filterButtonImage];
    self.navigationItem.leftBarButtonItem = filterButton;
    
    [self changeTitle];
}

-(void)getFromDB
{
    Database *db = [Database database];
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for(ServicesCategories *cat in LocalizationGetBranchesFilter)
    {
        for(Service *b in cat.elements)
        {
            if (b.checked) {
                [a addObject:b];
            }
        }
    }
    self.choosedObjects = [db getAllWithWhereArray:a:@"branches"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self getFromDB];
    
    if (![LocalizationGetCity isEqualToString:city.code]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (LocalizationGetLanguage != lang) {
        [table reloadData];
        lang = LocalizationGetLanguage;
        [self changeTitle];
    }
    
    for(MapAnnotation *entry in choosedObjects){
        CLLocation *annnotLoc = [[CLLocation alloc]initWithLatitude:entry.latitude longitude:entry.longitude];
        
        int distance = [locationManager.location distanceFromLocation:annnotLoc];
        entry.distance = distance;
    }
    
    NSArray *sortedArray = [choosedObjects sortedArrayUsingSelector:@selector(sort:)];
    
    choosedObjects = [sortedArray mutableCopy];
    
    if (location != locationManager.location) {
        [table reloadData];
        location = locationManager.location;
    }
}

-(void)changeTitle
{

    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	navTitle.backgroundColor = [UIColor clearColor];
	navTitle.font = [UIFont boldSystemFontOfSize:14.0];
	navTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	navTitle.textAlignment = UITextAlignmentCenter;
	navTitle.textColor =[UIColor whiteColor];
    navTitle.text = [NSMutableString stringWithFormat: @"%@", AMLocalizedString(@"title_departments")];    
	self.navigationItem.titleView = navTitle;		
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.choosedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    
    ListCell *listCell = (ListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (listCell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        listCell = self.cell;
        self.cell = nil;
    }
    
    MapAnnotation *ann = [[MapAnnotation alloc]init];
    ann = [self.choosedObjects objectAtIndex:indexPath.row];
    
    if ([LocalizationGetLanguage isEqualToString: @"ru"]) {
        listCell.title.text = ann.title_ru;    
    }else {
        listCell.title.text = ann.title_en;    
    }
    
    UIImage *image = [UIImage imageNamed:ann.image];
    [listCell.image setImage:image];
    
    NSString *distanceS = [[NSString alloc] init];
    if (ann.distance < 999) {
        distanceS = [NSString stringWithFormat:@"%.f m", ann.distance];
    }else if(ann.distance < 100000){
        distanceS = [NSString stringWithFormat:@"%.2f km", ann.distance/1000];
    }else{
        distanceS = @">100km";
    }

    listCell.distance.text = distanceS;
    
    return listCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    
//    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    detailViewController.ann = [self.choosedObjects objectAtIndex:indexPath.row];
//    detailViewController.city = self.city;
//    detailViewController.closestCity = self.closestCity;
//    [self.navigationController pushViewController:detailViewController animated:YES];
//}	

-(void)showListOnMap
{
    MapViewController *l = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    l.userLocation = locationManager.location;
    l.city = self.city;
    l.closestCity = self.closestCity;
    l.where = @"branches";
    l.choosedObjects = self.choosedObjects;

    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.45];

    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [self.navigationController pushViewController:l animated:YES];
//    [l initAnnotations];
}

-(void)showFilters
{
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    if (LocalizationGetBranchesFilter==nil) {
        Database *db = [Database database];
        filters = [db getAllServicesCategories:@"branches_service_categories"];
        
        for(ServicesCategories *cat in filters)
        {
            cat.elements = [db getAllServices:@"branches_services":cat.uniqId];
        }
        
        LocalizationSetBranchesFilter(filters);
    }else {
        filters = LocalizationGetBranchesFilter;
    }
    
    FiltersViewController *l = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle:nil];
    [l initWithArray:filters];
    
    [self.navigationController pushViewController:l animated:YES];
}

@end
