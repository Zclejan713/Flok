//
//  EditProfileViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 07/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PECropViewController.h"
@interface EditProfileViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,PECropViewControllerDelegate>
{
    IBOutlet UIImageView *profileImg;
    IBOutlet UITextField *tfFirstName;
    IBOutlet UITextField *tfLastName;
    IBOutlet UITextField *tfPhone;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfUserName;
    IBOutlet UITextField *tfDob;
    IBOutlet UITextView *tvAboutMe;
    IBOutlet UITextField *tfBod;
    IBOutlet UITextField *tfMonth;
    IBOutlet UITextField *tfYear;
    IBOutlet UITextField *tfSchool;
    IBOutlet UITextField *tfWork;
    IBOutlet UILabel *lblPrivacy;
    IBOutlet UIButton *btnAdd;
    IBOutlet UIImageView *imgTextBg;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    IBOutlet UIImageView *img3;
    IBOutlet UIImageView *img4;
    IBOutlet UIView *vwFriend;
    IBOutlet UITableView *tblFriend;
    IBOutlet UIImageView *add2;
    IBOutlet UIImageView *add3;
    IBOutlet UIImageView *add4;
    int photoNo;
    NSString *strName;
    NSString *imageId;
    NSArray *arrImage;
    IBOutlet UIScrollView *scroll;
    BOOL isImageEdit;
    BOOL isPrivate;
    NSString *strSessName,*strSessVal;
    UIDatePicker *datepickerDate,*datepickerMonth,*datepickerYear;
    UIDatePicker *datepicker;
    UIImage *tempImg;

}
@property (nonatomic, weak) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic) UIPopoverController *popover;
@end
