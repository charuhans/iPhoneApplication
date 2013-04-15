//
//  BirdProfileViewController.m
//  BirdSpotter
//
//  Created by Newton on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirdProfileViewController.h"
#import "BirdProfileModel.h"
#import "Bird.h"
#import <AVFoundation/AVAudioPlayer.h>

@implementation BirdProfileViewController
@synthesize audioPlayer;
@synthesize playSoundButton;
@synthesize profileImageOutlet;
@synthesize birdNameOutlet, statusOutlet;
@synthesize habitatOutlet, matingSeasonOutlet;
@synthesize dietOutlet, triviaOutlet;
@synthesize migrationOutlet, birdID;
@synthesize toolbar, scrollview;
@synthesize isPlayButtonClicked, isAudioPresent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{ 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
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

- (void)viewDidLoad{
    [super viewDidLoad];
    
    isPlayButtonClicked = YES;
    isAudioPresent = NO;
    
    // Do any additional setup after loading the view from its nib.
    if([self.audioPlayer isPlaying])
        [self.audioPlayer stop];
    
    //these two lines add scoll to the page, add UIscroll in xib and do this then drag file owner onto uiscroll and select scrollbar
    scrollview.frame = CGRectMake(0, 44, 320, 460);
    [scrollview setContentSize:CGSizeMake(320, 500)];    
    
    [self.playSoundButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
         
    //fill all the profile data
    [self fillBirdProfileData];
}

- (void)viewDidUnload{
    [self setProfileImageOutlet:nil];
    [self setBirdNameOutlet:nil];
    [self setStatusOutlet:nil];
    [self setHabitatOutlet:nil];
    [self setMatingSeasonOutlet:nil];
    [self setDietOutlet:nil];
    [self setTriviaOutlet:nil];
    [self setMigrationOutlet:nil];
    [self setScrollview:nil];
    [self setBackButton:nil];
    [self setPlaySoundButton:nil];
    
    [self.audioPlayer stop];
    [self.audioPlayer release];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [toolbar release];
    [profileImageOutlet release];
    [birdNameOutlet release];
    [statusOutlet release];
    [habitatOutlet release];
    [matingSeasonOutlet release];
    [dietOutlet release];
    [triviaOutlet release];
    [migrationOutlet release];
    [scrollview release];
    //[backButton release];
    //backButton = nil;
    [playSoundButton release];
    [super dealloc];
}

-(void) fillBirdProfileData{
    Bird* tempBird = [BirdProfileModel getBirdFromId:self.birdID];
    
    profileImageOutlet.image = [UIImage imageNamed:tempBird.profile_image_file];
    birdNameOutlet.text = tempBird.name;
    statusOutlet.text = [BirdProfileModel getStatusInformation: tempBird.status];
    habitatOutlet.text = tempBird.habitat;
    matingSeasonOutlet.text = tempBird.mating_season;
    dietOutlet.text = tempBird.food;
    triviaOutlet.text = tempBird.trivia;
    migrationOutlet.text = tempBird.calender_migration;
    
    
    NSArray *listItems = [tempBird.audio_file componentsSeparatedByString:@"."];
    
    NSString* nameofFile = [listItems objectAtIndex:0];
    
    if(![nameofFile isEqualToString:@"no audio"])
    {
        // Get the file path to the song to play.
        NSString *filePath = [[NSBundle mainBundle] pathForResource:nameofFile ofType:@"mp3"];
        //  NSString *filePath = [[NSBundle mainBundle]pathForResource:@"American_Black_Vulture" ofType:@"mp3"];
    
        // Convert the file path to a URL.
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
        //Initialize the AVAudioPlayer.
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];   
        
        [filePath release];
        [fileURL release];
        isAudioPresent = YES;
    }
}

- (IBAction)backToHome:(id)sender{
    [self.audioPlayer stop];
    [self.audioPlayer release];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)playSoundAction:(id)sender
{
    if (isAudioPresent == YES)
    {
        if(isPlayButtonClicked) //if it true
        {
            [self.playSoundButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            //put pause image and play the sound
            self.audioPlayer.currentTime = 0;    
            [self.audioPlayer play];
            isPlayButtonClicked = NO;
        }
        else
        {
            //play button and stop sound if playing 
            [self.playSoundButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [self.audioPlayer stop];
            isPlayButtonClicked = YES;
        }  
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Warning !!"
                                                            message:@"Sound for this bird is not available" delegate:self 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
}
@end
