//
//  PhoneContactTableViewCell.h
//  Flok
//
//  Created by NITS_Mac3 on 28/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneContactTableViewCell : UITableViewCell
@property(retain,nonatomic)IBOutlet UILabel *lblName;
@property(retain,nonatomic)IBOutlet UILabel *lblEmail;
@property(retain,nonatomic)IBOutlet UIButton *btnInvite;
@property(retain,nonatomic)IBOutlet UIButton *btnFollow;
@end
