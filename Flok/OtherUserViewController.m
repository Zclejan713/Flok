//
//  OtherUserViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 05/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "OtherUserViewController.h"
#import "WebImageOperations.h"
#import "ListeningViewController.h"
#import "TreeCell.h"
#import "ChatViewController.h"
#import "FeedbackViewController.h"
#import "InappropriateReport.h"
#import "OtherUserFlok.h"
#import "FlikDetailsForRequestBase.h"
#import "HashTagFeed.h"
@interface OtherUserViewController ()

@end

@implementation OtherUserViewController
@synthesize OtherUserId,OtherUserdic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"OtherUserViewController");
    scrlProfileImg.hidden=YES;
    vwTransparent.hidden=YES;
    self.view.backgroundColor=[UIColor clearColor];
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    prefs=[NSUserDefaults standardUserDefaults];
    
    // scrlMain.contentSize=CGSizeMake(scrlMain.frame.size.width, vwMain.frame.size.height);
    vwMain.autoresizingMask =(UIViewAutoresizingFlexibleLeftMargin   |
                              UIViewAutoresizingFlexibleRightMargin  |
                              UIViewAutoresizingFlexibleTopMargin    |
                              UIViewAutoresizingFlexibleBottomMargin);
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Floks", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(10, 5, vwMain.frame.size.width-20, 30);
    segmentedControl.tintColor=[UIColor colorWithRed:249.0/255.0 green:91.0/255.0 blue:21.0/255.0 alpha:1];
    [segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    lblProfileImgCount.hidden=YES;
     btnShowMore.hidden=YES;
    
    lblProfileImgCount.textColor=[UIColor whiteColor];
    [lblProfileImgCount setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:91.0/255.0 blue:21.0/255.0 alpha:1]];
    lblProfileImgCount.layer.cornerRadius=lblProfileImgCount.frame.size.width/2;
    lblProfileImgCount.clipsToBounds=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    vwTemp.hidden=NO;
    //[self scrollImage:arrimg];
    [self getProfileInfo];
    [self getFlokInfo];
    

}
-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    latitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
}
#pragma mark- call Flok list api
-(void)getFlokList{
    
    CLLocationCoordinate2D coordinate=[self getLocation];
    latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *strTime=[self getLocateDate];
    
    NSString *str;
    str=[OtherUserdic valueForKey:@"user_id"];
    if ([str length]==0) {
       str=[OtherUserdic valueForKey:@"id"];
    }
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&current_time=%@&lat=%@&lang=%@",str,strTime,latitude,longitude];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/myfloklist" serviceType:@"POST"];
}
-(void)getSharedFlokList{
   // NSString *strTime=[self getCurrentDate];
    CLLocationCoordinate2D coordinate=[self getLocation];
    latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *str;
    str=[OtherUserdic valueForKey:@"user_id"];
    if ([str length]==0) {
        str=[OtherUserdic valueForKey:@"id"];
    }
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&lat=%@&lang=%@",str,latitude,longitude];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/mySharedPost" serviceType:@"POST"];
}

#pragma mark- Method


