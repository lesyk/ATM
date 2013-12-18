//
//  ServicesCategories.h
//  ATM
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface ServicesCategories : NSObject

@property (nonatomic, assign)int uniqId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* name_ru;
@property (nonatomic, copy) NSString* code;
@property (nonatomic, retain) NSMutableArray* elements;

@end
