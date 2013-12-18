//
//  BranchesFiltersViewController.m
//  ATM
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterCell.h"
#import "Database.h"
#import "Service.h"
#import "LocalizationSystem.h"
#import "FiltersViewController.h"
#import "BranchViewController.h"
#import "ServicesCategories.h"

@implementation FiltersViewController

@synthesize table, branchesCell, filters, lang;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initWithArray:(NSMutableArray*)array
{
    filters = [[NSMutableArray alloc] init];
    filters = array;
}

-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:AMLocalizedString(@"done") 
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = btnBack;
    
    if (LocalizationGetLanguage != lang) {
        [table reloadData];
        lang = LocalizationGetLanguage;
    }
}

-(IBAction)goBack:(id)sender  {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [filters count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    ServicesCategories *a = (ServicesCategories*)[filters objectAtIndex:section];
    return [a.elements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FilterCell";
    FilterCell *branchesFilterCell = (FilterCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (branchesFilterCell == nil) {
        [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        branchesFilterCell = self.branchesCell;
        self.branchesCell = nil;
    }
    
    ServicesCategories *cat = (ServicesCategories*)[filters objectAtIndex:indexPath.section];
    Service *service = [[Service alloc] init];
    service = [cat.elements objectAtIndex:indexPath.row];
    
    if ([LocalizationGetLanguage isEqualToString: @"ru"]) {
        branchesFilterCell.title.text = service.name_ru;    
    }else {
        branchesFilterCell.title.text = service.name;    
    }
    
    return branchesFilterCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ServicesCategories *cat = (ServicesCategories*)[filters objectAtIndex:section];

    NSString *title = [[NSString alloc] init];
    
    if ([LocalizationGetLanguage isEqualToString: @"ru"]) {
        title = cat.name_ru;    
    }else {
        title = cat.name;
    }
    return  title;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServicesCategories *cat = (ServicesCategories*)[filters objectAtIndex:indexPath.section];
    Service *service = [[Service alloc] init];
    service = [cat.elements objectAtIndex:indexPath.row];
    
    if (service.checked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;  
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath 
{
    ServicesCategories *cat = (ServicesCategories*)[filters objectAtIndex:indexPath.section];
    Service *service = [[Service alloc] init];
    service = [cat.elements objectAtIndex:indexPath.row];
    
    if (service.checked) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        service.checked = FALSE;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        service.checked = TRUE;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
