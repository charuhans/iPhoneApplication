//
//  MenuViewController.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define DEFAULT_LATITUDE 29.814434
#define DEFAULT_LONGITUDE -95.361328

#import "MenuViewController.h"
#import "BirdBookTableViewController.h"
#import "HotspotMapViewController.h"
#import "UserPreferences.h"
#import "Location.h"
#import "GeoLocationHelperModel.h"
#import "MultipleViewController.h"
#import "PhotoGallery.h"
#import "Selecter.h"


@implementation MenuViewController

@synthesize birdBookVC;
@synthesize hotSpotVC;
@synthesize appDelegate;
@synthesize locationPopUp;
@synthesize locationManager;
@synthesize latitude, longitude;
@synthesize cityString;
@synthesize birdGalleryVC;
@synthesize citySelectorVC;
@synthesize selecterVC;
//@synthesize userLocation;

@synthesize multiVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    BirdBookTableViewController *bbVC = [[BirdBookTableViewController alloc] initWithNibName:@"BirdBookTableViewController" bundle:[NSBundle mainBundle]];
    self.birdBookVC = bbVC;
    [bbVC release];
    
    HotspotMapViewController *hsptVC = [[HotspotMapViewController alloc] initWithNibName:@"HotspotMapViewController" bundle:[NSBundle mainBundle]];
    self.hotSpotVC = hsptVC;
    [hsptVC release];
    
    PhotoGallery *bgVC = [[PhotoGallery alloc] initWithNibName:@"PhotoGallery" bundle:[NSBundle mainBundle]];
    self.birdGalleryVC = bgVC;
    [bgVC release];
    
    MultipleViewController *mVC = [[MultipleViewController alloc] initWithNibName:@"MultipleViewController" bundle:[NSBundle mainBundle]];
    self.multiVC = mVC;
    [mVC release];      
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cityString = @"Houston";
        latitude = DEFAULT_LATITUDE;
        longitude = DEFAULT_LONGITUDE;
    }
    return self;
}
-(void)dealloc{
    //my addition
    [multiVC release];
    [birdGalleryVC release];
    //[locationManager release];
    [cityString release];
    [birdBookVC release];
    [hotSpotVC release];
    [citySelectorVC release];
    [selecterVC release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //based on app setting, set location pref
    if ([UserPreferences allowLocationSetting]) 
    {
        NSLog(@"Location Service Setting Enable");
        //[UserPreferences setPreferences:TRUE popup:[UserPreferences locationPopupDisplayed]];
        [UserPreferences setPreferences:TRUE popup:TRUE];
        
        NSLog(@"User allows Location Service");
        // Initialization code here.
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"Location Service Setting Disable");
        //[UserPreferences setPreferences:FALSE popup:[UserPreferences locationPopupDisplayed]];
        //[UserPreferences setPreferences:FALSE popup:FALSE];
        
        if (![UserPreferences locationPopupDisplayed]) 
        {
            locationPopUp = [[UIAlertView alloc] initWithTitle:@"BirdSpotter would like to use your Location." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            
            [locationPopUp show];
            [locationPopUp release];
        }
        [UserPreferences setPreferences:FALSE popup:TRUE];
    }
    
    
    
    
    /*
    //based on user location service pref, do the following
    if (![UserPreferences allowLocationService])
    {
        NSLog(@"No Location Service");
        //load popup for user confirmation
        if (![UserPreferences locationPopupDisplayed]) 
        {
            locationPopUp = [[UIAlertView alloc] initWithTitle:@"BirdSpotter would like to use your Location." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            
            [locationPopUp show];
            [locationPopUp release];
        }
        
        //present a picker to user to select city
        //get coordinates from city table from db
        
        /*
        latitude = appDelegate.userLatitude;
        longitude = appDelegate.userLongitude;
        NSLog(@"Lat: %f, Long: %f\n",latitude,longitude);
        [self reverseGeocode];*/
    /*}*/
    /*else
    {
        NSLog(@"User allows Location Service");
        // Initialization code here.
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
    }*/
    
    /*
    // Initialization code here.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
     */
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"Start updating location %f, %f", newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;
    
    [self reverseGeocode];
}
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location Mngr Errored: %@", [error description]);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) 
    {
        //NSLog(@"user pressed Cancel");
		[UserPreferences setPreferences:FALSE popup:TRUE];
        
        //citySelectorVC = [[CitySelectorViewController alloc] initWithNibName:@"CitySelectorViewController" bundle:nil];
       //[self.view addSubview:citySelectorVC.view];
        
        selecterVC = [[Selecter alloc] initWithNibName:@"Selecter" bundle:nil];
        selecterVC.view.frame = CGRectMake(0, 200, selecterVC.view.frame.size.width, selecterVC.view.frame.size.height);  

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:3.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:selecterVC.view cache:YES];
        [self.view addSubview:selecterVC.view];
        [UIView commitAnimations];

	}
	else 
    {
        [UserPreferences setPreferences:TRUE popup:TRUE];
        NSLog(@"User allows Location Service");
        // Initialization code here.
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
	}
}
#pragma reversegeocoder
- (void)reverseGeocode{
    CLLocationCoordinate2D userLocation;
    userLocation.latitude = latitude;
    userLocation.longitude = longitude;
    
    self.appDelegate.userCoordinate = userLocation;
    
    // Instanciate the reverse geocoder and set the coordinate which should be geocoded
    MKReverseGeocoder* reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:userLocation];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}
- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFindPlacemark:(MKPlacemark*)placemark{
    cityString = [placemark.addressDictionary objectForKey:@"City"];
    //NSString* streetString = [placemark.addressDictionary objectForKey:@"Street"];
    //NSString* zipCodeString = [placemark.addressDictionary objectForKey:@"ZIP"];
    NSLog(@"City: %@", cityString);
    
    //[GeoLocationHelperModel getHotspotsForCity:cityString];    
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	NSLog(@"Reverse Geocoder Errored: %@", [error description]);
    
    //[GeoLocationHelperModel getHotspotsForCity:[NSString stringWithString:@"Houston"]]; 
    cityString = @"Houston"; 
}
#pragma iBOutlets
- (IBAction)openBirdBook:(id)sender {
    if (![UserPreferences allowLocationService])
    {
        BirdSpotterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        cityString = appDelegate.cityString;
        latitude = appDelegate.userLatitude;
        longitude = appDelegate.userLongitude;
        NSLog(@"Lat: %f, Long: %f\n",latitude,longitude);
        [self reverseGeocode];
        NSLog(@"city string for hs: %@", appDelegate.cityString);
    }
    [GeoLocationHelperModel getHotspotsForCity:cityString];    
    [multiVC setVCIndex:1];
    [self presentModalViewController:multiVC animated:NO];
}
- (IBAction)openHotSpots:(id)sender {
    if (![UserPreferences allowLocationService])
    {
        BirdSpotterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        cityString = appDelegate.cityString;
        latitude = appDelegate.userLatitude;
        longitude = appDelegate.userLongitude;
        NSLog(@"Lat: %f, Long: %f\n",latitude,longitude);
        [self reverseGeocode];
        NSLog(@"city string for hs: %@", appDelegate.cityString);
    }
    
    [GeoLocationHelperModel getHotspotsForCity:cityString];  
    
    [multiVC setVCIndex:2];
    [self presentModalViewController:multiVC animated:NO];
}
- (IBAction)openGallery:(id)sender  {
    if (![UserPreferences allowLocationService])
    {
        BirdSpotterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        cityString = appDelegate.cityString;
        latitude = appDelegate.userLatitude;
        longitude = appDelegate.userLongitude;
        NSLog(@"Lat: %f, Long: %f\n",latitude,longitude);
        [self reverseGeocode];
        NSLog(@"city string for hs: %@", appDelegate.cityString);
    }
    [GeoLocationHelperModel getHotspotsForCity:cityString]; 
    [multiVC setVCIndex:3];;
    [self presentModalViewController:multiVC animated:NO];
}



@end
