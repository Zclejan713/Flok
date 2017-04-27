//
//  ChatViewController.h
//  RishtaBliss
//
//  Created by NITS_Mac3 on 05/07/16.
//  Copyright © 2016 Suman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ChatViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UITableView *tblChat;
    IBOutlet UIImageView *imgProduct;
    IBOutlet UILabel *lblTitle;
    IBOutlet UITextView *tvChat;
    IBOutlet UIView *vwChat;
    IBOutlet UIView *vwChatHeader;
    IBOutlet UIButton *btnDone;
    NSMutableArray *arrChat;
    NSIndexPath *selectdIndexPath;
    
    AppDelegate *app;
    NSString *strSessName,*strSessVal;
    NSTimer *timerForChat;
    
    NSString *strToId;
    NSString *strFromId;
    
    NSString *fromimage;
    NSString *toimage;
    NSString *userId;
    UIImageView *uploadImg;
    BOOL iskeyboardDidShow;
    CGRect keyboardFrame;
    int count;
    NSString *last_id;
    
}
@property(strong,nonatomic)NSString *strFriendId;
@property(strong,nonatomic)NSDictionary *productDic;
@property(strong,nonatomic)NSDictionary *dataDic;
@property(strong,nonatomic)NSString *strProductUrl;
@property(strong,nonatomic)NSString *strProductName;
@property(assign)BOOL isBlock;
-(IBAction)btnBackPressed:(id)sender;
-(IBAction)btnSendPressed:(id)sender;
-(void)reloadChatPage:(NSDictionary*)chatDic;
@end
