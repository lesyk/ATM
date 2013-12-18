//
//  ConfigurationViewController.m
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationViewController.h"
#import "LocalizationSystem.h"
#import "Database.h"
#import "City.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController
@synthesize languageLabel, languageSwitcher, navBar, citySwitcher, allCities, table, cityLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    allCities = [[NSMutableArray alloc] init];
    Database *db = [Database database];
    
    allCities = [db getAllCities];
    
    if ([LocalizationGetLanguage isEqualToString:@"ru"]) 
    {
     	languageSwitcher.selectedSegmentIndex = 1;
    }else{
        languageSwitcher.selectedSegmentIndex = 0;
    }
    
	[languageSwitcher addTarget:self
	                     action:@selector(pickOne:)
	           forControlEvents:UIControlEventValueChanged];
    
    if ([LocalizationGetCity isEqualToString:@"lvov"]) 
    {
     	citySwitcher.selectedSegmentIndex = 1;
    }else{
        citySwitcher.selectedSegmentIndex = 0;
    }
    
    [citySwitcher addTarget:self
	                     action:@selector(pickCity:)
	           forControlEvents:UIControlEventValueChanged];

    
    [self changeUIText];
}

- (void)pickOne:(id)sender{
    UISegmentedControl *a = sender;
    if (a.selectedSegmentIndex == 0) {
        [self changeLanguage:@"en"];
    }else{
        [self changeLanguage:@"ru"];
    }
} 

- (void)pickCity:(id)sender
{
    UISegmentedControl *a = sender;
    if (a.selectedSegmentIndex == 0) {
        [self changeCity:@"kyiv"];
    }else{
        [self changeCity:@"lvov"];
    }
}

-(void)changeLanguage:(NSString *)language
{
	LocalizationSetLanguage(language);
    [self changeTabsTranslation];
    [self changeUIText];
    [table reloadData];
    [self writeLanguageToNSDef:language];
}

- (void)changeCity:(NSString *)city
{
    LocalizationSetCity(city);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)writeLanguageToNSDef:(NSString*)language
{
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:language forKey:@"language"];
    [defaults synchronize];
}

- (void) changeUIText
{
	languageLabel.text = AMLocalizedString(@"language");
  	cityLabel.text = AMLocalizedString(@"city");
    navBar.title = AMLocalizedString(@"tab_settings");
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	navTitle.backgroundColor = [UIColor clearColor];
	navTitle.font = [UIFont boldSystemFontOfSize:14.0];
	navTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	navTitle.textAlignment = UITextAlignmentCenter;
	navTitle.textColor =[UIColor whiteColor];
	navTitle.text = navBar.title;
	navBar.titleView = navTitle;		
}

- (void) changeTabsTranslation
{
    NSArray *tabBarItemTitles = [NSArray arrayWithObjects: @"tab_about_bank", @"tab_cashmachines", @"tab_bank_part", @"tab_settings", nil];
    for(UITabBarItem *tabBarItem in [self.tabBarController.tabBar items])
    {
        tabBarItem.title = AMLocalizedString([tabBarItemTitles objectAtIndex:[[self.tabBarController.tabBar items] indexOfObject:tabBarItem]]);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allCities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:	CellIdentifier];
    }
    
    City *city = [allCities objectAtIndex:[indexPath row]];
    
    if (![LocalizationGetLanguage isEqualToString:@"ru"]) 
    {
     	cell.textLabel.text = city.name;
    }else{
        cell.textLabel.text = city.name_ru;
    }
    
    if ([LocalizationGetCity isEqualToString:city.code]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    City *city = [allCities objectAtIndex:indexPath.row];
    LocalizationSetCity(city.code);
    [table reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:city.code forKey:@"city"];
    [defaults synchronize];
}

@end
