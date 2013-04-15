//
//  BirdBookCellViewController.h
//  BirdSpotter
//
//  Created by Newton on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirdBookCellViewController : UITableViewCell
{

    UIImageView *birdThumbnail;
    UILabel *birdName;
}
@property (nonatomic, retain) IBOutlet UIImageView *birdThumbnail;
@property (nonatomic, retain) IBOutlet UILabel *birdName;

@end
