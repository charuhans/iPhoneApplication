//
//  FishBankModel.h
//  HW1_Newton
//
//  Created by Varun Varghese on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FishBankModel : NSObject
{
    NSString *fish_category;
    NSString *fish_name;
    NSInteger fish_counter;
}

//-(id)initWithName:(NSString*)n count:(NSInteger)fcounter;
+(void) truncateTable:(NSString*)dbPath;
//+(void) addFishToTable:(NSString*)name dbPath:(NSString*)dbPath;
+(void) removeFishFromTable:(NSString*)name dbPath:(NSString*)dbPath;
+(void) getDataFromDB:(NSString *)dbPath;
+(void) finalizeStatements;
+(void) updateFishBankDB:(NSString *)dbPath name:(NSString *)fishName andChange:(int)change;


-(id)initWithName:(NSString*)inputFishName andCategory:(NSString*) inputFishCategory count:(NSInteger)fcounter;
+(void) addFishToFishBank:(NSString*) inputFishName andFishCategory:(NSString*) inputFishCategory dbPath:(NSString*) databasePath;
+(void) updateDB:(NSString*)inputFishCategory andFishName:(NSString*) inputFishName dbPath:(NSString*)dbPath;
@property (nonatomic,retain)  NSString *fish_category;
@property (nonatomic,retain)  NSString *fish_name;
@property (nonatomic, assign) NSInteger fish_counter;

@end
