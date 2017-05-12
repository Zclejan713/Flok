//
//  ChatCell.m
//  Flok
//
//  Created by NITS_Mac4 on 17/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgv.layer.cornerRadius=_imgv.frame.size.height/2;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
