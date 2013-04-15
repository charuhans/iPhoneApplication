//
//  HotSpot.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HotSpot : NSObject <MKAnnotation>
{
    int hsID;
    int cityID;
    NSString *name;
    NSMutableArray *birdArray;
    CLLocationCoordinate2D coordinate;
    CLLocationCoordinate2D userCoordinate;
    NSString* distanceFromUser;
}

@property (assign) int hsID;
@property (assign) int cityID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *birdArray;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (assign) NSString* distanceFromUser;


- (id)initWithName:(NSString*)n birdArray:(NSMutableArray*)birds coordinate:(CLLocationCoordinate2D) loc userCord:(CLLocationCoordinate2D)usrCord hspotID:(int)h cityID:(int)c;
//- (id)initWithName:(NSString*)n coordinate:(CLLocationCoordinate2D)loc hspotID:(int)h cityID:(int)c;
- (NSString *)title;
//- (NSString*)subtitle;
-(double) getDistanceFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;
@end
