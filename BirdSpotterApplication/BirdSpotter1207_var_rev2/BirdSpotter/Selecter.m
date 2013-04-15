//
//  Selecter.m
//  BirdSpotter
//
//  Created by Varun Varghese on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Selecter.h"
#import "GeoLocationHelperModel.h"

@implementation Selecter
@synthesize cityPicker;
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    arrayCity = [[NSMutableArray alloc] init];
    [arrayCity addObject:@"Houston"];
    [arrayCity addObject:@"Austin"];
    [arrayCity addObject:@"Galveston"];
    [arrayCity addObject:@"San Antonio"];
    [arrayCity addObject:@"Corpus Christi"];
    
    appDelegate.cityString = [arrayCity objectAtIndex:0];
    CLLocationCoordinate2D userCoordinate = [GeoLocationHelperModel getCoordinatesFor:[arrayCity objectAtIndex:0]];
    appDelegate.userLatitude = userCoordinate.latitude;
    appDelegate.userLongitude = userCoordinate.longitude;
}

- (void)viewDidUnload
{
    [self setCityPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [cityPicker release];
    [super dealloc];
}
- (IBAction)dismiss:(id)sender {
    [self.view removeFromSuperview];
}

#pragma mark - picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView 
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [arrayCity count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayCity objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayCity objectAtIndex:row], row);
    appDelegate.cityString = [arrayCity objectAtIndex:row];
    CLLocationCoordinate2D userCoordinate = [GeoLocationHelperModel getCoordinatesFor:[arrayCity objectAtIndex:row]];
    appDelegate.userLatitude = userCoordinate.latitude;
    appDelegate.userLongitude = userCoordinate.longitude;
}
@end
