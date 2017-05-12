//
//  MessagePage.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MessagePage : UIViewController<UITabBarControllerDelegate>
{
    IBOutlet UIView *vwSearch;
    IBOutlet UITextField *tfSearch;
    IBOutlet UITableView *tblMsg;
    IBOutlet UIView *vwFriend;
    IBOutlet UIView *NoMessage;
    IBOutlet UITableView *tblFriend;
    IBOutlet UISearchBar *search;
    NSArray *arrList;
    NSMutableArray *searchResults;
    NSMutableArray *arrFriend,*arrCheck,*arrPeople;
    BOOL isFilter;
    BOOL isCheck;
    NSString * accessList;
}
-(void)changeTabBarIcon;
-(void)getMessageList;
-(void)changeNotificationTabBarIcon;
-(void)changeTreeTabBarIcon; 
@end
