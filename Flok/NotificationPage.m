//
//  NotificationPage.m
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "NotificationPage.h"
#import "NotificationTableViewCell.h"
#import "WebImageOperations.h"
#import "JoinFlokTableViewCell.h"
#import "OtherUserFlok.h"
#import "OtherUserViewController.h"
#import "NotificationCell.h"
#import "FlikDetailsForRequestBase.h"
#import "FollowRequestTableViewCell.h"
@interface NotificationPage ()

@end

@implementation NotificationPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
     NSLog(@"NotificationPage");
    vwNoProduct.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getNnotificationList];
    tblMsg.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tabBarController.delegate = self;

}


#pragma mark- call notification list api

-(void)getNnotificationList{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/listNofication" serviceType:@"POST"];
}


-(void)acceptRequest:(id)sender{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    NSString *strTime=[self getCurrentDate];
    UIButton *btn=(UIButton*)sender;
    NSDictionary *dict=[arrList objectAtIndex:[btn tag]];
    NSString *dataString=[NSString stringWithFormat:@"notification_id=%@&user_id=%@&flok_id=%@&date_time=%@",[dict valueForKey:@"id"],[dict valueForKey:@"accept_user_id"],[dict valueForKey:@"flok_id"],strTime];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/acceptJoinRequest" serviceType:@"POST"];
}

-(void)rejectRequest:(id)sender{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    UIButton *btn=(UIButton*)sender;
    NSDictionary *dict=[arrList objectAtIndex:[btn tag]];
   // NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *requestUserId=[dict valueForKey:@"user_id"];
    NSString *strTime=[self getCurrentDate];
    NSString *dataString=[NSString stringWithFormat:@"notification_id=%@&user_id=%@&flok_id=%@&date_time=%@",[dict valueForKey:@"id"],requestUserId,[dict valueForKey:@"flok_id"],strTime];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/rejectJoinRequest" serviceType:@"POST"];
}

-(void)acceptFollow:(id)sender{
    [SVProgressHUD showWithStatus:@"Please wait.."];
    NSString *strTime=[self getCurrentDate];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    UIButton *btn=(UIButton*)sender;
    NSDictionary *dict=[arrList objectAtIndex:[btn tag]];
    NSString *dataString=[NSString stringWithFormat:@"follow_id=%@&user_id=%@&date_time=%@",[dict valueForKey:@"user_id"],userId,strTime];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/acceptfollower" serviceType:@"POST"];
    
    
}

