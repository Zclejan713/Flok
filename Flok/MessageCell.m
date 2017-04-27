//
//  MessageCell.m
//  Flok
//
//  Created by NITS_Mac4 on 17/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgv.layer.cornerRadius=_imgv.frame.size.height/2;
    _vw1.backgroundColor=[UIColor clearColor];
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
