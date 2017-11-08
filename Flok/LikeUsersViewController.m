//
//  LikeUsersViewController.m
//  Tchin
//
//  Created by NITS_Mac3 on 11/08/17.
//  Copyright © 2017 NITS_Mac3. All rights reserved.
//

#import "LikeUsersViewController.h"
#import "UserListTableViewCell.h"
#import "OtherUserViewController.h"
#import "MePage.h"
#import "Global.h"
@interface LikeUsersViewController ()
{
    NSMutableArray *arrUser;
}
@end

@implementation LikeUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _tblMain.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllLikeUser];
}
-(IBAction)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getAllLikeUser{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@",[_dictPost valueForKey:@"id"],userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/likeUserlist" serviceType:@"POST"];
    
}

#pragma mark UITableView-delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrUser.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"tcell";
    UserListTableViewCell *cell=(UserListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell=nil;
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
    }
    NSDictionary *dict=[arrUser objectAtIndex:indexPath.row];
    cell.lblName.text=[NSString stringWithFormat:@"%@ likes this post",[dict valueForKey:@"full_name"]];
    
    BOOL isFollow=[[dict valueForKey:@"is_friend"] boolValue];
    if (isFollow) {
        //cell.btnFollow.hidden=YES;
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
    }else{
        // cell.btnFollow.hidden=NO;
        [cell.btnFollow addTarget:self action:@selector(followAction:)forControlEvents:UIControlEventTouchUpInside];
        [cell.btnFollow setTag:indexPath.row];
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
    }

    
    [cell.btnProfile setTag:indexPath.row];
    [cell.btnProfile addTarget:self action:@selector(showOtherProfile:)forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell.lblName setTextColor:[UIColor grayColor]];
    NSString *fullname=[NSString stringWithFormat:@"%@ ",[dict valueForKey:@"full_name"]];
    CGFloat boldTextFontSize = 14.0f;
                        
    NSRange range1 = [cell.lblName.text rangeOfString:fullname];
    //NSRange range2 = [cell.lblName.text rangeOfString:[dict valueForKey:@"message"]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:cell.lblName.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                            range:range1];
    
    [attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range1];
    //[attributedText addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: range2];
    cell.lblName.attributedText = attributedText;
    
    cell.lblContact.text=[dict valueForKey:@"username"];
    
    NSString *imgurl=[dict valueForKey:@"user_image"];//lastPathComponent
    NSString *temp=[imgurl lastPathComponent];
    if ([temp isEqualToString:@"no.png"]) {
        
        cell.imgProfile.image=[UIImage imageNamed:@"no_profileimage"];
    }else if ([imgurl length]==0){
        cell.imgProfile.image=[UIImage imageNamed:@"no_profileimage"];
    }else{
        [Global setImage:[dict valueForKey:@"user_image"] imageHolder:cell.imgProfile];
    }
    
    cell.btnAdd.tag=indexPath.row;
    cell.btnAdd.hidden=YES;
    
    cell.imgProfile.layer.cornerRadius=cell.imgProfile.frame.size.width/2;
    cell.imgProfile.layer.masksToBounds=YES;
    cell.btnAdd.layer.cornerRadius=5.0f;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)showOtherProfile:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    
    NSDictionary *dic=[arrUser objectAtIndex:[btn tag]];
    NSString *userId100=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if([[dic objectForKey:@"user_id"] isEqualToString:userId100]){
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // self.tabBarController.tabBar.hidden = NO;
        MePage *vc=(MePage*)[storyboard instantiateViewControllerWithIdentifier:@"MePage"];
        vc.frompage=@"1";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    else{
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.OtherUserdic=[arrUser objectAtIndex:[btn tag]];
        // vc.OtherUserId=[dic valueForKey:@""];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(IBAction)followAction:(UIButton*)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    UserListTableViewCell *cell=(UserListTableViewCell*)superView1;
    
    
    NSIndexPath *indexPath= [_tblMain indexPathForCell:cell];
    
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrUser objectAtIndex:indexPath.row]];
    
    
    int status=[[oldDic valueForKey:@"is_friend"] intValue];
    if (status==0) {
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"is_friend"];
        [arrUser replaceObjectAtIndex:indexPath.row withObject:dic];
        
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithDictionary:[arrUser objectAtIndex:indexPath.row]];
        
        NSString *strTime=[self getCurrentDate];
        NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,[Dic valueForKey:@"user_id"],strTime];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}

-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if ([serviceName isEqualToString:@"flok/likeUserlist"]){
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            arrUser=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"flokLikeList"]];
            [_tblMain reloadData];

        }
    }
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
