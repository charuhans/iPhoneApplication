//
//  MenuViewController.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>


@class UserPreferences;
@class Location;
@class BirdBookTableViewController;
@class HotspotMapViewController;
@class GeoLocationHelperModel;
@class PhotoGallery;
@class CitySelectorViewController;
@class MultipleViewController;
@class Selecter;

@interface MenuViewController : UIViewController <CLLocationManagerDelegate,MKReverseGeocoderDelegate>
{
    BirdBookTableViewController *birdBookVC;
    HotspotMapViewController *hotSpotVC;
    PhotoGallery *birdGalleryVC;
    CitySelectorViewController *citySelectorVC;
    Selecter *selecterVC;
    
    //app delegate
    BirdSpotterAppDelegate* appDelegate;
    
    //popup for location service pref
    UIAlertView* locationPopUp;
    
    //Location
    CLLocationManager *locationManager;
    
    //user location
    //CLLocationCoordinate2D userLocation;
    
    //
    double latitude;
    double longitude;
    
    //CLLocationCoordinate2D userCoordinate;   
    
    NSString* cityString;
    
    
    //my addition
    IBOutlet MultipleViewController *multiVC;
}

//==========
//my addition
@property(nonatomic,retain) IBOutlet MultipleViewController *multiVC;
//=======


@property (nonatomic, retain) BirdBookTableViewController *birdBookVC;
@property (nonatomic, retain) HotspotMapViewController *hotSpotVC;
@property (nonatomic, retain) PhotoGallery *birdGalleryVC;
@property (nonatomic, retain) CitySelectorViewController *citySelectorVC;
@property (nonatomic, retain) Selecter *selecterVC;
@property (nonatomic, retain) UIAlertView* locationPopUp;
@property (nonatomic, retain) BirdSpotterAppDelegate* appDelegate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString* cityString;

//@property (assign) CLLocationCoordinate2D userLocation;
@property (assign) double latitude;
@property (assign) double longitude;
//@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;

- (IBAction)openBirdBook:(id)sender;
- (IBAction)openHotSpots:(id)sender;
- (IBAction)openGallery:(id)sender;

- (void)reverseGeocode;

@end