-(void)rejectFollow:(id)sender{
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
    UIButton *btn=(UIButton*)sender;
    NSDictionary *dict=[arrList objectAtIndex:[btn tag]];
    NSString *requestUserId=[dict valueForKey:@"user_id"];
    
    NSString *dataString=[NSString stringWithFormat:@"follow_id=%@&user_id=%@",[dict valueForKey:@"flok_id"],requestUserId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/rejectfollower" serviceType:@"POST"];
}
#pragma mark- Table datasource & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblMsg)
    {
        return arrList.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblMsg)
    {
        NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        NSString *isFriend=[dict valueForKey:@"type"];
        if ([isFriend isEqualToString:@"JOIN_REQUEST"]) {
//            return 104;
            
            return 168;
        }else if ([isFriend isEqualToString:@"FOLLOW"]) {
            //            return 104;
            
            return 88;
        }else if ([isFriend isEqualToString:@"ACCEPTED_JOIN_REQUEST"]) {
            //            return 104;
            
            return 130;
        }else if ([isFriend isEqualToString:@"REJECTED_JOIN_REQUEST"]) {
            //            return 104;
            
            return 130;
        }
        else{
            return 130;
        }
        //return 72;
        return 190;
        
    }
    return 0.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblMsg)
    {
        NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        NSString *isFriend=[dict valueForKey:@"type"];
        
        if ([isFriend isEqualToString:@"JOIN_REQUEST"]) {
           
            NSString *strIdentifier=@"tcell";
            JoinFlokTableViewCell *tCell=(JoinFlokTableViewCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"JoinFlokTableViewCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            tCell.lblName.text=[dict valueForKey:@"full_name"];
            tCell.lblNotification.text=[dict valueForKey:@"message"];
            
            CGFloat boldTextFontSize = 12.0f;
            NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
            NSRange range2 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"flok_title"]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range1];
            
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: range2];
            tCell.lblNotification.attributedText = attributedText;

           
            NSString *userImg=[dict valueForKey:@"user_image"];
            if ([userImg length]==0) {
                tCell.ProfileImage.image=[UIImage imageNamed:@"no-profile"];
            }
            else{
                
                [tCell.indicator startAnimating];
                [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:tCell.ProfileImage and:tCell.indicator];
            }
            tCell.FlokTiTtle.text=[dict valueForKey:@"flok_title"];
            tCell.FlokDescription.text=[dict valueForKey:@"flok_description"];
            tCell.datelabel.text=[self calculateTime:[dict valueForKey:@"date"]];

            
            tCell.btnAccept.tag=indexPath.row;
            tCell.btnReject.tag=indexPath.row;
           
            [tCell.btnAccept addTarget:self action:@selector(acceptRequest:)forControlEvents:UIControlEventTouchUpInside];
            [tCell.btnReject addTarget:self action:@selector(rejectRequest:)forControlEvents:UIControlEventTouchUpInside];
            
            [tCell.btnDetails addTarget:self action:@selector(showOtherProfile:)forControlEvents:UIControlEventTouchUpInside];
            tCell.btnDetails.tag=indexPath.row;
            tCell.selectionStyle=UITableViewCellSelectionStyleNone;
             return tCell;

        }else if ([isFriend isEqualToString:@"FOLLOW"]) {
            
            NSString *strIdentifier=@"tcell";
            NotificationCell *tCell=(NotificationCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            tCell.lblName.text=[dict valueForKey:@"full_name"];
            tCell.lblNotification.text=[dict valueForKey:@"message"];
            
            CGFloat boldTextFontSize = 12.0f;
            NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
            tCell.lblNotification.attributedText = attributedText;
           

            tCell.Profileimg.layer.cornerRadius = 5;
            tCell.Profileimg.layer.masksToBounds = YES;
            //tCell.tvdesc.textColor=[UIColor grayColor];
            NSString *userImg=[dict valueForKey:@"user_image"];
            if ([userImg length]==0) {
                tCell.Profileimg.image=[UIImage imageNamed:@"no-profile"];
            }
            else{
                
                [tCell.indicator startAnimating];
                [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:tCell.Profileimg and:tCell.indicator];
            }
            
            tCell.FlokTittlelbl.text=[dict valueForKey:@"flok_title"];
           // tCell.FlokDetailslbl.text=[dict valueForKey:@"flok_description"];
            tCell.datelabel.text=[self calculateTime:[dict valueForKey:@"date"]];
            
            tCell.btnDetails.tag=indexPath.row;
            [tCell.btnDetails addTarget:self action:@selector(showOtherProfile:)forControlEvents:UIControlEventTouchUpInside];
            
            
                tCell.imgIcon.image=[UIImage imageNamed:@"man-user"];
            
            tCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return tCell;

        }else if ([isFriend isEqualToString:@"ACCEPTED_JOIN_REQUEST"]) {
            NSString *strIdentifier=@"tcell";
            NotificationTableViewCell *tCell=(NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            tCell.lblName.text=[dict valueForKey:@"full_name"];
            tCell.lblNotification.text=[dict valueForKey:@"message"];
            
            CGFloat boldTextFontSize = 12.0f;
            NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
            NSRange range2 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"flok_title"]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range1];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range2];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: range2];
            tCell.lblNotification.attributedText = attributedText;
            
            
            tCell.Profileimg.layer.cornerRadius = 5;
            tCell.Profileimg.layer.masksToBounds = YES;
            //tCell.tvdesc.textColor=[UIColor grayColor];
            NSString *userImg=[dict valueForKey:@"user_image"];
            if ([userImg length]==0) {
                tCell.Profileimg.image=[UIImage imageNamed:@"no-profile"];
            }
            else{
                
                [tCell.indicator startAnimating];
                [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:tCell.Profileimg and:tCell.indicator];
            }
            
            tCell.FlokTittlelbl.text=[dict valueForKey:@"flok_title"];
            tCell.FlokDetailslbl.text=[dict valueForKey:@"flok_description"];
            tCell.datelabel.text=[self calculateTime:[dict valueForKey:@"date"]];
            
            tCell.btnDetails.tag=indexPath.row;
            [tCell.btnDetails addTarget:self action:@selector(showOtherProfile:)forControlEvents:UIControlEventTouchUpInside];
            
           // [tCell.btnDetail addTarget:self action:@selector(showDetail:)forControlEvents:UIControlEventTouchUpInside];
                
            tCell.imgIcon.image=[UIImage imageNamed:@"goose"];
            tCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return tCell;
 
        }else if ([isFriend isEqualToString:@"REJECTED_JOIN_REQUEST"]) {
            NSString *strIdentifier=@"tcell";
            NotificationTableViewCell *tCell=(NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            tCell.lblName.text=[dict valueForKey:@"full_name"];
            tCell.lblNotification.text=[dict valueForKey:@"message"];
            
            CGFloat boldTextFontSize = 12.0f;
            NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
            NSRange range2 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"flok_title"]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: range2];
            tCell.lblNotification.attributedText = attributedText;
            
    
            tCell.Profileimg.layer.cornerRadius = 5;
            tCell.Profileimg.layer.masksToBounds = YES;
            //tCell.tvdesc.textColor=[UIColor grayColor];
            NSString *userImg=[dict valueForKey:@"user_image"];
            if ([userImg length]==0) {
                tCell.Profileimg.image=[UIImage imageNamed:@"no-profile"];
            }
            else{
                
                [tCell.indicator startAnimating];
                [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:tCell.Profileimg and:tCell.indicator];
            }
            
            tCell.FlokTittlelbl.text=[dict valueForKey:@"flok_title"];
            tCell.FlokDetailslbl.text=[dict valueForKey:@"flok_description"];
            tCell.datelabel.text=[self calculateTime:[dict valueForKey:@"date"]];
            
            tCell.btnDetails.tag=indexPath.row;
            [tCell.btnDetails addTarget:self action:@selector(showOtherProfile:)forControlEvents:UIControlEventTouchUpInside];
        
            tCell.imgIcon.image=[UIImage imageNamed:@"goose"];
            tCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return tCell;
 
        
        }else if ([isFriend isEqualToString:@"FOLLOWREQUEST"]) {
            
            NSString *strIdentifier=@"tcell";
            FollowRequestTableViewCell *tCell=(FollowRequestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"FollowRequestTableViewCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            tCell.lblName.text=[dict valueForKey:@"message"];
            //tCell.lblNotification.text=[dict valueForKey:@"message"];
            
            CGFloat boldTextFontSize = 12.0f;
            NSRange range1 = [tCell.lblName.text rangeOfString:[dict valueForKey:@"full_name"]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblName.text];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
            tCell.lblName.attributedText = attributedText;
            
            
            tCell.Profileimg.layer.cornerRadius = 5;
            tCell.Profileimg.layer.masksToBounds = YES;
            //tCell.tvdesc.textColor=[UIColor grayColor];
            NSString *userImg=[dict valueForKey:@"user_image"];
            if ([userImg length]==0) {
                tCell.Profileimg.image=[UIImage imageNamed:@"no-profile"];
            }
            else{
                
                [tCell.indicator startAnimating];
                [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:tCell.Profileimg and:tCell.indicator];
            }
            
           // tCell.FlokTittlelbl.text=[dict valueForKey:@"flok_title"];
            // tCell.FlokDetailslbl.text=[dict valueForKey:@"flok_description"];
            tCell.lblTime.text=[self calculateTime:[dict valueForKey:@"date"]];
            
            tCell.btnDetails.tag=indexPath.row;
            tCell.btnAccept.tag=indexPath.row;
            tCell.btnReject.tag=indexPath.row;
            [tCell.btnAccept addTarget:self action:@selector(acceptFollow:)forControlEvents:UIControlEventTouchUpInside];
            
            [tCell.btnReject addTarget:self action:@selector(rejectFollow:)forControlEvents:UIControlEventTouchUpInside];
            
            tCell.imgIcon.image=[UIImage imageNamed:@"man-user"];
            
            tCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return tCell;
            
        }
        else{
            
            NSString *strIdentifier=@"tcell";
            NotificationTableViewCell *tCell=(NotificationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            tCell.lblName.text=[dict valueForKey:@"full_name"];
            tCell.lblNotification.text=[dict valueForKey:@"message"];
            
            CGFloat boldTextFontSize = 12.0f;
            NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
             NSRange range2 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"flok_title"]];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                    range:range1];
            
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
            [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: range2];
            tCell.lblNotification.attributedText = attributedText;
            
            
            
            tCell.Profileimg.layer.cornerRadius = 5;
            tCell.Profileimg.layer.masksToBounds = YES;
            //tCell.tvdesc.textColor=[UIColor grayColor];
            NSString *userImg=[dict valueForKey:@"user_image"];
            if ([userImg length]==0) {
                tCell.Profileimg.image=[UIImage imageNamed:@"no-profile"];
            }
            else{
                
                [tCell.indicator startAnimating];
                [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:tCell.Profileimg and:tCell.indicator];
            }
            
            tCell.FlokTittlelbl.text=[dict valueForKey:@"flok_title"];
            tCell.FlokDetailslbl.text=[dict valueForKey:@"flok_description"];
            tCell.datelabel.text=[self calculateTime:[dict valueForKey:@"date"]];
        
            tCell.btnDetails.tag=indexPath.row;
            [tCell.btnDetails addTarget:self action:@selector(showOtherProfile:)forControlEvents:UIControlEventTouchUpInside];
            
            if ([isFriend isEqualToString:@"COMMENT"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"close-envelope"];
            }
            else if ([isFriend isEqualToString:@"Like"]) {
                
                tCell.lblNotification.text=[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"message"],[dict valueForKey:@"flok_title"]];
                //tCell.lblNotification.text=[dict valueForKey:@"message"];
                
                CGFloat boldTextFontSize = 12.0f;
                NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
                NSRange range2 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"flok_title"]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
                [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: range2];
                tCell.lblNotification.attributedText = attributedText;
                
                tCell.imgIcon.image=[UIImage imageNamed:@"like"];
                
            }
            else if ([isFriend isEqualToString:@"Dislike"]) {
                tCell.lblNotification.text=[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"message"],[dict valueForKey:@"flok_title"]];
                //tCell.lblNotification.text=[dict valueForKey:@"message"];
                
                CGFloat boldTextFontSize = 12.0f;
                NSRange range1 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"full_name"]];
                NSRange range2 = [tCell.lblNotification.text rangeOfString:[dict valueForKey:@"flok_title"]];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:tCell.lblNotification.text];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                                        range:range1];
                
                [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
                [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: range2];
                tCell.lblNotification.attributedText = attributedText;
                
                tCell.imgIcon.image=[UIImage imageNamed:@"down-arrow-1"];
            }
            else if ([isFriend isEqualToString:@"INVITE"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"goose"];
                
            }else if ([isFriend isEqualToString:@"JOINED"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"man-user"];
                
            }else if ([isFriend isEqualToString:@"FOLLOW"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"man-user"];
                
            }else if ([isFriend isEqualToString:@"REFLOK"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"reflok-1"];
                
            }
            else if ([isFriend isEqualToString:@"ACCEPTED_JOIN_REQUEST"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"goose"];
            }
            else if ([isFriend isEqualToString:@"REJECTED_JOIN_REQUEST"]) {
                
                tCell.imgIcon.image=[UIImage imageNamed:@"goose"];
            }
            else{
                
                 tCell.imgIcon.image=[UIImage imageNamed:@"goose"];
            }
            
            tCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return tCell;
        }
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
    
    NSString *isFriend=[dict valueForKey:@"type"];
    if ([isFriend isEqualToString:@"INVITE"] || [isFriend isEqualToString:@"JOINED"] ) {
        
        NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
        vc.flokId=[dict valueForKey:@"flok_id"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([isFriend isEqualToString:@"FOLLOW"] || [isFriend isEqualToString:@"JOIN_REQUEST"]){
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        
        NSDictionary *dic=[arrList objectAtIndex:indexPath.row];
        vc.OtherUserdic=dic;
        // vc.OtherUserId=[dic valueForKey:@""];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([isFriend isEqualToString:@"FOLLOWREQUEST"]){
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        
        NSDictionary *dic=[arrList objectAtIndex:indexPath.row];
        vc.OtherUserdic=dic;
        // vc.OtherUserId=[dic valueForKey:@""];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([isFriend isEqualToString:@"REJECTED_JOIN_REQUEST"] ){
        
        OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
        vc.flokId=[dict valueForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];

        
     }else if ([isFriend isEqualToString:@"ACCEPTED_JOIN_REQUEST"] ){
         
         OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
         vc.flokId=[dict valueForKey:@"flok_id"];
         [self.navigationController pushViewController:vc animated:YES];
     }else if ([isFriend isEqualToString:@"FOLLOWREQUEST"] || [isFriend isEqualToString:@"COMMENT"]) {
         OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
         vc.flokId=[dict valueForKey:@"flok_id"];
         [self.navigationController pushViewController:vc animated:YES];
         
     }
    

       /* NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
        vc.flokId=[dict valueForKey:@"flok_id"];
        [self.navigationController pushViewController:vc animated:YES];*/
    //}
   /* ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    vc.strFriendId=[dict valueForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];*/
    
}

-(NSString*)calculateTime:(NSString*)time{
    
    if ([time isEqualToString:@"0000-00-00 00:00:00"]) {
        
        return @"";
    }
    
    NSString *gmtDateString =[NSString stringWithFormat:@"%@",time]; //@"29/10/2015 00:01";
    NSDateFormatter *df = [NSDateFormatter new];
    //[df setDateFormat:@"dd/MM/yyyy HH:mm"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //Create the date assuming the given string is in GMT
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [df dateFromString:gmtDateString];
    
    //Create a date string in the local timezone
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSString *localDateString = [df stringFromDate:date];
    
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date1 = [df dateFromString:localDateString];
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    
    //NSDate *now = [NSDate date];
    
    NSDate* sourceDate = [NSDate date];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* now = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond)
                                               fromDate:date1
                                                 toDate:now
                                                options:0];
    
    if (components.year > 0) {
        formatter.allowedUnits = NSCalendarUnitYear;
    } else if (components.month > 0) {
        formatter.allowedUnits = NSCalendarUnitMonth;
    } else if (components.weekOfMonth > 0) {
        formatter.allowedUnits = NSCalendarUnitWeekOfMonth;
    } else if (components.day > 0) {
        formatter.allowedUnits = NSCalendarUnitDay;
    } else if (components.hour > 0) {
        formatter.allowedUnits = NSCalendarUnitHour;
    } else if (components.minute > 0) {
        formatter.allowedUnits = NSCalendarUnitMinute;
    } else {
        formatter.allowedUnits = NSCalendarUnitSecond;
        // return @"0 minute";
    }
    
    NSString *formatString = NSLocalizedString(@"%@ ago", @"Used to say how much time has passed. e.g. '2 hr ago'");
    NSLog(@"===%@",[NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]]);
    NSLog(@"check time-%@",[NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]]);
    return [NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]];
    
}





