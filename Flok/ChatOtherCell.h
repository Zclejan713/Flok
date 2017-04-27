//
//  ChatOtherCell.h
//  Roadswap Classifieds
//
//  Created by NITS_Mac1 on 24/11/15.
//  Copyright © 2015 NITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatOtherCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imgUser;
@property(strong,nonatomic)IBOutlet UIImageView *imgMsg;
@property(strong,nonatomic)IBOutlet UITextView *tvTxt;
@property(strong,nonatomic)IBOutlet UILabel *lblTime;
@property(strong,nonatomic)IBOutlet UITextView *lblMsg;
@property(strong,nonatomic)IBOutlet UIView *vwMain;
@property(strong,nonatomic)IBOutlet UIView *vwSub;
@property(strong,nonatomic)IBOutlet UIView *vwMsg;
@end
