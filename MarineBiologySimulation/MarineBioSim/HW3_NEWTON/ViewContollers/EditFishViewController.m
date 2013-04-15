//
//  EditFishViewController.m
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "HW3_NEWTONAppDelegate.h"
#import "EditFishViewController.h"
#import "fishWebViewContoller.h"
#import "MenuViewController.h"
#import "FishBankViewController.h"
#import "SimulationViewController.h"
#import "FishStoreViewController.h"
#import "FishStoreModel.h"
#import "FishTankModel.h"
#import "FishBankModel.h"
#import "CustomSwitch.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "WebGalleryViewController.h"

@implementation EditFishViewController
@synthesize goToWebViewButton;
@synthesize categoryOutlet;
@synthesize motionoutlet;
@synthesize fishImageView,toolbar,myPickerView,arrayCategory, arrayMotion;
@synthesize appdelegate;
@synthesize groupMotionOutlet;
@synthesize fishNameOutlet;
@synthesize categoryNextOutlet;
@synthesize motionNextOutlet;
@synthesize fishWebVC;
@synthesize fishWebNavControl;
@synthesize isEditing, isInserting;
@synthesize editingFishName;
@synthesize link;
@synthesize webGalleryVC, webGalleryNavControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        isEditing = NO;
        isInserting = NO;
        editingFishName = [[NSString alloc] init];
        /*
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        */
        
        appdelegate = [[UIApplication sharedApplication] delegate];
        
        isCategory = FALSE;
        isMotion = FALSE;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goToFishStore)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAndGoBack)];
        
        fishWebViewContoller *fwViewController = [[fishWebViewContoller alloc] initWithNibName:@"fishWebViewContoller" bundle:[NSBundle mainBundle]];
        self.fishWebVC = fwViewController;
        [fwViewController release];
        
        UINavigationController *FWNavController = [[UINavigationController alloc] initWithRootViewController:self.fishWebVC];
        self.fishWebNavControl = FWNavController;
        [FWNavController release];
        
        WebGalleryViewController *webVC = [[WebGalleryViewController alloc] initWithNibName:@"WebGalleryViewController" bundle:[NSBundle mainBundle]];
        self.webGalleryVC = webVC;
        [webVC release];
        
        UINavigationController *webNavController = [[UINavigationController alloc] initWithRootViewController:self.webGalleryVC];
        self.webGalleryNavControl = webNavController;
        [webNavController release];
        
        toolbar = [UIToolbar new];    
        toolbar.frame = CGRectMake(0, 160, 320, 40);
        
        arrayCategory = [[NSMutableArray alloc] init];
        [arrayCategory addObject:@"Angle"];
        [arrayCategory addObject:@"Anthias"];
        [arrayCategory addObject:@"Bass"];
        [arrayCategory addObject:@"Batfish"];
        [arrayCategory addObject:@"Blenny"];
        [arrayCategory addObject:@"Boxfish"];
        [arrayCategory addObject:@"Cardinalfish"];
        [arrayCategory addObject:@"Clownfish"];
        [arrayCategory addObject:@"Dartfish"];
        [arrayCategory addObject:@"Dragonetes"];
        [arrayCategory addObject:@"Shark"];
        
        arrayMotion = [[NSMutableArray alloc] init];
        for(int i = 1; i < 8; i++)
        {
            [arrayMotion addObject:[@"Type " stringByAppendingFormat:@"%d",i]];
        }
        
        
        
        //adding flexible space between buttons to evenly space tham out 
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        //adding birdbook button
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self 
                                       action:@selector(doneAction)]; 
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                       target:self 
                                         action:@selector(cancelAction)]; 
        
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects: doneButton, space, cancelButton, nil];
        
        [toolbarItems retain];
        
        [toolbar setItems:toolbarItems animated:NO];
        
        
        groupMotionOutlet = [CustomSwitch switchWithLeftText:@"YES" andRight:@"NO"];
        [groupMotionOutlet setCenter:CGPointMake(198.0f,248.0f)];
        
        goToWebViewButton.enabled = NO;
                
        [self.view addSubview:groupMotionOutlet];
        
    }
    return self;
}

