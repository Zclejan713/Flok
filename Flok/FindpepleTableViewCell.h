//
//  FindpepleTableViewCell.h
//  EchoEction
//
//  Created by NITS_Mac3 on 25/09/15.
//  Copyright © 2015 NITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindpepleTableViewCell : UITableViewCell
@property(retain,nonatomic)IBOutlet UIImageView *img;
@property(retain,nonatomic)IBOutlet UIImageView *imgFriend;
@property(retain,nonatomic)IBOutlet UILabel *lblName;
@property(retain,nonatomic)IBOutlet UILabel *lblEmail;
@property(retain,nonatomic)IBOutlet UILabel *lblUserName;
@property(retain,nonatomic)IBOutlet UILabel *lblFriend;
@property(retain,nonatomic)IBOutlet UILabel *lblPending;
@property(retain,nonatomic)IBOutlet UIView *vwBg;
@property(retain,nonatomic)IBOutlet UIButton *btnInvite;
@property(retain,nonatomic)IBOutlet UIButton *btnFollow;
@property(retain,nonatomic)IBOutlet UIActivityIndicatorView *indicator;

@end
