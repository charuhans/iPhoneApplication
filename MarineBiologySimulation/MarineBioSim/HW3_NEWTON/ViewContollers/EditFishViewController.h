//
//  EditFishViewController.h
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HW3_NEWTONAppDelegate;
@class fishWebViewContoller;
@class CustomSwitch;
@class WebGalleryViewController;


@interface EditFishViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate>
{
    HW3_NEWTONAppDelegate* appdelegate;
    fishWebViewContoller *fishWebVC; 
    UINavigationController *fishWebNavControl;
    UIImageView *fishImageView;
    UIToolbar *toolbar;
    BOOL isCategory;
    BOOL isMotion;    
    IBOutlet UIPickerView *myPickerView;
    
    NSMutableArray *arrayCategory;
    NSMutableArray *arrayMotion;
    
    UITextField *categoryOutlet;
    UITextField *motionoutlet;
    UIButton *categoryNextOutlet;
    UIButton *motionNextOutlet;
    IBOutlet CustomSwitch *groupMotionOutlet;
    IBOutlet UITextField *fishNameOutlet;
    
    BOOL isEditing;
    NSString* editingFishName;
    BOOL isInserting;
    
    UIButton *goToWebViewButton;
    NSString* link;
    WebGalleryViewController *webGalleryVC;
    UINavigationController *webGalleryNavControl;
}


@property(nonatomic,retain) WebGalleryViewController *webGalleryVC;
@property(nonatomic,retain) UINavigationController *webGalleryNavControl;

@property(nonatomic, assign) NSString* link;
@property (nonatomic, retain) IBOutlet UIButton *goToWebViewButton;


@property(nonatomic, assign) BOOL isEditing;
@property(nonatomic, assign) BOOL isInserting;
@property(nonatomic, retain) NSString* editingFishName;

@property(nonatomic, retain) HW3_NEWTONAppDelegate* appdelegate;

@property (nonatomic, retain) IBOutlet CustomSwitch *groupMotionOutlet;
@property (nonatomic, retain) IBOutlet UITextField *fishNameOutlet;

@property (nonatomic, retain) IBOutlet UIButton *categoryNextOutlet;
@property (nonatomic, retain) IBOutlet UIButton *motionNextOutlet;

@property (nonatomic, retain) fishWebViewContoller *fishWebVC;
@property (nonatomic, retain) IBOutlet UIImageView *fishImageView;
@property (nonatomic, retain) UINavigationController *fishWebNavControl; 
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIPickerView *myPickerView;

@property (nonatomic, retain) NSMutableArray *arrayCategory;
@property (nonatomic, retain) NSMutableArray *arrayMotion;

@property (nonatomic, retain) IBOutlet UITextField *categoryOutlet;
@property (nonatomic, retain) IBOutlet UITextField *motionoutlet;

-(void) setValues:(NSString *) fishCategory andMotion:(NSString*) fishMotion andGrouptMotion:(BOOL) fishGroupMotion 
          andName:(NSString*) fishName andImage:(NSString*) fishImage;

-(void) setFishName:(NSString*) fishName;
- (IBAction)categoryAction:(id)sender;
- (IBAction)motionAction:(id)sender;
-(BOOL) fishExistsInFishStore;
- (IBAction)goToWebView:(id)sender;

//clear everything on the screen
-(void) clearAll;

//save image to the document folder
- (void)saveImage: (UIImage*)image;
-(void) loadImage:(NSString*) imageName;
-(void) loadImageasUIImage:(UIImage*) image;
-(void) addPickerView;
//remove keyboard
-(IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
