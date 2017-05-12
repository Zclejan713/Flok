//
//  SearchUsersViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 22/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SearchUsersViewController : UIViewController
{
    NSMutableArray *arrGender;
    UIPickerView *myPickerView;
    NSString *strGender;
    NSInteger selectedRow;
    NSUserDefaults *prefs;
    NSString *last_Id;
    NSString *searchData;
    IBOutlet UITextField *tfFname;
    IBOutlet UITextField *tfLname;
    IBOutlet UITextField *tfGender;
}

@end
