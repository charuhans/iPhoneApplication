//
//  MenuViewController.h
//  HW1_Newton
//
//  Created by Newton on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FishStoreViewController;
@class SimulationViewController;

@interface MenuViewController : UIViewController 
{
    
    FishStoreViewController     *fishStoreVC;
    UINavigationController      *fishStoreNavControl;
    
    
    SimulationViewController    *simVC;
    UINavigationController      *fishSimNavControl;
}

@property (nonatomic, retain) FishStoreViewController  *fishStoreVC;
@property (nonatomic, retain) UINavigationController   *fishStoreNavControl;

@property (nonatomic, retain) SimulationViewController    *simVC;
@property (nonatomic, retain) UINavigationController      *fishSimNavControl;

- (IBAction)simulationAction:(id)sender;
- (IBAction)fishstoreAction:(id)sender;
- (IBAction)quitAction:(id)sender;

@end
