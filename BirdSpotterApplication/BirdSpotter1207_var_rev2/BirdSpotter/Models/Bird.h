//
//  Bird.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bird : NSObject
{
    int dbID;
    int status;
    NSString* name;
    NSString* habitat;
    NSString* food;
    NSString* calender_migration;
    NSString* mating_season;
    NSString* trivia;
    NSString* notes;
    NSString* audio_file;
    NSString* profile_image_file;
    NSString* bird_book_img;
    NSMutableArray* galleryImageArray;
}


@property(nonatomic, assign) int dbID;
@property(nonatomic, assign) int status;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* habitat;
@property(nonatomic, retain) NSString* food;
@property(nonatomic, retain) NSString* calender_migration;
@property(nonatomic, retain) NSString* mating_season;
@property(nonatomic, retain) NSString* trivia;
@property(nonatomic, retain) NSString* notes;
@property(nonatomic, retain) NSString* audio_file;
@property(nonatomic, retain) NSString* profile_image_file;
@property(nonatomic, retain) NSString* bird_book_img;
@property(nonatomic, retain) NSMutableArray* galleryImageArray;

- (id)initWithID:(int)i name:(NSString*)n status:(int)s habitat:(NSString*)h food:(NSString*)f
cMigration:(NSString*)cm mating:(NSString*)m trivia:(NSString*)t notes:(NSString*)n audio:(NSString*)a
      profileImg:(NSString*)img bBookImg:(NSString*)bImg;// galleryImages:(NSMutableArray*)imgArray;
-(NSComparisonResult) compareByName:(Bird*)otherBird;

@end
