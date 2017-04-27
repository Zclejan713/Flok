//
//  OtherUserViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 05/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface OtherUserViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet HCSStarRatingView *vwStar;
    CLLocationManager *locationManager;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UITableView *tblMain;
    IBOutlet UIView *vwMain;
    IBOutlet UIView *vwImg;
    IBOutlet UIImageView *profileImg;
    IBOutlet UITextView *tvAbout;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAge;
    IBOutlet UILabel *lblFollow;
    IBOutlet UILabel *lblFollowers;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblMutual;
    IBOutlet UILabel *lblProfileImgCount;
    IBOutlet UILabel *schoollabel;
    IBOutlet UILabel *workLabel;
    IBOutlet UIButton *btnFollow;
    IBOutlet UIView *vwStarRating;
    IBOutlet UIView *vwTemp;
    IBOutlet UIButton *btnShowMore;
    IBOutlet UIScrollView *scrlImg;
    IBOutlet UIView *vwTransparent;
    IBOutlet UIScrollView *scrlProfileImg;
    UISegmentedControl *segmentedControl;
    NSInteger totalImg;
    BOOL isPrivate;
    NSMutableArray *arrPost;
    NSMutableArray *arrShared;
    NSMutableArray *arrimg;
    NSMutableArray *arrHashtag;
    NSArray *arrFriends;
    NSUserDefaults *prefs;
    NSString *userId;
    NSString *latitude;
    NSString *longitude;
    NSString *facebookId;
}
@property(retain ,nonatomic)NSString *OtherUserId;
@property(retain,nonatomic)NSDictionary *OtherUserdic;
-(IBAction)rateToUserAction:(id)sender;
-(IBAction)reportUser:(id)sender;
@end
