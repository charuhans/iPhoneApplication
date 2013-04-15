//
//  SimulationViewController.m
//  HW1_Newton
//
//  Created by Newton on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimulationViewController.h"
#import "FishBankViewController.h"
#import "FishTankInfo.h"
#import "FishTankModel.h"
#import "HW3_NEWTONAppDelegate.h"
#import "FishStoreModel.h"
#import "FishBankModel.h"


#define IMAGE_COUNT       3
#define SCREEN_HEIGHT     460
#define SCREEN_WIDTH      320
#define STATUS_BAR_HEIGHT 20
#define SEA_BED_IMG_COUNT 2


@implementation SimulationViewController

@synthesize fishBankVC;
@synthesize fishBankNavControl;
@synthesize arrayOfFishesInTank;
@synthesize center;
@synthesize cgSize;
@synthesize fishImg;
@synthesize image_name_simscreen;
@synthesize gridX;
@synthesize gridY;
@synthesize timer;
@synthesize ui_image_array;
@synthesize motion;
@synthesize radiusOfFish;
@synthesize idCounter;
@synthesize touchLocToRemove;
@synthesize touch;
@synthesize appDelegate;
@synthesize fish_name_added;

//background animation
@synthesize _endTime, _startTime;
@synthesize animatedSeaImages, seaImageArray;
@synthesize seaBedImages1, seaBedArray1;
@synthesize seaBedImages2, seaBedArray2;
@synthesize seaBedImages3, seaBedArray3;
@synthesize seaBedImages4, seaBedArray4;
@synthesize seaBedImages5, seaBedArray5;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
   
    HW3_NEWTONAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
    self.appDelegate = aDelegate;
    [aDelegate release];
    
    //[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    FishBankViewController *fbVC = [[FishBankViewController alloc] initWithNibName:@"FishBankViewController" bundle:[NSBundle mainBundle]];
    self.fishBankVC = fbVC;    
    [fbVC release];
    
    UINavigationController *fbNavController = [[UINavigationController alloc] initWithRootViewController:self.fishBankVC];
    self.fishBankNavControl = fbNavController;
    [fbNavController release];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Main Menu" style:UIBarButtonItemStylePlain target:self action:@selector(goToHome:)];          
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    arrayOfFishesInTank = [[NSMutableArray alloc] init];
    ui_image_array      = [[NSMutableArray alloc] init];
    
    [self createSimulationView];
    
    [self populateFishTankArrayForSimulation];
    
    //get the radius of the image, it will be used for collision detection
    radiusOfFish = sqrt(floor(cgSize.height/(2*gridX))*floor(cgSize.height/(2*gridX)) + floor(cgSize.width/(2*gridY))*floor(cgSize.width/(2*gridY)));
        
    //=========================
    // Array to hold jpg images
    seaImageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
    
    seaBedArray1  = [[NSMutableArray alloc] initWithCapacity:SEA_BED_IMG_COUNT];
    seaBedArray2  = [[NSMutableArray alloc] initWithCapacity:SEA_BED_IMG_COUNT];
    seaBedArray3  = [[NSMutableArray alloc] initWithCapacity:SEA_BED_IMG_COUNT];
    seaBedArray4  = [[NSMutableArray alloc] initWithCapacity:SEA_BED_IMG_COUNT];
    seaBedArray5  = [[NSMutableArray alloc] initWithCapacity:SEA_BED_IMG_COUNT];
    
    // Build array of images, cycling through image names
    for (int i = 1; i <= IMAGE_COUNT; i++)
        [seaImageArray addObject:[UIImage imageNamed: [NSString stringWithFormat:@"simBack%d.png", i]]];
    
    for (int i = 1; i <= SEA_BED_IMG_COUNT; i++)
        [seaBedArray1 addObject:[UIImage imageNamed: [NSString stringWithFormat:@"screen1%d.png", i]]];
    
    for (int i = 1; i <= SEA_BED_IMG_COUNT; i++)
        [seaBedArray2 addObject:[UIImage imageNamed: [NSString stringWithFormat:@"screen2%d.png", i]]];
    
    for (int i = 1; i <= SEA_BED_IMG_COUNT; i++)
        [seaBedArray3 addObject:[UIImage imageNamed: [NSString stringWithFormat:@"screen3%d.png", i]]];
    
    for (int i = 1; i <= SEA_BED_IMG_COUNT; i++)
        [seaBedArray4 addObject:[UIImage imageNamed: [NSString stringWithFormat:@"screen4%d.png", i]]];
    
    for (int i = 1; i <= SEA_BED_IMG_COUNT; i++)
        [seaBedArray5 addObject:[UIImage imageNamed: [NSString stringWithFormat:@"screen5%d.png", i]]];    
    
    
    // Animated images - centered on screen
    animatedSeaImages = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, SCREEN_HEIGHT+50,SCREEN_WIDTH)];
    animatedSeaImages.animationImages = [NSArray arrayWithArray:seaImageArray];
    
    seaBedImages1 = [[UIImageView alloc] initWithFrame:CGRectMake(-10,  85, 150,230)];
    seaBedImages1.animationImages = [NSArray arrayWithArray:seaBedArray1];
    
    seaBedImages2 = [[UIImageView alloc] initWithFrame:CGRectMake(80,  60, 150,230)];
    seaBedImages2.animationImages = [NSArray arrayWithArray:seaBedArray2];
    
    seaBedImages3 = [[UIImageView alloc] initWithFrame:CGRectMake(170,  80, 150,230)];
    seaBedImages3.animationImages = [NSArray arrayWithArray:seaBedArray3];
    
    seaBedImages4 = [[UIImageView alloc] initWithFrame:CGRectMake(260,  70, 150,230)];
    seaBedImages4.animationImages = [NSArray arrayWithArray:seaBedArray4];
    
    seaBedImages5 = [[UIImageView alloc] initWithFrame:CGRectMake(340,  70, 150,230)];
    seaBedImages5.animationImages = [NSArray arrayWithArray:seaBedArray5];
    
    
    
    // One cycle through all the images takes 1 seconds
    animatedSeaImages.animationDuration = 2.0;
    
    seaBedImages1.animationDuration = 2.0;
    seaBedImages2.animationDuration = 2.0;
    seaBedImages3.animationDuration = 2.0;
    seaBedImages4.animationDuration = 2.0;
    seaBedImages5.animationDuration = 2.0;
    
    // Repeat forever
    animatedSeaImages.animationRepeatCount = 0;
    seaBedImages1.animationRepeatCount = 0;
    seaBedImages2.animationRepeatCount = 0;
    seaBedImages3.animationRepeatCount = 0;
    seaBedImages4.animationRepeatCount = 0;
    seaBedImages5.animationRepeatCount = 0;
    
    [self.view addSubview:animatedSeaImages];
    
    [self.view addSubview:seaBedImages1];
    [self.view addSubview:seaBedImages2];
    [self.view addSubview:seaBedImages3];
    [self.view addSubview:seaBedImages4];
    [self.view addSubview:seaBedImages5];
    
    // Start it up
    [animatedSeaImages startAnimating];
    [seaBedImages1 startAnimating];
    [seaBedImages2 startAnimating];
    [seaBedImages3 startAnimating];
    [seaBedImages4 startAnimating];
    [seaBedImages5 startAnimating];
    //=========================
    
    idCounter = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(simulation) userInfo:nil repeats:YES];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _startTime = [[NSDate date] timeIntervalSince1970];  //get the start time
    
    touch = [touches anyObject];
    CGPoint touchLoc = [touch locationInView: [touch view]];
    CGPoint gridNo;
    gridNo.x = (touchLoc.x/(cgSize.height/gridX));
    gridNo.y = (touchLoc.y/(cgSize.width/gridY));
    
    // store this location in NSMutableArray
    center.x = (floor(gridNo.x))*(floor(cgSize.height/gridX));
    center.y = ((floor(gridNo.y))*(floor(cgSize.width/gridY)));
    
    NSUInteger tapCount = [touch tapCount];
    
    if(tapCount == 2)
    {        
            touchLocToRemove = [touch locationInView:[touch view]];
            
            [self performSelector:@selector(removeFishFromTank) withObject:nil afterDelay:.4];
    }      
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _endTime = [[NSDate date] timeIntervalSince1970];
    float diff = _endTime - _startTime;    
    
    //if a person keeps holdin for long then we will go to next screen
    if(diff > 0.75)
    {        
        [self performSelector:@selector(addFishToTank) withObject:nil afterDelay:0];
    }
    
}
-(void)removeFishFromTank{
    
    float heightR = floor(cgSize.height/(2*gridX));
    float widthR  = floor(cgSize.width/(2*gridY));
        
    NSInteger count = 0;
    float smallestDistance = 1000;
    int index = -1;
    NSInteger fishIdentification = -1;
    NSString *fishIMGNAME;
    if([arrayOfFishesInTank count] > 0)
    {
        FishTankInfo *fishintank;
        float posX, posY, realDist;
        
        while (count < [arrayOfFishesInTank count])
        {
            fishintank = [arrayOfFishesInTank objectAtIndex:count];
            
            posX = fishintank.location.x+widthR;
            posY = fishintank.location.y+heightR;
            realDist = sqrt((touchLocToRemove.x - posX)*(touchLocToRemove.x - posX) + (touchLocToRemove.y-posY)*(touchLocToRemove.y-posY));
            
            if(realDist < smallestDistance)
            {
                smallestDistance = realDist;
                index = count;
                fishIdentification = fishintank.fish_ka_id;
                fishIMGNAME = [[NSString alloc] initWithString:fishintank.fishImg_name];
            }
            count++;
        }    
    
        if(smallestDistance < 0.65*radiusOfFish) 
        {
            //HW1_NewtonAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
            //remove from DB of fishtank
            [FishTankModel removeFishFromTableOnTap:fishIdentification dbPath:appDelegate.getDBPath];
        
            //remove from array, which removes from view in next step
            [arrayOfFishesInTank removeObjectAtIndex:index];
            int counter = 0;
            FishStoreModel *fishObject;
            
            while(counter < [appDelegate.fishStoreArray count])
            {
                fishObject = [appDelegate.fishStoreArray objectAtIndex:counter];
                if([fishIMGNAME isEqualToString:fishObject.fish_path])
                {
                    //decrease the label in fishbank
                    [FishBankModel updateFishBankDB:appDelegate.getDBPath name:fishObject.fish_name andChange:-1]; 
                }
                counter++;
            }
            
        
        }
    }
}
- (void)addFishToTank{      
    [self pauseTimer];
    [self presentModalViewController:self.fishBankNavControl animated:YES];    
}
-(void) pauseTimer{
    pauseStart = [[NSDate dateWithTimeIntervalSinceNow:0] retain];
    previousFireDate = [[timer fireDate] retain];
    [timer setFireDate:[NSDate distantFuture]];
} 
-(void) resumeTimer{
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    [pauseStart release];
    [previousFireDate release];
}
-(BOOL)checkIfPositionAvailable:(CGPoint) newPos andCount:(int) countInArray{
    //get the center of the fish image
    CGPoint newCenterOfImage = CGPointMake(newPos.x+ floor(cgSize.height/(2*gridX)), newPos.y +floor(cgSize.width/(2*gridY)));
        
    FishTankInfo *fishintank;
    CGPoint fishlocation, centerOfAnotherFish;
    int distanceBetweenCentres;
    
    int counter = 0;
    while(counter < [arrayOfFishesInTank count])
    {
        if(!(counter ==  countInArray))
        {
            fishintank = [arrayOfFishesInTank objectAtIndex:counter];
            fishlocation = fishintank.location;
            
            //center of another fish in the simulation view
            centerOfAnotherFish = CGPointMake(fishlocation.x+ floor(cgSize.height/(2*gridX)), fishlocation.y +floor(cgSize.width/(2*gridY)));     
            
            //distance between the two centres
            distanceBetweenCentres = sqrt(pow((newCenterOfImage.x - centerOfAnotherFish.x),2) + pow((newCenterOfImage.y - centerOfAnotherFish.y),2));
                                   
            if(distanceBetweenCentres <= 1.25*radiusOfFish )
            {
                return false;
            }
        }
        counter++;
    }
    return true;
    
}
-(BOOL)checkIfPositionAvailable:(CGPoint) newPos{
    //get the center of the fish image
    CGPoint newCenterOfImage = CGPointMake(newPos.x+ floor(cgSize.height/(2*gridX)), newPos.y +floor(cgSize.width/(2*gridY)));
        
    FishTankInfo *fishintank;
    int distanceBetweenCentres;
    CGPoint centerOfAnotherFish, fishlocation;
    
    int counter = 0;
    while(counter < [arrayOfFishesInTank count])
    {
        fishintank = [arrayOfFishesInTank objectAtIndex:counter];
        fishlocation = fishintank.location;
            
        //center of another fish in the simulation view
        centerOfAnotherFish = CGPointMake(fishlocation.x+ floor(cgSize.height/(2*gridX)), fishlocation.y +floor(cgSize.width/(2*gridY)));     
            
        //distance between the two centres
        distanceBetweenCentres = sqrt(pow((newCenterOfImage.x - centerOfAnotherFish.x),2) + pow((newCenterOfImage.y - centerOfAnotherFish.y),2));
            
        if(distanceBetweenCentres <= 1.8*radiusOfFish)
        {
            return false;
        }
        counter++;
    }
    
    return true;
    
}
-(int) getNewHeadDirectionType34:(NSInteger) headDirection{
    int arrayOfPossibleHeadDirections[3];
    int arrayCounter = 0;
    for(int i=1; i<=4; i++)
    {
        if(!(i == headDirection))
        {
            arrayOfPossibleHeadDirections[arrayCounter] = i;
            arrayCounter++;
        }
    }
    int choice = arc4random()%3;
    return arrayOfPossibleHeadDirections[choice];
}
-(int) getNewHeadDirectionType25:(NSInteger) headDirection{
    int arrayOfPossibleHeadDirections[3];
    int arrayCounter = 0;
    for(int i=5; i<=8; i++)
    {
        if(!(i == headDirection))
        {
            arrayOfPossibleHeadDirections[arrayCounter] = i;
            arrayCounter++;
        }
    }
    int choice = arc4random()%3;
    return arrayOfPossibleHeadDirections[choice];
}
-(int) getNewHeadDirectionType16:(NSInteger) headDirection{
    int arrayOfPossibleHeadDirections[7];
    int arrayCounter = 0;
    for(int i=1; i<=8; i++)
    {
        if(!(i == headDirection))
        {
            arrayOfPossibleHeadDirections[arrayCounter] = i;
            arrayCounter++;
        }
    }
    int choice = arc4random()%7;
    return arrayOfPossibleHeadDirections[choice];
}
-(BOOL) checkBounds:(CGPoint) new_loc{    
    CGPoint centerImagePoint = CGPointMake(new_loc.x+ floor(cgSize.height/(2*gridX)), new_loc.y +floor(cgSize.width/(2*gridY)));
    if(   centerImagePoint.x < radiusOfFish - 12 || (centerImagePoint.x > (cgSize.height - (radiusOfFish-15))) 
       || centerImagePoint.y < radiusOfFish - 22 || (centerImagePoint.y > (cgSize.width  - (radiusOfFish+30))))
    {
        return false;
    }    
    return true;
}
-(CGPoint) getNewPositionVH:(int)head andPosition:(CGPoint) location andCellJump:(int) numberOfCell{
    CGPoint updatedPosition;
    switch (head)
    {
        case 1:
            updatedPosition = CGPointMake(location.x, location.y-numberOfCell);           
            break;
            
        case 2:
            updatedPosition = CGPointMake(location.x, location.y+numberOfCell);           
            break;
            
        case 3:
            updatedPosition = CGPointMake(location.x-numberOfCell, location.y);           
            break;
            
        case 4:
            updatedPosition = CGPointMake(location.x+numberOfCell, location.y);           
            break;
            
        default:
            break;            
    }    
    return updatedPosition;
}
-(FishTankInfo *) newFishPositionVH:(CGFloat)x andY:(CGFloat)y andFishInfo:(FishTankInfo *) fishTank andCounter:(int) count andCellJump:(int) numberOfCell{
    CGPoint new_position =  CGPointMake(x, y);    
    if([self checkIfPositionAvailable:new_position andCount:count] && [self checkBounds:new_position] )
    {
        fishTank.location = new_position;
    }
    else
    {
        //assign a new head direction
        int head = [self getNewHeadDirectionType34:fishTank.directionHead];
        fishTank.directionHead = head;
        new_position = [self getNewPositionVH:head andPosition:fishTank.location andCellJump:numberOfCell];
        fishTank.location = new_position;
    } 
    return fishTank;
}
-(CGPoint) getNewPositionD:(int)head andPosition:(CGPoint) location andCellJump:(int) numberOfCell{
    CGPoint updatedPosition;
    switch (head)
    {
        case 5:
            updatedPosition = CGPointMake(location.x+numberOfCell, location.y-numberOfCell);           
            break;
            
        case 6:
            updatedPosition = CGPointMake(location.x-numberOfCell, location.y+numberOfCell);           
            break;
            
        case 7:
            updatedPosition = CGPointMake(location.x-numberOfCell, location.y-numberOfCell);           
            break;
            
        case 8:
            updatedPosition = CGPointMake(location.x+numberOfCell, location.y+numberOfCell);           
            break;
            
        default:
            break;
            
    }
    
    return updatedPosition;
}
-(FishTankInfo *) newFishPositionD:(CGFloat)x andY:(CGFloat)y andFishInfo:(FishTankInfo *) fishTank andCounter:(int) count andCellJump:(int) numberOfCell{
    CGPoint new_position =  CGPointMake(x, y);    
    if([self checkIfPositionAvailable:new_position andCount:count] && [self checkBounds:new_position] )
    {
        fishTank.location = new_position;
    }
    else
    {
        //assign a new head direction
        int head = [self getNewHeadDirectionType25:fishTank.directionHead];
        fishTank.directionHead = head;
        new_position = [self getNewPositionD:head andPosition:fishTank.location andCellJump:numberOfCell];
        fishTank.location = new_position;
    }     
    return fishTank;
}
-(CGPoint) getNewPositionAll:(int)head andPosition:(CGPoint) location andCellJump:(int) numberOfCell{
    CGPoint updatedPosition;
    switch (head)
    {
        case 1:
            updatedPosition = CGPointMake(location.x, location.y-numberOfCell);           
            break;
            
        case 2:
            updatedPosition = CGPointMake(location.x, location.y+numberOfCell);           
            break;
            
        case 3:
            updatedPosition = CGPointMake(location.x-numberOfCell, location.y);           
            break;
            
        case 4:
            updatedPosition = CGPointMake(location.x+numberOfCell, location.y);           
            break;
        case 5:
            updatedPosition = CGPointMake(location.x+numberOfCell, location.y-numberOfCell);           
            break;
            
        case 6:
            updatedPosition = CGPointMake(location.x-numberOfCell, location.y+numberOfCell);           
            break;
            
        case 7:
            updatedPosition = CGPointMake(location.x-numberOfCell, location.y-numberOfCell);           
            break;
            
        case 8:
            updatedPosition = CGPointMake(location.x+numberOfCell, location.y+numberOfCell);           
            break;
            
        default:
            break;            
    }    
    return updatedPosition;
}
-(FishTankInfo *) newFishPositionAll:(CGFloat)x andY:(CGFloat)y andFishInfo:(FishTankInfo *) fishTank andCounter:(int) count andCellJump:(int) numberOfCell{
    CGPoint new_position =  CGPointMake(x, y);
    
    if([self checkIfPositionAvailable:new_position andCount:count] && [self checkBounds:new_position] )
    {
        fishTank.location = new_position;
    }
    else
    {
        //assign a new head direction
        int head = [self getNewHeadDirectionType16:fishTank.directionHead];
        fishTank.directionHead = head;
        new_position = [self getNewPositionAll:head andPosition:fishTank.location andCellJump:numberOfCell];
        fishTank.location = new_position;
    }     
    return fishTank;
}
-(NSMutableArray*) getPossibleLocations:(NSInteger) motionpatt andLocation:(CGPoint) locs{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    //CGPoint point;
    
    switch (motionpatt)
    {
        case 1:    
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x ,locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y+1)]]; 
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y+1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y+1)]];
            break;
            
        case 2:
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y+1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y+1)]];
            break;
            
        case 3:            
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y-1)]];        
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y+1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y)]];
            break;
            
        case 4:
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y-2)]];        
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y+2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y)]];
            break;
            
        case 5:
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y-2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y+2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y-2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y+2)]];                       
            break;
            
        case 6:
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x ,locs.y-2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y+2)]]; 
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y+1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-1, locs.y-1)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+1, locs.y+1)]];
            break;
            
        case 7:
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x ,locs.y-2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x, locs.y+2)]]; 
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y-2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y+2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x-2, locs.y-2)]];
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(locs.x+2, locs.y+2)]];
            break;
            
    }
    
    return array;
}
-(void)simulation{
    //we need to update the location of fishes in the array
    NSInteger count = 0;
    
    //NSMutableArray *possiblePositions = [[NSMutableArray alloc] init];
        
    [self getDataFromDBforSimulation];
    
    int numberOfFishesInTank = [arrayOfFishesInTank count];
    
    
    //NSInteger togetherCounter = 0;
    
    while (count < numberOfFishesInTank) 
    {
        FishTankInfo *fishintank = [arrayOfFishesInTank objectAtIndex:count];
        
        CGPoint fishlocation = fishintank.location;
        NSInteger head_direction = fishintank.directionHead; 
        motion = fishintank.motion_pattern;
        
        float cellJump;
        double dist;
        double myDist;
        double smallestDist = 2000.0;
        NSInteger myNewHeadDirection;
        
        //NSInteger assignHeadDir = 1;
        
        
        if([fishintank.fish_group isEqualToString:@"YES"])
        {
            NSMutableArray* possiblePlacesICanGo = [self getPossibleLocations:(NSInteger) motion andLocation:fishlocation];
            int groupmotioncounter = 0;
            while (groupmotioncounter < [arrayOfFishesInTank count]) 
            {
                if(groupmotioncounter == count)
                {
                    groupmotioncounter++;
                    continue;
                }
                else
                {                    
                    FishTankInfo *anotherFishinTank = [arrayOfFishesInTank objectAtIndex:groupmotioncounter];
                    CGPoint otherfishloc = CGPointMake(anotherFishinTank.location.x, anotherFishinTank.location.y);
                    dist = sqrt((fishlocation.x - otherfishloc.x)*(fishlocation.x - otherfishloc.x) + (fishlocation.y - otherfishloc.y)*(fishlocation.y - otherfishloc.y));
                    if([anotherFishinTank.fishImg_name isEqualToString:fishintank.fishImg_name] && dist < 5*radiusOfFish)
                    {
                        if ( dist > 2.25* radiusOfFish) 
                        {
                            int i;
                            for (i =0; i < [possiblePlacesICanGo count]; i++) 
                            {
                                CGPoint pts = [[possiblePlacesICanGo objectAtIndex:i] CGPointValue];
                                myDist = sqrt((pts.x - otherfishloc.x)*(pts.x - otherfishloc.x) + (pts.y - otherfishloc.y)*(pts.y - otherfishloc.y));
                                if(smallestDist > myDist)
                                {
                                    smallestDist = myDist;
                                    if([possiblePlacesICanGo count] == 8)
                                    {
                                        myNewHeadDirection = i+1;
                                    }
                                    else                                         
                                    {
                                        if(fishintank.motion_pattern == 3  || fishintank.motion_pattern == 4)
                                        {
                                            myNewHeadDirection = i+1;
                                        }
                                        else
                                        {                                        
                                            myNewHeadDirection = i+5;
                                        }
                                    }
                                }                                
                            }
                            
                            fishintank.directionHead = myNewHeadDirection;
                            //break;
                        }
                        else
                        {
                            if(groupmotioncounter != 0)
                            {
                                fishintank.directionHead = anotherFishinTank.directionHead;
                            }
                        }
                    }
                }
                groupmotioncounter++;
            }
        }
        
        switch (motion)
        {
            case 1:
                cellJump = 2;
                switch (head_direction)
                {
                    case 1: //goes to top of the screen
                        fishintank = [self newFishPositionAll:fishlocation.x andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                        
                    case 2: //goes to down side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                        
                    case 3: //goes to left side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x-cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                        
                    case 4: //goes to right side of the screen                            
                        fishintank = [self newFishPositionAll:fishlocation.x+cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                        
                    case 5: //goes to top of the screen
                        fishintank = [self newFishPositionAll:fishlocation.x+cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                        
                        break;
                        
                    case 6: //goes to down side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x-cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                        
                    case 7: //goes to left side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x-cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                        
                    case 8: //goes to right side of the screen   
                        fishintank = [self newFishPositionAll:fishlocation.x+cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    default:
                        break;                
                }  
               
                break;
            case 2:
                
                cellJump = 2;
                switch (head_direction)
                {
                    case 5: //goes to top of the screen
                    case 1:
                        fishintank = [self newFishPositionD:fishlocation.x+cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                        
                        break;
                    
                    case 6: //goes to down side of the screen
                    case 2:
                        fishintank = [self newFishPositionD:fishlocation.x-cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                    
                    case 7: //goes to left side of the screen 
                    case 3:
                        fishintank = [self newFishPositionD:fishlocation.x-cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    case 8: //goes to right side of the screen   
                    case 4:
                        fishintank = [self newFishPositionD:fishlocation.x+cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    default:
                        break;
                }  
                break;
                
            case 3:                
                cellJump = 2;
                switch (head_direction)
                {
                    case 1: //goes to top of the screen
                    case 5:
                        fishintank = [self newFishPositionVH:fishlocation.x andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                        
                    case 2: //goes to down side of the screen  
                    case 6:
                        fishintank = [self newFishPositionVH:fishlocation.x andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                        
                    case 3: //goes to left side of the screen  
                    case 7:
                        fishintank = [self newFishPositionVH:fishlocation.x-cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                        
                    case 4: //goes to right side of the screen 
                    case 8:
                        fishintank = [self newFishPositionVH:fishlocation.x+cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                        
                    default:
                        break;
                }                     
            break;
                
            case 4:
                cellJump = 4;
                switch (head_direction)
                {
                    case 1: //goes to top of the screen
                    case 5:
                        fishintank = [self newFishPositionVH:fishlocation.x andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                        
                        break;
                    
                    case 2: //goes to down side of the screen 
                    case 6:
                        fishintank = [self newFishPositionVH:fishlocation.x andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                    
                    case 3: //goes to left side of the screen  
                    case 7:
                        fishintank = [self newFishPositionVH:fishlocation.x-cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    case 4: //goes to right side of the screen
                    case 8:
                        fishintank = [self newFishPositionVH:fishlocation.x+cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    default:
                        break;
                }          
                break;
               
            case 5:
                cellJump = 4;
                switch (head_direction)
                {
                    case 5: //goes to top of the screen
                    case 1:
                        fishintank = [self newFishPositionD:fishlocation.x+cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                        
                        break;
                    
                    case 6: //goes to down side of the screen  
                    case 2:
                        fishintank = [self newFishPositionD:fishlocation.x-cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                    
                    case 7: //goes to left side of the screen  
                    case 3:
                        fishintank = [self newFishPositionD:fishlocation.x-cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    case 8: //goes to right side of the screen   
                    case 4:
                        fishintank = [self newFishPositionD:fishlocation.x+cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    default:
                        break;
                }  
                break;
                
            case 7:
                cellJump = 4;
                switch (head_direction)
                {
                    case 1: //goes to top of the screen
                        fishintank = [self newFishPositionAll:fishlocation.x andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                    
                    case 2: //goes to down side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                    
                    case 3: //goes to left side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x-cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    case 4: //goes to right side of the screen   
                        fishintank = [self newFishPositionAll:fishlocation.x+cellJump andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    case 5: //goes to top of the screen
                        fishintank = [self newFishPositionAll:fishlocation.x+cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                        
                        break;
                    
                    case 6: //goes to down side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x-cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];                         
                        break;
                    
                    case 7: //goes to left side of the screen  
                        fishintank = [self newFishPositionAll:fishlocation.x-cellJump andY:fishlocation.y-cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    case 8: //goes to right side of the screen   
                        fishintank = [self newFishPositionAll:fishlocation.x+cellJump andY:fishlocation.y+cellJump andFishInfo:fishintank andCounter: count andCellJump:cellJump];
                        break;
                    
                    default:
                        break;                
                }
                break;
                
            case 6:
                switch (head_direction)
            {
                case 1: //goes to top of the screen
                    fishintank = [self newFishPositionAll:fishlocation.x andY:fishlocation.y-4 andFishInfo:fishintank andCounter: count andCellJump:2];                         
                    break;
                    
                case 2: //goes to down side of the screen  
                    fishintank = [self newFishPositionAll:fishlocation.x andY:fishlocation.y+4 andFishInfo:fishintank andCounter: count andCellJump:2];                         
                    break;
                    
                case 3: //goes to left side of the screen  
                    fishintank = [self newFishPositionAll:fishlocation.x-4 andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:2];
                    break;
                    
                case 4: //goes to right side of the screen   
                    fishintank = [self newFishPositionAll:fishlocation.x+4 andY:fishlocation.y andFishInfo:fishintank andCounter: count andCellJump:2];
                    break;
                    
                case 5: //goes to top of the screen
                    fishintank = [self newFishPositionAll:fishlocation.x+2 andY:fishlocation.y-2 andFishInfo:fishintank andCounter: count andCellJump:1];                        
                    break;
                    
                case 6: //goes to down side of the screen  
                    fishintank = [self newFishPositionAll:fishlocation.x-2 andY:fishlocation.y+2 andFishInfo:fishintank andCounter: count andCellJump:1];                         
                    break;
                    
                case 7: //goes to left side of the screen  
                    fishintank = [self newFishPositionAll:fishlocation.x-2 andY:fishlocation.y-2 andFishInfo:fishintank andCounter: count andCellJump:1];
                    break;
                    
                case 8: //goes to right side of the screen   
                    fishintank = [self newFishPositionAll:fishlocation.x+2 andY:fishlocation.y+2 andFishInfo:fishintank andCounter: count andCellJump:1];
                    break;
                    
                default:
                    break;                
            }
                break;
            default:
                break;
        }
                    
        [arrayOfFishesInTank replaceObjectAtIndex:count withObject:fishintank];              
        
     //   [possiblePositions removeAllObjects];
        count++;
    }
    
    [self removeFromSuperView];
    
    
    [self getFishesFromFishTank];
    
    //update the position in database as well
    count = 0;
    while (count < numberOfFishesInTank) 
    {
        
       [self updatePositionOfFishes:[arrayOfFishesInTank objectAtIndex:count]];
       count++;
    }
    
    [self.view setNeedsDisplay];
}
-(void) getDataFromDBforSimulation{
    static sqlite3  *database   = nil;
    sqlite3_stmt    *selectstmt = nil; 
    
    if ([arrayOfFishesInTank count] > 0) 
    {
        [arrayOfFishesInTank removeAllObjects];
    }
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT fish_id, fish_category, x, y, head_direction, fish_name, fish_group FROM fish_tank";       
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                NSInteger id_fish = sqlite3_column_double(selectstmt, 0);
                //NSString *newCategory   = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 1)];
                NSInteger x             = sqlite3_column_double(selectstmt, 2);
                NSInteger y             = sqlite3_column_double(selectstmt, 3);
                NSInteger headDir       = sqlite3_column_int(selectstmt, 4);
                NSString *newName       = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 5)];
                //NSString *newGroup      = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
                
                NSString *newGroup = [FishStoreModel getGroupMotionFromDB:[appDelegate getDBPath] andName:newName];
                
                CGPoint location = CGPointMake(x, y);
                NSInteger pattern = [FishStoreModel getMotionFromDB:[appDelegate getDBPath] andName:newName];
                NSString* path =  [[NSString alloc] initWithString:[FishStoreModel getImagePath:[appDelegate getDBPath] andName:newName]];
                
                FishTankInfo *fishTankObj = [[FishTankInfo alloc] initWithName:path andLoc:location andDirection:headDir andPattern:pattern andFishID:id_fish andGroup:newGroup];                
                
                [arrayOfFishesInTank addObject:fishTankObj];
            }
        }
    }
}
-(void) updatePositionOfFishes:(FishTankInfo*) fishInfo
{
    static sqlite3      *database       = nil;
    static sqlite3_stmt *updateposition = nil;
    
    if (sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "UPDATE fish_tank set x = ?, y = ?, head_direction = ? where fish_id = ?"; //insert
        
        if(sqlite3_prepare_v2(database, sql, -1, &updateposition, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error while creating updating position statement. '%s'", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_int (updateposition,  1, fishInfo.location.x);
        sqlite3_bind_int (updateposition,  2, fishInfo.location.y);
        sqlite3_bind_int (updateposition,  3, fishInfo.directionHead);        
        sqlite3_bind_int (updateposition,  4, fishInfo.fish_ka_id);
        
        
        if(SQLITE_DONE != sqlite3_step(updateposition))
        {
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(database));
        }
        
        //Reset the add statement.
        sqlite3_reset(updateposition);
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Simulation";    
       
    [self removeFromSuperView];
    
    [self getFishesFromFishTank];   
   
    //get the phone screen parameter and lay the grid (virtually)
    [self createSimulationView];
    
}

-(void) setFishName:(NSString*) name
{
    fish_name_added = [[NSString alloc] initWithString:name];
}
//this method will set up the image location in a particular grid
-(void) setImage
{    
    // checks if image name is smaller then we are loading the screen for the first time
    if([image_name_simscreen length] < 2)
    {
        fishImg =  [[UIImageView alloc] init];
    }
    else
    {
        [self getMotionPattern:image_name_simscreen];
        FishTankInfo *fishinfo;
        
        NSInteger motionPatt = [FishStoreModel getMotionFromDB:[appDelegate getDBPath] andName:fish_name_added];
        NSString *group      = [FishStoreModel getGroupMotionFromDB:[appDelegate getDBPath] andName:fish_name_added];
        if(motionPatt == 4 || motionPatt == 3)
        {
            fishinfo = [[FishTankInfo alloc] initWithName:image_name_simscreen andLoc:center andDirection:4 andPattern:motion andFishID:idCounter andGroup:group];
        }
        else if(motionPatt == 2 || motionPatt == 5)
        {
            fishinfo = [[FishTankInfo alloc] initWithName:image_name_simscreen andLoc:center andDirection:8 andPattern:motion andFishID:idCounter andGroup:group];
        }
        else 
        {
            fishinfo = [[FishTankInfo alloc] initWithName:image_name_simscreen andLoc:center andDirection:4 andPattern:motion andFishID:idCounter andGroup:group];
        }
          
        
        //[FishTankModel addFishToTable:image_name_simscreen xcord:center.x ycord:center.y headDir:4 dbPath:[appDelegate getDBPath] fishid:idCounter];
        //[FishTankModel getDataFromDB:[appDelegate getDBPath]];
        [arrayOfFishesInTank addObject:fishinfo];
        
        //[self.view addSubview:fishinfo.imgView];
    }    
}
-(void) removeFromSuperView
{
    int i = 0;
    while(i < [ui_image_array count])
    {
        [[ui_image_array objectAtIndex:i] removeFromSuperview];
        i++;
    } 
    [ui_image_array removeAllObjects];
    ui_image_array = nil;
    
}
-(UIImageView *) imageRotatedByDegrees:(CGFloat) degrees andImage:(UIImageView *)fishImage
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(degrees *(3.147/180));
    fishImage.transform = transform;
    return fishImage;    
}
-(void)getFishesFromFishTank
{   
    NSEnumerator *e = [arrayOfFishesInTank objectEnumerator];
    id item;
    NSString *fishImageName;
    UIImage  *fishImage;
    CGPoint fish_location;
    NSInteger headDir, fishMotionPattern; 
    
    ui_image_array  = [[NSMutableArray alloc] init];
    
    while ((item = [e nextObject])) 
    {
        fishImageName         = [NSString stringWithFormat:@"%@",[item fishImg_name]];
        fishImage             = [UIImage imageWithContentsOfFile:fishImageName];
        fish_location         = [item location];
        headDir               = [item directionHead];  
        fishMotionPattern     = [item motion_pattern];
        
        
        self.fishImg = [[UIImageView alloc] initWithFrame:CGRectMake(fish_location.x ,fish_location.y, floor(cgSize.height/gridX), floor(cgSize.width/gridY))];
        self.fishImg.image = fishImage;
                
        [ui_image_array addObject:fishImg];
        
        if(timer)
        {
        switch (fishMotionPattern) 
        {
            case 3:
            case 4:
                switch (headDir)
                {
                    case 4:
                        fishImg.image = [self rotate:UIImageOrientationUp andImage:fishImg.image]; 
                        break;
                    case 3:
                        fishImg.image = [self rotate:UIImageOrientationUpMirrored andImage:fishImg.image]; 
                        break;
                    case 2:
                        fishImg.image = [self rotate:UIImageOrientationRightMirrored andImage:fishImg.image]; 
                        break;
                    case 1:
                        fishImg.image = [self rotate:UIImageOrientationLeft andImage:fishImg.image]; 
                        break;
                    default:
                        break;
                } 
                break;
                
            case 1:
                switch (headDir)
                {
                    case 4:
                        fishImg.image = [self rotate:UIImageOrientationRightMirrored andImage:fishImg.image]; 
                        break;
                    case 3:
                        fishImg.image = [self rotate:UIImageOrientationUpMirrored andImage:fishImg.image];  
                        fishImg = [self imageRotatedByDegrees:45 andImage:fishImg];
                        break;
                    case 2:
                        fishImg.image = [self rotate:UIImageOrientationUpMirrored andImage:fishImg.image]; 
                        break;
                    case 1:
                        fishImg.image = [self rotate:UIImageOrientationLeft andImage:fishImg.image]; 
                        fishImg = [self imageRotatedByDegrees:45 andImage:fishImg];
                        break;
                    default:
                        break;
                } 
                break;
            case 2:
            case 5:
                switch (headDir)
                {
                    case 4:
                        fishImg.image = [self rotate:UIImageOrientationUp andImage:fishImg.image]; 
                        break;
                    case 3:
                        fishImg.image = [self rotate:UIImageOrientationUpMirrored andImage:fishImg.image]; 
                        break;
                    case 2:
                        fishImg.image = [self rotate:UIImageOrientationRightMirrored andImage:fishImg.image]; 
                        break;
                    case 1:
                        fishImg.image = [self rotate:UIImageOrientationLeft andImage:fishImg.image]; 
                        break;
                    default:
                        break;
                }                
                fishImg = [self imageRotatedByDegrees:45 andImage:fishImg];
                break;
            default:
                break;
        }
        
        }
        [self.view addSubview:fishImg];
    }
}    
-(void)dealloc
{
    
    [touch release];
    [fish_name_added release];
    //[acceleration release];
    
    //animation release
    [animatedSeaImages release];
    [seaImageArray release];
    
    [seaBedImages1 release];
    [seaBedArray1  release];
    [seaBedImages2 release];
    [seaBedArray2  release];
    [seaBedImages3 release];
    [seaBedArray3  release];
    [seaBedImages4 release];
    [seaBedArray4  release];
    [seaBedImages5 release];
    [seaBedArray5  release];
    
    [appDelegate release];
    [timer release];
    [image_name_simscreen release];
    [fishImg release];
    [fishBankVC release];
    [fishBankNavControl release];
    [arrayOfFishesInTank release];   
    [ui_image_array release];
    [super dealloc];
}
-(void)goToHome:(id)sender
{
    [self pauseTimer];
    [self dismissModalViewControllerAnimated:YES];    
}
-(void)set_image_name_simscreen:(NSString *) nameoffishimage
{
    self.image_name_simscreen = nameoffishimage;
}

//-(float) getAngle
//{
    //float xx = -[acceleration x]; 
	//float yy =  [acceleration y]; 
	//return atan2(yy, xx);    
//}


//this method gets called from fishbank view controller, refreshes the view. still have some issues need to fix this
-(void) refresh //:(NSString *)fish_image_name;
{    
    [self resumeTimer];
    //this method is called when image view is loaded
    [self setImage];
    
    [self viewDidLoad];
}
//gets the screen bound and also sets the number of grid needed
- (void)createSimulationView
{
    CGRect cgRect = [[UIScreen mainScreen] bounds];
    cgSize  = cgRect.size;
    gridX = 8;
    gridY = 5;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
-(void) populateFishTankArrayForSimulation
{
    sqlite3 *database        = nil;
    sqlite3_stmt *selectstmt = nil;
    
    NSString *dbPath = appDelegate.getDBPath;
        
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        const char *sql = "SELECT fish_id, x, y, head_direction, fish_image, motion_pattern, fish_group FROM fish_tank as FT, fish_store as FS where FS.fish_name = FT.fish_category";
        sqlite3_stmt *selectstmt;        
        
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)        
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            {
                NSInteger id_fish = sqlite3_column_double(selectstmt, 0);
                NSInteger xcord = sqlite3_column_double(selectstmt, 1);
                NSInteger ycord = sqlite3_column_double(selectstmt, 2);
                NSInteger headDir       = sqlite3_column_int(selectstmt, 3);
                NSString *fish_img_name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 4)];
                motion = sqlite3_column_int(selectstmt, 5);
                NSString *group = [NSString stringWithUTF8String:(char*)sqlite3_column_text(selectstmt, 6)];
                
                CGPoint point = CGPointMake(xcord, ycord);
                
                FishTankInfo *fishTankobject = [[FishTankInfo alloc] initWithName:fish_img_name andLoc:point andDirection:headDir andPattern:motion andFishID:id_fish andGroup:group];
                [arrayOfFishesInTank addObject:fishTankobject];                
                [fishTankobject release];
            }
        }
    }
    
    if(selectstmt) sqlite3_finalize(selectstmt);
}
-(void) getMotionPattern:(NSString *)image_name
{
    sqlite3 *databaseMotion        = nil;
    sqlite3_stmt *getmotionstmt = nil;
    //HW1_NewtonAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *dbPath = appDelegate.getDBPath;
    
    if (sqlite3_open([dbPath UTF8String], &databaseMotion) == SQLITE_OK) 
    {
        const char *sql = "SELECT motion FROM fish_store where fish_path = ?";
       // sqlite3_stmt *selectstmt;        
        if(sqlite3_prepare_v2(databaseMotion, sql, -1, &getmotionstmt, NULL) == SQLITE_OK)        
        {
            sqlite3_bind_text(getmotionstmt, 1, [image_name UTF8String]  , -1, SQLITE_TRANSIENT);
            while(sqlite3_step(getmotionstmt) ==     SQLITE_ROW) 
                {
                    motion = sqlite3_column_int(getmotionstmt, 0);
                }
            }
        }
        
        if(getmotionstmt) sqlite3_finalize(getmotionstmt);
}

//================
-(CGRect) swapWidthAndHeight:(CGRect) rect
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}
-(UIImage*)rotate:(UIImageOrientation)orient andImage:(UIImage *)fishImage
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = fishImage.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            // would get you an exact copy of the original
            return fishImage;
            break;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = [self swapWidthAndHeight:bnds];
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = [self swapWidthAndHeight:bnds];
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
        bnds = [self swapWidthAndHeight:bnds];
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = [self swapWidthAndHeight:bnds];
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return copy;
}

@end
