//
//  MyView.m
//  ImagePicker
//
//  Created by Krzysiek on 09-04-29.
//  Copyright 2009 www.chris-software.com. All rights reserved.
//

#import "MyView.h"
#import "BirdSpotterAppDelegate.h"
#import "MenuViewController.h"
#import "MultipleViewController.h"


@implementation MyView

@synthesize appDelegate, isCamera;

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error  contextInfo:(void *)contextInfo{
    if (error) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save image"\
                                                       delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)openCameraRoll {
    /*
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		UIPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[self presentModalViewController:UIPicker animated:YES];

	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera is not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    */
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:UIPicker animated:YES];
        
        isCamera = NO;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(IBAction)openCamera {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [appDelegate.menuVC.multiVC.toolbar removeFromSuperview];
        
        self.isCamera = YES;
        
		[self presentModalViewController:UIPicker animated:YES];

	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera is not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	imageView.image = image;
    if(isCamera)
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [appDelegate.menuVC.multiVC.view addSubview:appDelegate.menuVC.multiVC.toolbar];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [appDelegate.menuVC.multiVC.view addSubview:appDelegate.menuVC.multiVC.toolbar];
}

-(void)viewDidLoad {
    appDelegate = [[UIApplication sharedApplication] delegate];;
    
	UIPicker = [[UIImagePickerController alloc] init];
	//UIPicker.allowsImageEditing = NO;
	UIPicker.delegate = self;	
}

- (void)dealloc {
    [super dealloc];
    [appDelegate release];
	[imageView release];
	[UIPicker release];
}


@end
