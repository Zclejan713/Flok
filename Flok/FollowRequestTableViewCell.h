//
//  FollowRequestTableViewCell.h
//  Flok
//
//  Created by NITS_Mac3 on 24/01/17.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowRequestTableViewCell : UITableViewCell
@property(retain,nonatomic)IBOutlet UIImageView *Profileimg;
@property(retain,nonatomic)IBOutlet UILabel *lblName;
@property(retain,nonatomic)IBOutlet UIButton *btnAccept;
@property(retain,nonatomic)IBOutlet UIButton *btnReject;
@property(retain,nonatomic)IBOutlet UIButton *btnDetails;
@property(retain,nonatomic)IBOutlet UILabel *lblTime;
@property(retain,nonatomic)IBOutlet UIImageView *imgIcon;
@property(retain,nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@end
