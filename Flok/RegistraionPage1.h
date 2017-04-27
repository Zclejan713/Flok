//
//  RegistraionPage1.h
//  Ourtistry
//
//  Created by NITS_Mac1 on 22/03/16.
//  Copyright © 2016 NITS_Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface RegistraionPage1 : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>
{
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UITextField *tfFullname;
    IBOutlet UITextField *tfDate;
    IBOutlet UITextField *tfMonth;
    IBOutlet UITextField *tfYear;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfUsername;
    IBOutlet UITextField *tfPwd;
    IBOutlet UITextField *tfGender;
    IBOutlet UIButton *btnSignup;
    IBOutlet UIImageView *imgCheck;
    IBOutlet UITextView *tvTerms;
    NSString *strGender;
    AppDelegate *app;
    NSString *imgUrl;
    NSMutableArray *arrGender;
    UIPickerView *myPickerView;
    NSInteger selectedRow;
    
    


}
- (IBAction)backTap:(id)sender;
- (IBAction)forwardTap:(id)sender;
- (IBAction)signupTap:(id)sender;




@end
