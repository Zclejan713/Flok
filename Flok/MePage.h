//
//  MePage.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface MePage : UIViewController
{
    CLLocationManager *locationManager;
    IBOutlet HCSStarRatingView *vwStar;
    IBOutlet UITableView *tblMain;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UIView *vwImg;
    IBOutlet UIView *vwRatingAlert;
    IBOutlet UIImageView *profileImg;
    IBOutlet UITextView *tvAbout;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAge;
    IBOutlet UILabel *lblFollow;
    IBOutlet UILabel *lblFollowers;
    IBOutlet UILabel *lblMutual;
    IBOutlet UILabel *lblProfileImgCount;
    IBOutlet UILabel *startdatelbl;
    IBOutlet UIButton *btnFollow;
    IBOutlet UIButton *btnShowMore;
    IBOutlet UIView *vwStarRating;
    IBOutlet UIScrollView *scrlImg;
    IBOutlet UIView *vwTransparent;
    IBOutlet UIView *vwFilter;
    IBOutlet UIScrollView *scrlProfileImg;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIView *vwTemp;
    NSInteger totalImg;
    BOOL isPrivate;
    
    UISegmentedControl *segmentedControl;
    NSMutableArray *arrPost;
    NSMutableArray *arrShared;
    NSString *userId,*filterDate;
    NSString *latitude;
    NSString *longitude;
    NSDictionary *userDetailsDic,*tempDic;
    NSArray *arrFriends;
    NSIndexPath *tempIndexPath;
    NSMutableArray *arrHashtag;
    AppDelegate *app;
}

- (IBAction)logoutTap:(UIButton *)sender;
@property(strong,nonatomic) NSString *frompage;
-(void)changeNotificationTabBarIcon;
-(void)changeMessageTabBarIcon;
-(void)changeTreeTabBarIcon;

@end
