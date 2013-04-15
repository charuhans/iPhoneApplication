//
//  HotSpot.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotSpot.h"

@implementation HotSpot

@synthesize hsID, cityID;
@synthesize name;
@synthesize birdArray;
@synthesize coordinate;
@synthesize distanceFromUser;
@synthesize userCoordinate;

/*
- (id)initWithName:(NSString*)n birdArray:(NSMutableArray*)birds coordinate:(CLLocationCoordinate2D)loc
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.name = n;
        birdIDArray = [[NSMutableArray alloc]initWithArray:birds];
        self.coordinate = loc;
    }
    
    return self;
}
 */

//- (id)initWithName:(NSString*)n coordinate:(CLLocationCoordinate2D)loc hspotID:(int)h cityID:(int)c
- (id)initWithName:(NSString*)n birdArray:(NSMutableArray*)birds coordinate:(CLLocationCoordinate2D)loc userCord:(CLLocationCoordinate2D)usrCord hspotID:(int)h cityID:(int)c
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.hsID = h;
        self.cityID = c;
        self.name = n;
        self.coordinate = loc;
        self.userCoordinate = usrCord;
        //self.distanceFromUser = [NSString stringWithFormat:@"%@f", [self getDistanceFrom:userCoordinate to:coordinate]];
        birdArray = [[NSMutableArray alloc]initWithArray:birds];
    }
    
    return self;
}

- (NSString *)title
{
    return self.name;
}
/*
- (NSString*)subtitle
{
    //return self.distanceFromUser;
    return [NSString stringWithFormat:@"%1.1f", [self getDistanceFrom:userCoordinate to:coordinate]];
}*/

-(double) getDistanceFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    /*
     sqrt(x * x + y * y)
     
     where x = 69.1 * (lat2 - lat1)
     and y = 69.1 * (lon2 - lon1) * cos(lat1/57.3)*/
    
    double lat1 =  (M_PI *(from.latitude) / 180);
    double lat2 =  (M_PI *(to.latitude) / 180);
    double lon1 =  (M_PI *(from.longitude) / 180);
    double lon2 =  (M_PI *(to.longitude) / 180);
    /*
    double x = 69.1 * (lat2 - lat1);
    double y = 69.1 * (lon2 - lon1) * cos(lat1/57.3);
    double d = sqrt(x * x + y * y);*/
    //////////////////////
    int R = 6371; // km
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a = sin(dLat / 2) * sin(dLat / 2) + lat1 * lat2 * sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    double d = R * c * 0.621371;
    
    double r = round(d * 100) / 100;
    
    ////////////////////
    /*double distance = 0;
    
    double nRadius = 3963;//6371;//km
    
    
    double nDLat = cos(M_PI *(to.latitude - from.latitude) / 180);
    double nDLon = cos(M_PI *(to.longitude - from.longitude) / 180);
    
    double nLat1 =  cos(M_PI *(from.latitude) / 180);
    double nLat2 =  cos(M_PI *(to.latitude) / 180);
    
    double nA = pow ( sin(nDLat/2), 2 ) + cos(nLat1) * cos(nLat2) * pow ( sin(nDLon/2), 2 );
    
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    distance = (nRadius * nC)/100;*/
    
    NSLog(@"Dist: %f",r);
    return r;
}

@end
