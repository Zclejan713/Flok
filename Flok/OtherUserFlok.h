//
//  OtherUserFlok.h
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface OtherUserFlok : UIViewController
{
    IBOutlet UIButton *btnBack;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UIView *vwTalk;
    IBOutlet UIImageView *imgBanner;
    IBOutlet UIImageView *imgLimit;
    IBOutlet UIButton *btnView;
    IBOutlet UIButton *btnCommentPost;
    IBOutlet UITextView *lblTitle;
    IBOutlet UIImageView *imgUser;
    IBOutlet UILabel *lblLikecount;
    IBOutlet UILabel *lblDislikecount;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblPeople;
    IBOutlet UILabel *lblLimit;
    IBOutlet UILabel *lblJoin;
    IBOutlet UILabel *lblRequest;
    IBOutlet UILabel *lblFname;
    IBOutlet UILabel *lblDistance;
    IBOutlet UILabel *lblRequestBase;
    IBOutlet UITableView *tblvw;
    IBOutlet UIButton *btnJoinfolk;
    IBOutlet UIButton *btnLimit;
    IBOutlet UIButton *btnLocation;
    IBOutlet UIButton *btnShowMap;
    IBOutlet UIView *vwTransparent;
    IBOutlet UIImageView *imgBgBanner;
    IBOutlet UIView *vwComment;
    IBOutlet UIView *vwHideMap;
    IBOutlet UITextView *tfComment;
    IBOutlet UITextView *tvDes;
    NSMutableArray *arrMain;
    NSDictionary *DicFlok;
    NSDictionary *userDic;
    NSString *userId;
    NSString *Flokker;
    BOOL stageOne;
    BOOL stageTwo;
    BOOL stageThree;
    BOOL stagelast;
    BOOL isKeyOpen;
    BOOL isAbleToReport;
    BOOL isOP;
    BOOL isRecentJoin;
    BOOL isFlokLimited;
    float keyHeight;
    
}
@property(retain ,nonatomic)NSString *flokId;
@property(retain ,nonatomic)NSString *distance;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgDesBorder;
- (IBAction)backTap:(id)sender;
- (IBAction)searchTap:(id)sender;
- (IBAction)featherTap:(UIButton *)sender;
- (IBAction)viewPhtTap:(UIButton *)sender;
- (IBAction)joinfolkTap:(id)sender;
- (IBAction)locationTap:(UIButton *)sender;




@end