-(IBAction)showFollowerAction:(id)sender{
    
    ListeningViewController *vc=(ListeningViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ListeningViewController"];
    vc.isListening=@"No";
    NSString *str;
    str=[OtherUserdic valueForKey:@"user_id"];
    if ([str length]==0) {
        str=[OtherUserdic valueForKey:@"id"];
    }
    vc.userId=str;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)showFollowingAction:(id)sender{
    
    ListeningViewController *vc=(ListeningViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ListeningViewController"];
    vc.isListening=@"Yes";
    NSString *str;
    str=[OtherUserdic valueForKey:@"user_id"];
    if ([str length]==0) {
        str=[OtherUserdic valueForKey:@"id"];
    }
    vc.userId=str;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(IBAction)chatAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
        vc.dataDic=OtherUserdic;
        vc.strFriendId=[OtherUserdic valueForKey:@"user_id"];
        [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)rateToUserAction:(id)sender{
    
   // UIButton *btn=(UIButton*)sender;
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedbackViewController *vc=(FeedbackViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    
    // NSDictionary *dic=[arrList objectAtIndex:[btn tag]];
    vc.userData=OtherUserdic;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIViewController *)TopviewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    NSArray *arrVc=self.navigationController.viewControllers;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        if ([[arrVc objectAtIndex:numberOfViewControllers - 2] isKindOfClass:[UITabBarController class]])
        {
            UITabBarController *tabVc=[arrVc objectAtIndex:numberOfViewControllers - 2];
            return tabVc.selectedViewController;
        }
        else{
            return [arrVc objectAtIndex:numberOfViewControllers - 2];
        }
    return nil;
}

#pragma mark- Hcs Rating
-(void)setvwRating:(float)rateval vw:(HCSStarRatingView*)myview
{
    myview.maximumValue = 5;
    myview.minimumValue = 0;
    myview.value=rateval;
    myview.allowsHalfStars = YES;
    myview.accurateHalfStars = YES;
    
    myview.tintColor=appGreen;
    myview.backgroundColor=[UIColor clearColor];
    myview.userInteractionEnabled=NO;
    //[myview addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)didChangeValue:(HCSStarRatingView*)myvw
{
    NSLog(@"%0.2f",myvw.value);
    
    if (myvw == vwStar)
    {
        if (myvw.value >= 5) {
            
        }
        else if (myvw.value >= 3 && myvw.value < 5){
            
        }
        else{
            
        }
    }
}
-(void)profileScrollImage:(NSMutableArray*)myarr
{
    
    NSLog(@"profileScrollImage-----");
    [scrlMain.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int imgx=0;
    int imgy=0;
    int imgW=self.view.frame.size.width;
    int imgH=scrlMain.frame.size.height;
    NSInteger count = myarr.count;
    
    totalImg=count;
    if (count>1) {
        lblProfileImgCount.hidden=NO;
        lblProfileImgCount.text=[NSString stringWithFormat:@"1/%ld",(long)count];
    }
    if (count>0) {
        
        for (int i=0; i<myarr.count; i++) {
            NSDictionary *dict=[myarr objectAtIndex:i];
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(imgx,imgy,imgW,imgH)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            NSString *imgstr=[dict valueForKey:@"image"];
            if ([imgstr length]==0) {
                imageView.image=[UIImage imageNamed:@"no-profile"];
            }else{
                NSString* imageName=[imgstr lastPathComponent];
                if ([imageName isEqualToString:@"no.png"]) {
                    imageView.image=[UIImage imageNamed:@"no-profile"];
                    
                }else{
                    [self setImageWithurl:imgstr andImageView:imageView and:nil];
                }
            }
            UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
            
            [scrlMain addGestureRecognizer:letterTapRecognizer];
            [scrlMain  setBackgroundColor:[UIColor blackColor]];
            [scrlMain addSubview:imageView];
            imgx=imgx+imgW;
            
        }
    }
    
    else{
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(imgx,imgy,imgW,imgH)];
        imageView.image=[UIImage imageNamed:@"no-profile"];
        [scrlMain addSubview:imageView];
    }
    
    scrlMain.contentSize=CGSizeMake(SCREEN_WIDTH*myarr.count, scrlMain.frame.size.height);
    scrlMain.pagingEnabled=YES;
    
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    
    scrlProfileImg.hidden=NO;
    vwTransparent.hidden=NO;
}
-(IBAction)cancelProfileImage:(id)sender{
    scrlProfileImg.hidden=YES;
    vwTransparent.hidden=YES;
}
-(void)profileBGScrollImage:(NSMutableArray*)myarr
{
    
    NSLog(@"profileScrollImage-----");
    [scrlProfileImg.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int imgx=0;
    int imgy=0;
    int imgW=self.view.frame.size.width;
    int imgH=scrlProfileImg.frame.size.height;
    NSInteger count = myarr.count;
    
   
    if (count>0) {
        
        for (int i=0; i<myarr.count; i++) {
            NSDictionary *dict=[myarr objectAtIndex:i];
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(imgx,imgy,imgW,imgH)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            NSString *imgstr=[dict valueForKey:@"image"];
            if ([imgstr length]==0) {
                imageView.image=[UIImage imageNamed:@"no-profile"];
            }else{
                NSString* imageName=[imgstr lastPathComponent];
                if ([imageName isEqualToString:@"no.png"]) {
                    imageView.image=[UIImage imageNamed:@"no-profile"];
                    
                }else{
                    [self setImageWithurl:imgstr andImageView:imageView and:nil];
                }
            }
            [scrlProfileImg  setBackgroundColor:[UIColor blackColor]];
            [scrlProfileImg addSubview:imageView];
            imgx=imgx+imgW;
            
        }
    }
    
    else{
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(imgx,imgy,imgW,imgH)];
        imageView.image=[UIImage imageNamed:@"no-profile"];
        [scrlProfileImg addSubview:imageView];
    }
    
    scrlProfileImg.contentSize=CGSizeMake(SCREEN_WIDTH*myarr.count, scrlMain.frame.size.height);
    scrlProfileImg.pagingEnabled=YES;
    
}

#pragma mark UITableView-delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
    {
        return 1;
    }
    else{
       
        return [arrShared count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 548;//[arrFlok count];
    }
    else{
        return 132;//[arrUser count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }else{
        return 45;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 44, tableView.frame.size.width, 1)];
    [view setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:91.0/255.0 blue:21.0/255.0 alpha:1]];
    [separator setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:236.0/255.0 alpha:1]];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,tableView.frame.size.width , 45)];
    fromLabel.text = @"Floks";
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor whiteColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    [fromLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
   
    
    [view addSubview:separator];
    //[view addSubview:segmentedControl];
    [view addSubview:fromLabel];
    /* Create custom view to display section header... */
    
    //NSString *string =[list objectAtIndex:section];
    /* Section header is in 0th index... */
    //[label setText:string];
    //[view addSubview:label];
    // [view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]]; //your background color...
    return view;
    
}
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 if(section == 0)
 return @"Section 1";
 else
 return @"Section 2";
 }*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section==0) {
        
        static NSString *cellIdentifier=@"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell.contentView addSubview:vwMain];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else {
        
        static NSString *cellIdentifier=@"tcell";
        TreeCell *tCell=(TreeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        tCell=nil;
        if (tCell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TreeCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
            
        }
        
        /* static NSString *strIdentifier=@"tcell";
         TreeCell *tCell=(TreeCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
         NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TreeCell" owner:self options:nil];
         tCell=[nib objectAtIndex:0];*/
        NSDictionary *dict=[arrShared objectAtIndex:indexPath.row];
        tCell.lblFlokName.editable =NO;
        tCell.lblFlokName.text=[dict valueForKey:@"title"];
        [self colorWord:tCell.lblFlokName];
        
       
        
        tCell.lblTime.text=[self calculateTime:[dict valueForKey:@"date"]];
        NSString *fullName=[dict valueForKey:@"uploaded_by"];
        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[fullName componentsSeparatedByString:@" "]];
        NSString *Name=[array objectAtIndex:0];
        NSString *strTemp=[NSString stringWithFormat:@"%@ @%@",Name,[dict valueForKey:@"username"]];
        tCell.lblName.attributedText=[self setTextAttribute:strTemp Name:Name and:dict];
        tCell.lblDistance.text=[NSString stringWithFormat:@"%.01f miles",[[dict valueForKey:@"distance"] floatValue]];
       // tCell.lblTime.text=[dict valueForKey:@""];
        tCell.lblLikeCount.text=[NSString stringWithFormat:@"%@ " ,[dict valueForKey:@"likecount"]];
        
        
        BOOL isReflok=[[dict valueForKey:@"isReFlokByMe"] intValue];
        if (isReflok) {
            tCell.imgReflok.image=[UIImage imageNamed:@"reflok_hover"];
            //[tCell.btnReflok setUserInteractionEnabled:NO];
        }else{
            tCell.imgReflok.image=[UIImage imageNamed:@"reflok"];
            //[tCell.btnReflok setUserInteractionEnabled:YES];
        }
        
        NSString *strType=[dict valueForKey:@"type"];
        if ([strType isEqualToString:@"social"]) {
          //  tCell.vwReflok.hidden=NO;
        }else{
            //tCell.vwReflok.hidden=YES;
        }
        
        NSString *userImg=[dict valueForKey:@"uploaded_by_userImage"];
        
        if ([userImg length]==0) {
            tCell.imgUser.image=[UIImage imageNamed:@"no-profile"];
        }else{
            [tCell.indicator startAnimating];
           // [self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:tCell.imgFlag and:tCell.indicator];
        }
        
        NSString *user_Id=[dict valueForKey:@"user_id"];
        if ([userId isEqualToString:user_Id])
        {
            [tCell.btnProfile addTarget:self action:@selector(showOtherProfile:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [tCell.btnProfile addTarget:self action:@selector(showOtherProfile:) forControlEvents:UIControlEventTouchUpInside];
        }
        tCell.btnEditImg.hidden=YES;
        tCell.btnDeleteImg.hidden=YES;
        tCell.btnEdit.hidden=YES;
        tCell.btnDelete.hidden=YES;
        tCell.btnProfile.tag=indexPath.row;
        tCell.btnLike.tag=indexPath.row;
     
        
        NSString *time2=[self timerValue:[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"start_date"],[dict valueForKey:@"start_time"]]];
        
        BOOL isExpired=[[dict valueForKey:@"isExpired"] boolValue];
        if (isExpired==YES) {
            tCell.vwExpired.hidden=NO;
            tCell.lblUserName.text=@"Expired";
            
        }else {
            tCell.vwExpired.hidden=YES;
           // tCell.lblUserName.hidden=NO;
            tCell.lblUserName.text=[NSString stringWithFormat:@"%@",time2];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
        [tCell.lblFlokName addGestureRecognizer:tap];
        
        [tCell.btnLike addTarget:self action:@selector(flokLike:)forControlEvents:UIControlEventTouchUpInside];
        
       
        [tCell.btnMsg addTarget:self action:@selector(messageAction:)forControlEvents:UIControlEventTouchUpInside];
        
        tCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return tCell;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section!=0) {
        
        NSDictionary *dict;
        
        dict=[arrShared objectAtIndex:indexPath.row];
        BOOL isExpired=[[dict valueForKey:@"isExpired"] boolValue];
        if (isExpired!=YES) {
          
            if ([userId isEqualToString:[dict valueForKey:@"user_id"]]) {
                OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
                vc.flokId=[dict valueForKey:@"id"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else{
                
                
                BOOL isJoinByme=[[dict valueForKey:@"is_joined_by_me"] intValue];
                if (isJoinByme) {
                    OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
                    vc.flokId=[dict valueForKey:@"id"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
                    vc.flokId=[dict valueForKey:@"id"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }
        }
        
        
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        
        previousPage = page;
       
        lblProfileImgCount.text=[NSString stringWithFormat:@"%ld/%d",previousPage+1,totalImg];
    }
}
-(IBAction)showOtherProfile:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    NSDictionary *dict;
    if (segmentedControl.selectedSegmentIndex == 0) {
        dict=[arrShared objectAtIndex:[btn tag]];
    }else{
        dict=[arrShared objectAtIndex:[btn tag]];
    }
    // NSDictionary *dic=[arrMain objectAtIndex:[btn tag]];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
    
   // NSDictionary *dic=[arrPost objectAtIndex:[btn tag]];
    vc.OtherUserdic=dict;
    // vc.OtherUserId=[dic valueForKey:@""];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


-(IBAction)messageAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
}
-(IBAction)flokLike:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    TreeCell *cell=(TreeCell*)superView1;
    int temp=[cell.lblLikeCount.text intValue]+1;
    NSIndexPath *indexPath;
    
    indexPath = [tblMain indexPathForCell:cell];
    NSString *strTime=[self getLocateDate];
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrShared objectAtIndex:indexPath.row]];
    int status=[[oldDic valueForKey:@"isLikedByMe"] intValue];
    if (status==0) {
        cell.lblLikeCount.text=[NSString stringWithFormat:@"%@" ,[NSString stringWithFormat:@"%d",temp]];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        int totalVote=[[dic valueForKey:@"likecount"] intValue]+1;
        [dic setObject:[NSString stringWithFormat:@"%d",totalVote ] forKey:@"likecount"];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"isLikedByMe"];
        [arrShared replaceObjectAtIndex:indexPath.row withObject:dic];
        
        NSString *postid=[oldDic valueForKey:@"id"];
       // NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@&date_time=%@",userId,postid,strTime];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/like" serviceType:@"POST"];
        
    }
    
    
}


- (IBAction)segmentSwitch:(id)sender {
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [tblMain reloadData];
        //type=@"local";
        //[self getFlokList];
        //[scrlMain setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [tblMain reloadData];
        //type=@"social";
        // [self getFlokList];
        // [scrlMain setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    }
}


-(void)setDataToVewpage:(NSDictionary*)dict{
    
    isPrivate=[[dict valueForKey:@"profile_setting"] boolValue];
    NSInteger isFriend=[[dict valueForKey:@"isFollowedByMe"] integerValue];
    if (isPrivate==YES) {
        if (isFriend==1) {
           // [self getFlokInfo];
            //[self getSharedFlokList];
        }
    }else{
       // [self getFlokInfo];
        //[self getSharedFlokList];
    }
    NSString *strAge=[dict valueForKey:@"age"];
    if ([strAge length]!=0) {
        if (![strAge isEqualToString:@"0"]) {
            
            if (isPrivate==YES) {
                lblName.text=[NSString stringWithFormat:@"%@, %@ 🔒",[dict valueForKey:@"full_name"],[dict valueForKey:@"age"]];
            }else{
                lblName.text=[NSString stringWithFormat:@"%@, %@",[dict valueForKey:@"full_name"],[dict valueForKey:@"age"]];
            }
        }else{
            if (isPrivate==YES) {
                lblName.text=[NSString stringWithFormat:@"%@ 🔒",[dict valueForKey:@"full_name"]];
            }else{
                lblName.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"full_name"]];
            }
        }
    }else{
        if (isPrivate==YES) {
            lblName.text=[NSString stringWithFormat:@"%@ 🔒",[dict valueForKey:@"full_name"]];
        }else{
            lblName.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"full_name"]];
        }
        
    }    //lblName.text=[dict valueForKey:@"full_name"];
    lblAge.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]];
   // lblFollow.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"followingcount"]];
    lblFollow.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"followingcount"]];
    lblFollowers.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"followercount"]];
    schoollabel.text=[dict valueForKey:@"school"];
    workLabel.text=[dict valueForKey:@"work"];
   // [self setvwRating:4.7619047619048 vw:vwStar];
    [self setvwRating:[[dict valueForKey:@"rate_in_five"] floatValue] vw:vwStar];
    tvAbout.text=[dict valueForKey:@"about_me"];
    NSArray *arrFriend=[[NSArray alloc] initWithArray:[dict valueForKey:@"followingList"]];
    if (arrFriend.count>0) {
        //[self scrollImage:arrFriend];
    }else{
        lblMutual.hidden=YES;
    }
    
    /*BOOL isFriend=[[dict valueForKey:@"isFollowedByMe"] integerValue];
    if (!isFriend) {
        [btnFollow setTag:1];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [btnFollow addTarget:self action:@selector(btnFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnFollow setTag:2];
        //[btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        [btnFollow addTarget:self action:@selector(btnUnFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }*/
    
    if (isFriend==0) {
        [btnFollow setTag:1];
        [btnFollow setUserInteractionEnabled:YES];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [btnFollow addTarget:self action:@selector(btnFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if (isFriend==2) {
        [btnFollow setTag:1];
        [btnFollow setUserInteractionEnabled:NO];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"pending-1"] forState:UIControlStateNormal];
        
    }else if (isFriend==1) {
        [btnFollow setTag:2];
        [btnFollow setUserInteractionEnabled:YES];
        //[btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        [btnFollow addTarget:self action:@selector(btnFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
  
      NSArray *imagearr=[dict valueForKey:@"allimages"];
      if(imagearr.count>0){
      [self profileScrollImage:[dict valueForKey:@"allimages"]];
      [self profileBGScrollImage:[dict valueForKey:@"allimages"]];
    
    }
    else{
        
            NSString *userImg=[dict valueForKey:@"image"];
            if ([userImg length]==0) {
                profileImg.image=[UIImage imageNamed:@"no-profile"];
            }else{
        
                [self setImageWithurl:[dict valueForKey:@"image"] andImageView:profileImg and:nil];
                
            }
    }
    //[self setvwRating:[[dict valueForKey:@"rate_in_five"] floatValue] vw:vwStar];
    
    // [self setImageWithurl:[dict valueForKey:@"floksImage"] andImageView:profileImg and:nil];
    //[self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:imgUser and:nil];
    vwTemp.hidden=YES;
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

-(IBAction)btnUnFollowAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
   
    [Global disableAfterClick:btn];
    if ([btn tag]==1) {
        UIButton *btn=(UIButton*)sender;
        [Global disableAfterClick:btn];
         NSString *strTime=[self getCurrentDate];
        NSString *temp=[OtherUserdic valueForKey:@"id"];
        if ([temp length]!=0) {
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,[OtherUserdic valueForKey:@"id"],strTime];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
        }else{
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,[OtherUserdic valueForKey:@"user_id"],strTime];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
        }
        
    }else if([btn tag]==2){
        NSString *temp=[OtherUserdic valueForKey:@"id"];
        if ([temp length]!=0) {
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[OtherUserdic valueForKey:@"id"]];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/unfollow" serviceType:@"POST"];
        }else{
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[OtherUserdic valueForKey:@"user_id"]];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/unfollow" serviceType:@"POST"];
        }
        
    }

  
}

