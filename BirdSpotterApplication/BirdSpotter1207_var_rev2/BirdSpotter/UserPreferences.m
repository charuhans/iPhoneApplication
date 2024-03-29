//
//  UserPreferences.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserPreferences.h"

@implementation UserPreferences

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(BOOL)allowLocationService
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"allowLocationService"];
}

+(BOOL)locationPopupDisplayed
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"locationPopupDisplayed"];
}
+(BOOL)allowLocationSetting
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"allowLocationSetting"];
}

+(BOOL)setPreferences:(BOOL)allow popup:(BOOL)popup
{
    // Set values
    [[NSUserDefaults standardUserDefaults] setBool:allow forKey:@"allowLocationService"];
    [[NSUserDefaults standardUserDefaults] setBool:popup forKey:@"locationPopupDisplayed"];
    //[[NSUserDefaults standardUserDefaults] setBool:popup forKey:@"allowLocationSetting"];
    
    // Return the results of attempting to write preferences to system
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveToUserDefaults:(NSString*)key value:(NSString*)valueString
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:valueString forKey:key];
		[standardUserDefaults synchronize];
	} else {
		NSLog(@"Unable to save %@ = %@ to user defaults", key, valueString);
	}
}

+ (NSString*)retrieveFromUserDefaults:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString* val = nil;
    
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:key];
    
	// TODO: / apparent Apple bug: if user hasn't opened Settings for this app yet (as if?!), then
	// the defaults haven't been copied in yet.  So do so here.  Adds another null check
	// for every retrieve, but should only trip the first time
	if (val == nil) { 
		NSLog(@"user defaults may not have been loaded from Settings.bundle ... doing that now ...");
		//Get the bundle path
		NSString *bPath = [[NSBundle mainBundle] bundlePath];
		NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        
		//Get the Preferences Array from the dictionary
		NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
		NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
		//Loop through the array
		NSDictionary *item;
		for(item in preferencesArray)
		{
			//Get the key of the item.
			NSString *keyValue = [item objectForKey:@"Key"];
            
			//Get the default value specified in the plist file.
			id defaultValue = [item objectForKey:@"DefaultValue"];
            
			if (keyValue && defaultValue) {				
				[standardUserDefaults setObject:defaultValue forKey:keyValue];
				if ([keyValue compare:key] == NSOrderedSame)
					val = defaultValue;
			}
		}
		[standardUserDefaults synchronize];
	}
	return val;
}

@end
