//
//  CameraViewController.h
//  BirdSpotter
//
//  Created by Newton on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@class BirdSpotterAppDelegate;

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
{    
    UIImageView *imageView;
    BOOL newMedia;    
    IBOutlet UIButton *cameraButton;
    IBOutlet UIButton *cameraRoll;
    BirdSpotterAppDelegate *appDelegate;
    UIImagePickerController *m_picker; 
    UIActivityIndicatorView *activity;
}

@property(nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) UIImagePickerController *m_picker;
@property (nonatomic, retain) BirdSpotterAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraRoll;
//@property (nonatomic, retain) NSString* savedImagePath;

- (void)useCamera;
- (void)useCameraRoll;
//- (void)setPathName:(NSString*) path;

@end
