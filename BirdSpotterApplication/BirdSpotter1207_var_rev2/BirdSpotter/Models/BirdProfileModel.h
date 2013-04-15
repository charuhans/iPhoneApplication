//
//  BirdProfileModel.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
@class Bird;

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BirdProfileModel : NSObject
{
    
}


//Static methods.
+ (void) getDataFromDB:(NSString *)dbPath;
+ (void) finalizeStatements;

+(void) addBirdToDB:(Bird*)b;
+(void) removeBirdFromDB:(int)dbID;
+(NSString*) getBirdBookImg:(int)birdID;
+(int) getBirdIdFromName:(NSString*)name;
+(Bird*) getBirdFromId:(int)birdID;
+(NSString*) getStatusInformation:(int)status;

@end
