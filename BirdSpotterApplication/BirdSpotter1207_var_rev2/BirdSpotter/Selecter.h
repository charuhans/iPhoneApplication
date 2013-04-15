//
//  Selecter.h
//  BirdSpotter
//
//  Created by Varun Varghese on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeoLocationHelperModel;

@interface Selecter : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *cityPicker;
    
    NSMutableArray *arrayCity;
    
    BirdSpotterAppDelegate* appDelegate;
}


@property (nonatomic, retain) BirdSpotterAppDelegate* appDelegate;
@property (nonatomic, retain) IBOutlet UIPickerView *cityPicker;

- (IBAction)dismiss:(id)sender;

@end