-(void) goToFishStore
{
    [self clearAll];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) doneAndGoBack
{
    //set all the values in the db and go back to fish store, new value to be added on add
    // values should be modified on edit in fish store
    if(![self fishExistsInFishStore] || isEditing)
    {
        //save the image to the document folder, so that it can be uploaded later on    
        [self saveImage:fishImageView.image];    
    
        [self clearAll];
        
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Fish Name already exists." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

-(BOOL) fishExistsInFishStore
{
    BOOL isFishPresentInBank = FALSE;
    
    HW3_NEWTONAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSEnumerator *e = [appDelegate.fishStoreArray objectEnumerator];
    id item;
    while (item = [e nextObject]) 
    {
        NSString *tempName = [NSString stringWithFormat:@"%@",[item fish_name]];
        
        if([fishNameOutlet.text isEqualToString:tempName])
        {
            isFishPresentInBank = TRUE;
        }
    }   
    return isFishPresentInBank;
}

- (void)saveImage: (UIImage*)image
{
    if (image != nil && ![categoryOutlet.text isEqualToString:@""] && ![motionoutlet.text isEqualToString:@""] && ![fishNameOutlet.text isEqualToString:@""])
    {
        //get the path for document directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@%@",fishNameOutlet.text,@".png"] ];
                
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
        
        NSNumber* number = [NSNumber numberWithUnsignedChar:[motionoutlet.text characterAtIndex:5]];
        NSInteger motionInt = [number intValue] - 48;
            
        NSString* group;
        if(groupMotionOutlet.on ==YES)
        {
            group = [[NSString alloc] initWithString:@"YES"];
        }
        else
        {
            group = [[NSString alloc] initWithString:@"NO"];
        }
                
        if(isEditing)
        {
            
            //update fish store
            [FishStoreModel updateDB:categoryOutlet.text andMotion:motionInt andFishGroup:group andFishName:fishNameOutlet.text andFishPath:path dbPath:[appdelegate getDBPath]];
            
            //update fish bank
            [FishBankModel updateDB:(NSString*)categoryOutlet.text andFishName:fishNameOutlet.text dbPath:[appdelegate getDBPath]];
            
            //update fish tank
            [FishTankModel updateDB:fishNameOutlet.text dbPath:[appdelegate getDBPath] name:path group:group];
            
            //also their arrays
            
            [FishStoreModel getDataFromDB:[appdelegate getDBPath]];
            [FishBankModel getDataFromDB:[appdelegate getDBPath]];
            [FishTankModel getDataFromDB:[appdelegate getDBPath]];
        }
        else
        {
                
        //add all this to database as well
            [FishStoreModel addFishToFishStore:categoryOutlet.text andMotion:motionInt andFishGroup:group andFishName:fishNameOutlet.text andFishPath:path dbPath:[appdelegate getDBPath]];
            [FishStoreModel getDataFromDB:[appdelegate getDBPath]];
        }
        
        fishNameOutlet.enabled = YES;
        
        [appdelegate.menuVC.fishStoreVC.tableView reloadData];
        [appdelegate.menuVC.simVC.fishBankVC.tableView reloadData];
    }
}

-(void) clearAll
{
    categoryOutlet.text = @"";
    motionoutlet.text = @"";
    fishNameOutlet.text = @"";
    [groupMotionOutlet setOn:NO];
    [fishImageView removeFromSuperview];
}

- (void)dealloc
{
    [webGalleryVC release];
    [webGalleryNavControl release];
    [link release];
    [editingFishName release];
    [appdelegate release];
    [arrayMotion release];
    [arrayCategory release];
    [toolbar release];
    [categoryOutlet release];
    [motionoutlet release];
    [categoryNextOutlet release];
    [motionNextOutlet release];
    [groupMotionOutlet release];
    [fishNameOutlet release];
    [goToWebViewButton release];
    [super dealloc];
    [fishWebVC release];
    [fishWebNavControl release];
}
-(void) setValues:(NSString *) fishCategory andMotion:(NSString*) fishMotion andGrouptMotion:(BOOL) fishGroupMotion 
          andName:(NSString*) fishName andImage:(NSString*) fishImageName
{
    categoryOutlet.text  = fishCategory;
    motionoutlet.text    = fishMotion;
    groupMotionOutlet.on = fishGroupMotion;
    fishNameOutlet.text  = fishName;
    [self loadImage:fishImageName];
}

-(void) setFishName:(NSString*) fishName
{
    fishNameOutlet.text = fishName;
}

-(IBAction) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [fishNameOutlet resignFirstResponder];
    [self.view endEditing:YES];
} 

- (IBAction)backgroundTouch:(id)sender {
    [fishNameOutlet resignFirstResponder];
    [sender resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) loadImageasUIImage:(UIImage*) image
{    
    self.fishImageView = [[UIImageView alloc] initWithImage:image];
    [fishImageView setFrame:CGRectMake(133, 292, 104, 105)];
    
    [self.view addSubview:fishImageView];
}

-(void) loadImage:(NSString*) imageName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString* path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithString:imageName] ];
    UIImage* image = [UIImage imageWithContentsOfFile:imageName];
        
    self.fishImageView = [[UIImageView alloc] initWithImage:image];
    [fishImageView setFrame:CGRectMake(133, 292, 104, 105)];
    
    [self.view addSubview:fishImageView];
}

