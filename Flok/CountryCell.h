//
//  CountryCell.h
//  Flok
//
//  Created by NITS_Mac4 on 25/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UIImageView *imgFlag;
@property(nonatomic,strong) IBOutlet UILabel *lblname;
@property(nonatomic,strong) IBOutlet UILabel *lblCountrycode;
@property(nonatomic,strong) IBOutlet UILabel *lblphonecode;



@end
