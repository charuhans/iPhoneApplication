//
//  FishBankViewController.h
//  HW1_Newton
//
//  Created by Varun Varghese on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FishBankCellViewController;
@class HW3_NEWTONAppDelegate;

@interface FishBankViewController : UITableViewController <UIAccelerometerDelegate> 
{
    HW3_NEWTONAppDelegate   *fishBankAppDelegate;
    NSString                *image_name_to_simvc;
    UIAccelerometer         *accelerometer;
    float angle;
}

@property(nonatomic, assign) float angle;
@property(nonatomic, retain) HW3_NEWTONAppDelegate  *fishBankAppDelegate;
@property(nonatomic, retain) NSString               *image_name_to_simvc;
@property(nonatomic, retain) UIAccelerometer        *accelerometer;
@end
