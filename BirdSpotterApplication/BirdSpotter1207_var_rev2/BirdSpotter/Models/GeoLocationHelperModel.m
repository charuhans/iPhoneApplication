//
//  GeoLocationHelperModel.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
static sqlite3 *database = nil;


#import "GeoLocationHelperModel.h"
#import "HotSpot.h"

@implementation GeoLocationHelperModel

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(int)getCityIdFromName:(NSString*)name
{
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    int cityID = 0;
    sqlite3_stmt *selectCityStmt = nil;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        //select city id from name
        if(selectCityStmt == nil) 
        {
            
            const char *sql = "SELECT id FROM city WHERE name = ?";
            if(sqlite3_prepare_v2(database, sql, -1, &selectCityStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating selectCityStmt. '%s'", sqlite3_errmsg(database));
            }
            
            sqlite3_bind_text(selectCityStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            if(sqlite3_step(selectCityStmt) == SQLITE_ROW) 
            {
                //get city id
                cityID  = sqlite3_column_int(selectCityStmt, 0);
                //NSLog(@"City ID from DB: %d",cityID);
            }
            sqlite3_finalize(selectCityStmt);
            
        }
        sqlite3_close(database);
    }
    else
        sqlite3_close(database);
    
    return cityID;
}

+(void)getHotspotsForCity:(NSString*)name
{
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([[appDelegate hotSpotArray]count] > 0) 
    {
        [[appDelegate hotSpotArray] removeAllObjects];
    }
    
    int cityID = [self getCityIdFromName:name];
    sqlite3_stmt *selectHotSpotStmt = nil;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        //select hotspots for the given city
        if(selectHotSpotStmt == nil) 
        {
            const char *sql = "SELECT * FROM hot_spots WHERE city_id = ?";
            if(sqlite3_prepare_v2(database, sql, -1, &selectHotSpotStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating selectHotSpotStmt. '%s'", sqlite3_errmsg(database));
            }
            
            sqlite3_bind_int(selectHotSpotStmt, 1, cityID);
            while(sqlite3_step(selectHotSpotStmt) == SQLITE_ROW) 
            {
                int hsID = sqlite3_column_int(selectHotSpotStmt, 0);
                int cityID = sqlite3_column_int(selectHotSpotStmt, 1);
                
                CLLocationCoordinate2D coord;
                coord.latitude = sqlite3_column_double(selectHotSpotStmt, 2);
                coord.longitude = sqlite3_column_double(selectHotSpotStmt, 3);
                
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectHotSpotStmt, 4)];
                //NSLog(@"HSarray: HS name from DB: %@",name);
                
                HotSpot *hs = [[HotSpot alloc] initWithName:name birdArray:[self getBirdsForHS:hsID] coordinate:coord userCord:appDelegate.userCoordinate hspotID:hsID cityID:cityID];
                [appDelegate.hotSpotArray addObject:hs];
            }
            sqlite3_finalize(selectHotSpotStmt);
        }
        sqlite3_close(database);
    }
    else
        sqlite3_close(database);
}

+(NSMutableArray*)getBirdsForHS:(int)hdID
{
    NSMutableArray *birds = [[NSMutableArray alloc] init];
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    sqlite3_stmt *selecBirdsForHsStmt = nil;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        if(selecBirdsForHsStmt == nil) 
        {
            const char *sql = "SELECT bird_profile.name FROM bird_profile,bird_hotspots WHERE bird_profile.id = bird_hotspots.bird_id AND bird_hotspots.hotspot_id = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &selecBirdsForHsStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating selecBirdsForHsStmt. '%s'", sqlite3_errmsg(database));
            }
            
            sqlite3_bind_int(selecBirdsForHsStmt, 1, hdID);
            while(sqlite3_step(selecBirdsForHsStmt) == SQLITE_ROW) 
            {
                //NSLog(@"HS ID: %d, Bird: %@", hdID, [NSString stringWithUTF8String:(char*)sqlite3_column_text(selecBirdsForHsStmt, 0)]);
                [birds addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(selecBirdsForHsStmt, 0)]];
            }
            
            sqlite3_finalize(selecBirdsForHsStmt);
        }
        sqlite3_close(database);
    }
    else
        sqlite3_close(database);
    
    return birds;
}

+(CLLocationCoordinate2D)getCoordinatesFor:(NSString*)city
{
    CLLocationCoordinate2D location;
    location.latitude = 0.0f;
    location.longitude = 0.0f;
    
   BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    sqlite3_stmt *selecCoordForCity = nil;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        if(selecCoordForCity == nil) 
        {
            const char *sql = "SELECT * FROM city WHERE name = ?";
            
            if(sqlite3_prepare_v2(database, sql, -1, &selecCoordForCity, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating selecCoordForCity. '%s'", sqlite3_errmsg(database));
            }
            //NSLog(@"city: %@",city);
            sqlite3_bind_text(selecCoordForCity, 1, [city UTF8String], -1, SQLITE_TRANSIENT);
            while(sqlite3_step(selecCoordForCity) == SQLITE_ROW) 
            {
                location.latitude = sqlite3_column_double(selecCoordForCity, 3);
                location.longitude = sqlite3_column_double(selecCoordForCity, 4);
            }
            
            sqlite3_finalize(selecCoordForCity);
        }
        sqlite3_close(database);
    }
    else
        sqlite3_close(database);
    
    return location;
}

@end
