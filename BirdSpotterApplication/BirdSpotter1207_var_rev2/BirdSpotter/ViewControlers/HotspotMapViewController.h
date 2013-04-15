//
//  HotspotMapViewController.h
//  BirdSpotter
//
//  Created by Varun Varghese on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define METERS_PER_MILE 1609.344
#define MAP_DISPLAY_SCALE 100.0 //how many miles needs to be displayed

@class GeoLocationHelperModel;
@class  HotSpot;
@class BirdProfileViewController;

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SectionHeaderView.h"


@class MenuViewController;

@interface HotspotMapViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, SectionHeaderViewDelegate> 
{
    MKMapView *mapView;
    UITableView *hotspotTable;
    UIView *headerView;
    UIView *footerView;
    NSMutableArray* sectionInfoArray;
    NSInteger openSectionIndex;
    
    BirdProfileViewController *birdProfileVC;
    
    //app delegate
    BirdSpotterAppDelegate* appDelegate;
}

@property (nonatomic, retain) BirdSpotterAppDelegate* appDelegate;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITableView *hotspotTable;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, retain) BirdProfileViewController *birdProfileVC;

- (void)addAnnotations;

@end
