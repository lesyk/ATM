//
//  ConfigurationViewController.h
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigurationViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UILabel *languageLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *languageSwitcher;
@property (nonatomic, retain) IBOutlet UISegmentedControl *citySwitcher;
@property (nonatomic, retain) IBOutlet UINavigationItem *navBar;
@property (nonatomic, retain) NSMutableArray *allCities;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;

- (void)writeLanguageToNSDef:(NSString*)language;
- (void)changeTabsTranslation;
- (void) changeUIText;
- (void)pickOne:(id)sender;
- (void)pickCity:(id)sender;
- (void)changeLanguage:(NSString *)language;
- (void)changeCity:(NSString *)city;

@end
