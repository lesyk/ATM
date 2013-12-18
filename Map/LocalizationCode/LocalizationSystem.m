//
//  LocalizationSystem.m
//  Battle of Puppets
//
//  Created by Juan Albero Sanchis on 27/02/10.
//  Copyright Aggressive Mediocrity 2010. All rights reserved.
//

#import "LocalizationSystem.h"
#import "City.h"
#import "Database.h"

@implementation LocalizationSystem

//Singleton instance
static LocalizationSystem *_sharedLocalSystem = nil;
static NSString *lang = nil;
static NSString *city = nil;
static NSMutableArray *branchesFilters = nil;
static NSMutableArray *atmsFilters = nil;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;

+ (LocalizationSystem *)sharedLocalSystem
{
	@synchronized([LocalizationSystem class])
	{
		if (!_sharedLocalSystem){
			[[self alloc] init];
		}
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([LocalizationSystem class])
	{
		NSAssert(_sharedLocalSystem == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedLocalSystem = [super alloc];
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}


- (id)init
{
    if ((self = [super init])) 
    {
		//empty.
		bundle = [NSBundle mainBundle];
	}
    return self;
}

- (NSString *)localizedStringForKey:(NSString *)key
{
	return [bundle localizedStringForKey:key value:@"" table:nil];
}


- (void) setLanguage:(NSString*) l
{
	
	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
	
	if (path == nil)
		//in case the language does not exists
		[self resetLocalization];
	else
        bundle = [NSBundle bundleWithPath:path];
    
    lang = l;
}

- (NSString*) getLanguage
{

    if (!lang) {
        NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        
        NSString *preferredLang = [languages objectAtIndex:0];
        lang = preferredLang;
    }
	return lang;
}

- (void) setCity:(NSString *)code
{
    city = code;
}

- (NSString *) getCity{
    if (!city) {
        [self setCity:@"kyiv"];
    }
	return city;
}

- (void) setBranchFilters:(NSMutableArray*) filters
{
    branchesFilters = filters;
}

- (NSMutableArray*) getBranchFilters
{
	return branchesFilters;
}

- (void) setAtmFilters:(NSMutableArray*) filters
{
    atmsFilters = filters;
}

- (NSMutableArray*) getAtmFilters
{
    return atmsFilters;
}

- (void) resetLocalization
{
	bundle = [NSBundle mainBundle];
}


@end
