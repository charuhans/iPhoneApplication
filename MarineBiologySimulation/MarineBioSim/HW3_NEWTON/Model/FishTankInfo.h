#import <Foundation/Foundation.h>


@interface FishTankInfo : NSObject 
{
    //IBOutlet UIImageView * imgView;
    UIImage   *fish_image;
    CGPoint   location;
    NSInteger  directionHead;
    NSString  *fishImg_name;
    NSInteger motion_pattern;
    NSInteger fish_ka_id;
    NSString* fish_group;
}

//@property(nonatomic, retain) IBOutlet UIImageView * imgView;
@property(nonatomic, retain) IBOutlet UIImage   *fish_image;
@property(nonatomic, assign) CGPoint   location;
@property(nonatomic, assign) NSInteger  directionHead;
@property(nonatomic, retain) NSString  *fishImg_name;
@property(nonatomic, assign) NSInteger motion_pattern;
@property(nonatomic, assign) NSInteger fish_ka_id;
@property(nonatomic, assign) NSString* fish_group;

- (id)initWithName:(NSString*)fishName andLoc:(CGPoint)loc andDirection:(NSInteger)direction andPattern:(NSInteger)motion andFishID:(NSInteger)ID  andGroup:(NSString*) group;
- (void) setFishID:(NSInteger)idoffishy;
- (void)dealloc;
//+ (void)setnewLoc:(CGPoint) point;
@end
