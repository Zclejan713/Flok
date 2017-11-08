//
//  HashTagTableViewCell.h
//  Flok
//
//  Created by Ritwik Ghosh on 30/07/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HashTagTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@end
