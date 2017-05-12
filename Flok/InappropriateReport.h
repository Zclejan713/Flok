//
//  InappropriateReport.h
//  Flok
//
//  Created by NITS_Mac3 on 14/12/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InappropriateReport : UIViewController
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UITextView *tvDes;
    IBOutlet UILabel *lblName;
    IBOutlet UIView *vwBg;
    BOOL isKeyBoard;
}
@property(retain ,nonatomic)NSString *OtherUserId;
@property(retain ,nonatomic)NSString *OtherUserImg;
@property(retain ,nonatomic)NSString *OtherUserName;
@end
