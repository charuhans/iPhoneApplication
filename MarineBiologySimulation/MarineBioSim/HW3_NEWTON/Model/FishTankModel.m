#import "FishTankModel.h"
#import "FishStoreModel.h"
#import "FishTankInfo.h"
#import "SimulationViewController.h"
#import "MenuViewController.h"
#import "HW3_NEWTONAppDelegate.h"

static sqlite3      *database       = nil;
static sqlite3_stmt *deleteStmt     = nil;
static sqlite3_stmt *addStmt        = nil;
static sqlite3_stmt *isPresentStmt  = nil;
static sqlite3_stmt *removeOnTap    = nil;
static sqlite3_stmt *updateDB       = nil;
static sqlite3_stmt *updateposition = nil;

@implementation FishTankModel

@synthesize fish_category, xCord, yCord, head_direction, fish_group, fish_name;

-(id)initWithName:(NSString*)c xcord:(int)x ycord:(int)y headDir:(int)h group:(NSString*)g name:(NSString*)n
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.fish_category = c;
        self.xCord = x;
        self.yCord = y;
        self.head_direction = h;
        self.fish_group = g;
        self.fish_name = n;
    }
    
    return self;
}
+(void) updatePositionOfFishes:(FishTankInfo*) fishInfo andPath:(NSString*) dbPath{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "UPDATE fish_tank set x = ?, y = ?, head_direction = ? where fish_category = ?"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &updateposition, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating updating position statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_int (updateposition,  1, fishInfo.location.x);
        sqlite3_bind_int (updateposition,  2, fishInfo.location.y);
        sqlite3_bind_int (updateposition,  3, fishInfo.directionHead);        
        sqlite3_bind_text(updateposition, 2, [fishInfo.fishImg_name UTF8String], -1, SQLITE_TRANSIENT);
        
        
        if(SQLITE_DONE != sqlite3_step(updateposition))
        {
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        }
        
        //Reset the add statement.
        sqlite3_reset(updateposition);
    }
}
+(void) updateDB:(NSString*)category dbPath:(NSString*)dbPath name:(NSString*) name  group:(NSString*) newGroup{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "UPDATE fish_tank set fish_name = ?, fish_group = ? where fish_category = ?"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &updateDB, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(updateDB, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateDB, 2, [newGroup UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateDB, 3, [category UTF8String], -1, SQLITE_TRANSIENT);
        
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
-(void)dealloc{
    [fish_name release];
    [fish_group release];
    [fish_category release];    
    [super dealloc];
}
+(void) truncateTable:(NSString*)dbPath{
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "DELETE FROM fish_tank"; //truncate
        char* errorMsg;
        
        if (sqlite3_exec(database, sql, NULL, NULL, &errorMsg)!= SQLITE_OK) 
        {
            NSLog(@"Error: %s", errorMsg);
        }
    }
}

+(void) addFishToTable:(NSString*)category xcord:(int)x ycord:(int)y headDir:(int)h dbPath:(NSString*)dbPath fishid:(NSInteger)ID  fishGroup:(NSString*) group name:(NSString*) name
{
    if (![self isFishPresent:name dbPath:dbPath]) 
    {
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
        {
            const char *sql = "INSERT INTO fish_tank(fish_id,fish_category,x,y,head_direction,fish_name,fish_group) VALUES(?,?,?,?,?,?,?)"; //insert
            
            if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            
            sqlite3_bind_int (addStmt,  1, ID);
            sqlite3_bind_text(addStmt,  2, [category UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int (addStmt,  3, x);
            sqlite3_bind_int (addStmt,  4, y);
            sqlite3_bind_int (addStmt,  5, h);
            sqlite3_bind_text(addStmt,  6, [name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt,  7, [group UTF8String], -1, SQLITE_TRANSIENT);
            
            if(SQLITE_DONE != sqlite3_step(addStmt))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }
            
            //Reset the add statement.
            sqlite3_reset(addStmt);
        }
    }
}

+(void) removeFishFromTable:(NSString*)name dbPath:(NSString*)dbPath
{
   // if ([self isFishPresent:name dbPath:dbPath]) 
    //{
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
        {
            if(deleteStmt == nil) 
            {
                const char *sql = "DELETE FROM fish_tank WHERE fish_name = ?";
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
    //}

}

+(BOOL) isFishPresent:(NSString*)name dbPath:(NSString*)dbPath
{
    BOOL isPresent = FALSE;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        if(isPresentStmt == nil)
        {
            const char *sql = "SELECT fish_category FROM fish_tank WHERE fish_name = ?";
            if(sqlite3_prepare_v2(database, sql, -1, &isPresentStmt, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating select statement. '%s'", sqlite3_errmsg(database));
            }
            sqlite3_bind_text(isPresentStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(isPresentStmt) == SQLITE_ROW) 
            {
                isPresent = TRUE;
            }
            sqlite3_reset(isPresentStmt);
        }
    }
    
    return isPresent;
}

+(void) getDataFromDB:(NSString *)dbPath
{
    HW3_NEWTONAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.fishTankArray count] > 0) 
    {
        [appDelegate.fishTankArray removeAllObjects];
    }
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT fish_id, fish_category, x, y, head_direction, fish_name, fish_group FROM fish_tank";
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                //NSInteger id_fish = sqlite3_column_double(selectstmt, 0);
                NSString *newCategory   = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
                NSInteger x             = sqlite3_column_double(selectstmt, 2);
                NSInteger y             = sqlite3_column_double(selectstmt, 3);
                NSInteger headDir       = sqlite3_column_int(selectstmt, 4);
                NSString *newName       = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 5)];
                NSString *newGroup      = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
                
                FishTankModel *fishTankObj = [[FishTankModel alloc] initWithName:newCategory xcord:x ycord:y headDir:headDir group:newGroup name:newName];
                [appDelegate.fishTankArray addObject:fishTankObj];
                [fishTankObj release];
            }
        }
    }
}

