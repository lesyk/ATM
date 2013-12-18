//
//  MainWindow.h
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@interface MainWindow : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MapViewController *viewController;
    UINavigationController *navController;
    UITabBar *tabBar;
}
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end