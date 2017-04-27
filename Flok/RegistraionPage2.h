//
//  RegistraionPage2.h
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface RegistraionPage2 : UIViewController
{
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIView *vwMain;
    IBOutlet UITextField *tfPhone;
    IBOutlet UITextField *lblCountryCode;
    
}

- (IBAction)backTap:(id)sender;
- (IBAction)forwardTap:(id)sender;
- (IBAction)phonecodeTap:(UIButton *)sender;








@end
