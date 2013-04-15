//
//  BirdProfileModel.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

static sqlite3 *database = nil;

#import "BirdProfileModel.h"
#import "Bird.h"

@implementation BirdProfileModel


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

-(void) dealloc
{
    
    [super dealloc];
}

//Static methods.
+ (void) getDataFromDB:(NSString *)dbPath
{
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    //clear the array
        
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        //const char *sql = "SELECT fish_name, fish_image, motion_pattern FROM fish_store";
        /*NSString *sqlString = @"SELECT * FROM bird_profile image_name FROM bird_images WHERE id.bird_profile = bird_id.bird_images AND type.bird_images = '1'";*/
        /*NSString *sqlString = @"SELECT bird_profile.id,name, status,habitat,food,calender_migration,mating_season,trivia,notes,audio_file,profile_pic, image_name FROM bird_profile, bird_images WHERE bird_profile.id = bird_images.bird_id AND bird_images.type = ?";*/
       
        NSString *sqlString = @"SELECT * FROM bird_profile";
        sqlite3_stmt *selectstmt;
        
        if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                int birdID = sqlite3_column_int(selectstmt, 0);
                NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
                int status = sqlite3_column_int(selectstmt, 2);
                NSString *habitat = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 3)];
                NSString *food = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 4)];
                NSString *migration = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 5)];
                NSString *mating = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
                NSString *trivia = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 7)];
                NSString *notes = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 8)];
                NSString *audio = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 9)];
                NSString *profilePic = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 10)];
                NSString *birdbookPic = [self getBirdBookImg:birdID];
                //NSLog(@"%d", birdID);
               //NSLog(@"%@", birdbookPic);
                
                Bird *birdObj = [[Bird alloc] initWithID:birdID name:name status:status habitat:habitat food:food cMigration:migration mating:mating trivia:trivia notes:notes audio:audio profileImg:profilePic bBookImg:birdbookPic];
                
                [appDelegate.birdProfileArray addObject:birdObj];
                [birdObj release];
            }
        }
    }
    else
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the m
}

+ (void) finalizeStatements
{
    if(database) sqlite3_close(database);
}

+(void) addBirdToDB:(Bird*)b
{
    //
}

+(void) removeBirdFromDB:(int)dbID
{
    //
}

+(NSString*) getBirdBookImg:(int)birdID
{
    NSString *img = @"bird1.png";
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    sqlite3_stmt *selectstmt;

    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT image_name FROM bird_images WHERE bird_id = ? AND type = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) != SQLITE_OK) 
        {
            NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_bind_int(selectstmt, 1, birdID);
        sqlite3_bind_int(selectstmt, 2, 1);
        
        while(sqlite3_step(selectstmt) == SQLITE_ROW) 
        {
            img = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 0)];
        }
    }
    else
        sqlite3_close(database);
    //NSLog(@"%d, %@", birdID, img);
    return  img;
}

+(int) getBirdIdFromName:(NSString*)name
{
    int result = 0;
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    sqlite3_stmt *selectstmt;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT id FROM bird_profile WHERE name = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) != SQLITE_OK) 
        {
            NSAssert1(0, @"Error while creating get bird from id statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_bind_text(selectstmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        
        while(sqlite3_step(selectstmt) == SQLITE_ROW) 
        {
            result = sqlite3_column_int(selectstmt, 0);
        }
    }
    else
        sqlite3_close(database);
    
    return  result;
}

+(Bird*) getBirdFromId:(int)birdID
{
    Bird* result = [[[Bird alloc]init]autorelease];
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    sqlite3_stmt *selectstmt;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT * FROM bird_profile WHERE id = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) != SQLITE_OK) 
        {
            NSAssert1(0, @"Error while creating get bird from id statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_bind_int(selectstmt, 1, birdID);
        
        while(sqlite3_step(selectstmt) == SQLITE_ROW) 
        {
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
            int status = sqlite3_column_int(selectstmt, 2);
            NSString *habitat = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 3)];
            NSString *food = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 4)];
            NSString *migration = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 5)];
            NSString *mating = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
            NSString *trivia = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 7)];
            NSString *notes = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 8)];
            NSString *audio = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 9)];
            NSString *profilePic = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 10)];
            NSString *birdbookPic = [self getBirdBookImg:birdID];
            
            NSLog(@"Name = %@ audio = %@",name, audio);
            
            result = [[Bird alloc]initWithID:birdID name:name status:status habitat:habitat food:food cMigration:migration mating:mating trivia:trivia notes:notes audio:audio profileImg:profilePic bBookImg:birdbookPic];
        }
    }
    return result;
}

+(NSString*) getStatusInformation:(int)status
{
    NSString *statusDescription = @"Least Concern";
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    sqlite3_stmt *selectstmt;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT description FROM status_description WHERE id = ?";
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) != SQLITE_OK) 
        {
            NSAssert1(0, @"Error while selecting status. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_bind_int(selectstmt, 1, status);
        
        if(sqlite3_step(selectstmt) == SQLITE_ROW) 
        {
            statusDescription = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 0)];
        }
    }
    else
        sqlite3_close(database);
    //NSLog(@"%d, %@", birdID, img);
    return  statusDescription;

}

@end
