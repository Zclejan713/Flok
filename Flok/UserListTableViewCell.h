//
//  UserListTableViewCell.h
//  Tchin
//
//  Created by NITS_Mac3 on 25/07/17.
//  Copyright © 2017 NITS_Mac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblContact;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property(retain,nonatomic)IBOutlet UIButton *btnFollow;
@end
