//
//  ChatPage.h
//  Flok
//
//  Created by NITS_Mac4 on 17/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@interface ChatPage : UIViewController
{
    IBOutlet UIButton *backBtn;
    IBOutlet UILabel *lblName;
    IBOutlet UIButton *btnInfo;
    IBOutlet UITableView *tblChat;
    
    IBOutlet UIView *vwSend;
    IBOutlet UITextView *tvSend;
    IBOutlet UIButton *btnSend;
    
    
}

- (IBAction)backTap:(UIButton *)sender;
- (IBAction)infoTap:(UIButton *)sender;



@end
