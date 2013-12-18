//
//  AboutBank.m
//  ATM
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutBankViewController.h"
#import "LocalizationSystem.h"

@interface AboutBankViewController ()

@end

@implementation AboutBankViewController

@synthesize navBar, lang;

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
    [self changeTitle];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (LocalizationGetLanguage != lang) {
        lang = LocalizationGetLanguage;
        [self changeTitle];
    }
}

-(void)changeTitle
{
    //    NSString *city_name = [[NSString alloc] init];
    //    if (![LocalizationGetLanguage isEqualToString: @"ru"]) {
    //        city_name = city.name;
    //    }else {
    //        city_name = city.name_ru;
    //    }
    
    //    self.title = [NSMutableString stringWithFormat: @"%@ - %@", city_name, AMLocalizedString(@"list_view_title")];
    self.title = [NSMutableString stringWithFormat: @"%@", AMLocalizedString(@"title_about_bank")];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
	navTitle.backgroundColor = [UIColor clearColor];
	navTitle.font = [UIFont boldSystemFontOfSize:14.0];
	navTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	navTitle.textAlignment = UITextAlignmentCenter;
	navTitle.textColor =[UIColor whiteColor];
	navTitle.text = self.title;
  	navBar.titleView = navTitle;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
