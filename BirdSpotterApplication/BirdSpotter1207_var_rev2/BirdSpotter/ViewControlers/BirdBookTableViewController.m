//
//  BirdBookTableViewController.m
//  BirdSpotter
//
//  Created by Newton on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirdSpotterAppDelegate.h"
#import "BirdBookTableViewController.h"
#import "BirdBookCellViewController.h"
#import "Bird.h"
#import "BirdProfileViewController.h"
#import "BirdProfileModel.h"
#import "MultipleViewController.h"

@implementation BirdBookTableViewController
@synthesize appDelegate;
@synthesize content;
@synthesize indices;
@synthesize birdProfileVC;
@synthesize birdIndex;
@synthesize filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [filteredListContent release];
    [birdIndex release];
    [birdProfileVC release];
    [indices release];
    [content release];
    [appDelegate release];
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
    
    self.tableView.separatorColor = [UIColor colorWithRed:0.5f green:0.48f blue:0.47f alpha:1.0f];
    
    //intit birdIndex array
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    self.birdIndex = indexArray;
    [indexArray release];
    
    //init app delegate
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //init contents
    content = [self getSortedBirds];
    indices = [[content valueForKey:@"headerTitle"] retain];
    
    // create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.content count]];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [birdProfileVC viewDidLoad];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.filteredListContent = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [birdProfileVC viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [birdProfileVC viewDidDisappear:animated];
    
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Bird *tempBird in appDelegate.birdProfileArray)
	{
        /*
		NSComparisonResult result = [tempBird.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
                NSLog(@"Comparison result %@", tempBird.name);
				[self.filteredListContent addObject:tempBird.name];
            }*/
        NSRange nameResultsRange = [tempBird.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (nameResultsRange.length > 0)
        {
            [self.filteredListContent addObject:tempBird.name];
        }
		
	}
}
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:@"All"];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return [self.content count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [[[content objectAtIndex:section] objectForKey:@"rowValues"] count] ;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"BirdBookCellView";
     
    BirdBookCellViewController *birdCell = (BirdBookCellViewController*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (birdCell == nil) 
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BirdBookCellView" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) 
            {
                birdCell = currentObject;
                break;
            }
        }
        
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            NSLog(@"Row name %@",[filteredListContent objectAtIndex:indexPath.row]);
            
            //[self.filteredListContent objectAtIndex:indexPath.row];
            birdCell.birdName.text = [filteredListContent objectAtIndex:indexPath.row];
            
            for (Bird *tempBird in appDelegate.birdProfileArray) 
            {
                if([tempBird.name isEqualToString:[filteredListContent objectAtIndex:indexPath.row]])
                {
                    birdCell.birdThumbnail.image = [UIImage imageNamed:tempBird.bird_book_img];
                    //[birdIndex addObject: [[NSNumber alloc] initWithInt:tempBird.dbID]]; //add id to an array
                }
            }
        }
        else
        {
            birdCell.birdName.text = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] 
                                      objectAtIndex:indexPath.row];
            
            for (Bird *tempBird in appDelegate.birdProfileArray) 
            {
                if([tempBird.name isEqualToString:[[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] 
                                                   objectAtIndex:indexPath.row]])
                {
                    birdCell.birdThumbnail.image = [UIImage imageNamed:tempBird.bird_book_img];
                    [birdIndex addObject: [[NSNumber alloc] initWithInt:tempBird.dbID]]; //add id to an array
                }
            }
        }
        
        
        
    }
    return birdCell;*/
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        NSLog(@"Row name %@",[filteredListContent objectAtIndex:indexPath.row]);
        
        //[self.filteredListContent objectAtIndex:indexPath.row];
        [cell.textLabel setText: [filteredListContent objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell.textLabel setText: [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] 
                                  objectAtIndex:indexPath.row]];
        
        for (Bird *tempBird in appDelegate.birdProfileArray) 
        {
            if([tempBird.name isEqualToString:[[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] 
                                               objectAtIndex:indexPath.row]])
            {
                [birdIndex addObject: [[NSNumber alloc] initWithInt:tempBird.dbID]]; //add id to an array
            }
        }
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (tableView != self.searchDisplayController.searchResultsTableView)
        return [[content objectAtIndex:section] objectForKey:@"headerTitle"];
    else
        return @"";
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    return [content valueForKey:@"headerTitle"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* name;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        
        //product = [self.filteredListContent objectAtIndex:indexPath.row];
        name = [filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        name = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    }    
    //int n = [((NSNumber*)[birdIndex objectAtIndex: indexPath.row]) intValue];
    //NSString* name = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    
    //Bird* tempBird = [BirdProfileModel getBirdFromId:[BirdProfileModel getBirdIdFromName:name]];
    
    //init a bird profile view
    BirdProfileViewController *aBirdProfileVC = [[BirdProfileViewController alloc] initWithNibName:@"BirdProfileViewController" bundle:[NSBundle mainBundle]];
    self.birdProfileVC = aBirdProfileVC;
    [aBirdProfileVC release];
    
    self.birdProfileVC.birdID = [BirdProfileModel getBirdIdFromName:name];
    
    //make transition
    [self presentModalViewController:self.birdProfileVC animated:YES];
    
    [name release];
    //[tempBird release];
}

-(NSArray*) getSortedBirds
{
    //NSLog(@"getSortedBirds");
    NSMutableArray *content = [NSMutableArray new];
    
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
    
    NSMutableArray *sortedBirds = [appDelegate.birdProfileArray sortedArrayUsingSelector:@selector(compareByName:)];
    
    for (int i = 0; i < [letters length]; i++) 
    {
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *names = [[[NSMutableArray alloc] init] autorelease];
        BOOL found = FALSE;
        
        for (Bird *tempBird in sortedBirds) 
        {
            if (toupper([tempBird.name characterAtIndex:0]) == toupper([letters characterAtIndex:i])) 
            {
                //NSLog(@"Found char");
                [names addObject:[NSString stringWithString:tempBird.name]];
                found = true;
            }
        }
        
        if (found) 
        {
            // add objects to contents
            char currentLetter[2] = { toupper([letters characterAtIndex:i]), '\0'};        
            [row setValue:[NSString stringWithCString:currentLetter encoding:NSASCIIStringEncoding] 
                   forKey:@"headerTitle"]; //row headers
            [row setValue:names forKey:@"rowValues"]; //row contents         
            [content addObject:row];
        }
        
    }
    
    return content;
}

@end
