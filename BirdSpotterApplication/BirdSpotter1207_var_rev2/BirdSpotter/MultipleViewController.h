//
//  MultipleViewController.h
//  BirdSpotter
//
//  Created by Newton on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@class MenuViewController;
@class BirdGalleryViewController;
@class BirdProfileViewController;
@class BirdBookTableViewController;
@class HotspotMapViewController;
@class CameraViewController;

@interface MultipleViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet MenuViewController             *menuVC;
    IBOutlet BirdGalleryViewController      *birdGalleryVC;
    IBOutlet BirdProfileViewController      *birdProfileVC;
    IBOutlet BirdBookTableViewController    *birdBookTableVC;
    IBOutlet HotspotMapViewController       *hotspotMapVC;  
    IBOutlet CameraViewController           *cameraVC;
    
    IBOutlet UIButton* homeButton;
    IBOutlet UIButton* birdBookButton;
    IBOutlet UIButton* hotSpotButton;
    IBOutlet UIButton* galleryButton;
    IBOutlet UIButton* cameraButton;
    IBOutlet NSMutableArray *toolbarItems;
    
    UIImagePickerController *picker;
    
    UIViewController *viewController;
    UIToolbar *toolbar;
    int vcIndex;        
}

@property (retain, nonatomic) IBOutlet NSMutableArray *toolbarItems;

@property (retain, nonatomic) IBOutlet UIButton* homeButton;
@property (retain, nonatomic) IBOutlet UIButton* birdBookButton;
@property (retain, nonatomic) IBOutlet UIButton* hotSpotButton;
@property (retain, nonatomic) IBOutlet UIButton* galleryButton;
@property (retain, nonatomic) IBOutlet UIButton* cameraButton;


@property (retain, nonatomic) MenuViewController            *menuVC;
@property (retain, nonatomic) BirdGalleryViewController     *birdGalleryVC;
@property (retain, nonatomic) BirdProfileViewController     *birdProfileVC;
@property (retain, nonatomic) BirdBookTableViewController   *birdBookTableVC;
@property (retain, nonatomic) HotspotMapViewController      *hotspotMapVC;
@property (retain, nonatomic) CameraViewController          *cameraVC;
@property (nonatomic, assign) NSInteger vcIndex;

@property(nonatomic,retain) UIViewController *viewController;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (retain, nonatomic) UIImagePickerController *picker;

//-(IBAction)loadMenuViewController:(id)sender;
//-(IBAction)loadBirdGalleryViewController:(id)sender;
//-(IBAction)loadBirdProfileViewController:(id)sender;
//-(IBAction)loadBirdBookTableViewController:(id)sender;
//-(IBAction)loadBirdBookTableViewController:(id)sender;

-(void) setButtonActive:(UIButton*) buttonToBeActive andImageName:(NSString*) imgname andPosition:(int) position;
-(void) makeButtonInactive:(UIButton*) button andImgName:(NSString*) imgName andPosition:(int) position;
-(UIImage*) resize:(UIImage*) image;
-(void) clearView;
-(void) displayview: (int) intNewView;
-(void) setVCIndex:  (int) index;

@end
