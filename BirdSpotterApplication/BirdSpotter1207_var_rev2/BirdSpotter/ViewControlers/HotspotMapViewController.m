//
//  HotspotMapViewController.m
//  BirdSpotter
//
//  Created by Varun Varghese on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define DEFAULT_ROW_HEIGHT 36
#define HEADER_HEIGHT 36

#import "HotspotMapViewController.h"
#import "MenuViewController.h"
#import "GeoLocationHelperModel.h"
#import "HotSpot.h"
#import "SectionInfo.h"
#import "BirdProfileViewController.h"

@implementation HotspotMapViewController

@synthesize appDelegate;
@synthesize mapView;
@synthesize hotspotTable;
@synthesize headerView;
@synthesize footerView;
@synthesize sectionInfoArray;
@synthesize openSectionIndex;
@synthesize birdProfileVC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //init app delegate
        appDelegate = [[UIApplication sharedApplication] delegate];
        NSLog(@"app delegate for hotspot map init");
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
    
    // Set up default values.
    self.hotspotTable.sectionHeaderHeight = HEADER_HEIGHT;
    //rowHeight = DEFAULT_ROW_HEIGHT;
    openSectionIndex = NSNotFound;
    
    
    //[self performSelectorOnMainThread:@selector(addAnnotations) withObject:nil waitUntilDone:false];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    NSLog(@"HOTSPOT VC: View Wil Appear");
    //user location
    CLLocationCoordinate2D userLocation;
    userLocation.latitude = appDelegate.menuVC.latitude;
    userLocation.longitude = appDelegate.menuVC.longitude;
    
    //specify the box (or region) to display
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, MAP_DISPLAY_SCALE*METERS_PER_MILE, MAP_DISPLAY_SCALE*METERS_PER_MILE);
    
    //trim the region a bit into what can actually fit on the screen
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    
    //tells the mapView to display the region
    [mapView setRegion:adjustedRegion animated:YES];
    
    [mapView setShowsUserLocation:YES];
    
    //init the table data array
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self.appDelegate.hotSpotArray count])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (HotSpot *hs in self.appDelegate.hotSpotArray) {
			
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.hotspot = hs;
			sectionInfo.open = NO;
			
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
			NSInteger countOfBirds = [[sectionInfo.hotspot birdArray] count];
			for (NSInteger i = 0; i < countOfBirds; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
			
			[infoArray addObject:sectionInfo];
		}
		
		self.sectionInfoArray = infoArray;
	}
    [self addAnnotations];
    [hotspotTable reloadData];
}



- (void)viewDidUnload
{
    //[appDelegate release];
    [self setMapView:nil];
    [self setHotspotTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.sectionInfoArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma annotations

- (void)addAnnotations
{
    /*
    CLLocationCoordinate2D userCord;
    userCord.latitude = appDelegate.menuVC.latitude;
    userCord.longitude = appDelegate.menuVC.longitude;
    
    NSString * timeStampString =@"1304245000";
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    CLLocation *userLocation = [[CLLocation alloc] initWithCoordinate:userCord altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:date];*/
    //[NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970]]
    
    for (HotSpot *hs in appDelegate.hotSpotArray) 
    {
        /*CLLocation *hsLocation = [[CLLocation alloc] initWithCoordinate:[hs coordinate] altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:date];
        //NSLog(@"add annotations");
        float distance = [userLocation distanceFromLocation:hsLocation]/1000;
         
        
        NSString *distanceString = [NSString stringWithFormat:@"%f", distance];
        //[distanceString stringByAppendingString:@" km"];
        NSLog(@"%@", distanceString);
        hs.distanceFromUser = distanceString;*/
        
        [mapView addAnnotation:hs];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view 
{
    //
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //
}

- (MKAnnotationView *)mapView:(MKMapView *)mapViewLocal viewForAnnotation:(id <MKAnnotation>)annotation 
{
    if ([annotation isKindOfClass:[MKUserLocation class]] ) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapViewLocal dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    /*
    if(pinView == nil) 
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        pinView.pinColor = MKPinAnnotationColorPurple;
        //pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.calloutOffset = CGPointMake(-5, 5);
        
        UIImageView *birdIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird1.png"]];
        [birdIconView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.leftCalloutAccessoryView = birdIconView;
       [birdIconView release]; 
    }*/
    if (!pinView)
    {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];

        [pinView setPinColor:MKPinAnnotationColorPurple];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;

        UIImageView *birdIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird1.png"]];
        [birdIconView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.leftCalloutAccessoryView = birdIconView;
        [birdIconView release];        
    }
    else 
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    static NSString *identifier = @"HotSpot";   
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) 
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } 
    else 
    {
        annotationView.annotation = annotation;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    return annotationView;
}   
*/
    
- (void)dealloc 
{
    [appDelegate release];
    [birdProfileVC release];
    [mapView release];
    [hotspotTable release];
    [headerView release];
    [footerView release];
    [super dealloc];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.appDelegate hotSpotArray] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numBirdsInSection = [[sectionInfo.hotspot birdArray] count];
	
    return sectionInfo.open ? numBirdsInSection : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //return headerView;
    /*UIView* header = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,60)];
    [header setBackgroundColor:[UIColor darkGrayColor]];
    return header;*/
    
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    
    if (!sectionInfo.headerView) {
    sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0,hotspotTable.bounds.size.width, HEADER_HEIGHT) title:[sectionInfo.hotspot name] section:section delegate:self];
    }
    return sectionInfo.headerView;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    //NSString *name = [[[[[self.sectionInfoArray objectAtIndex:indexPath.section] hotspot] birdArray]objectAtIndex:indexPath.row] name];
    //NSLog(@"Section: %d, Row: %d", indexPath.section, indexPath.row);
    HotSpot *hs = (HotSpot *)[[self.sectionInfoArray objectAtIndex:indexPath.section] hotspot];
    //NSLog(@"%@",[[hs birdArray]objectAtIndex:indexPath.row]);
    [cell.textLabel setText: [[hs birdArray]objectAtIndex:indexPath.row]];
    
    //[cell.textLabel setText:@"Hello TableView"];
    //[self.hotspotTable beginUpdates];
    //[self.hotspotTable endUpdates];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HotSpot *hs = (HotSpot *)[[self.sectionInfoArray objectAtIndex:indexPath.section] hotspot];
    NSString* name = [[hs birdArray]objectAtIndex:indexPath.row];
    
    //Bird* tempBird = [BirdProfileModel getBirdFromId:[BirdProfileModel getBirdIdFromName:name]];
    
    //init a bird profile view
    BirdProfileViewController *aBirdProfileVC = [[BirdProfileViewController alloc] initWithNibName:@"BirdProfileViewController" bundle:[NSBundle mainBundle]];
    self.birdProfileVC = aBirdProfileVC;
    [aBirdProfileVC release];
    
    self.birdProfileVC.birdID = [BirdProfileModel getBirdIdFromName:name];
    
    //make transition
    [self presentModalViewController:self.birdProfileVC animated:YES];
    
    [name release];
}

#pragma mark Section header delegate
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.hotspot.birdArray count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.hotspot.birdArray count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.hotspotTable beginUpdates];
    [self.hotspotTable insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.hotspotTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.hotspotTable endUpdates];
    self.openSectionIndex = sectionOpened;
    
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.hotspotTable numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.hotspotTable deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.hotspotTable beginUpdates];
    [self.hotspotTable endUpdates];
    
    self.openSectionIndex = NSNotFound;
}

@end