-(void) loadDefaultImage:(UIImage*) defaultImg
{
    self.fishImageView = [[UIImageView alloc] initWithImage:defaultImg];
    [fishImageView setFrame:CGRectMake(147, 305, 104, 105)];
        
    [self.view addSubview:fishImageView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setFishImageView:nil];
    [self setCategoryOutlet:nil];
    [self setMotionoutlet:nil];
    [self setCategoryNextOutlet:nil];
    [self setMotionNextOutlet:nil];
    [self setGroupMotionOutlet:nil];
    [self setFishNameOutlet:nil];
    [self setGoToWebViewButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)categoryAction:(id)sender 
{
    categoryOutlet.text = @"Angle";
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [self addPickerView];
    
    isCategory = TRUE;
    isMotion   = FALSE;
}

- (IBAction)motionAction:(id)sender 
{
    motionoutlet.text = @"Type 1";
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [self addPickerView];
    
    isMotion   = TRUE;
    isCategory = FALSE;
}

-(void) addPickerView
{
    categoryNextOutlet.enabled = NO;
    motionNextOutlet.enabled   = NO;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    [self.view addSubview:myPickerView];
    [self.view addSubview:toolbar];
}

-(NSString*)getCategoryLink
{
    if ([categoryOutlet.text isEqualToString:@"Angle"]) 
    {
        return @"angle";
    }
    else if ([categoryOutlet.text isEqualToString:@"Anthias"]) 
    {
        return @"anthias";
    }
    else if ([categoryOutlet.text isEqualToString:@"Bass"]) 
    {
        return @"bass";
    }
    else if ([categoryOutlet.text isEqualToString:@"Batfish"]) 
    {
        return @"batfish";
    }
    else if ([categoryOutlet.text isEqualToString:@"Blenny"]) 
    {
        return @"blenny";
    }
    else if ([categoryOutlet.text isEqualToString:@"Boxfish"]) 
    {
        return @"boxfish";
    }
    else if ([categoryOutlet.text isEqualToString:@"Cardinalfish"]) 
    {
        return @"cardinalfish";
    }
    else if ([categoryOutlet.text isEqualToString:@"Clownfish"]) 
    {
        return @"clownfish";
    }
    else if ([categoryOutlet.text isEqualToString:@"Dartfish"]) 
    {
        return @"dartfish";
    }
    else if ([categoryOutlet.text isEqualToString:@"Dragonetes"]) 
    {
        return @"dragonets";
    }
    else if ([categoryOutlet.text isEqualToString:@"Shark"]) 
    {
        return @"shark";
    }
    
    return @"angle";
}

- (IBAction)goToWebView:(id)sender 
{
    NSLog(@"Length ->%d",[categoryOutlet.text length]);
    NSLog(@"Hello -> %@",categoryOutlet.text);
    NSError *error = nil;
    NSMutableArray *imgNameAray = [[NSMutableArray alloc] init];
    
    if([categoryOutlet.text length] > 1)
    {
        
        NSString* category = [[NSString alloc] initWithString:[self getCategoryLink]];
        link = [[NSString alloc] initWithFormat:@"%@%@",@"http://129.7.54.19/html/marineaquarium/",category];
       // [fishWebVC setLinks:category];
        NSData *companyData = [NSData dataWithContentsOfURL:[NSURL URLWithString:link]];
        NSString *responseString = [[NSString alloc] initWithData:companyData encoding:NSUTF8StringEncoding];
        
        HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
        
        if (error) 
        {
            //NSLog(@"Error: %@", error);
            return;
        }
        
        
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"a"];
        
        for (HTMLNode *inputNode in inputNodes)        
        {
            NSString* filename = [[NSString alloc] initWithString:[inputNode getAttributeNamed:@"href"]];
            
            if([filename isEqualToString:@"Thumbs.db"])
            {
                break;
            }
            NSArray *myArray = [filename componentsSeparatedByString: @"."];
            
            
            if([[myArray objectAtIndex:[myArray count]-1] isEqualToString:@"jpg"] || [[myArray objectAtIndex:[myArray count]-1] isEqualToString:@"JPG"])
            {
                [imgNameAray addObject:filename];
                
                NSLog(@"%@", [myArray objectAtIndex:0]); 
            }
            
        }
        
        
        
        [parser release];
        
        [webGalleryVC setLinkImageArray:link imgArray:imgNameAray];
        //[webGalleryVC viewDidLoad];
        //NSString* category = [[NSString alloc] initWithString:[self getCategoryLink]];
        //[fishWebVC setLinks:category];
        [self presentModalViewController:self.webGalleryNavControl animated:YES];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Select a category First." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component 
{
    if(isCategory)
    {
        categoryOutlet.text =  [arrayCategory objectAtIndex:row]; 
        goToWebViewButton.enabled = YES;
        
    }
    else if(isMotion)
    {
        motionoutlet.text =  [arrayMotion objectAtIndex:row];  
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    NSUInteger numRows;
    if(isCategory)
    {
        numRows = [arrayCategory count];
    }
    else if(isMotion)
    {
       numRows = [arrayMotion count];
    }
    
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)doneAction
{
    
    [toolbar removeFromSuperview];
    [myPickerView removeFromSuperview];
    isMotion = FALSE;
    isCategory = FALSE;
    categoryNextOutlet.enabled = YES;
    motionNextOutlet.enabled   = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [myPickerView release];
}
-(void)cancelAction
{
    if(isCategory)
    {
        categoryOutlet.text = @"";
        isCategory = FALSE;
    }
    if(isMotion)
    {
        motionoutlet.text = @"";
        isMotion = FALSE;
    }
    [toolbar removeFromSuperview];
    [myPickerView removeFromSuperview];
    
    categoryNextOutlet.enabled = YES;
    motionNextOutlet.enabled   = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [myPickerView release];
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    NSString *title;
    if(isCategory)
    {
        title = [arrayCategory objectAtIndex:row];  
    
    }
    else if(isMotion)
    {
        title = [arrayMotion objectAtIndex:row];  
    }
    
    return title;
}


// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{
    int sectionWidth = 300;
    
    return sectionWidth;
}
@end
