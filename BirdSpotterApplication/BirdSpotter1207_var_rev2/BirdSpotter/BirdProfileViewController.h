//
//  BirdProfileViewController.h
//  BirdSpotter
//
//  Created by Newton on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class BirdProfileModel;
@class Bird;
@class AVAudioPlayer;

#import <UIKit/UIKit.h>

@interface BirdProfileViewController : UIViewController {
    UIImageView *profileImageOutlet;
    UILabel *birdNameOutlet;
    UILabel *statusOutlet;
    UILabel *habitatOutlet;
    UILabel *matingSeasonOutlet;
    UILabel *dietOutlet;
    UILabel *triviaOutlet;
    UILabel *migrationOutlet;    
    UIToolbar *toolbar;    
    int birdID;
    IBOutlet UIScrollView *scrollview;
    AVAudioPlayer *audioPlayer;
    UIButton *playSoundButton;
    BOOL isPlayButtonClicked;
    BOOL isAudioPresent;
    
    //IBOutlet UIButton* backButton;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, assign) BOOL isPlayButtonClicked;
@property (nonatomic, assign) BOOL isAudioPresent;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageOutlet;
@property (nonatomic, retain) IBOutlet UILabel *birdNameOutlet;
@property (nonatomic, retain) IBOutlet UILabel *statusOutlet;
@property (nonatomic, retain) IBOutlet UILabel *habitatOutlet;
@property (nonatomic, retain) IBOutlet UILabel *matingSeasonOutlet;
@property (nonatomic, retain) IBOutlet UILabel *dietOutlet;
@property (nonatomic, retain) IBOutlet UILabel *triviaOutlet;
@property (nonatomic, retain) IBOutlet UILabel *migrationOutlet;
@property (assign) int birdID;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UIButton *playSoundButton;

- (IBAction)playSoundAction:(id)sender;

- (IBAction)back:(id)sender;
-(void) fillBirdProfileData;
- (IBAction)backToHome:(id)sender;

//@property (nonatomic, retain) IBOutlet UIButton *backButton;

@end
