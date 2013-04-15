//
//  WebGalleryViewController.m
//  HW3_NEWTON
//
//  Created by Newton on 11/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebGalleryViewController.h"
#import "EditFishViewController.h"
#import "HW3_NEWTONAppDelegate.h"
#import "MenuViewController.h"
#import "EditFishViewController.h"
#import "FishStoreViewController.h"


@implementation WebGalleryViewController
//selectedImage,
@synthesize galleryTitle,appDelegate;
@synthesize imageView,imageViewSelection,imgView,link, imageName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    imageView = [[NSMutableArray alloc] init];
    
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(gotToEditView)];
        self.navigationItem.title =@"Fish Gallery";
        appDelegate = [[UIApplication sharedApplication]delegate];
        
    }
    return self;
}

-(void)gotToEditView
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) setLinkImageArray: (NSString *)url imgArray:(NSMutableArray*)array
{
    link = url;
    imageName = [[NSMutableArray alloc] initWithArray:array];// array;
}

- (void)dealloc
{
    [appDelegate release];
    [imageName release];
    [link release];
    [imgView release];
    [imageView release];
    [imageViewSelection release];
    //[selectedImage release];
    [galleryTitle release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) viewDidAppear:(BOOL)animated
{
    [self viewDidLoad];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [imageView removeAllObjects];
    
    // Create view
	UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	
    
    int count = [imageName count];
    int i;
    for(i= 0; i < count; i++)
    {
        //NSLog(@"%@",[imageName objectAtIndex:i]);
        NSString *name = [[NSString alloc]initWithFormat:@"%@%@%@",link,@"/", [imageName objectAtIndex:i]];
        UIImage* imageABC = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:name]]];
        [imageView addObject:imageABC];
       // [imageABC release];
    }
    
	int row = 0;
	int column = 0;
	for(int i = 0; i < imageView.count; i++)
    {		
		UIImage *image = [imageView objectAtIndex:i];
        self.imgView = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:self.imgView];
        
        [imgView release];
		
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*80+20, row*80+2, 75,75);		
        [button setImage:image forState:UIControlStateNormal];        
		[button addTarget:self  action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];		
        button.tag = i; 
        

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(column*80 +100, row*80, 200,50)];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
        label.backgroundColor = [UIColor colorWithRed:.89 green:.85 blue:.71 alpha:1];
        label.text = [NSString stringWithFormat:@"%@", [imageName objectAtIndex:i]];
        
        [view addSubview:label];
        
        [view addSubview:button];
		
		if (column == 0) 
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
   // [self.view addSubview:topView];
	
    [view release];
    //[topView release];
   // [topBanner release];
    
}

- (IBAction)buttonClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
    
    
    NSString *name = [[NSString alloc]initWithFormat:@"%@%@%@",link,@"/", [imageName objectAtIndex:button.tag]];
    UIImage* imageABC = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:name]]];
    
    //get label too
    NSString* fileName = [NSString stringWithFormat:@"%@",[imageName objectAtIndex:button.tag]];
    
    if(! appDelegate.menuVC.fishStoreVC.addEditVC.isEditing)
    {
        [appDelegate.menuVC.fishStoreVC.addEditVC setFishName:[[fileName componentsSeparatedByString:@"."] objectAtIndex:0]];
    }
    
    [appDelegate.menuVC.fishStoreVC.addEditVC loadImageasUIImage:imageABC];
    
    //from here set label and image in editvc
   // name     = nil;
    //fileName = nil;
    //imageABC = nil;
    
    
    
    //also dismiss viewcontroller
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setGalleryTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
