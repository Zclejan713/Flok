//
//  FindYourFlokViewController.h
//  Flok
//
//  Created by Ritwik Ghosh on 06/07/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AjeetAnnotation.h"
#import "PECropViewController.h"

@interface FindYourFlokViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UIActionSheetDelegate,PECropViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


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
    IBOutlet UILabel *lblPlaceHolder;
    IBOutlet UILabel *lblMaxLimit;
    IBOutlet UISearchBar *search;
    IBOutlet UIView *vwSub;
    NSString *latitude;
    NSString *longitude;
    NSString *accessList;
    NSString *allaccessed;
    NSString *strStardate, *strEnddate,*strStarTime, *strEndTime;
    NSMutableArray *arrHashtag;
    BOOL isFilter;
    BOOL isCheck;
    BOOL isImageUpload;
    NSMutableArray *searchResults;
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

@end
