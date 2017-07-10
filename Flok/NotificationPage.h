//
//  NotificationPage.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface NotificationPage : UIViewController<UITabBarControllerDelegate>
{
    IBOutlet UITableView *tblMsg;
    IBOutlet UIView *vwNoProduct;
    IBOutlet UISegmentedControl *segmentedControl;
    NSArray *arrList;
}
-(void)changeTabBarIcon;
-(void)getNnotificationList;
-(void)changeTreeTabBarIcon;
-(void)changeTabMessageBarIcon;
@end
