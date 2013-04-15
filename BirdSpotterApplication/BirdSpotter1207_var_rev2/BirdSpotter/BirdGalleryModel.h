//
//  BirdGalleryModel.h
//  BirdSpotter
//
//  Created by Newton on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bird;

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BirdGalleryModel : NSObject{}


//Static methods.
+ (void) getDataFromDB:(NSString *)dbPath;
+ (void) finalizeStatements;
@end

