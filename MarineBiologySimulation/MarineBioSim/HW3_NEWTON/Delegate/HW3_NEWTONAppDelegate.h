//
//  HW3_NEWTONAppDelegate.h
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class MenuViewController;
@class FishStoreModel;
@class FishBankModel;
@class FishTankModel;
//===
@class fishWebViewContoller;

@interface HW3_NEWTONAppDelegate : NSObject <UIApplicationDelegate> 
{ 
    //Database variables
    NSString *databaseName;
    NSString *databasePath;
    
    MenuViewController *menuVC;
    
    //Arrays to store the fish objects
    NSMutableArray *fishStoreArray;
    NSMutableArray *fishBankArray;
    NSMutableArray *fishTankArray;
    
}

@property (nonatomic, retain) MenuViewController *menuVC;
@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
//@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, retain) NSMutableArray *fishStoreArray;
@property (nonatomic, retain) NSMutableArray *fishBankArray;
@property (nonatomic, retain) NSMutableArray *fishTankArray;

- (NSURL *)applicationDocumentsDirectory;
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

@end
