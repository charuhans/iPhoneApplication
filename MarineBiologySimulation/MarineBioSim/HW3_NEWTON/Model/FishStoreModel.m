//
//  FishStoreModel.m
//  HW1_Newton
//
//  Created by Varun Varghese on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HW3_NEWTONAppDelegate.h"
#import "FishStoreModel.h"

static sqlite3      *database       = nil;
static sqlite3_stmt *deleteStmt     = nil;
static sqlite3_stmt *addStmt        = nil;
static sqlite3_stmt *updatestmt     = nil;
//static sqlite3_stmt *getcounter     = nil;

@implementation FishStoreModel


@synthesize  fish_name;
@synthesize  fish_path;
@synthesize  group_motion;
@synthesize  motion_pattern;
@synthesize  motion_pattern_description;
@synthesize  fish_category;

-(id)initWithName:(NSString *) inputFishName image:(NSString *)inputFishPath pattern:(NSInteger)inputMotionPattern patternDesc:(NSString *)inputPatternDesc groupMotion:(BOOL) inputGoupMotion fishCategory:(NSString*) inputFishCategory;

{
    self = [super init];
    if (self) 
    {
        self.fish_name                  = inputFishName;
        self.fish_path                  = inputFishPath;
        self.motion_pattern             = inputMotionPattern;
        self.motion_pattern_description = inputPatternDesc;
        self.group_motion               = inputGoupMotion;
        self.fish_category              = inputFishCategory;
    }
    
    return self;
}

-(void) dealloc
{
    [fish_name release];
    [fish_path release];
    [fish_category release];
    [motion_pattern_description release];    
    [super dealloc];
}

+(void) truncateTable:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "DELETE FROM fish_store"; //truncate
        char* errorMsg;
        
        if (sqlite3_exec(database, sql, NULL, NULL, &errorMsg)!= SQLITE_OK) {
            NSLog(@"Error: %s", errorMsg);
        }
    }
}

+ (void) getDataFromDB:(NSString *)dbPath 
{
    
    NSLog(@"%@",dbPath);
    
    HW3_NEWTONAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.fishStoreArray count] > 0) 
    {
        [appDelegate.fishStoreArray removeAllObjects];
    }
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        
        NSString *sqlString = @"SELECT fish_name, fish_path, motion, description.pattern_description, fish_category, fish_group FROM fish_store INNER JOIN description ON motion = description.id";
        
        
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
                NSString *newFishName       = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 0)];
                NSString *newFishPath       = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
                NSInteger newMotionPattern  = sqlite3_column_int(selectstmt, 2);
                NSString *newMotionDesc     = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 3)];
                NSString *newFishCategory   = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 4)];
                NSString *newFishGroup      = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 5)];
                
                BOOL isGroup;
                if([newFishGroup isEqualToString:@"YES"])
                {
                    isGroup = YES;
                }
                else
                {
                    isGroup = NO;
                }
                
                FishStoreModel *fishObj     = [[FishStoreModel alloc] initWithName:newFishName image:newFishPath pattern:newMotionPattern patternDesc:newMotionDesc groupMotion:isGroup fishCategory:newFishCategory];
                
                [appDelegate.fishStoreArray addObject:fishObj];
                [fishObj release];
            }
        }
    }
    else
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

+(void) updateDB:(NSString*)inputFishCategory andMotion:(NSInteger) inputMotion andFishGroup:(NSString*) inputGroup andFishName:(NSString*) inputFishName andFishPath:(NSString*) inputFishPath dbPath:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "UPDATE fish_store set fish_category = ?, motion = ?, fish_group = ?, fish_path = ? where fish_name = (?)"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &updatestmt, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        NSLog(@"%@", inputFishPath);
        
        sqlite3_bind_text(updatestmt, 1, [inputFishCategory UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int( updatestmt, 2, inputMotion);
        sqlite3_bind_text(updatestmt, 3, [inputGroup UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updatestmt, 4, [inputFishPath UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updatestmt, 5, [inputFishName UTF8String], -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(updatestmt))
        {
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        }
        else
        {
            //success = TRUE;
        }
        
        //Reset the add statement.
        sqlite3_reset(updatestmt);
    }
}

+(void) addFishToFishStore:(NSString*)inputFishCategory andMotion:(NSInteger) inputMotion andFishGroup:(NSString*) inputGroup andFishName:(NSString*) inputFishName 
               andFishPath:(NSString*) inputFishPath dbPath:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "INSERT INTO fish_store(fish_category, motion, fish_group, fish_name,  fish_path) VALUES(?,?,?,?,?)"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(addStmt, 1, [inputFishCategory UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int( addStmt, 2, inputMotion);
        sqlite3_bind_text(addStmt, 3, [inputGroup UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 4, [inputFishName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 5, [inputFishPath UTF8String], -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
        {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        else
        {
            //success = TRUE;
        }
        //Reset the add statement.
        sqlite3_reset(addStmt);
    }
}
+ (void) finalizeStatements 
{
    if(database) sqlite3_close(database);
}

+(void) removeFishFromFishStore:(NSString*)name dbPath:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        if(deleteStmt == nil) 
        {
            const char *sql = "DELETE FROM fish_store WHERE fish_name = ?";
            if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
            }
        }
        
        //When binding parameters, index starts from 1 and not zero.
        sqlite3_bind_text(deleteStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
        {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_reset(deleteStmt);
    }
}

+ (NSInteger) getMotionFromDB:(NSString *)dbPath andName:(NSString*) name
{
    NSInteger newMotionPattern ;
            
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        
        NSString *sqlString = @"SELECT motion FROM fish_store where fish_name = ?";
        
        
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            //When binding parameters, index starts from 1 and not zero.
            sqlite3_bind_text(selectstmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
                newMotionPattern  = sqlite3_column_int(selectstmt, 0);
            }
        }
        else
        {
            NSAssert1(0, @"Could not get the motion ", sqlite3_errmsg(database));
        }
    }
    else
    {
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
    }
    return newMotionPattern;
}

+(NSString*) getImagePath:(NSString *)dbPath andName:(NSString*) name
{
    NSString* imagePath;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        
        NSString *sqlString = @"SELECT fish_path FROM fish_store where fish_name = ?";
        
        
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            //When binding parameters, index starts from 1 and not zero.
            sqlite3_bind_text(selectstmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
                imagePath  = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 0)];
            }
        }
        else
        {
            NSAssert1(0, @"Could not get the motion ", sqlite3_errmsg(database));
        }
    }
    else
    {
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
    }
    return imagePath; 
}

+ (NSString*) getGroupMotionFromDB:(NSString *)dbPath andName:(NSString*) name
{
    NSString* newGroupMotion;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        
        NSString *sqlString = @"SELECT fish_group FROM fish_store where fish_name = ?";
        
        
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            //When binding parameters, index starts from 1 and not zero.
            sqlite3_bind_text(selectstmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
                newGroupMotion  = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 0)];
            }
        }
        else
        {
            NSAssert1(0, @"Could not get the motion ", sqlite3_errmsg(database));
        }
    }
    else
    {
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
    }
    return newGroupMotion;
}

@end
