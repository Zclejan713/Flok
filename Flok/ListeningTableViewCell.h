//
//  ListeningTableViewCell.h
//  EchoEction
//
//  Created by NITS_Mac3 on 21/12/15.
//  Copyright © 2015 NITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListeningTableViewCell : UITableViewCell
@property(retain,nonatomic)IBOutlet UIImageView *img;
@property(retain,nonatomic)IBOutlet UILabel *lblName;
@property(retain,nonatomic)IBOutlet UILabel *lblEmail;
@property(retain,nonatomic)IBOutlet UILabel *lblAlert;
@property(retain,nonatomic)IBOutlet UIView *vwUnfriend;
@property(retain,nonatomic)IBOutlet UIButton*btnUnfriend;
@property(retain,nonatomic)IBOutlet UIButton*btnConfirm;
@property(retain,nonatomic)IBOutlet UIButton*btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (weak, nonatomic) IBOutlet UIButton *btnUnfollow;
@property(retain,nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@end
