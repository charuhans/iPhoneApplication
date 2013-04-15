//
//  FishStoreCellViewController.h
//  HW1_Newton
//
//  Created by Varun Varghese on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FishStoreCellViewController : UITableViewCell
{
    //
    UILabel *fishName;
    UILabel *motionPatternDescription;
    UIImageView *addOrRemove;
    UIImageView *fishImage;
    UILabel *categoryOutlet;
}
@property (nonatomic, retain) IBOutlet UILabel *categoryOutlet;
@property (nonatomic, retain) IBOutlet UILabel *fishName;
@property (nonatomic, retain) IBOutlet UILabel *motionPatternDescription;
@property (nonatomic, retain) IBOutlet UIImageView *addOrRemove;
@property (nonatomic, retain) IBOutlet UIImageView *fishImage;

@end
