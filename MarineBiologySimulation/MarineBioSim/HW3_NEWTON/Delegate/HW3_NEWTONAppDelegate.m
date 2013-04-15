//
//  HW3_NEWTONAppDelegate.m
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HW3_NEWTONAppDelegate.h"
#import "FishStoreModel.h"
#import "FishBankModel.h"
#import "FishTankModel.h"
#import "MenuViewController.h"

//===
#import "fishWebViewContoller.h"

@implementation HW3_NEWTONAppDelegate

@synthesize menuVC;
@synthesize window=_window;
@synthesize fishBankArray, fishTankArray, fishStoreArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Copy database to the user's phone if needed.
    [self copyDatabaseIfNeeded];
    
    //Initialize the fish store array.
    NSMutableArray *tempStoreArray = [[NSMutableArray alloc] init];
    self.fishStoreArray = tempStoreArray;
    [tempStoreArray release];
    
    //Initialize the fish bank array.
    NSMutableArray *tempBankArray = [[NSMutableArray alloc] init];
    self.fishBankArray = tempBankArray;
    [tempBankArray release];
    
    //Initialize the fish bank array.
    NSMutableArray *tempTankArray = [[NSMutableArray alloc] init];
    self.fishTankArray = tempTankArray;
    [tempTankArray release];
    
    //clear up all the data from the database if available
    [FishStoreModel truncateTable:[self getDBPath]];
    [FishBankModel truncateTable:[self getDBPath]];
    [FishTankModel truncateTable:[self getDBPath]];
    
    //Once the db is copied, get the DB contents.
    [FishStoreModel getDataFromDB:[self getDBPath]];
    [FishBankModel  getDataFromDB:[self getDBPath]];
    [FishTankModel  getDataFromDB:[self getDBPath]];
    
    
    MenuViewController *mViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
    self.menuVC = mViewController;    
    
    self.window.rootViewController = self.menuVC;
    //[_window addSubview:mViewController.view];    
    
    [mViewController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void) copyDatabaseIfNeeded 
{
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) 
    {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FishDB.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
        {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
    }
    else
    {
        NSLog(@"Database created successfully");
    }
}
- (NSString *) getDBPath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"FishDB.sqlite"];
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (void)dealloc
{
    [fishBankArray release];
    [fishStoreArray release];
    [fishTankArray release];
    [menuVC release];
    [_window release];
    [super dealloc];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
