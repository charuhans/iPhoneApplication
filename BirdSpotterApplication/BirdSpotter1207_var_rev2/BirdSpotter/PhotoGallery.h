//
//  PhotoGallery.h
//  Three20PhotoDemo
//
//  Created by Newton on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BirdSpotterAppDelegate;
@class ViewControllerForDuplicateEndCaps;

@interface PhotoGallery : UIViewController
{
    BirdSpotterAppDelegate *appDelegate;
    NSMutableArray *imageView;
    NSMutableArray *imageViewSelection;
    UIImage *selectedImage;
    UIImageView *imgView;    
    
    UIImageView *galleryTitle;
    
    
    ViewControllerForDuplicateEndCaps *viewControllerForDuplicateEndCaps;
}

@property (nonatomic, retain) ViewControllerForDuplicateEndCaps *viewControllerForDuplicateEndCaps;
@property (nonatomic, retain) BirdSpotterAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIImageView *galleryTitle;
@property (nonatomic, retain) NSMutableArray *imageView;
@property (nonatomic, retain) NSMutableArray *imageViewSelection;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImageView *imgView;

-(void) loadImagesforGallery;
-(void) loadAllImages;
@end
