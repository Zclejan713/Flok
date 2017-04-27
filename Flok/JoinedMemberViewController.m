//
//  JoinedMemberViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 21/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "JoinedMemberViewController.h"
#import "JoinedMemberTableViewCell.h"
#import "OtherUserViewController.h"
#import "WebImageOperations.h"
#import "FeedbackViewController.h"

@interface JoinedMemberViewController ()

@end

@implementation JoinedMemberViewController
@synthesize FlokId,isAbleToReport,isOP,isExpired,Flokker;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"JoinedMemberViewController");
    lblFlokker.text=Flokker;
    
    [self getJoinedMember ];
    tblMain.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (isOP==YES) {
        if (isAbleToReport==YES) {
            isReport=YES;
        }else{
            isReport=NO;
        }
    }else{
        isReport=NO;
    }
}
-(IBAction)backAction:(id)sender{
    
   [self.navigationController popViewControllerAnimated:YES];
}
-(void)rateJoinedMember{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@&owner_id=%@",[rateUserDic valueForKey:@"user_id"],FlokId,userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/UserRating" serviceType:@"POST"];

}
-(void)removeMemberFromFlok{
    
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",[rateUserDic valueForKey:@"user_id"],FlokId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/removeuserflok" serviceType:@"POST"];
    
}
-(void)getJoinedMember{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,FlokId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/listJoinee" serviceType:@"POST"];
    
}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/updateSettings"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [Global showOnlyAlert:@"Success" :@"Data saved successfully" ];
        }
        
        
    }else if ([serviceName isEqualToString:@"flok/listJoinee"]){
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            arrList=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"flokJoinedList"]];
            [tblMain reloadData];
            
        }
        
        
    }else if ([serviceName isEqualToString:@"users/UserRating"]){
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
             [Global showOnlyAlert:@"Success" :@"You have successfully rated this user" ];
            [self getJoinedMember];
        }
        
        
    }else if ([serviceName isEqualToString:@"flok/removeuserflok"]){
        AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.isRemoveFromFlok=YES;
        if ([[data valueForKey:@"Ack"] intValue]==1) {
         //   [Global showOnlyAlert:@"Success" :@"You have successfully rated this user" ];
            [self getJoinedMember];
        }
        
        
    }
}



#pragma mark- Table datasource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrList count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"CellIdentifier";
    JoinedMemberTableViewCell *cell=(JoinedMemberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell=nil;
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"JoinedMemberTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
        NSDictionary *dic=[arrList objectAtIndex:indexPath.row];
    
        cell.lblName.text=[dic valueForKey:@"full_name"];
        cell.UserName.text=[dic valueForKey:@"username"];
        [cell.btnRate setTag:indexPath.row];
        [cell.btnRate addTarget:self action:@selector(rateToUserAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnLeave setTag:indexPath.row];
    [cell.btnLeave addTarget:self action:@selector(removeFromFlok:) forControlEvents:UIControlEventTouchUpInside];
    
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSString *userImg=[dic valueForKey:@"user_image"];
    
    if ([userImg length]==0) {
        cell.profileImg.image=[UIImage imageNamed:@"no-profile"];
    }else{
        [cell.indicator startAnimating];
        [self setImageWithurl:[dic valueForKey:@"user_image"] andImageView:cell.profileImg and:cell.indicator];
    }
    BOOL isRated=[[dic valueForKey:@"is_rated"] boolValue];
    
    if (isReport==YES) {
        if (isRated==NO) {
            cell.btnRate.hidden=NO;
        }else{
        cell.btnRate.hidden=YES;
        }
    }else{
        cell.btnRate.hidden=YES; //ritwik
     //   cell.btnLeave.hidden=YES;
    }
    if (isOP==YES) {
        
        cell.btnLeave.hidden=NO; //ritwik
    }else{
        cell.btnLeave.hidden=YES;
    }
    if (isExpired==YES) {
        cell.btnLeave.hidden=YES;
    }
    cell.btnRate.layer.cornerRadius=4;
    cell.btnRate.layer.borderWidth=0.5;
    cell.btnRate.layer.borderColor=[UIColor whiteColor].CGColor;
    
    cell.btnLeave.layer.cornerRadius=4;
    cell.btnLeave.layer.borderWidth=0.5;
    cell.btnLeave.layer.borderColor=[UIColor whiteColor].CGColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
    vc.OtherUserdic=[arrList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)rateToUserAction:(id)sender{
    UIButton *btn=(UIButton*)sender;
    rateUserDic=[arrList objectAtIndex:[btn tag]];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Clicking this means this user bailed on your planned flok. It will negatively affect their flokstar rating." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert setTag:1];
    [alert show];
}
-(void)removeFromFlok:(id)sender{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Are you sure you want to remove from your flok?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert setTag:2];
    [alert show];
    
    UIButton *btn=(UIButton*)sender;
    rateUserDic=[arrList objectAtIndex:[btn tag]];
   /* UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedbackViewController *vc=(FeedbackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    
    
    vc.userData=[arrList objectAtIndex:[btn tag]];
    [self.navigationController pushViewController:vc animated:YES];*/
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            [self rateJoinedMember];
            
        }
    }else if (alertView.tag==2){
        if (buttonIndex==1) {
            [self removeMemberFromFlok];
            
        } 
    }
    
    
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

@end
