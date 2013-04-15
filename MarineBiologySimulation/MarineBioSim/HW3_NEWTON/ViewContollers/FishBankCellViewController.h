//
//  FishBankCellViewController.h
//  HW1_Newton
//
//  Created by Varun Varghese on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FishBankCellViewController : UITableViewCell {
    IBOutlet UILabel        *fishName;
    IBOutlet UILabel        *motionPatternDescription;
    IBOutlet UIImageView    *fishImage;
    IBOutlet UILabel        *counterLabel;
    UILabel *categoryOutlet;
}
@property (nonatomic, retain) IBOutlet UILabel *categoryOutlet;

@property (nonatomic, retain) IBOutlet UILabel      *counterLabel;
@property (nonatomic, retain) IBOutlet UILabel      *fishName;
@property (nonatomic, retain) IBOutlet UILabel      *motionPatternDescription;
@property (nonatomic, retain) IBOutlet UIImageView  *fishImage;
@end
