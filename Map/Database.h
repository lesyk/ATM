#import <Foundation/Foundation.h>
#import "City.h"
#import "/usr/include/sqlite3.h"

@interface Database : NSObject{
    sqlite3 *sqlite_db;
}

+(Database *)database;

-(NSMutableArray *)getAllCities;
-(City *)getCityByCode:(NSString*)code;

-(NSMutableArray *)getAllWithWhereArray:(NSMutableArray*)array:(NSString*)from;

-(NSMutableArray *)getAllServices:(NSString*)from:(int)category;

-(NSMutableArray *)getAllServicesCategories:(NSString*)from;


@end
