//
//  CommentViewController.h
//  Flok
//
//  Created by Ritwik Ghosh on 27/07/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat commentFrame;
static CGFloat frameWidth;

@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblMain;
@property (weak, nonatomic) IBOutlet UITextView *tvComment;

@property (weak, nonatomic) IBOutlet UIView *vwComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@end
