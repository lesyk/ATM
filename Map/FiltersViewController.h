//
//  BranchesFiltersViewController.h
//  ATM
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCell.h"

@interface FiltersViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet FilterCell *branchesCell;
@property (nonatomic, retain) NSMutableArray *filters;
@property (nonatomic, retain) NSString* lang;

-(IBAction)goBack:(id)sender;
-(void)initWithArray:(NSMutableArray*)array;


@end
