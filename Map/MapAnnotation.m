//
//  mapAnnotation.m
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize uniqId, title, subtitle, description, coordinate, latitude, longitude, image, distance, address, phone, photo, phoneS, title_ru, description_ru, subtitle_ru, address_ru, title_en,subtitle_en,description_en,address_en, city, thisbank;

-(NSComparisonResult)sort:(MapAnnotation *)otherObject {
    if (self.distance < otherObject.distance) {
        return NSOrderedAscending;
    } else if(self.distance > otherObject.distance){
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end