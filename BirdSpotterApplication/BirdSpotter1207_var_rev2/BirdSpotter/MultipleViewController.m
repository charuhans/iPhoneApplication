//
//  MultipleViewController.m
//  BirdSpotter
//
//  Created by Newton on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultipleViewController.h"
#import "MenuViewController.h"
#import "PhotoGallery.h"
#import "BirdProfileViewController.h"
#import "BirdBookTableViewController.h"
#import "HotspotMapViewController.h"
#import "CameraViewController.h"
#import "MyView.h"
//#import "testPickerViewController.h"

@implementation MultipleViewController

@synthesize menuVC, birdGalleryVC, birdProfileVC, birdBookTableVC, hotspotMapVC, cameraVC;
@synthesize viewController , toolbar, picker;
@synthesize homeButton, birdBookButton, hotSpotButton,galleryButton, cameraButton, toolbarItems;
@synthesize vcIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        UIImage* newImage;
        
        toolbar = [UIToolbar new];    
        toolbar.frame = CGRectMake(0, 420, 320, 50);
        
        //toolbar.barStyle = UIBarStyleBlackTranslucent;
        //[toolbar sizeToFit];
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toolbar.png"]];
        iv.frame = CGRectMake(0, 0, toolbar.frame.size.width, toolbar.frame.size.height);        
        [toolbar insertSubview:iv atIndex:0];
       toolbar.backgroundColor = [UIColor blackColor];
        
        
        //adding flexible space between buttons to evenly space tham out 
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        //adding birdbook button
        UIImage *birdBookImage = [UIImage imageNamed:@"tb_birdbook_button.png"];
        newImage =  [self resize:birdBookImage]; 
        
        birdBookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];    
        [birdBookButton setImage:newImage forState:UIControlStateNormal];   
        birdBookButton.frame = CGRectMake(0, 0, 30, 35);
        [birdBookButton addTarget:self action:@selector(birdBookButtonPressed) forControlEvents:UIControlEventTouchUpInside];         
        UIBarButtonItem *birdBookIcon = [[UIBarButtonItem alloc]	initWithCustomView:birdBookButton];
        
        //[newImage release];
        
        
        //adding home button
        UIImage *homeImage  = [UIImage imageNamed:@"tb_home_button.png"];
        newImage =  [self resize:homeImage]; 
        
        homeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [homeButton setImage:newImage forState:UIControlStateNormal];
        homeButton.frame = CGRectMake(0, 0, 30, 35);
        [homeButton addTarget:self action:@selector(homeButtonPressed) forControlEvents:UIControlEventTouchUpInside];                 
        UIBarButtonItem *homeBarIcon = [[UIBarButtonItem alloc]	initWithCustomView:homeButton];
        
        //[newImage release];
        
        //adding hot spot button
        UIImage *hotSpotImage = [UIImage imageNamed:@"tb_search_button.png"]; 
        newImage =  [self resize:hotSpotImage];        
        
        hotSpotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        [hotSpotButton setImage:newImage forState:UIControlStateNormal];          
        hotSpotButton.frame = CGRectMake(0, 0, 30, 35);
        [hotSpotButton addTarget:self action:@selector(hotSpotButtonPressed) forControlEvents:UIControlEventTouchUpInside];         
        UIBarButtonItem *hotSpotIcon = [[UIBarButtonItem alloc]	initWithCustomView:hotSpotButton];
                
        //[newImage release];
        
        //adding gallerybutton
        UIImage *galleryImage = [UIImage imageNamed:@"tb_gallery_button.png"];  
        newImage =  [self resize:galleryImage]; 
        
        galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [galleryButton setImage:newImage forState:UIControlStateNormal];   
        galleryButton.frame = CGRectMake(0, 0, 30, 35);
        [galleryButton addTarget:self action:@selector(galleryButtonPressed) forControlEvents:UIControlEventTouchUpInside];         
        UIBarButtonItem *galleryIcon = [[UIBarButtonItem alloc]	initWithCustomView:galleryButton];
        
        //newImage =  [self resize:hotSpotImage]; 
        
        //camera button
        UIImage *cameraImage = [UIImage imageNamed:@"tb_camera_button.png"];
        newImage =  [self resize:cameraImage]; 
        
        cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraButton setImage:newImage forState:UIControlStateNormal];   
        cameraButton.frame = CGRectMake(0, 0, 30, 35);
        [cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];         
        UIBarButtonItem *cameraIcon = [[UIBarButtonItem alloc]	initWithCustomView:cameraButton];
        
        //[newImage release];
        
        toolbarItems = [NSMutableArray arrayWithObjects:
                                        space, homeBarIcon,
                                        space, birdBookIcon,
                                        space, hotSpotIcon,
                                        space, galleryIcon,
                                        space, cameraIcon,
                                        space, nil];
        
        [toolbarItems retain];        
        [toolbar setItems:toolbarItems animated:NO];
                
        [iv release];
        [cameraImage release];
        [cameraIcon release];
        [galleryImage release];
        [galleryIcon release];
        [hotSpotImage release];
        [hotSpotIcon release];
        [homeImage release];
        [homeBarIcon release];
        [birdBookImage release];
        [birdBookIcon release];      
    }
    return self;
}
-(UIImage*) resize:(UIImage*) image
{
    CGSize newsize = CGSizeMake(35, 35);
    UIGraphicsBeginImageContext(newsize);
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}
-(void) setVCIndex:(int) index{
    vcIndex = index;
    [self displayview:index];
}
//Action methods for toolbar buttons:
- (void) birdBookButtonPressed{
    [self clearView];    
    [self displayview:1];
}
- (void) hotSpotButtonPressed{
    
    [self clearView];    
    [self displayview:2];
}
- (void) galleryButtonPressed{    
    [self clearView];
    [self displayview:3];
}
- (void) homeButtonPressed{
    [self clearView];                
    [self dismissModalViewControllerAnimated:NO];   
}
- (void) cameraButtonPressed{
    [self clearView];
    [self displayview:4];
}
-(void) makeButtonInactive:(UIButton*) button andImgName:(NSString*) imgName andPosition:(int) position{
    UIImage *image = [UIImage imageNamed:imgName];     
    
    image = [self resize:image];
    
    [button setImage:image forState:UIControlStateNormal];       
    UIBarButtonItem *icon = [[UIBarButtonItem alloc]	initWithCustomView:galleryButton];
    
    [toolbarItems replaceObjectAtIndex:position withObject:icon];
    
    //[icon release];   
    //[image release];
}
-(void) setButtonActive:(UIButton*) buttonToBeActive andImageName:(NSString*) imgname andPosition:(int) position{
    //set the position button active and rest inactive
   
    [self makeButtonInactive:homeButton andImgName:@"tb_home_button.png" andPosition:1];    
    [self makeButtonInactive:birdBookButton andImgName:@"tb_birdbook_button.png" andPosition:3]; 
    [self makeButtonInactive:hotSpotButton andImgName:@"tb_search_button.png" andPosition:5]; 
    [self makeButtonInactive:galleryButton andImgName:@"tb_gallery_button.png" andPosition:7]; 
    [self makeButtonInactive:cameraButton andImgName:@"tb_camera_button.png" andPosition:9]; 
    
    UIImage *image = [UIImage imageNamed:imgname];    
    
    image = [self resize:image];
    
    [buttonToBeActive setImage:image forState:UIControlStateNormal];           
    UIBarButtonItem *icon = [[UIBarButtonItem alloc]	initWithCustomView:buttonToBeActive];        
    [toolbarItems replaceObjectAtIndex:position withObject:icon];        
    //[icon release];
    //[image release];
}
-(void)displayview:(int)intNewView{
    [viewController.view removeFromSuperview];
    
    switch(intNewView)
    {
        case 1: 
            
            [self setButtonActive:birdBookButton andImageName:@"tb_birdbook_button_active.png" andPosition:3];
            viewController = [[BirdBookTableViewController alloc] initWithNibName:@"BirdBookTableViewController" bundle:[NSBundle mainBundle]];
             
            break;
        case 2: 
            [self setButtonActive:hotSpotButton andImageName:@"tb_search_button_active.png" andPosition:5];
            viewController = [[HotspotMapViewController alloc] initWithNibName:@"HotspotMapViewController" bundle:[NSBundle mainBundle]];   
            
            //UIImage *inactiveHotspot = [UIImage imageNamed:@"newsearch_button_active.png"];
            //[hotSpotButton setBackgroundImage:inactiveHotspot forState:UIControlStateNormal];
            //[inactiveHotspot release];
            
            break;
            
        case 3: 
            [self setButtonActive:galleryButton andImageName:@"tb_gallery_button_active.png" andPosition:7];
            viewController = [[PhotoGallery alloc] initWithNibName:@"PhotoGallery" bundle:[NSBundle mainBundle]];               
            break;
            
        case 4:    
            [self setButtonActive:cameraButton andImageName:@"tb_camera_button_active.png" andPosition:9];
            viewController = [[MyView alloc] initWithNibName:@"MyView" bundle:[NSBundle mainBundle]];
            break;
            
        default:
            break;                
    }
    
    [self.view addSubview:viewController.view];  
    [viewController viewWillAppear:YES];
    [self.view addSubview:toolbar];
    
}

- (void) clearView {}
- (void)dealloc{
    [toolbarItems release];
    [homeButton release];
    [birdBookButton release];
    [hotSpotButton release];
    [galleryButton release];
    [cameraButton release];
    
    [picker release];
    [cameraVC release];
    [viewController release];
    [menuVC release];
    [birdGalleryVC release];
    [birdProfileVC release];
    [birdBookTableVC release];
    [hotspotMapVC release];  
    [toolbar release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];    
    
    //viewController = [[BirdBookTableViewController alloc] initWithNibName:@"BirdBookTableViewController" bundle:[NSBundle mainBundle]];
    //[self displayview:vcIndex];
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
