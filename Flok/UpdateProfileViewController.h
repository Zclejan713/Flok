//
//  UpdateProfileViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 11/05/17.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileViewController : UIViewController
{
    IBOutlet UITextField *tfDate;
    IBOutlet UITextField *tfMonth;
    IBOutlet UITextField *tfYear;
    IBOutlet UIButton *btnSignup;
    IBOutlet UITextField *tfGender;
    UIDatePicker *datepicker;
    UIDatePicker *datepickerDate,*datepickerMonth,*datepickerYear;
    UIPickerView *myPickerView;
    NSInteger selectedRow;
    NSString *strGender;
}
@end
