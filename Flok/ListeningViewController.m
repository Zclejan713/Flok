//
//  ListeningViewController.m
//  EchoEction
//
//  Created by NITS_Mac3 on 21/12/15.
//  Copyright © 2015 NITS. All rights reserved.
//

#import "ListeningViewController.h"
#import "ListeningTableViewCell.h"
#import "WebImageOperations.h"
#import "RegistraionPage1.h"
#import "OtherUserViewController.h"
@interface ListeningViewController ()

@end

@implementation ListeningViewController
@synthesize isListening,isOtherUser,userId;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ListeningViewController");
    
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    vwListeners.hidden=YES;
    vwListening.hidden=YES;
    tblListeners.hidden=YES;
    tblListening.hidden=YES;
    NSLog(@"isOtherUser---%@",isOtherUser);
    
  
}
-(void)viewWillAppear:(BOOL)animated{
    
    if ([isListening isEqualToString:@"Yes"]) {
        [self listeningAction:self];
        //  [self getListening];
        isListeners=NO;
    }else{
        [self listenersAction:self];
        //[self getListening];;
        isListeners=YES;
    }
    
    NSString *my_Id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if ([my_Id isEqualToString:userId]) {
        isOtherUser=@"No";
    }else{
        isOtherUser=@"yes";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getListening{
    
    NSString *my_Id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString = [NSString stringWithFormat:@"user_id=%@&my_id=%@",userId,my_Id];
    [[Global sharedInstance] setDelegate:nil];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/myFollowing" serviceType:@"POST"];
    
}
-(void)getListeners{
    
    NSString *my_Id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString = [NSString stringWithFormat:@"user_id=%@&my_id=%@",userId,my_Id];
     [[Global sharedInstance] setDelegate:nil];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/myFollower" serviceType:@"POST"];

}

-(IBAction)removeAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    removeDic=[arrListeners objectAtIndex:btn.tag];
    indexpath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Are you sure you want to remove this follower?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag=4;
    
    [alert show];
    
}
-(IBAction)UnfollowAction:(id)sender{
   
    UIButton *btn=(UIButton*)sender;
    removeDic=[arrListening objectAtIndex:btn.tag];
    indexpath = [NSIndexPath indexPathForRow:btn.tag inSection:0];

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Are you sure you want to unfollow this user?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag=4;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag==4){
        
        if (buttonIndex==1) {
              [self  unfollowAction];
            if (isListeners==YES) {
                /*[tblListeners beginUpdates];
                [arrListeners removeObjectAtIndex:indexpath.row];
                [tblListeners deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tblListeners endUpdates];
                [tblListeners reloadData];
                [self performSelector:@selector(reFreshTblListeners)
                           withObject:nil
                           afterDelay:1.0];*/

            }
        }
    }else if(alertView.tag==5){
        [self  unfollowAction];
        [tblListening beginUpdates];
        [arrListening removeObjectAtIndex:indexpath.row];
        [tblListening deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tblListening endUpdates];
        [self performSelector:@selector(reFreshTblListening)
                   withObject:nil
                   afterDelay:1.0];
    }
    
    
}
-(void)unfollowAction{
    
   // NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[removeDic valueForKey:@"id"]];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/unfollow" serviceType:@"POST"];
    NSLog(@"dataString------%@",dataString);
    NSLog(@"Remove user name--%@",[removeDic valueForKey:@"full_name"]);
}
-(void)reFreshTblListeners{
     [tblListeners reloadData];
}
-(void)reFreshTblListening{
    [tblListening reloadData];
}
-(IBAction)unfriendAction:(UIButton *)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
   
    ListeningTableViewCell *cell=(ListeningTableViewCell *)superView1;
    
    NSData *data1 = UIImagePNGRepresentation(cell.btnUnfriend.currentBackgroundImage);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"add_friend.png"]);
    NSString *my_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    if ([data1 isEqual:data2])
    {
        NSDictionary *dic;
        if ([isListening isEqualToString:@"Yes"]){
            
            dic=[arrListening objectAtIndex:[sender tag]];
        }else{
            dic=[arrListeners objectAtIndex:[sender tag]];
        }
        [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        NSString *strTime=[self getCurrentDate];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",my_id,[dic valueForKey:@"id"],strTime];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }else{
        NSDictionary *dic=[arrListening objectAtIndex:[sender tag]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        cell.vwUnfriend.frame = CGRectMake(0, cell.vwUnfriend.frame.origin.y ,cell.vwUnfriend.frame.size.width,cell.vwUnfriend.frame.size.height);
        if (isListeners==YES) {
            cell.lblAlert.text=[NSString stringWithFormat:@"Are you sure you want to stop %@ From following to you ?",[dic valueForKey:@"full_name"]];
            
        }else{
            cell.lblAlert.text=[NSString stringWithFormat:@"Are you sure you want to stop following to %@ ?",[dic valueForKey:@"full_name"]];
        }
        [UIView commitAnimations];
        
    }
    
}
-(IBAction)CancelUnfriendAction:(UIButton *)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    ListeningTableViewCell *cell=(ListeningTableViewCell *)superView1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    cell.vwUnfriend.frame = CGRectMake(cell.vwUnfriend.frame.origin.x+self.view.frame.size.width, cell.vwUnfriend.frame.origin.y ,cell.vwUnfriend.frame.size.width,cell.vwUnfriend.frame.size.height);
    [UIView commitAnimations];
}
-(IBAction)ConfirmUnfriendAction:(UIButton *)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    ListeningTableViewCell *cell=(ListeningTableViewCell *)superView1;
    NSDictionary *dict;
    if ([isListening isEqualToString:@"Yes"]){
        
        dict=[arrListening objectAtIndex:[sender tag]];
    }else{
        dict=[arrListeners objectAtIndex:[sender tag]];
    }
    [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    cell.vwUnfriend.frame = CGRectMake(self.view.frame.size.width, cell.vwUnfriend.frame.origin.y ,cell.vwUnfriend.frame.size.width,cell.vwUnfriend.frame.size.height);
    [UIView commitAnimations];
   NSString *my_id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",my_id,[dict valueForKey:@"id"]];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/unfollow" serviceType:@"POST"];
}
/*-(IBAction)followAction:(UIButton*)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    ListeningTableViewCell *cell=(ListeningTableViewCell *)superView1;
    NSIndexPath *indexPath;
    NSMutableDictionary *oldDic;
    if ([isListening isEqualToString:@"Yes"]) {
        indexPath =[tblListening indexPathForCell:cell];
        oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrListening objectAtIndex:indexPath.row]];
    }else{
        indexPath =[tblListeners indexPathForCell:cell];
        oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrListeners objectAtIndex:indexPath.row]];
    }
    
       [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
    
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[Dic valueForKey:@"id"]];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }
}*/

