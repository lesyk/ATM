//
//  City.h
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, assign)int uniqId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, copy) NSString* name_ru;
@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* description_ru;

@end
