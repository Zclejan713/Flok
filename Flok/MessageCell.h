//
//  MessageCell.h
//  Flok
//
//  Created by NITS_Mac4 on 17/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UIImageView *imgv;
@property(nonatomic,strong) IBOutlet UILabel *lblnm;
@property(nonatomic,strong) IBOutlet UITextView *tvdesc;
@property(nonatomic,strong) IBOutlet UIView *vw1;
@property(nonatomic,strong) IBOutlet UILabel *lblDist;
@property(nonatomic,strong) IBOutlet UILabel *lblTime;
@property(nonatomic,strong) IBOutlet UILabel *lblBottomline;
@property(nonatomic,strong) IBOutlet UILabel *lblCount;
@property(nonatomic,strong) IBOutlet UIImageView *imgRound;
@property(nonatomic,strong) IBOutlet UIButton *btnProfile;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *indicator;



@end
