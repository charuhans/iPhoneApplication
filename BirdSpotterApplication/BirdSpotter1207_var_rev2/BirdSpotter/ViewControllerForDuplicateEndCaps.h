//
//  ViewControllerForDuplicateEndCaps.h
//
//  Created by Newton on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BirdSpotterAppDelegate;

@interface ViewControllerForDuplicateEndCaps : UIViewController <UIScrollViewDelegate>
{
    BirdSpotterAppDelegate *appDelegate;
	IBOutlet UIScrollView *scrollView;
    NSInteger count;
    NSInteger pos;
    //IBOutlet UIButton *faceBookButton;
}

@property (nonatomic, retain) BirdSpotterAppDelegate *appDelegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger pos;

//@property (nonatomic, retain) IBOutlet UIButton *faceBookButton;



- (void)faceBookTouchAction;

- (void) addImageAtPosition:(int) i;
- (void) setimagecounter:(NSInteger) position;

@end
