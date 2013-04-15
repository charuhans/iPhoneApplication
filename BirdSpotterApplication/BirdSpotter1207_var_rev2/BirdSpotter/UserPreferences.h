//
//  UserPreferences.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject

+(BOOL)allowLocationService;
+(BOOL)locationPopupDisplayed;
+(BOOL)allowLocationSetting;
+(BOOL)setPreferences:(BOOL)allow popup:(BOOL)popup;
+(void)saveToUserDefaults:(NSString*)key value:(NSString*)valueString;
+(NSString*)retrieveFromUserDefaults:(NSString*)key;

@end
