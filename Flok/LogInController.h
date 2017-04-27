//
//  LogInController.h
//  Ourtistry
//
//  Created by NITS_Mac1 on 22/03/16.
//  Copyright © 2016 NITS_Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LogInController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfPassword;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIScrollView *scrlMain;
    
    NSDictionary *userDetailsDic;
    

}

-(IBAction)btnLogInPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
-(IBAction)btnNewUserSignUpPressed:(id)sender;







@end
