//
//  PhotoGallery.m
//  Three20PhotoDemo
//
//  Created by Newton on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoGallery.h"
#import "BirdSpotterAppDelegate.h"
#import "ViewControllerForDuplicateEndCaps.h"
#import "BirdSpotterAppDelegate.h"

@implementation PhotoGallery
@synthesize galleryTitle, appDelegate;
@synthesize imageView,imageViewSelection,selectedImage,imgView;
@synthesize viewControllerForDuplicateEndCaps;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    //imageView = [[NSMutableArray alloc] init];
            
        
    /*
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //get the path to data.plist that holds our current counter for image name
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; 
    
    //get data from the file and put it in info
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile: path];   
    int value;
    
    //get the current value in the plist
    value = [[info objectForKey:@"value"] intValue]; 
    
    
    //test image
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //
    for (int i = 1; i < value; i++)
    {
        NSString* fileName = [[NSString alloc] initWithFormat:@"imageSaved%d.png",i];
        
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        UIImage *imgTry = [UIImage imageWithContentsOfFile:getImagePath];
        
        if(imgTry != NULL)
        {
            [imageView addObject:imgTry];
        } 
        
        [fileName release];
        [imgTry release];
    }
    */
    
    if (self) 
    {        
        if(imageView == nil)
        {
            
        }
        ViewControllerForDuplicateEndCaps *bbVC = [[ViewControllerForDuplicateEndCaps alloc] initWithNibName:@"ViewControllerForDuplicateEndCaps" bundle:[NSBundle mainBundle]];
        self.viewControllerForDuplicateEndCaps = bbVC;
        [bbVC release];
        
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    [appDelegate release];
    [viewControllerForDuplicateEndCaps release];
    [imgView release];
    [imageView release];
    [imageViewSelection release];
    [selectedImage release];
    [galleryTitle release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) loadAllImages{
    /*
    imageView = [[NSMutableArray alloc] init];
    [imageView addObject:[UIImage imageNamed:@"american_vulture1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"american_vulture3_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"golden_warbler1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"golden_warbler2_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"great_blue_heron1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"great_blue_heron2_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"inter_least_tern1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"interior_least_tern2_full.png"]];    
    [imageView addObject:[UIImage imageNamed:@"little_blue_heron1_full.png"]];    
    [imageView addObject:[UIImage imageNamed:@"little_blue_heron2_full.png"]];    
    [imageView addObject:[UIImage imageNamed:@"mexican_spotted_owl1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"mexican_spotted_owl2_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"piping_plover1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"piping_plover2_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"rose_throated_becard1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"rose_throated_becard2_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"roseate_spoonbill1_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"roseate_spoonbill2_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"whooping_crane1_full.png"]]; 
    [imageView addObject:[UIImage imageNamed:@"whooping_crane2_full.png"]]; 
    [imageView addObject:[UIImage imageNamed:@"aplomado_falcon_00_full.png"]]; 
    [imageView addObject:[UIImage imageNamed:@"aplomado_falcon_01_full.png"]]; 
    [imageView addObject:[UIImage imageNamed:@"bald_eagle_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"bald_eagle_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"black_capped_vireo_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"black_capped_vireo_01_full.png"]]; 
    [imageView addObject:[UIImage imageNamed:@"brown_pelican_00_full.png"]]; 
    [imageView addObject:[UIImage imageNamed:@"brown_pelican_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"eskimo_curlew_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"eskimo_curlew_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"red-cockaded_woodpecker_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"red-cockaded_woodpecker_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"reddish_egret_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"reddish_egret_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"swallow_tailed_kite_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"swallow_tailed_kite_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"white_faced_ibis_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"white_faced_ibis_01_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"white_faced_hawk_00_full.png"]];
    [imageView addObject:[UIImage imageNamed:@"white_faced_hawk_01_full.png"]];  
  */
}

-(void) loadImagesforGallery{
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //get the path to data.plist that holds our current counter for image name
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; 
    
    //get data from the file and put it in info
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile: path];   
    int value;
    
    //get the current value in the plist
    value = [[info objectForKey:@"value"] intValue]; 
    
    NSString* fileName = [[NSString alloc] initWithFormat:@"imageSaved%d.png",value];
        
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage *imgTry = [UIImage imageWithContentsOfFile:getImagePath];
        
    if(imgTry != NULL)
    {
        [imageView addObject:imgTry];
    } 
        
    [fileName release];
    [imgTry release];
    */
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
        
	UIImageView *topBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_gallery_topbar.png"]];
    UIView      *topView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [topView addSubview:topBanner];
    
    // Create view
	UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 375)];
	
	int row = 0;
	int column = 0;
	for(int i = 0; i < appDelegate.galleryArray.count; i++)
    {		
		UIImage *image = [appDelegate.galleryArray objectAtIndex:i];
        self.imgView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:self.imgView];
        
        [imgView release];
		
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*80+2, row*80+2, 75,75);
		
        [button setImage:image forState:UIControlStateNormal];
        
		[button addTarget:self  action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
        button.tag = i; 
		       
        [view addSubview:button];
		
		if (column == 3) 
        {
			column = 0;
			row++;
		} 
        else
        {
			column++;
		}
		
	}
	
	[view setContentSize:CGSizeMake(320, (row+1) * 80 + 10)];
	
    [view setBackgroundColor:[UIColor colorWithRed:.89 green:.85 blue:.71 alpha:1]];
     
	[self.view addSubview:view];
    [self.view addSubview:topView];
	
    [view release];
    [topView release];
    [topBanner release];
    
}

- (IBAction)buttonClicked:(id)sender {
	UIButton *button = (UIButton *)sender;
	
    [viewControllerForDuplicateEndCaps setimagecounter:button.tag];
    [self presentModalViewController:viewControllerForDuplicateEndCaps animated:YES];
}

- (void)viewDidUnload{
    //[self setGalleryTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
