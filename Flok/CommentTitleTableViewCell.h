//
//  CommentTitleTableViewCell.h
//  Flok
//
//  Created by Ritwik Ghosh on 29/07/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;

@property (weak, nonatomic) IBOutlet UITextView *tvTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;
@end
