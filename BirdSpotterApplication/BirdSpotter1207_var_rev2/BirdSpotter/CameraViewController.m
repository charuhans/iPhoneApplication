//
//  CameraViewController.m
//  BirdSpotter
//
//  Created by Newton on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "BirdSpotterAppDelegate.h"
#import "MenuViewController.h"
#import "MultipleViewController.h"

@implementation CameraViewController
@synthesize imageView, cameraRoll, cameraButton, appDelegate, m_picker, activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        appDelegate = [[UIApplication sharedApplication] delegate];
        
        cameraButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cameraButton addTarget:self action:@selector(useCamera) forControlEvents:UIControlEventTouchDown];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera_button.png"] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera_button_active.png"] forState:UIControlStateHighlighted];
        cameraButton.frame = CGRectMake(100.0, 375.0, 120.0, 40.0);
        
        cameraRoll= [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cameraRoll addTarget:self action:@selector(useCameraRoll)  forControlEvents:UIControlEventTouchDown];
        [cameraRoll setBackgroundImage:[UIImage imageNamed:@"camera_roll.png"] forState:UIControlStateNormal];
        [cameraRoll setBackgroundImage:[UIImage imageNamed:@"camera_Roll_active.png"] forState:UIControlStateHighlighted];
        cameraRoll.frame = CGRectMake(180.0, 360.0, 120.0, 40.0);
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activity.frame = CGRectMake(140, 220, 40, 40);
        activity.tag = 12;
        
    }
    return self;
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];       
    [self.view addSubview:cameraButton];
    [self.view addSubview:cameraRoll];
}

- (void)viewDidUnload
{
    [imageView release];
    self.imageView = nil ;
    [cameraButton release];
    self.cameraButton = nil ;
}

- (void)dealloc 
{
    [activity release];
    //[m_picker release];
    [appDelegate release];
    [cameraRoll release];
    //[cameraButton release];
    //[imageView release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) startActivityIndicator{
    [[UIApplication sharedApplication].keyWindow addSubview:activity];
    [activity startAnimating];
}
-(void) stopActivityIndicator{
    [activity stopAnimating];
    [activity removeFromSuperview];
    activity = nil;
}

- (void)useCamera{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {        
        [appDelegate.menuVC.multiVC.toolbar removeFromSuperview];
        m_picker = [[UIImagePickerController alloc] init];
        m_picker.delegate = self;        
        m_picker.sourceType = UIImagePickerControllerSourceTypeCamera;        
        [self presentModalViewController: m_picker animated:YES];
        //[m_picker release];
    }
    
}

- (void)useCameraRoll{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        m_picker= [[UIImagePickerController alloc]init];
		m_picker.delegate = self;
		m_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:m_picker animated:YES];
		[m_picker release];
    }
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error  contextInfo:(void *)contextInfo{
    if (error) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save image"\
                              delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [m_picker release];
    m_picker = nil;
    
    [appDelegate.menuVC.multiVC.view addSubview:appDelegate.menuVC.multiVC.toolbar];
    [self stopActivityIndicator];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /*
    NSArray *paths;
    NSString *documentsDirectory;
    NSString *path;
    int value;
    NSString* fileName;
    NSString *savedImagePath;
    //UIImage *image ;
    //NSData *imageData;
    */
       
    
    [self dismissModalViewControllerAnimated:YES];
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) 
    {
        UIImage *image = [info  objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        imageView.image = image;
        
        
        [self startActivityIndicator];
        
        [appDelegate.menuVC.multiVC.view addSubview:appDelegate.menuVC.multiVC.toolbar];
        
        if(image != NULL)
        {
            newMedia = YES;
        }
        
        if (newMedia)
        {      
            /*
            //paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
            //documentsDirectory = [paths objectAtIndex:0];
            
            //get the path to data.plist that holds our current counter for image name
            //path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; 
            
            
            //===================================
            //plist
            //get data from the file and put it in info
            //NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile: path];   
                        
            //get the current value in the plist
            //value = [[info objectForKey:@"value"] intValue];  
            
            //increase the counter to get new image name
            //value = value+1;            
            
            //change the value to new value that we have
            //[info setObject:[NSNumber numberWithInt:0] forKey:@"value"];
            
            //write the information to the plist (modify the file)
            //[info writeToFile: path atomically:YES];
            
            //release the uneeded memory
            //[info release];
            //===================================
            
            //fileName = [[NSString alloc] initWithFormat:@"savedImage%d.png",value];
             */
            
            /*
            UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
            activity.frame = CGRectMake(round((self.view.frame.size.width-45)/2), round((self.view.frame.size.height-45)/2), 45, 45);
            activity.tag = 111;
            [m_picker.view addSubview:activity];
            [activity startAnimating];
            */
            
            /*
            //savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            //UIImage *image1 = imageView.image; // imageView is my image from camera
            //NSData *imageData = UIImagePNGRepresentation(image);
            //[imageData writeToFile:savedImagePath atomically:NO]; 
              */        
            
            //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
            /*
            UIActivityIndicatorView *tmpImg = (UIActivityIndicatorView *)[m_picker.view viewWithTag:111];
            [tmpImg removeFromSuperview];
            */
            
            NSOperationQueue* queue = [NSOperationQueue new];
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveImage) object:nil];
            [queue addOperation:operation];
            [operation release];
        }
    }
     
    
    
    /*
    if(newMedia)
    {
        imageData = UIImagePNGRepresentation(imageView.image);
        [imageData writeToFile:savedImagePath atomically:YES]; 
        
        [fileName release];
    }
     */
}

-(void) goBackToView{
    [self stopActivityIndicator];
}

- (void)saveImage{
   // UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
     /*  
    [m_picker release];
    m_picker = nil;
    
    UIImage* image = imageView.image;
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithString: @"test.png"] ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    */
    
    
    [self performSelectorOnMainThread:@selector(goBackToView) withObject:nil waitUntilDone:NO];
}

@end
