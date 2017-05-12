//
//  FlikDetailsForRequestBase.h
//  Flok
//
//  Created by NITS_Mac3 on 19/10/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface FlikDetailsForRequestBase : UIViewController
{
    IBOutlet UIButton *btnBack;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UIImageView *imgBanner;
    IBOutlet UIButton *btnView;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgUser;
    IBOutlet UILabel *lblLikecount;
    IBOutlet UILabel *lblDislikecount;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblPeople;
    IBOutlet UILabel *lblLimit;
    IBOutlet UILabel *lblRequest;
    IBOutlet UILabel *FlokStartDatelbl;
    IBOutlet UILabel *enddatelbl;
    IBOutlet UILabel *StartTimelbl;
    IBOutlet UILabel *EndTimelbl;
    IBOutlet UITableView *tblvw;
    IBOutlet UIButton *btnJoinfolk;
    IBOutlet UIButton *btnLocation;
    IBOutlet UIView *vwTransparent;
    IBOutlet UIImageView *imgBgBanner;
    IBOutlet UIView *vwComment;
    IBOutlet UITextView *tfComment;
    IBOutlet UITextView *tvDes;
    NSMutableArray *arrMain;
    NSDictionary *DicFlok;
    NSDictionary *userDic;
    NSString *userId;
    BOOL stageOne;
    BOOL stageTwo;
    BOOL stageThree;
    BOOL stagelast;
    BOOL isKeyOpen;
    
    float keyHeight;
}
@property(retain ,nonatomic)NSString *flokId;
- (IBAction)backTap:(id)sender;
- (IBAction)searchTap:(id)sender;
- (IBAction)featherTap:(UIButton *)sender;
- (IBAction)viewPhtTap:(UIButton *)sender;
- (IBAction)joinfolkTap:(id)sender;
- (IBAction)locationTap:(UIButton *)sender;
@end
