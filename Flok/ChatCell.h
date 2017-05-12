//
//  ChatCell.h
//  Flok
//
//  Created by NITS_Mac4 on 17/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *vwBg;
@property (strong, nonatomic) IBOutlet UIImageView *imgv;
@property (strong, nonatomic) IBOutlet UIView *vwBody;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;



@end
