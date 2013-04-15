//
//  GPS.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize locationManager;
@synthesize latitude, longitude;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
    }
    
    return self;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Start updating location");
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    NSLog(@"LATITUDE: %f, Longitude: %f",latitude,longitude);
}

-(void)dealloc
{
    [locationManager release];
    [super dealloc];
}

-(double) getLatitude
{
    return self.latitude;
}
-(double) getLongitude
{
    return self.longitude;
}

@end
