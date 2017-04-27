//
//  ImagePreviewPage.h
//  Flok
//
//  Created by NITS_Mac4 on 19/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewPage : UIViewController
{
    IBOutlet UIButton *btnBack;
    IBOutlet UIScrollView *scrlMain;
    IBOutlet UIImageView *imgv;
    
}
- (IBAction)backTap:(id)sender;
@property(nonatomic,strong) NSDictionary *dictCame;


@end