-(IBAction)reportForAbuse:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Report to this user for inappropriate behavior",@"Block", nil];
    
    [actionSheet showInView:self.view];
    [actionSheet setTag:1];
    
     /* UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];*/
}
-(IBAction)btnFollowAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    if ([btn tag]==1) {
        UIButton *btn=(UIButton*)sender;
        [Global disableAfterClick:btn];
        if (isPrivate==YES) {
             [btnFollow setBackgroundImage:[UIImage imageNamed:@"pending-1"] forState:UIControlStateNormal];
            [btnFollow setUserInteractionEnabled:NO];
            [Global showOnlyAlert:@"" :@"You can follow only when user has accepted the request" ];
        }else{
             [btnFollow setBackgroundImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        }
       
        [UIView transitionWithView:btn
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ btn.highlighted = YES; }
         
                        completion:nil];

        NSString *temp=[OtherUserdic valueForKey:@"user_id"];
        NSString *strTime=[self getCurrentDate];
        if ([temp length]!=0) {
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,[OtherUserdic valueForKey:@"user_id"],strTime];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
        }else{
    
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,[OtherUserdic valueForKey:@"id"],strTime];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
        }
        
        
        
        
    }else if([btn tag]==2){
        [UIView transitionWithView:btn
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ btn.highlighted = YES; }
         
                        completion:nil];
        //NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *temp=[OtherUserdic valueForKey:@"user_id"];
        if ([temp length]!=0) {
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[OtherUserdic valueForKey:@"user_id"]];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/unfollow" serviceType:@"POST"];
        }else{
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[OtherUserdic valueForKey:@"id"]];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/unfollow" serviceType:@"POST"];
        }
        
    }
}


