//
//  FishTankModel.h
//  HW1_Newton
//
//  Created by Varun Varghese on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class FishStoreModel;
@class FishTankInfo;

@interface FishTankModel : NSObject
{
    NSString *fish_category;
    NSString *fish_name;
    NSInteger xCord;
    NSInteger yCord;
    NSInteger head_direction;
    NSString* fish_group;
}

-(id)initWithName:(NSString*)c xcord:(int)x ycord:(int)y headDir:(int)h group:(NSString*)g name:(NSString*)n;
+(void) truncateTable:(NSString*)dbPath;
+(void) addFishToTable:(NSString*)category xcord:(int)x ycord:(int)y headDir:(int)h dbPath:(NSString*)dbPath fishid:(NSInteger)ID  fishGroup:(NSString*) group name:(NSString*) name;
+(void) removeFishFromTable:(NSString*)name dbPath:(NSString*)dbPath;
+(BOOL) isFishPresent:(NSString*)name dbPath:(NSString*)dbPath;
+(void) getDataFromDB:(NSString *)dbPath;
+(void) finalizeStatements;
+(void) removeFishFromTableOnTap:(NSInteger) fishKaID dbPath:(NSString *) path;
+(void) updateDB:(NSString*)category dbPath:(NSString*)dbPath name:(NSString*) name group:(NSString*) newGroup;
+(void) updatePositionOfFishes:(FishTankInfo*) fishInfo  andPath:(NSString*) dbPath;
+(void) getDataFromDBforSimulation:(NSString *)dbPath;


@property (nonatomic,retain) NSString *fish_group;
@property (nonatomic,retain) NSString *fish_name;
@property (nonatomic,retain) NSString *fish_category;
@property (nonatomic,assign) NSInteger xCord;
@property (nonatomic,assign) NSInteger yCord;
@property (nonatomic,assign) NSInteger head_direction;

@end
