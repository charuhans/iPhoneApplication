//
//  BirdBookCellViewController.m
//  BirdSpotter
//
//  Created by Newton on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirdBookCellViewController.h"

@implementation BirdBookCellViewController
@synthesize birdThumbnail;
@synthesize birdName;

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

- (void)dealloc {
    [birdThumbnail release];
    [birdName release];
    [super dealloc];
}
@end
