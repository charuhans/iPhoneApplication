//
//  MenuViewController.m
//  HW1_Newton
//
//  Created by Newton on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HW3_NEWTONAppDelegate.h"
#import "MenuViewController.h"
#import "FishStoreViewController.h"
#import "SimulationViewController.h"

@implementation MenuViewController

@synthesize fishStoreVC;
@synthesize fishStoreNavControl;
@synthesize simVC, fishSimNavControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        FishStoreViewController *fsViewController = [[FishStoreViewController alloc] initWithNibName:@"FishStoreViewController" bundle:[NSBundle mainBundle]];
        self.fishStoreVC = fsViewController;
        [fsViewController release];
        
        UINavigationController *FSNavController = [[UINavigationController alloc] initWithRootViewController:self.fishStoreVC];
        self.fishStoreNavControl = FSNavController;
        [FSNavController release];
        
        SimulationViewController *simViewController = [[SimulationViewController alloc] initWithNibName:@"SimulationViewController" bundle:[NSBundle mainBundle]];
        self.simVC = simViewController;
        [simViewController release];
        
        UINavigationController *SimNavController = [[UINavigationController alloc] initWithRootViewController:self.simVC];
        self.fishSimNavControl = SimNavController;
        [SimNavController release];
        [simVC pauseTimer];
        
    }
    
    return self;
}

- (void)dealloc
{
    [simVC release];
    [fishSimNavControl release];
    [fishStoreVC release];
    [fishStoreNavControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)simulationAction:(id)sender 
{
    [simVC resumeTimer];
    [self presentModalViewController:self.fishSimNavControl animated:YES];
}

- (IBAction)fishstoreAction:(id)sender 
{
    [self presentModalViewController:self.fishStoreNavControl animated:YES];
}

- (IBAction)quitAction:(id)sender 
{
    exit(0);
     
}
@end
