//
//  SettingPage.h
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RangeSlider.h"
#import <MessageUI/MessageUI.h>
@interface SettingPage : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UITextField *tfGender;
    IBOutlet UISlider *DistanceSlider;
    IBOutlet UIImageView *imgCheck;
  //  IBOutlet UISlider *ageSlider;
    IBOutlet UILabel *lblMiles;
    IBOutlet UILabel *lblMaxAge;
    IBOutlet UILabel *lblMinAge;
    NSMutableArray *arrGender;
    UIPickerView *myPickerView;
    NSString *strGender;
    NSInteger selectedRow;
    NSString *miles;
    NSString *age;
    NSString *sliderMin;
    NSString *sliderMax;
    IBOutlet RangeSlider *slider;
    IBOutlet UILabel *lblMin;
    IBOutlet UILabel *lblMax;
    IBOutlet UIView *vwTemp;
    UILabel *reportLabel;
    BOOL isCheck;
    float floatMin,floatMax,floatGender;
    
    //IBOutlet UILabel *lbl
}
 @property (assign)BOOL isPrivate;
@end
