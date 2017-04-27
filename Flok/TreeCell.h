//
//  TreeCell.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UIImageView *imgFlag;
@property(nonatomic,strong) IBOutlet UIImageView *imgReflok;
@property(nonatomic,strong) IBOutlet UILabel *lblName;
@property(nonatomic,strong) IBOutlet UILabel *lblUserName;
@property(nonatomic,strong) IBOutlet UILabel *lblDistance;
@property(nonatomic,strong) IBOutlet UILabel *lblTime;
@property(nonatomic,strong) IBOutlet UIButton *btnReflok;
@property(nonatomic,strong) IBOutlet UIButton *btnLike;
@property(nonatomic,strong) IBOutlet UIButton *btnDislike;
@property(nonatomic,strong) IBOutlet UIButton *btnProfile;
@property(nonatomic,strong) IBOutlet UIButton *btnMsg;
@property(nonatomic,strong) IBOutlet UIButton *btnDelete;
@property(nonatomic,strong) IBOutlet UIButton *btnEdit;
@property(nonatomic,strong) IBOutlet UIButton *btnDeleteImg;
@property(nonatomic,strong) IBOutlet UIButton *btnEditImg;
//@property(nonatomic,strong) IBOutlet UILabel *lblFlokName;
@property(nonatomic,strong) IBOutlet UITextView *lblFlokName;
@property(nonatomic,strong) IBOutlet UILabel *lblLikeCount;
@property(nonatomic,strong) IBOutlet UILabel *lblDisLikeCount;
@property(nonatomic,strong) IBOutlet UILabel *lblReflokCount;
@property(nonatomic,strong) IBOutlet UIView *vwReflok;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,strong) IBOutlet UIView *vwExpired;
@property (weak, nonatomic) IBOutlet UIButton *EditBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *MsgImg;




@end
