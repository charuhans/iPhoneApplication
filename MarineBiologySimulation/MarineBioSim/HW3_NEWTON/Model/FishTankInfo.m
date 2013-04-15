//
//  FishTankInfo.m
//  HW1_Newton
//
//  Created by Newton on 10/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FishTankInfo.h"



@implementation FishTankInfo

@synthesize fish_image,fishImg_name, location, directionHead, motion_pattern, fish_ka_id, fish_group;//, imgView;

-(id)initWithName:(NSString *)fishName andLoc:(CGPoint)loc andDirection:(NSInteger)direction andPattern:(NSInteger)motion andFishID:(NSInteger)ID andGroup:(NSString*) group
{
    self.fishImg_name   = fishName;
    self.location       = loc;
    self.directionHead  = direction;
    self.motion_pattern = motion; 
    self.fish_ka_id     = ID;
    self.fish_group     = group;
    
    //CGRect cgRect = [[UIScreen mainScreen] bounds];
    //CGSize cgSize  = cgRect.size;
    //NSInteger gridX = 8;
    //NSInteger gridY = 5;
    
    //CGRect sizeofimage = CGRectMake(location.x, location.y, cgSize.height/gridX, cgSize.width/gridY);
    
    UIImage *tempImage = [UIImage imageWithContentsOfFile:self.fishImg_name];
    self.fish_image = tempImage;
    [tempImage release];
    
    //imgView = [[UIImageView alloc] initWithFrame:sizeofimage];
    //imgView.image = fish_image;
    //imgView.center = location;
    
    return self;
}

- (void) setFishID:(NSInteger)idoffishy
{
    self.fish_ka_id = idoffishy;
}
//-(void)setnewLoc:(CGPoint) newPoint
//{
//    imgView.center = newPoint;  
//}
-(void)dealloc
{
    [fish_group release];
    [fish_image release];
    [fishImg_name release];
    [super dealloc];
}

@end
