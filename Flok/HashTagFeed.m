//
//  HashTagFeed.m
//  Flok
//
//  Created by NITS_Mac3 on 08/12/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "HashTagFeed.h"
#import "AppDelegate.h"
#import "WebImageOperations.h"
#import "TreeCell.h"
#import "OtherUserViewController.h"
#import "MePage.h"
#import "EditFlokViewController.h"
#import "OtherUserFlok.h"
#import "FlikDetailsForRequestBase.h"

@implementation HashTagFeed
@synthesize hashtag;

- (void)viewDidLoad {
    [super viewDidLoad];
     userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [self getAllPost];
     userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    latitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    longitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
}
-(IBAction)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getAllPost{
    
    NSString *strTime=[self getCurrentDate];
    NSString *dataString=[NSString stringWithFormat:@"hashtag=%@&current_time=%@",hashtag,strTime];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/listhashtag" serviceType:@"POST"];
    
}


#pragma mark- Table datasource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrList count];
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSString *strIdentifier=@"tcell";
        TreeCell *tCell=(TreeCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TreeCell" owner:self options:nil];
        tCell=[nib objectAtIndex:0];
        NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        tCell.lblFlokName.editable =NO;
        tCell.lblFlokName.text=[dict valueForKey:@"title"];
        tCell.lblName.text=[dict valueForKey:@"uploaded_by"];
        NSString *time2=[self timerValue:[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"start_date"],[dict valueForKey:@"start_time"]]];
        tCell.lblUserName.text=[NSString stringWithFormat:@"%@",time2];
        tCell.lblDistance.text=[NSString stringWithFormat:@"%.01f miles",[[dict valueForKey:@"distance"] floatValue]];
        [self colorWord:tCell.lblFlokName];
        //tCell.lblTime.text=[dict valueForKey:@""];
        tCell.lblLikeCount.text=[NSString stringWithFormat:@"%@ " ,[dict valueForKey:@"likecount"]];
        tCell.lblDisLikeCount.text=[NSString stringWithFormat:@"%@ " ,[dict valueForKey:@"dislikecount"]];
        tCell.lblReflokCount.text=[NSString stringWithFormat:@"%@" ,[dict valueForKey:@"reflok_count"]];
        tCell.lblTime.text=[self calculateTime:[dict valueForKey:@"date"]];
        BOOL isReflok=[[dict valueForKey:@"isReFlokByMe"] intValue];
        if (isReflok) {
            tCell.imgReflok.image=[UIImage imageNamed:@"reflok_hover"];
            [tCell.btnReflok setUserInteractionEnabled:NO];
        }else{
            tCell.imgReflok.image=[UIImage imageNamed:@"reflok"];
            [tCell.btnReflok setUserInteractionEnabled:YES];
        }
        
        NSString *strType=[dict valueForKey:@"type"];
        if ([strType isEqualToString:@"social"]) {
           // tCell.vwReflok.hidden=NO;
        }else{
            tCell.vwReflok.hidden=YES;
        }
        
        NSString *userImg=[dict valueForKey:@"uploaded_by_userImage"];
        
        if ([userImg length]==0) {
          //  tCell.imgFlag.image=[UIImage imageNamed:@"no-profile"];
        }else{
            [tCell.indicator startAnimating];
           // [self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:tCell.imgFlag and:tCell.indicator];
        }
        NSString *user_Id=[dict valueForKey:@"user_id"];
        if ([userId isEqualToString:user_Id]) {
            [tCell.btnProfile addTarget:self action:@selector(showOtherProfile:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [tCell.btnProfile addTarget:self action:@selector(showOtherProfile:) forControlEvents:UIControlEventTouchUpInside];
        }
        tCell.btnProfile.tag=indexPath.row;
        tCell.btnReflok.tag=indexPath.row;
        tCell.btnLike.tag=indexPath.row;
        tCell.btnDislike.tag=indexPath.row;
        tCell.btnEdit.tag=indexPath.row;
        tCell.btnDelete.tag=indexPath.row;
        
        [tCell.btnLike addTarget:self action:@selector(flokLike:)forControlEvents:UIControlEventTouchUpInside];
        [tCell.btnDislike addTarget:self action:@selector(flokDisLike:)forControlEvents:UIControlEventTouchUpInside];
        [tCell.btnReflok addTarget:self action:@selector(ReflokAction:)forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if ([userId isEqualToString:[dict valueForKey:@"user_id"]]) {
            tCell.btnMsg.hidden=YES;
            tCell.MsgImg.hidden=YES;
            
            tCell.btnEdit.hidden=NO;
            tCell.btnDelete.hidden=NO;
            tCell.btnEditImg.hidden=NO;
            tCell.btnDeleteImg.hidden=NO;
            [tCell.btnDelete addTarget:self action:@selector(flokDelete:)forControlEvents:UIControlEventTouchUpInside];
            [tCell.btnEdit addTarget:self action:@selector(flokEdit:)forControlEvents:UIControlEventTouchUpInside];
        }else{
            tCell.btnEdit.hidden=YES;
            tCell.btnDelete.hidden=YES;
            tCell.btnEditImg.hidden=YES;
            tCell.btnDeleteImg.hidden=YES;
            [tCell.btnMsg addTarget:self action:@selector(messageAction:)forControlEvents:UIControlEventTouchUpInside];
            
            
        }
    BOOL isExpired=[[dict valueForKey:@"isExpired"] boolValue];
    if (isExpired==YES) {
        tCell.vwExpired.hidden=NO;
    }else {
        tCell.vwExpired.hidden=YES;
    }
    
        tCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return tCell;
        
        
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
    if ([userId isEqualToString:[dict valueForKey:@"user_id"]]) {
        OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
        vc.flokId=[dict valueForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        int access_type=[[dict valueForKey:@"access"] intValue];
        if (access_type ==0) {
            OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
            vc.flokId=[dict valueForKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            BOOL access_type=[[dict valueForKey:@"is_access"] boolValue];
            if (access_type) {
                OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
                vc.flokId=[dict valueForKey:@"id"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                
                NSLog(@"Cheking----");
                
                OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
                vc.flokId=[dict valueForKey:@"id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}

-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"flok/listhashtag"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            arrList=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"allFloks"]];
            [tblMain reloadData];
            
        }
        else{
            
           
        }
    }
}



-(void)showOtherProfile:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    NSDictionary *dic=[arrList objectAtIndex:[btn tag]];
    
    NSLog(@"dicjjjjjjjj-----%@",dic);
    
    NSString *userId100=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if([[dic objectForKey:@"user_id"] isEqualToString:userId100]){
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // self.tabBarController.tabBar.hidden = NO;
        MePage *vc=(MePage*)[storyboard instantiateViewControllerWithIdentifier:@"MePage"];
        vc.frompage=@"1";
        [self.navigationController pushViewController:vc animated:YES];
        
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //        UITabBarController *tabvc=
        //
        //        (UITabBarController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        //         [tabvc setSelectedIndex:3];
        //        UIViewController *myVC =(UIViewController*)[tabvc selectedViewController];
        //        [self.navigationController pushViewController:myVC animated:NO];
        
        
        
        
    }
    
    else{
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.otherUserdic=[arrList objectAtIndex:[btn tag]];
        // vc.OtherUserId=[dic valueForKey:@""];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark- Method
-(IBAction)ReflokAction:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    TreeCell *cell=(TreeCell*)superView1;
    int temp=[cell.lblReflokCount.text intValue]+1;
    NSIndexPath *indexPath;
   
    indexPath = [tblMain indexPathForCell:cell];
        
    
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrList objectAtIndex:indexPath.row]];
    //    int status=[[oldDic valueForKey:@"isReflokByMe"] integerValue];
    //    if (status==0) {
    cell.lblReflokCount.text=[NSString stringWithFormat:@"%@" ,[NSString stringWithFormat:@"%d",temp]];
    cell.imgReflok.image=[UIImage imageNamed:@"reflok_hover"];
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
    int totalVote=[[dic valueForKey:@"reflok_count"] intValue]+1;
    [dic setObject:[NSString stringWithFormat:@"%d",totalVote ] forKey:@"reflok_count"];
    [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"isReflokByMe"];
    [arrList replaceObjectAtIndex:indexPath.row withObject:dic];
    
    NSString *postid=[oldDic valueForKey:@"id"];
    // NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&reflok_id=%@&lat=%@&lang=%@",userId,postid,latitude,longitude];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/reFlok" serviceType:@"POST"];
   
    
}

-(IBAction)flokEdit:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    TreeCell *cell=(TreeCell*)superView1;
    NSIndexPath *indexPath;
    
    indexPath = [tblMain indexPathForCell:cell];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrList objectAtIndex:indexPath.row]];
    
    EditFlokViewController *vc=(EditFlokViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditFlokViewController"];
    vc.flokId=[dict valueForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(IBAction)flokDelete:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    TreeCell *cell=(TreeCell*)superView1;
    
    
    tempIndexPath = [tblMain indexPathForCell:cell];
    tempDic = [[NSMutableDictionary alloc] initWithDictionary:[arrList objectAtIndex:tempIndexPath.row]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are you sure you want to delete?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
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
    
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrList objectAtIndex:indexPath.row]];
    int status=[[oldDic valueForKey:@"isLikedByMe"] intValue];
    
    if (status==0) {
        
        cell.lblLikeCount.text=[NSString stringWithFormat:@"%@" ,[NSString stringWithFormat:@"%d",temp]];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        int totalVote=[[dic valueForKey:@"likecount"] intValue]+1;
        [dic setObject:[NSString stringWithFormat:@"%d",totalVote ] forKey:@"likecount"];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"isLikedByMe"];
        [arrList replaceObjectAtIndex:indexPath.row withObject:dic];
        
        NSString *postid=[oldDic valueForKey:@"id"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,postid];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/like" serviceType:@"POST"];
        
    }
}

