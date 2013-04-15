//
//  FishBankModel.m
//  HW1_Newton
//
//  Created by Varun Varghese on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HW3_NEWTONAppDelegate.h"
#import "FishBankModel.h"

static sqlite3      *database   = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt    = nil;
static sqlite3_stmt *updatestmt = nil;
static sqlite3_stmt *getcounter = nil;
static sqlite3_stmt *updateDB   = nil;

@implementation FishBankModel

@synthesize fish_category, fish_counter, fish_name;

-(id)initWithName:(NSString*)inputFishName andCategory:(NSString*) inputFishCategory count:(NSInteger)fcounter
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.fish_category = inputFishCategory;
        self.fish_name     = inputFishName;
        self.fish_counter  = fcounter;
    }
    
    return self;
}

-(void) dealloc
{
    [fish_name release];
    [fish_category release];
    [super dealloc];
}

+(void) truncateTable:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "DELETE FROM fish_bank"; //truncate
        char* errorMsg;
        
        if (sqlite3_exec(database, sql, NULL, NULL, &errorMsg)!= SQLITE_OK) {
            NSLog(@"Error: %s", errorMsg);
        }
    }
}

+(void) addFishToFishBank:(NSString*) inputFishName andFishCategory:(NSString*) inputFishCategory dbPath:(NSString*) databasePath
{
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "INSERT INTO fish_bank(fish_category, fish_name) VALUES(?,?)"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(addStmt, 1, [inputFishCategory UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(addStmt, 2, [inputFishName UTF8String],     -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(addStmt))
        {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        }
        else
            
        //Reset the add statement.
        sqlite3_reset(addStmt);
    }
}

+(void) removeFishFromTable:(NSString*)name dbPath:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        if(deleteStmt == nil) 
        {
            const char *sql = "DELETE FROM fish_bank WHERE fish_name = ?";
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

+(void)updateFishBankDB:(NSString *)dbPath name:(NSString *)fishName andChange:(int)change
{
    NSInteger counter;
    NSString* category;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        if(getcounter == nil)
        {
            const char *sql = "SELECT fish_category, fish_counter FROM fish_bank where fish_name = ?";
        
            if(sqlite3_prepare_v2(database, sql, -1, &getcounter, NULL) != SQLITE_OK)        
            {
                NSAssert1(0, @"Error while creating getcounter statement. '%s'", sqlite3_errmsg(database));
            }
        }
            
        sqlite3_bind_text(getcounter, 1, [fishName UTF8String], -1, SQLITE_TRANSIENT);
            
        while(sqlite3_step(getcounter) == SQLITE_ROW) 
        {     
        
            category = [NSString stringWithUTF8String:(char*)sqlite3_column_text(getcounter, 0)];
            counter =  (NSInteger)sqlite3_column_int(getcounter, 1);
        }
        sqlite3_reset(getcounter);
        
        //===============================================================================
        //also update the array that we hold for fish bank in app delegate
        HW3_NEWTONAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        int index;
        
        NSEnumerator *e = [appDelegate.fishBankArray objectEnumerator];
        id item;
        while (item = [e nextObject]) 
        {
            if([fishName isEqualToString:[NSString stringWithFormat:@"%@",[item fish_name]]])
            {
                index = [appDelegate.fishBankArray indexOfObject:item];
            }
        }        
        
        
        FishBankModel *replacewith = [[FishBankModel alloc]initWithName:fishName andCategory:category count:counter+change]; 
        [appDelegate.fishBankArray replaceObjectAtIndex:index withObject:replacewith];
        
        
        //updation
        if(updatestmt == nil) 
        {
            const char *sql = "UPDATE fish_bank set fish_counter = ? where fish_name = ?";
            if(sqlite3_prepare_v2(database, sql, -1, &updatestmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
            }
        }
        //===============================================================================
        
        counter = counter+change;
        NSString* newcounterStr = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d", counter] ];
              
        sqlite3_bind_text(updatestmt, 2, [fishName UTF8String],      -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updatestmt, 1, [newcounterStr UTF8String], -1, SQLITE_TRANSIENT);
        
        if (SQLITE_DONE != sqlite3_step(updatestmt))
        {
            NSAssert1(0, @"Error while updation. '%s'", sqlite3_errmsg(database));
        }        
        sqlite3_reset(updatestmt);
        
        
    }
}

+(void) getDataFromDB:(NSString *)dbPath
{
    HW3_NEWTONAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.fishBankArray count] > 0) 
    {
        [appDelegate.fishBankArray removeAllObjects];
    }
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT * FROM fish_bank";
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                NSString *newCategory   = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 0)];
                NSString *newName       = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
                NSInteger counter       = (NSInteger)sqlite3_column_int(selectstmt, 2);
                
                
                FishBankModel *fishBankObj = [[FishBankModel alloc] initWithName:newName andCategory:newCategory count:counter];
                
                [appDelegate.fishBankArray addObject:fishBankObj];
                [fishBankObj release];
            }
        }
    }
}

+(void) finalizeStatements
{
    if(database) sqlite3_close(database);
    if(deleteStmt) sqlite3_finalize(deleteStmt);
    if(addStmt) sqlite3_finalize(addStmt);
    if(getcounter) sqlite3_finalize(getcounter);
    if(updatestmt) sqlite3_finalize(updatestmt);
}

+(void) updateDB:(NSString*)inputFishCategory andFishName:(NSString*) inputFishName dbPath:(NSString*)dbPath
{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "UPDATE fish_bank set fish_category = ? where fish_name = (?)"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &updateDB, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(updateDB, 1, [inputFishCategory UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateDB, 2, [inputFishName UTF8String], -1, SQLITE_TRANSIENT);
        
        if(SQLITE_DONE != sqlite3_step(updateDB))
        {
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        }
        else
        {
            //success = TRUE;
        }
        
        //Reset the add statement.
        sqlite3_reset(updateDB);
    }
}
@end
