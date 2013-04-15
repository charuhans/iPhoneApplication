#import "FishBankViewController.h"
#import "FishBankCellViewController.h"
#import "FishBankModel.h"
#import "FishStoreModel.h"
#import "FishTankModel.h"
#import "SimulationViewController.h"
#import "MenuViewController.h"
#import "HW3_NEWTONAppDelegate.h"

@implementation FishBankViewController

@synthesize fishBankAppDelegate;
@synthesize image_name_to_simvc;
@synthesize accelerometer;
@synthesize angle;

- (id)initWithStyle:(UITableViewStyle)style
{
    self.image_name_to_simvc = [[NSString alloc] init];
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [accelerometer release];
    [fishBankAppDelegate release];
    [image_name_to_simvc release];
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
    
    fishBankAppDelegate = [[UIApplication sharedApplication] delegate];
    
    self.title = @"Fish Bank";
    self.tableView.rowHeight = 80.0f;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStylePlain target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;
    
}

-(void)goToHome:(id)sender
{
    [fishBankAppDelegate.menuVC.simVC resumeTimer];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float xx = acceleration.x;
    float yy = acceleration.y;
    //float zz = acceleration.z;
    
    self.angle = atan2(yy, xx);    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	
	if(angle >= -2.25 && angle <= -0.25)
	{
		//if(interfaceOrientation != UIInterfaceOrientationPortrait)
		//{
			interfaceOrientation = UIInterfaceOrientationPortrait;
            return YES;
		//}
	}
    
	if(angle >= -0.25 && angle <= 0.75)
	{
		//if(interfaceOrientation != UIInterfaceOrientationLandscapeRight)
		//{
			interfaceOrientation = UIInterfaceOrientationLandscapeRight;
            return YES;
		//}
	}
    
	if(angle >= 0.75 && angle <= 2.25)
	{
		//if(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown)
		//{
			interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
            return YES;
		//}
	}
    
	if(angle <= -2.25 || angle >= 2.25)
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    // Return the number of rows in the section.
    return [fishBankAppDelegate.fishBankArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"FishBankCellView";
    
    //Get the object from the array
    FishBankModel *fishObject = [fishBankAppDelegate.fishBankArray objectAtIndex:indexPath.row];
    
    FishBankCellViewController *fishBankCell = ( FishBankCellViewController*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(fishBankCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FishBankCellView" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) 
            {
                fishBankCell = currentObject;
                break;
            }
        }
        
        fishBankCell.fishName.text = fishObject.fish_name;
        
        NSEnumerator *e = [fishBankAppDelegate.fishStoreArray objectEnumerator];
        id item;
        while ((item = [e nextObject])) 
        {
            if([fishObject.fish_name isEqualToString:[NSString stringWithFormat:@"%@",[item fish_name]]])
            {
                fishBankCell.fishImage.image                = [UIImage imageWithContentsOfFile:[item fish_path]];
                fishBankCell.motionPatternDescription.text  = [NSString stringWithFormat:@"%@",[item motion_pattern_description]];
                fishBankCell.categoryOutlet.text            = [NSString stringWithFormat:@"%@", fishObject.fish_category];
                fishBankCell.counterLabel.text              = [NSString stringWithFormat:@"%d",fishObject.fish_counter];
            }
        }
    }
    
    return fishBankCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{     
    
    //Get the object from the fish store array
    FishBankModel *fishObject = [fishBankAppDelegate.fishBankArray objectAtIndex:indexPath.row];
   
    
    //add to fish tank db
    int x= (int)fishBankAppDelegate.menuVC.simVC.center.x;
    int y= (int)fishBankAppDelegate.menuVC.simVC.center.y;
    CGPoint userInputLocation = CGPointMake(x, y);
    
        
    if([fishBankAppDelegate.menuVC.simVC checkIfPositionAvailable:userInputLocation])
    {
        NSInteger h_dir;
        fishBankAppDelegate.menuVC.simVC.idCounter++;
        NSInteger motionPatt = [FishStoreModel getMotionFromDB:[fishBankAppDelegate getDBPath] andName:fishObject.fish_name];
        NSString* group_motion = [FishStoreModel getGroupMotionFromDB:[fishBankAppDelegate getDBPath] andName:fishObject.fish_name];
        if(motionPatt == 4 || motionPatt == 3)
        {
            h_dir = 4;
            [FishTankModel addFishToTable:fishObject.fish_category xcord:x ycord:y headDir:h_dir dbPath:fishBankAppDelegate.getDBPath fishid:fishBankAppDelegate.menuVC.simVC.idCounter fishGroup:group_motion name:fishObject.fish_name];
        }
        else if(motionPatt == 2 || motionPatt == 5)
        {
            h_dir = 8;
            [FishTankModel addFishToTable:fishObject.fish_category xcord:x ycord:y headDir:h_dir dbPath:fishBankAppDelegate.getDBPath fishid:fishBankAppDelegate.menuVC.simVC.idCounter fishGroup:group_motion name:fishObject.fish_name];
        }
        else 
        {
            h_dir = 4;
            [FishTankModel addFishToTable:fishObject.fish_category xcord:x ycord:y headDir:h_dir dbPath:fishBankAppDelegate.getDBPath fishid:fishBankAppDelegate.menuVC.simVC.idCounter fishGroup:group_motion name:fishObject.fish_name];
        }
        [fishBankAppDelegate.menuVC.simVC setFishName:fishObject.fish_name];
                
        [FishTankModel getDataFromDB:[fishBankAppDelegate getDBPath]];
        
        NSEnumerator *e = [fishBankAppDelegate.fishStoreArray objectEnumerator];
        id item;
    
        while ((item = [e nextObject])) 
        {
            if([fishObject.fish_name isEqualToString:[NSString stringWithFormat:@"%@",[item fish_name]]])
            {
                image_name_to_simvc = [NSString stringWithFormat:@"%@",[item fish_path]];
                [fishBankAppDelegate.menuVC.simVC set_image_name_simscreen:image_name_to_simvc];     
            
                //update the label in fish bank database
                [FishBankModel  updateFishBankDB:fishBankAppDelegate.getDBPath name:fishObject.fish_name andChange:1];
                break;
            }
        }        
        
        
        [fishBankAppDelegate.menuVC.simVC refresh];                
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        //cant add
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Adding Fish" message:@"Fish is too close to that location. \n Go back and select a new location." delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
     
    
}

@end