#pragma mark- call Flok list api
-(void)getProfileInfo{
    
   
    NSString *str;
    str=[OtherUserdic valueForKey:@"user_id"];
    if ([str length]==0) {
        str=[OtherUserdic valueForKey:@"id"];
    }
    NSString *dataString=[NSString stringWithFormat:@"my_id=%@&user_id=%@",userId,str];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/otherUserProfile" serviceType:@"POST"];
}
-(void)getFlokInfo{
    
    CLLocationCoordinate2D coordinate=[self getLocation];
    latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *strTime=[self getCurrentDate];
    NSString *user_Id=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *str;
    str=[OtherUserdic valueForKey:@"user_id"];
    if ([str length]==0) {
        str=[OtherUserdic valueForKey:@"id"];
    }
    NSString *dataString=[NSString stringWithFormat:@"my_id=%@&user_id=%@&lat=%@&lang=%@&current_time=%@",user_Id,str,latitude,longitude,strTime];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/myProfileSharedPost" serviceType:@"POST"];
}


#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage];
}

-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/otherUserProfile"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            NSDictionary *DicFlok=[data valueForKey:@"UserDetails"];
             NSLog(@"DicFlok-----%@",DicFlok);
            facebookId=[DicFlok valueForKey:@"fb_id"];
            if ([facebookId length]!=0) {
               [self fetchUserInfo];
            }
           [self setDataToVewpage:DicFlok];
            
        }
        else{
           // [Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Flok!" message:[data valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert setTag:5];
            return ;
            
        }
        
    }
    else if([serviceName isEqualToString:@"flok/myfloklist"])
    {
        NSLog(@"myfloklist list----%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            arrShared=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"allFloks"]];
            if (segmentedControl.selectedSegmentIndex == 0) {
                
                [tblMain reloadData];
            }
            else{
                
                [tblMain reloadData];
            }
        }
        else{
            
            //[Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
        }
    }
    else if([serviceName isEqualToString:@"flok/mySharedPost"])
    {
        NSLog(@"mySharedPost list----%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            arrShared=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"allFloks"]];
            //arrShared=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"allFloks"]];
            if (segmentedControl.selectedSegmentIndex == 0) {
                
                [tblMain reloadData];
            }
            else{
                
                [tblMain reloadData];
            }
        }
        else{
            
            //[Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
        }
    }else if([serviceName isEqualToString:@"flok/myProfileSharedPost"])
    {
        NSLog(@"mySharedPost list----%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
           
            arrShared=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"allFloks"]];
            [tblMain reloadData];
            
        }
        else{
            
            //[Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
        }
    }
    else if([serviceName isEqualToString:@"users/follow"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
           
            [btnFollow setTag:2];
        }
        
    }else if([serviceName isEqualToString:@"users/unfollow"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            [btnFollow setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
            [btnFollow setTag:1];
        }
        
    }else if([serviceName isEqualToString:@"users/block"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [Global showOnlyAlert:@"Flok" :@"Already Blocked"];
        }
        
    }
}


