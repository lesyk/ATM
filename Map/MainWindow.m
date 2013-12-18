//
//  MainWindow.m
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainWindow.h"
#import "LocalizationSystem.h"

@implementation MainWindow

@synthesize window;
@synthesize viewController;
@synthesize navController;
@synthesize tabBar;

#pragma mark -
#pragma mark Application lifecycle

- (id)init
{
    if (self = [super init])
    {
        //init
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *nsdefLanguage = [defaults objectForKey:@"language"];
        NSString *nsdefCity = [defaults objectForKey:@"city"];
        if (nsdefLanguage) {
            LocalizationSetLanguage(nsdefLanguage);
        }
        if (nsdefCity) {
            LocalizationSetCity(nsdefCity);
        }
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
//    
//    CGRect frame = CGRectMake(0, 0, 480, 49);
//    UIView *v = [[UIView alloc] initWithFrame:frame];
//    UIImage *i = [UIImage imageNamed:@"bgtab.png"];
//    UIColor *c = [[UIColor alloc] initWithPatternImage:i];
//    v.backgroundColor = c;
//    [[self tabBar] insertSubview:v atIndex:0];
    
    //init tabs
    NSArray *tabBarItemTitles = [NSArray arrayWithObjects: @"tab_about_bank", @"tab_cashmachines", @"tab_bank_part", @"tab_settings", nil];
    for(UITabBarItem *tabBarItem in [self.tabBar items])
    {
        tabBarItem.title = AMLocalizedString([tabBarItemTitles objectAtIndex:[[self.tabBar items] indexOfObject:tabBarItem]]);
    }
    
    [self.window addSubview:[navController view]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end