-(IBAction)listeningAction:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    isListeners=NO;
    isListening=@"Yes";
    [self getListening];
     [btnListeners setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1]];
    //[btnListeners setBackgroundColor:[UIColor colorWithRed:12.0/255.0 green:78.0/255.0 blue:99.0/255.0 alpha:1]];
    [btnListeners setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnListening setBackgroundColor:[UIColor whiteColor]];
    [btnListening setTintColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1]];
    
    
}
-(IBAction)listenersAction:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    isListeners=YES;
    isListening=@"no";
    [self getListeners];
    [btnListening setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1]];
    [btnListening setTintColor:[UIColor whiteColor]];
    [btnListeners setBackgroundColor:[UIColor whiteColor] ];
    [btnListeners setTitleColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1] forState:UIControlStateNormal];

}
-(IBAction)findPeople:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"FindFriendsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Table datasource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        
        return [arrListening count];
    }else{
        return [arrListeners count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"CellIdentifier";
    ListeningTableViewCell *cell=(ListeningTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   // cell=nil;
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ListeningTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    if (tableView.tag==1) {
        NSDictionary *dic=[arrListening objectAtIndex:indexPath.row];
        NSString *followedByMe=[NSString stringWithFormat:@"%@",[dic valueForKey:@"isFollowedByMe"]];
        cell.lblName.text=[dic valueForKey:@"full_name"];
        cell.lblEmail.text=[dic valueForKey:@"username"];
        [cell.btnUnfriend setTag:indexPath.row];
        [cell.btnConfirm setTag:indexPath.row];
        [cell.btnCancel setTag:indexPath.row];
        [cell.btnUnfollow setTag:indexPath.row];
        [cell.btnUnfriend addTarget:self action:@selector(unfriendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //if (![isOtherUser isEqualToString:@"yes"]) {
            
           
            [cell.btnConfirm addTarget:self action:@selector(ConfirmUnfriendAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnCancel addTarget:self action:@selector(CancelUnfriendAction:) forControlEvents:UIControlEventTouchUpInside];
            
         //}
        
        if ([followedByMe isEqualToString:@"0"]) {
            [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
        }else{
          [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        }
        NSString *my_Id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        if ([[dic valueForKey:@"id"] isEqualToString:my_Id]) {
            cell.btnUnfriend.hidden=YES;
        }else{
            cell.btnUnfriend.hidden=NO;
        }
        /*[cell.btnUnfriend addTarget:self action:@selector(UnfollowAction:) forControlEvents:UIControlEventTouchUpInside];*/
        
        NSString *imgUrl=[dic valueForKey:@"user_image"];
        
        if ([imgUrl length]==0) {
            cell.img.image=[UIImage imageNamed:@""];
        }else{
            [cell.indicator startAnimating];
            [self setImageWithurl:imgUrl andImageView:cell.img and:cell.indicator];
        }
        cell.img.layer.cornerRadius =5;
        cell.img.layer.masksToBounds = YES;
        cell.btnCancel.layer.cornerRadius =10;
        cell.btnCancel.layer.masksToBounds = YES;
        cell.btnConfirm.layer.cornerRadius =10;
        cell.btnConfirm.layer.masksToBounds = YES;
        CGRect frame=cell.vwUnfriend.frame;
        frame.origin.x=self.view.frame.size.width;
        cell.vwUnfriend.frame=frame;
        cell.btnUnfollow.layer.cornerRadius =5;
        cell.btnUnfollow.layer.masksToBounds = YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.btnRemove.hidden=YES;
         //cell.btnUnfriend.hidden=NO;
        if ([isOtherUser isEqualToString:@"yes"]) {
            cell.btnUnfollow.hidden=YES;
            cell.btnRemove.hidden=YES;
            
        }
    }else{
        NSDictionary *dic=[arrListeners objectAtIndex:indexPath.row];
        NSString *followedByMe=[NSString stringWithFormat:@"%@",[dic valueForKey:@"isFollowedByMe"]];
        cell.lblName.text=[dic valueForKey:@"full_name"];
        cell.lblEmail.text=[dic valueForKey:@"username"];
       
        
        if ([followedByMe isEqualToString:@"0"]) {
            [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
        }else{
            [cell.btnUnfriend setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        }
         //[cell.btnConfirm setBackgroundImage:[UIImage imageNamed:@"tick_hover"] forState:UIControlStateHighlighted];
        
        [cell.btnUnfriend setTag:indexPath.row];
        [cell.btnConfirm setTag:indexPath.row];
        [cell.btnCancel setTag:indexPath.row];
        [cell.btnRemove setTag:indexPath.row];
        cell.btnRemove.hidden=YES;
       // cell.btnUnfriend.hidden=YES;
        //if (![isOtherUser isEqualToString:@"yes"]) {
            
            [cell.btnUnfriend addTarget:self action:@selector(unfriendAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnConfirm addTarget:self action:@selector(ConfirmUnfriendAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnCancel addTarget:self action:@selector(CancelUnfriendAction:) forControlEvents:UIControlEventTouchUpInside];
            
           
       // }
        
        //unfriendAction
        NSString *imgUrl=[dic valueForKey:@"user_image"];
        
        if ([imgUrl length]==0) {
            cell.img.image=[UIImage imageNamed:@""];
        }else{
            [cell.indicator startAnimating];
            [self setImageWithurl:imgUrl andImageView:cell.img and:cell.indicator];
        }
        [cell.btnRemove addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.img.layer.cornerRadius =5;
        cell.img.layer.masksToBounds = YES;
        cell.btnCancel.layer.cornerRadius =10;
        cell.btnCancel.layer.masksToBounds = YES;
        cell.btnConfirm.layer.cornerRadius =10;
        cell.btnConfirm.layer.masksToBounds = YES;
        cell.btnRemove.layer.cornerRadius =5;
        cell.btnRemove.layer.masksToBounds = YES;
        CGRect frame=cell.vwUnfriend.frame;
        frame.origin.x=self.view.frame.size.width;
        cell.vwUnfriend.frame=frame;
        cell.btnRemove.hidden=NO;
        cell.btnUnfollow.hidden=YES;
        
        if ([isOtherUser isEqualToString:@"yes"]) {
            cell.btnUnfollow.hidden=YES;
            cell.btnRemove.hidden=YES;
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic;
    if (tableView.tag==1) {
        
            dic=[arrListening objectAtIndex:indexPath.row];
        }else
        {
            dic=[arrListeners objectAtIndex:indexPath.row];
            
        }
        
    //NSString *status=[NSString stringWithFormat:@"%@",[dic valueForKey:@"friendStatus"]];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
    
   
    vc.OtherUserdic=dic;
    // vc.OtherUserId=[dic valueForKey:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
    
        
}
-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview and:(UIActivityIndicatorView *)loder{
    
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
-(IBAction)btnAction:(id)sender{
    
    // cell.lblFriend.hidden=YES;
}
-(void) showOnlyAlert:(NSString*)title :(NSString*)message :(UIViewController*)vc
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    [vc presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/myFollowing"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
           
            arrListening=[data valueForKey:@"followingList"];
            [tblListening reloadData];
            
            tblListening.hidden=NO;
            tblListeners.hidden=YES;
        }else{
            tblListening.hidden=YES;
            tblListeners.hidden=YES;
            vwListening.hidden=NO;
            vwListeners.hidden=YES;
        }
        
        
    }else if([serviceName isEqualToString:@"users/myFollower"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            arrListeners=[data valueForKey:@"followerList"];
            [tblListeners reloadData];
            tblListening.hidden=YES;
            tblListeners.hidden=NO;
            
            
           
            
        }else{
            tblListening.hidden=YES;
            tblListeners.hidden=YES;
            vwListeners.hidden=NO;
            vwListening.hidden=YES;
        }
        
        
    }
}

-(BOOL)checkFollowingUser:(NSString*)user_Id{
    
    for (int i=0; i<arrListening.count; i++) {
        NSDictionary *dict=[arrListening objectAtIndex:i];
        if ([[dict objectForKey:@"user_id"] isEqualToString:user_Id]) {
            return YES;
        }
    }
    return NO;
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
