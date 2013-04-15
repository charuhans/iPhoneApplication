//
//  BirdProfileModel.m
//  BirdSpotter
//
//  Created by Newton on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

static sqlite3 *database = nil;

#import "BirdGalleryModel.h"

@implementation BirdGalleryModel


- (id)init{
    self = [super init];
    if (self) {}    
    return self;
}
-(void) dealloc{    
    [super dealloc];
}

//Static methods.
+ (void) getDataFromDB:(NSString *)dbPath
{
    BirdSpotterAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sqlString = @"SELECT * FROM bird_images";
        sqlite3_stmt *selectstmt;
        
        if(sqlite3_prepare_v2(database, [sqlString UTF8String], -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            //UIImageView* imgView;
            NSString *imgName;
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                //int idNo = sqlite3_column_int(selectstmt, 0);
                int birdID = sqlite3_column_int(selectstmt, 1);
                int imgType = sqlite3_column_int(selectstmt, 2);
                imgName = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 3)];
                
                
                
                if(imgType == 2)
                {
                    NSString* tempImgName = [NSString stringWithFormat:@"%@",imgName];
                    //NSLog(@"%d  %d %@", birdID, imgType, tempImgName);
                   
                    UIImage* img = [UIImage imageNamed:tempImgName];
                    
                    if (img) {
                        [appDelegate.galleryArray addObject:img];
                    }
                        
                    
                }
            }
            NSLog(@"Done Reading Db");            
        }
    }
    else
        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the m
}

+ (void) finalizeStatements
{
    if(database) sqlite3_close(database);
}
@end

