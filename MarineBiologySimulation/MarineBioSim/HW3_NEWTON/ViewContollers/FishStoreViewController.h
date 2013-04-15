//
//  FishStoreViewController.h
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditFishViewController;
@class FishStoreModel;
@class HW3_NEWTONAppDelegate;

@interface FishStoreViewController : UITableViewController <UIAccelerometerDelegate> 
{
    HW3_NEWTONAppDelegate *appDelegate;
    
    EditFishViewController *addEditVC;
    UINavigationController *addEditNavControl;
    
    NSString* fishNameSelected;
    FishStoreModel *fishObject;
    UIAccelerometer *accelerometer;
    
    IBOutlet UIBarButtonItem *addFishBankButton;
    float angle;
    
}
@property (nonatomic, retain) HW3_NEWTONAppDelegate *appDelegate;

@property(nonatomic, retain) IBOutlet UIBarButtonItem *addFishBankButton;
@property(nonatomic, retain) NSString* fishNameSelected;
@property(nonatomic, retain) FishStoreModel *fishObject;

@property (nonatomic, assign) float angle;


@property(nonatomic, retain) EditFishViewController *addEditVC;
@property(nonatomic, retain) UINavigationController *addEditNavControl; 

@property (nonatomic, retain) UIAccelerometer *accelerometer;
@end
