//
//  MutualFriendTableViewCell.h
//  Flok
//
//  Created by Ritwik Ghosh on 15/10/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutualFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