-(void)setDataToViewpage:(NSDictionary*)dict{
    
   // lblName.text=[dict valueForKey:@"full_name"];
   // lblAge.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"username"]];
    isPrivate=[[dict valueForKey:@"profile_setting"] boolValue];
    
    NSString *strAge=[dict valueForKey:@"age"];
    if ([strAge length]!=0) {
        if (![strAge isEqualToString:@"0"]) {
            
            if (isPrivate==YES) {
                lblName.text=[NSString stringWithFormat:@"%@, %@ 🔒",[dict valueForKey:@"full_name"],[dict valueForKey:@"age"]];
            }else{
               lblName.text=[NSString stringWithFormat:@"%@, %@",[dict valueForKey:@"full_name"],[dict valueForKey:@"age"]];
            }
        }else{
            if (isPrivate==YES) {
              lblName.text=[NSString stringWithFormat:@"%@ 🔒",[dict valueForKey:@"full_name"]];
            }else{
                lblName.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"full_name"]];
            }
        }
    }else{
        if (isPrivate==YES) {
          lblName.text=[NSString stringWithFormat:@"%@ 🔒",[dict valueForKey:@"full_name"]];
        }else{
           lblName.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"full_name"]];
        }
        
    }

    //lblUserName.text=[dict valueForKey:@"username"];
    lblFollow.text=[NSString stringWithFormat:@"%@ followers| %@ following",[dict valueForKey:@"followercount"],[dict valueForKey:@"followingcount"]];
    tvAbout.text=[dict valueForKey:@"about_me"];
   // NSArray *arrFriend=[[NSArray alloc] initWithArray:[dict valueForKey:@"followingList"]];
    
    //[self scrollImage:arrFriend];
    NSInteger isFriend=[[dict valueForKey:@"isFollowedByMe"] integerValue];
    if (isFriend==0) {
        [btnFollow setTag:1];
        [btnFollow setUserInteractionEnabled:YES];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        [btnFollow addTarget:self action:@selector(btnFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if (isFriend==0) {
        [btnFollow setTag:1];
        [btnFollow setUserInteractionEnabled:NO];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"Pending"] forState:UIControlStateNormal];
        
    }
    else{
        [btnFollow setTag:1];
        [btnFollow setUserInteractionEnabled:YES];
        //[btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [btnFollow setBackgroundImage:[UIImage imageNamed:@"unfollow"] forState:UIControlStateNormal];
        [btnFollow addTarget:self action:@selector(btnFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSString *userImg=[dict valueForKey:@"image"];
    
    if ([userImg length]==0) {
        profileImg.image=[UIImage imageNamed:@"no-profile"];
    }else{
        
        [self setImageWithurl:[dict valueForKey:@"image"] andImageView:profileImg and:nil];
    }
    
    
    
    //[self setImageWithurl:[dict valueForKey:@"floksImage"] andImageView:profileImg and:nil];
    //[self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:imgUser and:nil];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
        
    {
        InappropriateReport *vc=(InappropriateReport*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"InappropriateReport"];
        
        vc.OtherUserId=[OtherUserdic valueForKey:@"user_id"];
        vc.OtherUserImg=[OtherUserdic valueForKey:@"user_image"];
        vc.OtherUserName=[OtherUserdic valueForKey:@"full_name"];
        vc.userDic=OtherUserdic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(buttonIndex == 1)
        
    {
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Are you sure you want block this user?" delegate:self cancelButtonTitle:@"Sure" otherButtonTitles:@"Cancel", nil] ;
        
        [alert setTag:5];
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==5) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        
        if (buttonIndex==0) {
            
        }else{
            NSString *str;
            str=[OtherUserdic valueForKey:@"user_id"];
            if ([str length]==0) {
                str=[OtherUserdic valueForKey:@"id"];
            }
            
            NSString *dataString=[NSString stringWithFormat:@"user_id=%@&blocked_user_id=%@",userId,str];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/block" serviceType:@"POST"];
            
        }
    }
}

-(CLLocationCoordinate2D) getLocation{
    locationManager =[[CLLocationManager alloc] init];
    locationManager.delegate =(id)self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *location=[locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
    
}

-(NSString *)getLocateDate{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time=[dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return time;
    
}



-(NSMutableAttributedString*)setTextAttribute:(NSString*)strTemp Name:(NSString*)name and:(NSDictionary*)dict{
    
    
    NSString *userName=[NSString stringWithFormat:@"@%@",[dict valueForKey:@"username"]];
    NSString *time=[self calculateTime:[dict valueForKey:@"date"]];
    NSRange range1 = [strTemp rangeOfString:name];
    
    NSRange range2 = [strTemp rangeOfString:userName];
    NSRange range3 = [strTemp rangeOfString:time];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:strTemp];
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13.0]}
                            range:range1];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica"size:11.0]} range:range2];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica"size:11.0]}
                            range:range3];
    
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:range1];
    
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor grayColor]
                           range:range3];
    
    [attributedText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor grayColor]
                           range:range2];
    
    return attributedText;
}



