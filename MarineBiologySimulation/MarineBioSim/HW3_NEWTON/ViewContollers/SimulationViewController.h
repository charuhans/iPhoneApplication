//
//  SimulationViewController.h
//  HW1_Newton
//
//  Created by Newton on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "HW3_NEWTONAppDelegate.h"

@class FishBankViewController;
//@class SimulationRenderView;
@class FishTankInfo;

@interface SimulationViewController : UIViewController //<UIApplicationDelegate, UIAccelerometerDelegate> 
{
    //UIAcceleration *acceleration;
    
    HW3_NEWTONAppDelegate *appDelegate;
    UINavigationController *fishBankNavControl;
    FishBankViewController *fishBankVC; 
    IBOutlet UIImageView *fishImg;
    NSString *image_name_simscreen;
    CGPoint center;
    NSInteger gridX, gridY;
    CGSize cgSize;
    
    //array to hold sprite info
    NSMutableArray *arrayOfFishesInTank;
    
    //timer to start simulation
    NSTimer *timer;
    NSInteger idCounter, motion;
    NSMutableArray *ui_image_array;
    NSInteger radiusOfFish;
    NSDate *pauseStart, *previousFireDate;
    CGPoint touchLocToRemove;
    CFTimeInterval _startTime, _endTime; 
    
    //touch action 
    UITouch *touch;
    
    //========================
    //Background sea animation
    //========================
    UIImageView    *animatedSeaImages;
    NSMutableArray *seaImageArray;
    
    UIImageView    *seaBedImages1;
    NSMutableArray *seaBedArray1;
    
    UIImageView    *seaBedImages2;
    NSMutableArray *seaBedArray2;
    
    UIImageView    *seaBedImages3;
    NSMutableArray *seaBedArray3;
    
    UIImageView    *seaBedImages4;
    NSMutableArray *seaBedArray4;
    
    UIImageView    *seaBedImages5;
    NSMutableArray *seaBedArray5;
    //========================
    
    NSString* fish_name_added;

    
}
//@property (nonatomic, retain) UIAcceleration *acceleration;

@property (nonatomic, assign) CFTimeInterval         _startTime;
@property (nonatomic, assign) CFTimeInterval         _endTime;
@property (nonatomic,retain)  HW3_NEWTONAppDelegate  *appDelegate;
@property (nonatomic,retain)  UINavigationController *fishBankNavControl;
@property (nonatomic,retain)  FishBankViewController *fishBankVC;
@property (nonatomic, assign) CGPoint                 touchLocToRemove;
@property (nonatomic,assign)  CGPoint                 center;
@property (nonatomic,assign)  NSInteger               gridX;
@property (nonatomic,assign)  NSInteger               gridY;
@property (nonatomic,assign)  CGSize                  cgSize;
@property (nonatomic,retain)  IBOutlet UIImageView   *fishImg;
@property (nonatomic,retain)  NSString               *image_name_simscreen;
@property (nonatomic,retain)  NSMutableArray         *arrayOfFishesInTank;
@property (nonatomic,retain)  NSTimer                *timer;
@property (nonatomic,retain)  NSMutableArray         *ui_image_array;
@property (nonatomic,assign)  NSInteger               motion;
@property (nonatomic, assign) NSInteger               radiusOfFish;
@property (nonatomic, assign) NSInteger               idCounter;

@property (nonatomic, retain) NSString* fish_name_added;

//touch action
@property(nonatomic,retain) UITouch *touch;

//========================
//Background sea animation
//========================
@property(nonatomic, retain) UIImageView *animatedSeaImages;
@property(nonatomic, retain) NSMutableArray *seaImageArray;

@property(nonatomic, retain) UIImageView    *seaBedImages1;
@property(nonatomic, retain) NSMutableArray *seaBedArray1;

@property(nonatomic, retain) UIImageView    *seaBedImages2;
@property(nonatomic, retain) NSMutableArray *seaBedArray2;

@property(nonatomic, retain) UIImageView    *seaBedImages3;
@property(nonatomic, retain) NSMutableArray *seaBedArray3;

@property(nonatomic, retain) UIImageView    *seaBedImages4;
@property(nonatomic, retain) NSMutableArray *seaBedArray4;

@property(nonatomic, retain) UIImageView    *seaBedImages5;
@property(nonatomic, retain) NSMutableArray *seaBedArray5;

//========================
//-(float) getAngle;

-(void) updatePositionOfFishes:(FishTankInfo*) fishInfo;
-(void) getDataFromDBforSimulation;


-(void) setImage;
-(void) createSimulationView;
-(void) refresh;//:(NSString *) fish_image_name;
-(void) removeFishFromTank; //:(CGPoint) clickedLoc;
-(void) addFishToTank;
-(void) getFishesFromFishTank;
-(void) populateFishTankArrayForSimulation;
-(void) simulation;
-(void) getMotionPattern:(NSString *)image_name;
-(void)set_image_name_simscreen:(NSString *) nameoffishimage;
-(BOOL)checkIfPositionAvailable:(CGPoint) new_position  andCount:(int) count;
-(int) getNewHeadDirectionType34:(NSInteger) headDirection;
-(CGPoint) getNewPositionVH:(int)head andPosition:(CGPoint) location andCellJump:(int) numberOfCell;;
-(FishTankInfo *) newFishPositionVH:(CGFloat)x andY:(CGFloat)y andFishInfo:(FishTankInfo *) fishTank andCounter:(int) count andCellJump:(int) numberOfCell;
-(UIImage*)rotate:(UIImageOrientation)orient andImage:(UIImage *)fishImage;
-(CGRect) swapWidthAndHeight:(CGRect) rect;
-(BOOL)checkIfPositionAvailable:(CGPoint) new_position;

-(int) getNewHeadDirectionType34:(NSInteger) headDirection;
-(int) getNewHeadDirectionType25:(NSInteger) headDirection;
-(int) getNewHeadDirectionType16:(NSInteger) headDirection;

-(void) setFishName:(NSString*) name;
-(void) removeFromSuperView;

-(void) pauseTimer;
-(void) resumeTimer;
@end
