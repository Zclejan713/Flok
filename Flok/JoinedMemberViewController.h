//
//  JoinedMemberViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 21/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface JoinedMemberViewController : UIViewController
{
    IBOutlet UITableView *tblMain;
    IBOutlet UILabel *lblFlokker;
    NSArray *arrList;
    NSDictionary *rateUserDic;
    BOOL isReport;
}
@property(retain ,nonatomic)NSString *FlokId;
@property(retain ,nonatomic)NSString *Flokker;
@property(assign)BOOL isAbleToReport;
@property(assign)BOOL isExpired;
@property(assign)BOOL isOP;
@end
// 
