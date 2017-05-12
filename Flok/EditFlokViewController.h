//
//  EditFlokViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 06/12/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PECropViewController.h"
#import "Global.h"
@interface EditFlokViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,PECropViewControllerDelegate,UIActionSheetDelegate>

{
    
    IBOutlet UIButton *btnViewpht;
    IBOutlet UIButton *btnPostflok1,*btnPostflok2;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UIImageView *imgBanner;
    IBOutlet UIImageView *imgTextBg;
    IBOutlet UIImageView *imgCheck;
    IBOutlet UITextField *tfTitle;
    IBOutlet UITextField *tfAddr;
    IBOutlet UITableView *tblAddr;
    IBOutlet UITableView *tblFriend;
    IBOutlet UIView *vwFriend;
    IBOutlet MKMapView *mapvw;
    IBOutlet UITextField *tfMinfolk;
    IBOutlet UITextField *tfMaxfolk;
    IBOutlet UITextView *tvDesc;
    IBOutlet UISegmentedControl *segLocalsocial;
    IBOutlet UISegmentedControl *setAccess;
    IBOutlet UITextField *tfStartdate;
    IBOutlet UITextField *tfEnddate;
    IBOutlet UITextField *tfStarttime;
    IBOutlet UITextField *tfEndtime;
    IBOutlet UITextField *tfFlokLimit;
    IBOutlet UISearchBar *search;
    IBOutlet UIView *vwSub;
    NSString *latitude;
    NSString *longitude;
    NSString *accessList,*oldAccessList,*userId,*oldAllAccessList;
    NSString *strStardate, *strEnddate,*strStarTime, *strEndTime;
    NSString *allaccessed;
    BOOL isFilter;
    BOOL isCheck;
    BOOL  isPhotoEdit;
    NSMutableArray *searchResults,*arrHashtag;
    NSDictionary *DicFlok;
    NSString *strSessName,*strSessVal;
    AppDelegate *app;
    
}

- (IBAction)backTap:(id)sender;
- (IBAction)postflokTap:(UIButton *)sender;
- (IBAction)segLocalsocialTap:(UISegmentedControl *)sender;
- (IBAction)segAccessTap:(UISegmentedControl *)sender;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic) UIPopoverController *popover;
@property(retain ,nonatomic)NSString *flokId;
@end