#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    [SVProgressHUD dismiss];
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    [SVProgressHUD dismiss];
    
    if([serviceName isEqualToString:@"flok/listNofication"])
    {
         NSLog(@"data-------%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            arrList=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"flokNotiList"]];
            tblMsg.hidden=NO;
            vwNoProduct.hidden=YES;
            [tblMsg reloadData];
        }
        else{
            tblMsg.hidden=YES;
            vwNoProduct.hidden=NO;
            //[Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
            
        }
      
    }else if([serviceName isEqualToString:@"flok/acceptJoinRequest"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [self getNnotificationList];
        }
    }
    else if([serviceName isEqualToString:@"flok/rejectJoinRequest"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [self getNnotificationList];
        }
    }else if([serviceName isEqualToString:@"users/acceptfollower"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [self getNnotificationList];
        }
    }else if([serviceName isEqualToString:@"users/rejectfollower"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [self getNnotificationList];
        }
    }
}


#pragma mark Save image

-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview and:(UIActivityIndicatorView *)loder{
    
    [loder startAnimating];
    NSString* imageName=[url lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgview.image=[UIImage imageWithContentsOfFile:FilePath];
        [loder stopAnimating];
    }
    else
    {
        [WebImageOperations processImageDataWithURLString:url andBlock:^(NSData *imageData)
         {
             imgview.image=[UIImage imageWithData:imageData];
             [imageData writeToFile:FilePath atomically:YES];
             [loder stopAnimating];
         }];
    }
    
}


