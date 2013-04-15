//
//  GeoLocationHelperModel.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class HotSpot;

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoLocationHelperModel : NSObject
{

}

+(int)getCityIdFromName:(NSString*)name;
+(void)getHotspotsForCity:(NSString*)name;
+(NSMutableArray*)getBirdsForHS:(int)hdID;
+(CLLocationCoordinate2D)getCoordinatesFor:(NSString*)city;

@end
