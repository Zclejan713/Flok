//
//  NotificationTableViewCell.h
//  Flok
//
//  Created by NITS_Mac3 on 22/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property(retain,nonatomic)IBOutlet UIImageView *Profileimg;
@property(retain,nonatomic)IBOutlet UILabel *lblName;
@property(retain,nonatomic)IBOutlet UIButton *btnDetails;
@property(retain,nonatomic)IBOutlet UITextView *lblNotification;
@property(retain,nonatomic)IBOutlet UIImageView *imgIcon;
@property(retain,nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@property(retain,nonatomic)IBOutlet UIButton *btnDetail;
//@property (weak, nonatomic) IBOutlet UILabel *FlokTittlelbl;
@property(retain,nonatomic)IBOutlet UITextView *FlokTittlelbl;
//@property (weak, nonatomic) IBOutlet UILabel *FlokDetailslbl;
@property(retain,nonatomic)IBOutlet UITextView *FlokDetailslbl;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;



@end
