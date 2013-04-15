//
//  FishStoreViewController.m
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FishStoreViewController.h"
#import "EditFishViewController.h"
#import "FishStoreModel.h"
#import "FishStoreCellViewController.h"
#import "HW3_NEWTONAppDelegate.h"
#import "MenuViewController.h"
#import "FishTankInfo.h"
#import "FishBankModel.h"
#import "SimulationViewController.h"
#import "FishTankModel.h"
#import "FishBankViewController.h"

@implementation FishStoreViewController

@synthesize fishNameSelected,fishObject;
@synthesize addEditVC,addEditNavControl, appDelegate;
@synthesize addFishBankButton;
@synthesize accelerometer, angle;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}
- (void)dealloc{
    [accelerometer release];
    [addFishBankButton release];
    [fishNameSelected release];
    [fishObject release];
    [appDelegate release];
    [addEditNavControl release];
    [addEditVC release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];

    fishNameSelected = [[NSString alloc] init];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    //self.title = @"Fish Store";
    self.tableView.rowHeight = 80.0f;
        
    // create a toolbar where we can place some buttons
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:9];
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:spacer];
    
    // create a standard edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editFishInFishStore)];
    editButton.style = UIBarButtonItemStyleBordered;
    
    // create a standard add button with the trash icon
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self  action:@selector(deleteSelectedRow)];
    deleteButton.style = UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(goToHome:)];
    doneButton.style = UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(addToFishStore)];
    addButton.style = UIBarButtonItemStyleBordered;
    
    addFishBankButton = [[UIBarButtonItem alloc] initWithTitle:@"+ FB" style:UIBarButtonItemStylePlain target:self action:@selector(addToFishBank)];
    addFishBankButton.style = UIBarButtonItemStyleBordered;
    
    
    [buttons addObject:deleteButton];    
    [buttons addObject:spacer];    
    [buttons addObject:addButton];    
    [buttons addObject:spacer];    
    [buttons addObject:editButton];  
    [buttons addObject:spacer]; 
    [buttons addObject:addFishBankButton]; 
    [buttons addObject:spacer];  
    [buttons addObject:doneButton];
        
    
    [doneButton release];
    [addFishBankButton release];
    [editButton release];
    [addButton release];
    [deleteButton release];
    [spacer release];    
    
    // put the buttons in the toolbar and release them
    [toolbar setItems:buttons animated:NO];
    [buttons release];
    
    // place the toolbar into the navigation bar
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolbar] autorelease];
    [toolbar release];
    
    EditFishViewController *addEditViewController = [[EditFishViewController alloc] initWithNibName:@"EditFishViewController" bundle:[NSBundle mainBundle]];
    self.addEditVC = addEditViewController;
    [addEditViewController release];
    
    UINavigationController *ADNavController = [[UINavigationController alloc] initWithRootViewController:self.addEditVC];
    self.addEditNavControl = ADNavController;
    [ADNavController release];
    
    
}

-(void) addToFishBank
{
    if(fishObject != nil && [appDelegate.fishStoreArray count] > 0)
    {        
        //add it to database of fish bank
        if([addFishBankButton.title isEqualToString:@"+ FB"])
        {
            [FishBankModel addFishToFishBank:fishObject.fish_name andFishCategory:(NSString*) fishObject.fish_category dbPath:[appDelegate getDBPath]];
        }
        else
        {
            [FishBankModel removeFishFromTable:fishObject.fish_name dbPath:[appDelegate getDBPath]];    
            addFishBankButton.title = @"+ FB";     
        }
    
        [FishBankModel getDataFromDB:[appDelegate getDBPath]];
        [self.tableView reloadData];
    }
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;
    
}
-(void) deleteSelectedRow
{
    if([appDelegate.fishStoreArray count] > 0)
    {
    //removes from fish store
    [FishStoreModel removeFishFromFishStore:fishNameSelected dbPath:[appDelegate getDBPath]];
    [FishStoreModel getDataFromDB:[appDelegate getDBPath]];
    
    [appDelegate.menuVC.simVC.arrayOfFishesInTank removeAllObjects];
    
    //also remove from fish bank
    [FishBankModel removeFishFromTable:fishNameSelected dbPath:[appDelegate getDBPath]];
    [FishBankModel getDataFromDB:[appDelegate getDBPath]];
    
    //also remove from fish tank
    NSString* dbPath1 = [appDelegate getDBPath];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
   // NSString* path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@%@",fishNameSelected,@".png"] ];
    
    
    [FishTankModel removeFishFromTable:fishNameSelected dbPath:dbPath1];
    [FishTankModel getDataFromDB:[appDelegate getDBPath]];
    
    [appDelegate.menuVC.simVC.fishBankVC.tableView reloadData];
    [self.tableView reloadData];
    }
    
}

-(void) addToFishStore
{
    addEditVC.isEditing = NO;
    addEditVC.isInserting = YES;
    addEditVC.fishNameOutlet.enabled = YES;
    
    //open up the new view controller and get the data from repository
    [self presentModalViewController:self.addEditNavControl animated:YES];
}

