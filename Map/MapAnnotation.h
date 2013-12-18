//
//  mapAnnotation.h
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign)int uniqId;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* title_en;
@property (nonatomic, copy) NSString* subtitle_en;
@property (nonatomic, copy) NSString* description_en;
@property (nonatomic, copy) NSString* title_ru;
@property (nonatomic, copy) NSString* subtitle_ru;
@property (nonatomic, copy) NSString* description_ru;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float distance;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* address_en;
@property (nonatomic, copy) NSString* address_ru;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* phoneS;
@property (nonatomic, copy) NSString* photo;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, assign) BOOL thisbank;

- (NSComparisonResult)sort:(MapAnnotation *)otherObject;

@end
