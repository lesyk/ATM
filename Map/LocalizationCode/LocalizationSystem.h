//
//  LocalizationSystem.h
//  Battle of Puppets
//
//  Created by Juan Albero Sanchis on 27/02/10.
//  Copyright Aggressive Mediocrity 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

#define AMLocalizedString(key) \
[[LocalizationSystem sharedLocalSystem] localizedStringForKey:(key)]

#define LocalizationSetLanguage(language) \
[[LocalizationSystem sharedLocalSystem] setLanguage:(language)]

#define LocalizationGetLanguage \
[[LocalizationSystem sharedLocalSystem] getLanguage]


#define LocalizationSetCity(code) \
[[LocalizationSystem sharedLocalSystem] setCity:(code)]

#define LocalizationGetCity \
[[LocalizationSystem sharedLocalSystem] getCity]


#define LocalizationSetBranchesFilter(filters) \
[[LocalizationSystem sharedLocalSystem] setBranchFilters:(filters)]

#define LocalizationGetBranchesFilter \
[[LocalizationSystem sharedLocalSystem] getBranchFilters]


#define LocalizationSetAtmsFilter(filters) \
[[LocalizationSystem sharedLocalSystem] setAtmFilters:(filters)]

#define LocalizationGetAtmsFilter \
[[LocalizationSystem sharedLocalSystem] getAtmFilters]


#define LocalizationReset \
[[LocalizationSystem sharedLocalSystem] resetLocalization]

@interface LocalizationSystem : NSObject

// you really shouldn't care about this functions and use the MACROS
+ (LocalizationSystem *)sharedLocalSystem;

//gets the string localized
- (NSString *)localizedStringForKey:(NSString *)key;

//sets the language
- (void) setLanguage:(NSString*) language;

//gets the current language
- (NSString*) getLanguage;

- (void) setCity:(NSString*) code;

- (NSString*) getCity;

//get branches filters
- (void) setBranchFilters:(NSMutableArray*) filters;

- (NSMutableArray*) getBranchFilters;

//get atms filter
- (void) setAtmFilters:(NSMutableArray*) filters;

- (NSMutableArray*) getAtmFilters;

//resets this system.
- (void) resetLocalization;

@end