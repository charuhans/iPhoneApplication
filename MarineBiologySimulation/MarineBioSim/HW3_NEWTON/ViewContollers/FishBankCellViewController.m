//
//  FishBankCellViewController.m
//  HW1_Newton
//
//  Created by Varun Varghese on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FishBankCellViewController.h"

@implementation FishBankCellViewController
@synthesize categoryOutlet;
@synthesize counterLabel;
@synthesize fishName;
@synthesize motionPatternDescription;
@synthesize fishImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc 
{
    [fishName release];
    [motionPatternDescription release];
    [fishImage release];
    [counterLabel release];
    [categoryOutlet release];
    [super dealloc];
}
@end
