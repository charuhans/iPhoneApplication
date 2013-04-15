//
//  FishStoreModel.h
//  HW1_Newton
//
//  Created by Varun Varghese on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FishStoreModel : NSObject
{
    NSString *fish_name;
    NSString *fish_path;
    NSInteger motion_pattern;
    NSString *motion_pattern_description;
    
    BOOL group_motion;
    NSString* fish_category;
}

@property (nonatomic, retain) NSString *fish_name;
@property (nonatomic, retain) NSString *fish_path;
@property (assign) NSInteger motion_pattern;
@property (nonatomic, retain) NSString *motion_pattern_description;

@property (nonatomic, retain) NSString* fish_category;
@property (assign) BOOL group_motion;


-(id)initWithName:(NSString *) inputFishName image:(NSString *)inputFishPath 
          pattern:(NSInteger)inputMotionPattern patternDesc:(NSString *)inputPatternDesc groupMotion:(BOOL) inputGoupMotion
          fishCategory:(NSString*) inputFishCategory;

+(void) getDataFromDB:(NSString *)dbPath;
+(void) addFishToFishStore:(NSString*)inputFishCategory andMotion:(NSInteger) inputMotion andFishGroup:(NSString*) 
        inputGroup andFishName:(NSString*) inputFishName andFishPath:(NSString*) inputFishPath dbPath:(NSString*)dbPath;
+(void) removeFishFromFishStore:(NSString*)name dbPath:(NSString*)dbPath;
+(void) finalizeStatements;
+(void) truncateTable:(NSString*)dbPath;

+(NSString*) getImagePath:(NSString *)dbPath andName:(NSString*) name;

+ (NSString*) getGroupMotionFromDB:(NSString *)dbPath andName:(NSString*) name;
+ (NSInteger) getMotionFromDB:(NSString *)dbPath andName:(NSString*) name;
+(void) updateDB:(NSString*)inputFishCategory andMotion:(NSInteger) inputMotion andFishGroup:(NSString*) 
inputGroup andFishName:(NSString*) inputFishName andFishPath:(NSString*) inputFishPath dbPath:(NSString*)dbPath;
@end
