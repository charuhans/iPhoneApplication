//
//  GPS.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    double latitude;
    double longitude;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (assign) double latitude;
@property (assign) double longitude;

-(void)initWithLatitude:(double)lat andLongitude:(double)lon;
-(double) getLatitude;
-(double) getLongitude;

@end
