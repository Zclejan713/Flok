//
//  JoinFlokTableViewCell.h
//  Flok
//
//  Created by NITS_Mac3 on 26/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinFlokTableViewCell : UITableViewCell
@property(retain,nonatomic)IBOutlet UIImageView *Profileimg;
@property(retain,nonatomic)IBOutlet UILabel *lblName;
@property(retain,nonatomic)IBOutlet UILabel *lblNotification;
@property(retain,nonatomic)IBOutlet UIButton *btnAccept;
@property(retain,nonatomic)IBOutlet UIButton *btnReject;
@property(retain,nonatomic)IBOutlet UIButton *btnDetails;
@property(retain,nonatomic)IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UILabel *FlokTiTtle;

@property (weak, nonatomic) IBOutlet UILabel *FlokDescription;


@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *datelabel;



@end
