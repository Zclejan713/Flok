//
//  RegistraionPage3.h
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface RegistraionPage3 : UIViewController
{
    IBOutlet UIView *vwRadio;
    IBOutlet UIButton *btnBack;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UITextField *tfFname;
    IBOutlet UITextField *tfLname;
    IBOutlet UITextField *tfGender;
    IBOutlet UIButton *btnFnd;
    
}

- (IBAction)backTap:(id)sender;
- (IBAction)findfndTap:(UIButton *)sender;
- (IBAction)radioTap:(UIButton *)sender;






@end
