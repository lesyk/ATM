//
//  ObjectsDatabase.m
//  Map
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "MapAnnotation.h"
#import "City.h"
#import "Service.h"
#import "ServicesCategories.h"

@implementation Database

static Database *database;

+(Database *)database{
    if(database == nil){
        database = [[Database alloc] init];
    }
    return database;
}

-(id)init 
{
    self = [super init];
    if(self){
        //database
        [self checkAndCreateDatabase];
        
        // Get the path to the documents directory and append the databaseName
        NSString *databaseName = @"object.sqlite3";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];

        NSString *sqliteDb = databasePath;
        
        if(sqlite3_open([sqliteDb UTF8String], &sqlite_db) != SQLITE_OK){
            NSLog(@"Failed to open db");
        }

    }
    return self;
}

-(void) checkAndCreateDatabase{
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    
    NSString *databaseName = @"object.sqlite3";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    //    [fileManager release];
}

-(City *)getCityByCode:(NSString*)code
{
    City *entry = [[City alloc] init];
    NSString *query =  [[NSString alloc] 
                        initWithFormat:@"SELECT * FROM cities WHERE code = '%@'", code];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlite_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            entry.uniqId = sqlite3_column_int(statement, 0);
            entry.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            entry.latitude = sqlite3_column_double(statement, 2);
            entry.longitude = sqlite3_column_double(statement, 3);
            entry.name_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            entry.code = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            entry.description = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            entry.description_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
        }
        
        sqlite3_finalize(statement);
    }
    
    return entry;
}

-(NSMutableArray *)getAllCities
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM cities";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlite_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            City *city = [[City alloc] init];
            city.uniqId = sqlite3_column_int(statement, 0);
            city.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            city.latitude = sqlite3_column_double(statement, 2);
            city.longitude = sqlite3_column_double(statement, 3);
            city.name_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            city.code = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            city.description = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            city.description_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            
            [returnArray addObject: city];
        }
        sqlite3_finalize(statement);
    }
    return returnArray;
}

-(NSMutableArray *)getAllServices:(NSString*)from:(int)category
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSString *query = [NSMutableString stringWithFormat: @"SELECT * FROM %@ WHERE category = %i", from, category];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlite_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            Service *service = [[Service alloc] init];
            service.uniqId = sqlite3_column_int(statement, 0);
            service.code = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            service.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];;
            service.name_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            service.checked = FALSE;
            
            [returnArray addObject: service];
        }
        sqlite3_finalize(statement);
    }
    return returnArray;
}

-(NSMutableArray *)getAllWithWhereArray:(NSMutableArray*)array:(NSString*)from
{
    NSString *query =  [[NSString alloc] 
                        initWithFormat:@"SELECT * FROM %@", from];
    BOOL first = TRUE;
    for(Service *a in array)
    {
        if (a.checked) {
            if (first) {
                first = FALSE;
                NSString *s = [NSMutableString stringWithFormat: @" WHERE %@ = 1", a.code];    
                query = [NSMutableString stringWithFormat: @"%@ %@", query, s];    
            }else {
                NSString *s = [NSMutableString stringWithFormat: @" AND %@ = 1", a.code];    
                query = [NSMutableString stringWithFormat: @"%@ %@", query, s];    
            }
        }
    }
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlite_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            MapAnnotation *entry = [[MapAnnotation alloc] init];
            entry.uniqId = sqlite3_column_int(statement, 0);
            entry.title_en = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            entry.latitude = sqlite3_column_double(statement, 2);
            entry.longitude = sqlite3_column_double(statement, 3);
            entry.subtitle_en = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            entry.description_en = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            entry.address_en = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            entry.phone = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)];            
            entry.photo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)];            
            entry.phoneS = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 9)];            
            
            entry.title_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            entry.subtitle_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
            entry.description_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
            entry.address_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
            entry.city = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
            [returnArray addObject: entry];
        }
        
        sqlite3_finalize(statement);
    }
    
    return returnArray;
}

-(NSMutableArray *)getAllServicesCategories:(NSString*)from
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSString *query = [NSMutableString stringWithFormat: @"SELECT * FROM %@", from];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlite_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            ServicesCategories *service = [[ServicesCategories alloc] init];
            service.uniqId = sqlite3_column_int(statement, 0);
            service.code = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            service.name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];;
            service.name_ru = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            
            [returnArray addObject: service];
        }
        sqlite3_finalize(statement);
    }
    return returnArray;
}

-(void)dealloc {
//    [super dealloc];
    sqlite3_close(sqlite_db);
}

@end
