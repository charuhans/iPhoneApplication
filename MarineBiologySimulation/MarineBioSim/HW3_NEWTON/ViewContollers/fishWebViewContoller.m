//
//  fishWebViewContoller.m
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "fishWebViewContoller.h"
#import "HW3_NEWTONAppDelegate.h"
#import "FishStoreViewController.h"
#import "MenuViewController.h"
#import "EditFishViewController.h"

@implementation fishWebViewContoller


@synthesize fishImageInRepos;
@synthesize myLink;
@synthesize currentURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        myLink = [[NSString alloc] initWithString:@"http://129.7.54.19/html/marineaquarium/"];
        currentURL = [[NSString alloc] initWithString:myLink];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain  target:self action:@selector(doneAndGoBack)];
    }
    return self;
}

-(void) setLinks:(NSString*) openLink
{
    NSString *string = [NSString stringWithFormat:@"%@%@%@", myLink,openLink,@"/"];
    NSLog(@"%@", string);
    
    myLink      = string;
    NSLog(@"%@", myLink);    
    
    currentURL  = string;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
    
    //CAPTURE USER LINK-CLICK.
    NSURL *url = [request URL];
    currentURL =   [url absoluteString];
    
    if (![currentURL isEqualToString: @"about:blank"])
    {  
        if(![myLink isEqualToString:currentURL])
        {        
            //get the new link and download image
            NSLog(@"My URL: %s", [myLink UTF8String]);
            NSLog(@"Current URL: %s", [currentURL UTF8String]);
            HW3_NEWTONAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            
            //===================================
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentURL]]];
            //===================================
            
            NSArray *myArray = [currentURL componentsSeparatedByString: @"/"];
            NSString* fileName = (NSString*)[myArray lastObject];
            if(!appDelegate.menuVC.fishStoreVC.addEditVC.isEditing)
            {
                [appDelegate.menuVC.fishStoreVC.addEditVC setFishName:[[fileName componentsSeparatedByString:@"."] objectAtIndex:0]];
            }
            
            [appDelegate.menuVC.fishStoreVC.addEditVC loadImageasUIImage:img];
            
            [self resetLinks];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
    return YES;   
}

-(void) resetLinks
{
    myLink      = [[NSString alloc] initWithString:@"http://129.7.54.19/html/marineaquarium/"];   
    currentURL  = myLink; 
    NSLog(@"After resetting");
    NSLog(@"My URL: %s", [myLink UTF8String]);
    NSLog(@"Current URL: %s", [currentURL UTF8String]);
}

-(void) doneAndGoBack
{
    //remove the added string
    [self resetLinks];
    
    [self dismissModalViewControllerAnimated:YES];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    // NSLog(@"Current URL: %s", [currentURL UTF8String]);
     //NSLog(@"MyLink URL: %s", [myLink UTF8String]);
    
   // if (!(currentURL == (id)[NSNull null] || currentURL.length == 0 ))
    //{        
        //if(![myLink isEqualToString:currentURL])
        //{
         //   [fishImageInRepos goBack];
        //}
    //}
    
    [fishImageInRepos loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:myLink]]]; 
    
}
- (void)dealloc
{
    [currentURL release];
    [myLink release];
    [fishImageInRepos release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [fishImageInRepos loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:myLink]]]; 
    
}

- (void)viewDidUnload
{
    [self setFishImageInRepos:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