-(IBAction)showOtherProfile:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    // NSDictionary *dic=[arrMain objectAtIndex:[btn tag]];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
    
   // NSDictionary *dic=[arrList objectAtIndex:[btn tag]];
    vc.OtherUserdic=[arrList objectAtIndex:[btn tag]];
    // vc.OtherUserId=[dic valueForKey:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)changeTabBarIcon{
    
    
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"notification-grey-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"notification-orange-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
}
-(void)changeTabBarIconNormal{
    
   
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"notification-grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"notification-orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
}

-(IBAction)updateScreen:(id)sender{
    
    [tblMsg scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self changeTabBarIconNormal];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[NotificationPage class]])
    {
        
        [self updateScreen:self];
    }
    
    
    // [self changeTabBarIconNormal];
    
    NSLog(@"tab bar selected ");
}

-(void)changeMessageTabBarIconNormal{
    
    UIStoryboard *storyboard;
    UIViewController *myVC;
    storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    myVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
   
    UITabBar *tabBar=self.tabBarController.tabBar;
    // UITabBar *tabBar=tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:2];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"message-grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"message-orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
}

-(void)changeTreeTabBarIcon{
    
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"tree-grey-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"tree-orange-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
}
-(void)changeTabMessageBarIcon{
    
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:2];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"message-grey-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"message-orange-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
}

-(NSString *)getCurrentDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    return timeStamp;
}
@end
