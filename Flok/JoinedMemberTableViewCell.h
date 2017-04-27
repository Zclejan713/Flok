//
//  JoinedMemberTableViewCell.h
//  Flok
//
//  Created by NITS_Mac3 on 21/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinedMemberTableViewCell : UITableViewCell
@property (retain ,nonatomic)IBOutlet UIImageView *profileImg;
@property (retain ,nonatomic)IBOutlet UILabel *lblName;
@property (retain ,nonatomic)IBOutlet UILabel *UserName;
@property (retain ,nonatomic)IBOutlet UIButton *btnRate;
@property (retain ,nonatomic)IBOutlet UIButton *btnLeave;
@property (retain ,nonatomic)IBOutlet UIButton *btnRemove;
@property (retain ,nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@end
