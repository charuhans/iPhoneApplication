//
//  MyView.h
//  ImagePicker
//
//  Created by Krzysiek on 09-04-29.
//  Copyright 2009 www.chris-software.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyView : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
{
	IBOutlet UIImageView *imageView;
	UIImagePickerController *UIPicker;
    BOOL isCamera;
    BirdSpotterAppDelegate *appDelegate;
}


@property (nonatomic, retain) BirdSpotterAppDelegate *appDelegate;
@property (nonatomic, assign) BOOL isCamera;
-(IBAction)openCameraRoll;
-(IBAction)openCamera;

@end