-(void) editFishInFishStore
{
    if(fishObject != nil && [appDelegate.fishStoreArray count] > 0)
    {
        addEditVC.isEditing = YES;
        addEditVC.isInserting = NO;
        //data should be there in the fields
        NSString* category = [[NSString alloc] initWithString:fishObject.fish_category];
        NSString* name = [[NSString alloc] initWithString:fishObject.fish_name];
    
        NSInteger motion = fishObject.motion_pattern;
        NSString* motionStr = [NSString stringWithFormat:@"%@ %d",@"Type",motion];
    
        BOOL groupMotion = fishObject.group_motion;
        NSString* path   = [[NSString alloc] initWithString:fishObject.fish_path];
        //UIImage* image   = [[UIImage alloc] initWithContentsOfFile:path];
    
       // NSLog(@"%@", path);
    
        [addEditVC setValues:category andMotion:motionStr andGrouptMotion:groupMotion andName:name andImage:path];
        addEditVC.isEditing = YES;
        addEditVC.fishNameOutlet.enabled = NO;
        
        addEditVC.editingFishName = name;
        //[category release];
        //[name release];
        //[motionStr release];
        //[path release];
    
        [self presentModalViewController:self.addEditNavControl animated:YES];
    }
}

-(void)goToHome:(id)sender{
    [ self dismissModalViewControllerAnimated:YES];    
}
- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float xx = acceleration.x;
    float yy = acceleration.y;
    //float zz = acceleration.z;
    
    self.angle = atan2(yy, xx);    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    //float xx = -[acceleration x]; 
	//float yy =  [acceleration y]; 
	//float angle = atan2(yy, xx); 
	
	
	if(angle >= -2.25 && angle <= -0.25)
	{
		//if(interfaceOrientation != UIInterfaceOrientationPortrait)
		//{
        interfaceOrientation = UIInterfaceOrientationPortrait;
        return YES;
		//}
	}
    
	if(angle > -0.25 && angle <= 0.75)
	{
		//if(interfaceOrientation != UIInterfaceOrientationLandscapeRight)
		//{
		//	interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        return YES;
		//}
	}
    
	if(angle > 0.75 && angle <= 2.25)
	{
		//if(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
		//{
        interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        return YES;
		//}
	}
	
    if(angle < -2.25 || angle > 2.25)
	{
		//if(interfaceOrientation != UIInterfaceOrientationLandscapeLeft)
		//{
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        return YES;
		//}
	}    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [appDelegate.fishStoreArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FishStoreCellView";
    
    fishObject = [appDelegate.fishStoreArray objectAtIndex:indexPath.row];
    
    FishStoreCellViewController *fishStoreCell = ( FishStoreCellViewController*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //check if the fish is present in fish bank as well
    BOOL isFishPresentInBank = FALSE;
    NSEnumerator *e = [appDelegate.fishBankArray objectEnumerator];
    id item;
    while (item = [e nextObject]) 
    {
        NSString *tempName = [NSString stringWithFormat:@"%@",[item fish_name]];
        
        if([fishObject.fish_name isEqualToString:tempName])
        {
            isFishPresentInBank = TRUE;
            //break;
        }
    }
    
    if(fishStoreCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FishStoreCellView" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) 
            {
                fishStoreCell = currentObject;
                break;
            }
        }
        
        fishStoreCell.fishName.text = fishObject.fish_name;
        fishStoreCell.motionPatternDescription.text = fishObject.motion_pattern_description;
        fishStoreCell.categoryOutlet.text = fishObject.fish_category;
        
        //NSLog(@"%@", fishObject.fish_path);
        
        fishStoreCell.fishImage.image = [UIImage imageWithContentsOfFile:fishObject.fish_path];
                
        if(isFishPresentInBank)
        {
            fishStoreCell.addOrRemove.image = [UIImage imageNamed:@"delete.png"];
        }
        else
        {
            fishStoreCell.addOrRemove.image = [UIImage imageNamed:@"add.png"]; 
        }
        
    }
    return fishStoreCell;

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
    //Get the object from the array
    fishObject = [appDelegate.fishStoreArray objectAtIndex:indexPath.row];
    
    fishNameSelected = fishObject.fish_name;
    
    //check if the fish is present in fish bank as well
    BOOL isFishPresentInBank = FALSE;
    NSEnumerator *e = [appDelegate.fishBankArray objectEnumerator];
    id item;
    
    while (item = [e nextObject]) 
    {        
        if([fishObject.fish_name isEqualToString:[NSString stringWithFormat:@"%@",[item fish_name]]])
        {
            isFishPresentInBank = TRUE;
        }
    }
    
    if (isFishPresentInBank) 
    {
        //remove from db
        //[FishBankModel removeFishFromTable:fishObject.fish_name dbPath:appDelegate.getDBPath];
        //[FishBankModel getDataFromDB:appDelegate.getDBPath];
        addFishBankButton.title = @"- FB";
    }
    else
    {
        //add to db
        //[FishBankModel addFishToFishBank:fishObject.fish_name andFishCategory:fishObject.fish_category dbPath:[appDelegate getDBPath]];
        //[FishBankModel getDataFromDB:appDelegate.getDBPath];
        addFishBankButton.title = @"+ FB";
    }
    
    //[tableView reloadData];
}

@end