-(NSString*)calculateTime:(NSString*)time{
    if ([time isEqualToString:@"0000-00-00 00:00:00"]) {
        return @"";
    }
    NSString *gmtDateString =[NSString stringWithFormat:@"%@",time]; //@"29/10/2015 00:01";
    
    NSDateFormatter *df = [NSDateFormatter new];
    //[df setDateFormat:@"dd/MM/yyyy HH:mm"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[df setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    //Create the date assuming the given string is in GMT
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [df dateFromString:gmtDateString];
    if (!date) {
        return @"";
    }
    
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
    
    NSDate* now = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] ;
    
    
    
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
    NSLog(@"%@",[NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]]);
    return [NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]];
    
}
-(void)fetchUserInfo
{
    
    NSString *strTemp=[NSString stringWithFormat:@"/%@/friends",facebookId];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:strTemp
                                  parameters:@{@"fields": @"id, name, email"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
         NSDictionary  *userDetailsDic=(NSDictionary*)result;
        arrFriends=[[NSArray alloc] initWithArray:[userDetailsDic valueForKey:@"data"]];
        if (arrFriends.count>0) {
            [self scrollImage:arrFriends];
        }
        else{
            lblMutual.hidden=YES;
        }
    }];
}


#pragma mark- Scroll image
-(void)scrollImage:(NSArray*)myarr
{
    int imgx=4;
    int lblx=0;
    int imgy=4;
    int imgW=60;
    int imgH=60;
    

    NSInteger count = myarr.count;
    if (myarr.count>10) {
        count=10;
        btnShowMore.hidden=NO;
    }else{
        btnShowMore.hidden=YES;
    }
    
    for (int i=0; i<count; i++) {
        
        NSDictionary *dict=[myarr objectAtIndex:i];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(imgx,imgy,imgW,imgH)];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        imageView.layer.cornerRadius=imageView.frame.size.height/2;
        //imageView.backgroundColor=RGB(198,223,236);
        
        // NSString *imgstr=[dict valueForKey:@"user_image"];//arrimg[i];
        NSString *imgstr = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[dict valueForKey:@"id"]];
        
        if ([imgstr length]==0) {
            
            imageView.image=[UIImage imageNamed:@"no-profile"];
            
        }
        else{
            
            NSString* imageName=[imgstr lastPathComponent];
            if ([imageName isEqualToString:@"no.png"]) {
                imageView.image=[UIImage imageNamed:@"no-profile"];
                
            }else{
                
                [self setImageWithurlForFB:imgstr andImageView:imageView and:nil];
            }
        }
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(lblx,63,70,20)];
        //name.backgroundColor = [UIColor clearColor];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor blackColor];
        name.text = [dict valueForKey:@"name"];
        UIFont *myFont=[UIFont fontWithName:@"Helvetica" size:8];
        [name setFont:myFont];
        [scrlImg addSubview:name];
        //[scrlImg setBackgroundColor:[UIColor redColor]];
        [scrlImg addSubview:imageView];
        //scrlImg.pagingEnabled=YES;
        
        imgx=imgx+imgW+20;
        lblx=lblx+imgW+20;
    }
    scrlImg.contentSize = CGSizeMake(imgx, scrlImg.frame.size.height);
    scrlImg.showsHorizontalScrollIndicator=NO;
    scrlImg.showsVerticalScrollIndicator=NO;
    //scrlImg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"noimage"]];
    
}


