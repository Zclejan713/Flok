//
//  OtheruserflokCell.h
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtheruserflokCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgv;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparator;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;
@property (strong, nonatomic) IBOutlet UIView *vwBg;

@end
