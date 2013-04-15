//
//  ViewControllerForDuplicateEndCaps.m
//
//  Created by Newton on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerForDuplicateEndCaps.h"


@implementation ViewControllerForDuplicateEndCaps
//@synthesize faceBookButton;

@synthesize scrollView, count, pos, appDelegate;

- (void) setimagecounter:(NSInteger) position{
    self.pos = position;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];    
    self.count = [appDelegate.galleryArray count];
	
    int i;
    //[self addImageAtPosition:-1];
    for (i = 0; i < self.count; i++) 
    {
        [self addImageAtPosition:i];
    }
    //[self addImageAtPosition:i];	
	
	scrollView.contentSize = CGSizeMake(320 * count, 420);    
	[scrollView scrollRectToVisible:CGRectMake(320*pos,0,320,420) animated:NO];
        
  //  faceBookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // [faceBookButton addTarget:self action:@selector(faceBookTouchAction) forControlEvents:UIControlEventTouchDown];
    //[faceBookButton setTitle:@"Facebook connect" forState:UIControlStateNormal];
   // faceBookButton.frame = CGRectMake(320*(pos+1) + 124, 390, 90, 20);
    
   // [scrollView addSubview:faceBookButton];
    
    
    
}
- (void)faceBookTouchAction{
    NSLog(@"Login to facebook");
}
- (void) addImageAtPosition: (int)i {
    UIImage *image;
	// add image to scroll view
   // if(i == [appDelegate.galleryArray count])
   // {
   //     image = [appDelegate.galleryArray objectAtIndex:0];
   // }
   // else if(i == -1)
   // {
   //     image = [appDelegate.galleryArray objectAtIndex:[appDelegate.galleryArray count] -1];
   // }
   // else
   // {
        image = [appDelegate.galleryArray objectAtIndex:i];
   // }
    
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	
    imageView.frame = CGRectMake(i*320, 0, 320, 420);
    
	[scrollView addSubview:imageView];
	
    [imageView release];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {        
    NSLog(@"%f", scrollView.contentOffset.x);
    
	// The key is repositioning without animation      
	if (scrollView.contentOffset.x == 0)
    {         
		// user is scrolling to the left from image 1 to image 79. Reposition offset to show image 79 that is on the right in the scroll view         
		//[scrollView scrollRectToVisible:CGRectMake(320*(count-1),0,320,420) animated:NO];    
        //faceBookButton.frame = CGRectMake(320*(count -1)+124, 390, 90, 20);
	}    
	else if (scrollView.contentOffset.x == 320*(count)) {         
		// user is scrolling to the right from image 79 to image 1. Reposition offset to show image 1 that is on the left in the scroll view         
		//[scrollView scrollRectToVisible:CGRectMake(0,0,320,420) animated:NO];  
        //faceBookButton.frame = CGRectMake(124, 390, 90, 20);
	} 
    else
    {        
      //  faceBookButton.frame = CGRectMake(scrollView.contentOffset.x + 124, 390, 90, 20);
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
    //[self setFaceBookButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [appDelegate release];
	[scrollView release];
    //[faceBookButton release];
    [super dealloc];
}

@end
