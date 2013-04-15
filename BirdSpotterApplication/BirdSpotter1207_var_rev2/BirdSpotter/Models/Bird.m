//
//  Bird.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bird.h"

@implementation Bird


@synthesize dbID;
@synthesize status;
@synthesize name;
@synthesize habitat;
@synthesize food;
@synthesize calender_migration;
@synthesize mating_season;
@synthesize trivia;
@synthesize notes;
@synthesize audio_file;
@synthesize profile_image_file;
@synthesize bird_book_img;
@synthesize galleryImageArray;


- (id)initWithID:(int)i name:(NSString*)n status:(int)s habitat:(NSString*)h food:(NSString*)f
cMigration:(NSString*)cm mating:(NSString*)m trivia:(NSString*)t notes:(NSString*)note audio:(NSString*)a 
profileImg:(NSString*)img bBookImg:(NSString*)bImg
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.dbID = i;
        self.status = s;
        self.name = n;
        self.habitat = h;
        self.food = f;
        self.calender_migration = cm;
        self.mating_season = m;
        self.trivia = t;
        self.notes = note;
        self.audio_file = a;
        self.profile_image_file = img;
        self.bird_book_img = bImg;
        //self.galleryImageArray = imgArray;
        
    }
    
    return self;
}

-(NSComparisonResult) compareByName:(Bird*)otherBird
{
    return  [self.name compare:otherBird.name];
}

-(void) dealloc
{
    [name release];
    [habitat release];
    [food release];
    [calender_migration release];
    [mating_season release];
    [trivia release];
    [notes release];
    [audio_file release];
    [profile_image_file release];
    [bird_book_img release];
    [galleryImageArray release];
    
    [super dealloc];
}

@end
