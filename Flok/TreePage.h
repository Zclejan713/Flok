//
//  TreePage.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TreePage : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITabBarDelegate,UITabBarControllerDelegate>
{
    CLLocationManager *locationManager;
    IBOutlet UIView *vwPost;
    IBOutlet UIView *vwLocService;
    IBOutlet UIView *vwTransparent;
    IBOutlet UIView *vwAlert;
    IBOutlet UISegmentedControl *segmentedControl;
    NSMutableArray *arrList;
    NSString *latitude;
    NSString *longitude;
    NSString *userId;
    NSString *table_View;
    NSString *type;
    NSString *miles;
    NSString *lastId;
    NSDictionary *tempDic;
    NSIndexPath *tempIndexPath;
    NSMutableArray *arrHashtag;
    BOOL isValueGet;
    BOOL isNewUpdate;
    int feed_state;
     NSTimer *updateTimer;
    UIRefreshControl *refreshControl;
    UIRefreshControl *refreshControlHot;
}
-(IBAction)newflok:(id)sender;
-(void)changeTabBarIcon;
-(void)changeNotificationTabBarIcon;
-(void)changeMessageTabBarIcon;
@property(weak ,nonatomic)IBOutlet UIButton *btnBubble;
- (IBAction)tabheaderTap:(UIButton *)btnTab;
- (IBAction)featherTap:(UIButton *)sender;



@end
