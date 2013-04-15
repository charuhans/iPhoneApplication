//
//  fishWebViewContoller.h
//  HW3_NEWTON
//
//  Created by Newton on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface fishWebViewContoller : UIViewController <UIWebViewDelegate>
{
    NSString *myLink;
    NSString *currentURL;
    IBOutlet UIWebView *fishImageInRepos;
}
@property (nonatomic, retain) IBOutlet IBOutlet UIWebView *fishImageInRepos;
@property (nonatomic, retain) NSString *myLink;
@property (nonatomic, retain) NSString *currentURL;

-(void) setLinks:(NSString*) openLink;
-(void) resetLinks;
@end