-(IBAction)flokDisLike:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        
        superView1 = [superView1 superview];
    }
    
    TreeCell *cell=(TreeCell*)superView1;
    int temp=[cell.lblDisLikeCount.text intValue]+1;
    //tempCell=(TreeCell*)cell;
    NSIndexPath *indexPath;
    
    indexPath = [tblMain indexPathForCell:cell];
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrList objectAtIndex:indexPath.row]];
    
    int status=[[oldDic valueForKey:@"isDisLikedByMe"] intValue];
    
    if (status==0) {
        
        cell.lblDisLikeCount.text=[NSString stringWithFormat:@"%@" ,[NSString stringWithFormat:@"%d",temp]];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        int totalVote=[[dic valueForKey:@"dislikecount"] intValue]+1;
        [dic setObject:[NSString stringWithFormat:@"%d",totalVote ] forKey:@"dislikecount"];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"isDisLikedByMe"];
        [arrList replaceObjectAtIndex:indexPath.row withObject:dic];
        
        NSString *postid=[oldDic valueForKey:@"id"];
        
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,postid];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/dislike" serviceType:@"POST"];
    }
    
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
- (void)colorWord:(UITextView *)lblText {
    NSRange range;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:lblText.text];
    NSArray *words=[lblText.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"#"]) {
            range=[lblText.text rangeOfString:word];
            //  NSRange rangeBold = [word rangeOfString:@"BOLD"];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:77.0/255.0 green:171.0/255.0 blue:231.0/255.0 alpha:1] range:range];
            // [string setAttributes:dictBoldText range:range];
        }
    }
    
    
    [lblText setAttributedText:string];
    
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
    time=[NSString stringWithFormat:@"%@-%@-%@ %@ %@",[Array objectAtIndex:0],[myArray objectAtIndex:0],[myArray objectAtIndex:1],[Array objectAtIndex:1],[Array objectAtIndex:2]];
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
        /* NSInteger seconds1 = timeUntilEnd % 60;
         NSInteger minutes1 = (timeUntilEnd / 60) % 60;
         NSInteger hours1 = (timeUntilEnd / 3600);
         return  [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours1, (long)minutes1, (long)seconds1];*/
        
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        NSString *localDateString = [df stringFromDate:date];
        
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDate *date1 = [df dateFromString:localDateString];
        
        NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
        
        NSDateComponentsFormatter *formatter2 = [[NSDateComponentsFormatter alloc] init];
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
        //  NSLog(@"start date-- %@ %@",[NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components] ,[components month]]);
        
        
        // return [NSString stringWithFormat:formatString, [formatter stringFromDateComponents:components]];
        
        return [NSString stringWithFormat:@"Starts in %@!",intervalTime];
    }
}

@end