-(void)setImageWithurlForFB:(NSString*)url andImageView:(UIImageView*)imgview and:(UIActivityIndicatorView *)loder{
    
    [loder startAnimating];
    
    [WebImageOperations processImageDataWithURLString:url andBlock:^(NSData *imageData)
     {
         imgview.image=[UIImage imageWithData:imageData];
         // [imageData writeToFile:FilePath atomically:YES];
         [loder stopAnimating];
     }];
    //}
    
}


- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    
    UITextView *textView =  (UITextView *)recognizer.view;
    [self getHashTag:textView];
    CGPoint location = [recognizer locationInView:textView];
    NSLog(@"Tap Gesture Coordinates: %.2f %.2f -- %@", location.x, location.y,textView.text);
    
    CGPoint position = CGPointMake(location.x, location.y);
    //get location in text from textposition at point
    UITextPosition *tapPosition = [textView closestPositionToPoint:position];
    
    //fetch the word at this position (or nil, if not available)
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    NSString *tappedSentence =[NSString stringWithFormat:@"%@",[textView textInRange:textRange]];//;
    //  NSString *tappedSentence2 = [textView lineAtPosition:CGPointMake(location.x, location.y)];
    NSLog(@"selected :%@ -- %@ ",tappedSentence,tapPosition);
    
    for (int i=0; i<arrHashtag.count; i++) {
        NSString *str=[NSString stringWithFormat:@"%@",[arrHashtag objectAtIndex:i]];
        str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([str isEqualToString:tappedSentence]) {
            [self goToOtherPage:tappedSentence];
            return;
        }
    }
    CGPoint point;
    NSIndexPath *theIndexPath;
    point = [recognizer locationInView:tblMain];
    theIndexPath= [tblMain indexPathForRowAtPoint:point];
    

    NSDictionary *dict=[arrShared objectAtIndex:theIndexPath.row];
    if ([userId isEqualToString:[dict valueForKey:@"user_id"]]) {
        OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
        vc.flokId=[dict valueForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        
        BOOL isJoinByme=[[dict valueForKey:@"is_joined_by_me"] intValue];
        if (isJoinByme) {
            OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
            vc.flokId=[dict valueForKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
            vc.flokId=[dict valueForKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
}

- (void)getHashTag:(UITextView *)textView{
    arrHashtag=[[NSMutableArray alloc ] init];
    NSRange range;
    NSArray *words=[textView.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"#"]) {
            range=[textView.text rangeOfString:word];
            NSString *string1 = [textView.text substringWithRange:NSMakeRange(range.location+1, range.length)];
            [arrHashtag addObject:string1];
        }
    }
    
    NSLog(@"arrHastag value-- %@",arrHashtag);
}


-(void)goToOtherPage:(NSString*)hashTag{
    
    HashTagFeed *vc=(HashTagFeed*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HashTagFeed"];
    vc.hashtag=hashTag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)colorWord:(UITextView *)lblText {
    NSRange range;
    NSRange range1=[lblText.text rangeOfString:lblText.text];;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:lblText.text];
    NSArray *words=[lblText.text componentsSeparatedByString:@" "];
   
    [string setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue"size:12.0]}
                    range:range1];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range1];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"#"]) {
            range=[lblText.text rangeOfString:word];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:77.0/255.0 green:171.0/255.0 blue:231.0/255.0 alpha:1] range:range];
        }
    }
    
    [lblText setAttributedText:string];
    
}

