//
//  WebGalleryViewController.h
//  HW3_NEWTON
//
//  Created by Newton on 11/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HW3_NEWTONAppDelegate;

@interface WebGalleryViewController : UIViewController 
{
    
    NSString *link;
    
    NSMutableArray *imageView;
    NSMutableArray *imageName;
    NSMutableArray *imageViewSelection;
    //UIImage *selectedImage;
    UIImageView *imgView;   
    
    HW3_NEWTONAppDelegate *appDelegate;
    
    UIImageView *galleryTitle;
}
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) IBOutlet UIImageView *galleryTitle;
@property (nonatomic, retain) NSMutableArray *imageView;
@property (nonatomic, retain) NSMutableArray *imageName;
@property (nonatomic, retain) NSMutableArray *imageViewSelection;
//@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) HW3_NEWTONAppDelegate *appDelegate;

-(void) setLinkImageArray: (NSString *)url imgArray:(NSMutableArray*)array;

@end
