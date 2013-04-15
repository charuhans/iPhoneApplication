//
//  BirdBookTableViewController.h
//  BirdSpotter
//
//  Created by Newton on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
@class Bird;
@class BirdBookCellViewController;
@class BirdProfileViewController;
@class BirdProfileModel;

#import <UIKit/UIKit.h>

@interface BirdBookTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    BirdSpotterAppDelegate* appDelegate;
    
    NSArray *content;
    NSArray *indices;
    NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    BirdProfileViewController *birdProfileVC;
    
    NSMutableArray* birdIndex;
    
    
    
}

@property (nonatomic, retain) BirdSpotterAppDelegate* appDelegate;
@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSArray *indices;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, retain) BirdProfileViewController *birdProfileVC;
@property (nonatomic, retain) NSMutableArray* birdIndex;

-(NSArray*) getSortedBirds;
-(void) searchTableView;
-(void) doneSearching_Clicked:(id)sender;

@end