+(void) getDataFromDBforSimulation:(NSString *)dbPath
{
    HW3_NEWTONAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.menuVC.simVC.arrayOfFishesInTank count] > 0) 
    {
        [appDelegate.menuVC.simVC.arrayOfFishesInTank removeAllObjects];
    }
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT fish_id, fish_category, x, y, head_direction, fish_name, fish_group FROM fish_tank";
        sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                NSInteger id_fish = sqlite3_column_double(selectstmt, 0);
                NSString *newCategory   = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
                NSInteger x             = sqlite3_column_double(selectstmt, 2);
                NSInteger y             = sqlite3_column_double(selectstmt, 3);
                NSInteger headDir       = sqlite3_column_int(selectstmt, 4);
                NSString *newName       = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 5)];
                NSString *newGroup      = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
                
                
                CGPoint location = CGPointMake(x, y);
                NSInteger pattern = [FishStoreModel getMotionFromDB:[appDelegate getDBPath] andName:newCategory];
                NSString* path =  [[NSString alloc] initWithString:[FishStoreModel getImagePath:[appDelegate getDBPath] andName:newName]];
                
                FishTankInfo *fishTankObj = [[FishTankInfo alloc] initWithName:path andLoc:location andDirection:headDir andPattern:pattern andFishID:id_fish andGroup:newGroup];                
                
                [appDelegate.menuVC.simVC.arrayOfFishesInTank addObject:fishTankObj];
                //[fishTankObj release];
            }
        }
    }
}
+(void) finalizeStatements
{
    if(database) sqlite3_close(database);
    if(deleteStmt) sqlite3_finalize(deleteStmt);
    if(addStmt) sqlite3_finalize(addStmt);
    if(isPresentStmt) sqlite3_finalize(isPresentStmt);
}

+(void) removeFishFromTableOnTap:(NSInteger) fishKaID dbPath:(NSString *) path
{
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) 
    {
        if(removeOnTap == nil) 
        {
            const char *sql = "DELETE FROM fish_tank WHERE fish_id = ?";
            if(sqlite3_prepare_v2(database, sql, -1, &removeOnTap, NULL) != SQLITE_OK)
            {
                NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
            }
        }
            
        //When binding parameters, index starts from 1 and not zero.
        sqlite3_bind_int(removeOnTap, 1, fishKaID);
            
        if (SQLITE_DONE != sqlite3_step(removeOnTap))
        {
            NSAssert1(0, @"Error while removing fish on tap from DB. '%s'", sqlite3_errmsg(database));
        }
            
        sqlite3_reset(removeOnTap);
    }
}

@end