-(NSString *)getCurrentDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate* currentDate = [NSDate date];
    
    NSTimeZone* CurrentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* SystemTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [CurrentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger SystemGMTOffset = [SystemTimeZone secondsFromGMTForDate:currentDate];
    NSTimeInterval interval = SystemGMTOffset - currentGMTOffset;
    
    NSDate* TodayDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    NSLog(@"Current time zone Today Date : %@", TodayDate);
    
    NSString *timeStamp2 = [dateFormatter stringFromDate:TodayDate];
    
    return timeStamp2;
}

-(NSString *)timerValue: (NSString *)time
{
    NSArray *myArray = [time componentsSeparatedByString:@"/"];
    NSArray *Array = [[myArray objectAtIndex:2] componentsSeparatedByString:@" "];
    if(Array.count>2){
        time=[NSString stringWithFormat:@"%@-%@-%@ %@ %@",[Array objectAtIndex:0],[myArray objectAtIndex:0],[myArray objectAtIndex:1],[Array objectAtIndex:1],[Array objectAtIndex:2]];
    }else
    {
        return  @"Expired";
    }
    
    NSDateFormatter *df=[NSDateFormatter new];
    //[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *gmtDateString =[NSString stringWithFormat:@"%@",time];
    NSDate *date = [df dateFromString:gmtDateString];
    
    NSInteger timeUntilEnd = (NSInteger)[[df dateFromString:time] timeIntervalSinceDate:[NSDate date]];
    if (timeUntilEnd <= 0) {
        return  @"Happening Now!";
    }
    else {
                
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        NSString *localDateString = [df stringFromDate:date];
        
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDate *date1 = [df dateFromString:localDateString];
        
        NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
        
        //NSDateComponentsFormatter *formatter2 = [[NSDateComponentsFormatter alloc] init];
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
        
        //NSDate *now = [NSDate date];
        
        NSDate* sourceDate = [NSDate date];
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        NSDate* now = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] ;
        
        //NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond)
                                                   fromDate:now
                                                     toDate:date1
                                                    options:0];
        
        NSString *intervalTime;
        
        if (components.year > 0) {
            formatter.allowedUnits = NSCalendarUnitYear;
        } else if (components.month > 0) {
            formatter.allowedUnits = NSCalendarUnitMonth;
            intervalTime=[formatter stringFromDateComponents:components];
        } else if (components.weekOfMonth > 0) {
            formatter.allowedUnits = NSCalendarUnitWeekOfMonth;
            intervalTime=[formatter stringFromDateComponents:components];
        } else if (components.day > 0) {
            formatter.allowedUnits = NSCalendarUnitDay;
            
            NSInteger hour = [components hour];
            if(hour>1){
                intervalTime=[NSString stringWithFormat:@"%@ %ld hours",[formatter stringFromDateComponents:components] ,(long)[components hour]];
            }else{
                intervalTime=[NSString stringWithFormat:@"%@ %ld hour",[formatter stringFromDateComponents:components] ,(long)[components hour]];
            }
            
        } else if (components.hour > 0) {
            formatter.allowedUnits = NSCalendarUnitHour;
            NSInteger minute = [components minute];
            if (minute>1) {
                intervalTime=[NSString stringWithFormat:@"%@ %ld minutes",[formatter stringFromDateComponents:components] ,[components minute]];
            }else{
                
                intervalTime=[NSString stringWithFormat:@"%@ %ld minute",[formatter stringFromDateComponents:components] ,[components minute]];
            }
            
            
        } else if (components.minute > 0) {
            formatter.allowedUnits = NSCalendarUnitMinute;
            intervalTime=[formatter stringFromDateComponents:components];
        } else {
            formatter.allowedUnits = NSCalendarUnitSecond;
            intervalTime=[formatter stringFromDateComponents:components];
            // return @"0 minute";
        }
        
        NSString *formatString = NSLocalizedString(@"%@", @"Used to say how much time has passed. e.g. '2 hr ago'");
        NSLog(@"%@",[NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]]);
        
        return [NSString stringWithFormat:@"Starts in %@!",intervalTime];
    }
}


@end
