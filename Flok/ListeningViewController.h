//
//  ListeningViewController.h
//  EchoEction
//
//  Created by NITS_Mac3 on 21/12/15.
//  Copyright © 2015 NITS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ListeningViewController : UIViewController
{
    IBOutlet UITableView *tblListening;
    IBOutlet UITableView *tblListeners;
    IBOutlet UIButton *btnListening;
    IBOutlet UIButton *btnListeners;
    IBOutlet UIView *vwListening;
    IBOutlet UIView *vwListeners;
    BOOL isListeners;
    NSMutableArray *arrListening;
    NSMutableArray *arrListeners;
    NSString *strSessName,*strSessVal;
    NSDictionary *removeDic;
    NSIndexPath *indexpath;
    AppDelegate *app;
}
@property(retain,nonatomic)NSString *isListening;
@property(retain,nonatomic)NSString *isOtherUser;
@property(retain,nonatomic)NSString *userId;
@end
