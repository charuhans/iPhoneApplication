//
//  BirdSpotterAppDelegate.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@class MenuViewController;
@class Bird;
@class BirdProfileModel;
@class HotSpot;
//@class MultipleViewController;

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface BirdSpotterAppDelegate : NSObject <UIApplicationDelegate>
{
    MenuViewController* menuVC;
    //MultipleViewController *multipleVC;
    
    //Database variables
    NSString *databaseName;
    NSString *databasePath;
    
    //array to store the bird data
    NSMutableArray *birdProfileArray;
    
    //array to hold hotspots
    NSMutableArray *hotSpotArray;
    
    //array to hold bird gallery
    NSMutableArray *galleryArray;
    
    //popup for location service pref
    //UIAlertView* locationPopUp;
    
    NSString* cityString;
    double userLatitude;
    double userLongitude;
    
    CLLocationCoordinate2D userCoordinate;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) MenuViewController* menuVC;
@property (nonatomic, retain) NSMutableArray *birdProfileArray;
@property (nonatomic, retain) NSMutableArray *hotSpotArray;
@property (nonatomic, retain) NSMutableArray *galleryArray;
@property (nonatomic, retain) NSString* cityString;
@property (assign) double userLatitude;
@property (assign) double userLongitude;

//@property (nonatomic, retain) MultipleViewController *multipleVC;


//@property (nonatomic, retain) UIAlertView* locationPopUp;
@property (assign) CLLocationCoordinate2D userCoordinate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//database init functions
- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

//load user preference
-(void) loadPreferences;

//load a plist for adding information for gallery image
//-(void) loadPlistForGallery;

@end
