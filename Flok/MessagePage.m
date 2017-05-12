//
//  MessagePage.m
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "MessagePage.h"
#import "MessageCell.h"
#import "ChatPage.h"
#import "ChatViewController.h"
#import "WebImageOperations.h"
#import "CreateFlokPage.h"
#import "FriendTableViewCell.h"
#import "SearchMessage.h"
#import "OtherUserViewController.h"

@interface MessagePage ()

@end

@implementation MessagePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    self.view.backgroundColor=[UIColor clearColor];
    vwSearch.layer.cornerRadius=4;
    
    [vwFriend setFrame:CGRectMake(0, vwFriend.frame.size.height, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    
     NSLog(@"MessagePage");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    NoMessage.hidden=YES;
    arrPeople=[[NSMutableArray alloc]init];
    arrCheck=[[NSMutableArray alloc]init];
    for (int i=1; i<=100;i++) {
        [arrPeople addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self getMessageList];
    [self getFriendList ];
     self.tabBarController.delegate = self;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    // searchResults = [arrFriend filteredArrayUsingPredicate:resultPredicate];
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length]>=2) {
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        searchText];
        
        searchResults = [arrFriend filteredArrayUsingPredicate:resultPredicate];
        if (searchResults.count>0) {
            isFilter=YES;
            [tblFriend reloadData];
        }else{
            isFilter=NO;
            [tblFriend reloadData];
        }
        
    }
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(IBAction)creatFlokAction:(id)sender{
    
    CreateFlokPage *vc=(CreateFlokPage*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CreateFlokPage"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getFriendList{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/myFollower" serviceType:@"POST"];
}
#pragma mark- call Message list api
-(void)getMessageList{
    
    NSString * userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/getChatUsers" serviceType:@"POST"];
}
#pragma mark- Method

#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark- Table datasource & delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblMsg)
    {
        return arrList.count;
    }else
    {
        if (isFilter) {
            
            return searchResults.count;
        }
        else{
            
            return arrFriend.count;
        }
    }
    return 0;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblMsg)
    {
        return 80;
    }else{
        return 60.0;
    }

    return 0.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblMsg)
    {
        NSString *strIdentifier=@"tcell";
        MessageCell *tCell=(MessageCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        tCell=[nib objectAtIndex:0];
        NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        NSString *count=[NSString stringWithFormat:@"%@",[dict valueForKey:@"getUnreadChatsCount"]];
        if (![count isEqualToString:@"0"]) {
            tCell.lblCount.text=count;
            tCell.lblCount.hidden=NO;
            
        }else{
             tCell.lblCount.hidden=YES;
        }
        tCell.tvdesc.text=[dict valueForKey:@"last_message"];
        tCell.lblnm.text=[dict valueForKey:@"name"];
        if ([tCell.tvdesc.text length]>50) {
            tCell.tvdesc.text=[tCell.tvdesc.text substringToIndex:50];
        }
        
        tCell.tvdesc.textColor=[UIColor grayColor];
        NSString *strTime=[self calculateTime:[dict valueForKey:@"last_message_time"]];
        if ([strTime length]!=0) {
            tCell.lblTime.text=[self calculateTime:[dict valueForKey:@"last_message_time"]];
        }
        NSString *userImg=[dict valueForKey:@"image"];
        if ([userImg length]==0) {
            tCell.imgv.image=[UIImage imageNamed:@"no-profile"];
        }else{
            [tCell.indicator startAnimating];
            [self setImageWithurl:[dict valueForKey:@"image"] andImageView:tCell.imgv and:tCell.indicator];
        }
          tCell.btnProfile.tag=indexPath.row;
        [tCell.btnProfile addTarget:self action:@selector(showOtherProfile:) forControlEvents:UIControlEventTouchUpInside];
        tCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        tCell.lblCount.layer.cornerRadius=tCell.lblCount.frame.size.width/2;
        tCell.lblCount.layer.masksToBounds = YES;
        return tCell;
        
    }else if (tableView==tblFriend) {
        static NSString *cellIdentifier=@"CellIdentifier";
        FriendTableViewCell *cell=(FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"FriendTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSDictionary *dict;
        if (isFilter) {
            dict=[searchResults objectAtIndex:indexPath.row];
        }else{
            dict=[arrFriend objectAtIndex:indexPath.row];
        }
        
        cell.lblName.text=[dict valueForKey:@"full_name"];
        
        [cell.btnCheck addTarget:self action:@selector(checkMark:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheck setTag:indexPath.row];
        NSString *userImg=[dict valueForKey:@"user_image"];
        
        if ([userImg length]==0) {
            cell.profileImg.image=[UIImage imageNamed:@"no-profile"];
        }else{
            [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:cell.profileImg and:nil];
        }
        //NSString *str =[dict valueForKey:@"message"];
        NSString *tem=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        if ([self getCheckMarkList:tem]) {
            // [cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
            cell.imgCheck.image=[UIImage imageNamed:@"check"];
        }else{
            cell.imgCheck.image=[UIImage imageNamed:@"uncheck"];
            //[cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        }
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblMsg)
    {
        NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
        ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
        vc.strFriendId=[dict valueForKey:@"id"];
        vc.strProductName=[dict valueForKey:@"name"];
        vc.isBlock=[[dict valueForKey:@"is_blocked"] boolValue];
        [self.navigationController pushViewController:vc animated:YES];
 
    }else{
        NSDictionary *dict=[arrFriend objectAtIndex:indexPath.row];
        ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
        vc.strFriendId=[dict valueForKey:@"id"];
        vc.isBlock=[[dict valueForKey:@"is_blocked"] boolValue];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    
}
-(void)showOtherProfile:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    NSDictionary *dic=[arrList objectAtIndex:[btn tag]];
    
    NSLog(@"dicjjjjjjjj-----%@",dic);
    
    NSString *userId100=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if([[dic objectForKey:@"user_id"] isEqualToString:userId100]){
        
        
    
    }
    
    else{
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.otherUserdic=[arrList objectAtIndex:[btn tag]];
        // vc.OtherUserId=[dic valueForKey:@""];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(BOOL)getCheckMarkList:(NSString*)index{
    
    for(NSString *temp in arrCheck){
        if ([temp isEqualToString:index]) {
            return YES;
        }
    }
    return NO;
}

-(IBAction)checkMark:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    // [btn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    NSString *index=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    
    BOOL objectFound=NO;
    NSInteger myInt=0;
    
    for(NSString *temp in arrCheck){
        if ([temp isEqualToString:index]) {
            objectFound=YES;
            break;
        }
        myInt++;
    }
    
    if (objectFound==YES) {
        
        [arrCheck removeObjectAtIndex:myInt];
    }
    else{
        [arrCheck addObject:index];
    }
    
    [tblFriend reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}



-(IBAction)getFriendView:(id)sender{
    
     NSLog(@"getFriendView");
    
//    UIButton *btn=(UIButton*)sender;
//    [Global disableAfterClick:btn];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelay:1.0];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [vwFriend setFrame:CGRectMake(0, 0, vwFriend.frame.size.width, vwFriend.frame.size.height)];
//    [UIView commitAnimations];
//    
    
    
    SearchMessage *vc=(SearchMessage*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SearchMessage"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"flok/getChatUsers"])
    {
        
        if ([[data valueForKey:@"ACK"] intValue]==1) {
            NoMessage.hidden=YES;
            arrList=[[NSMutableArray alloc] initWithArray:[data valueForKey:@"chatUsers"]];
            [tblMsg reloadData];
        }else {
            NoMessage.hidden=NO;
        }
        
        
    }else if([serviceName isEqualToString:@"users/myFollower"]){
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            arrFriend=[data valueForKey:@"followerList"];
            [tblFriend reloadData];
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

#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0)
        NSLog(@"At the top");
}

-(IBAction)doneFriendView:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwFriend setFrame:CGRectMake(0, vwFriend.frame.size.height, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    [UIView commitAnimations];
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
    arrTemp=[arrFriend mutableCopy];
    
    NSMutableArray *arrGroup=[[NSMutableArray alloc] init];
    for (int i=0; i<arrCheck.count; i++) {
        int count=[[arrCheck objectAtIndex:i] intValue];
        NSMutableDictionary *dict=[arrFriend objectAtIndex:count];
        [arrTemp removeObject:dict];
        [arrGroup addObject:[dict valueForKey:@"id"]];
    }
    
    if (arrGroup.count==0) {
      //  [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please select any follower" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }else{
        
    }
    arrCheck=[[NSMutableArray alloc]init];
     accessList = [[arrGroup valueForKey:@"description"] componentsJoinedByString:@","];
    //[search resignFirstResponder];
}

-(IBAction)CancelFriendView:(id)sender{
    
    NSLog(@"CancelFriendView");
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwFriend setFrame:CGRectMake(0, vwFriend.frame.size.height, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    [UIView commitAnimations];
    [tfSearch resignFirstResponder];
    [search resignFirstResponder];
   
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


-(void)changeTabBarIcon{
    
    
    UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    UITabBarController *tabBarController = (UITabBarController *)myVC;
    
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:2];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"message-grey-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"message-orange-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
}
-(void)changeTabBarIconNormal{
    
    UIStoryboard *storyboard;
    UIViewController *myVC;
    storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    myVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    UITabBarController *tabBarController = (UITabBarController *)myVC;
    
    UITabBar *tabBar=self.tabBarController.tabBar;
    // UITabBar *tabBar=tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:2];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"message-grey"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"message-orange"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
}


-(IBAction)updateScreen:(id)sender{
    
    [tblMsg scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self changeTabBarIconNormal];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[MessagePage class]])
    {
        
        [self updateScreen:self];
    }
    
    
    // [self changeTabBarIconNormal];
    
    NSLog(@"tab bar selected ");
}

-(void)changeNotificationTabBarIcon{
    
    UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    UITabBarController *tabBarController = (UITabBarController *)myVC;
    
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    [tabBarItem1 setImage:[[UIImage imageNamed:@"notification-grey-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"notification-orange-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
}

-(void)changeTreeTabBarIcon{

    UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    UITabBarController *tabBarController = (UITabBarController *)myVC;
    UITabBar *tabBar=self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    [tabBarItem1 setImage:[[UIImage imageNamed:@"tree-grey-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"tree-orange-round"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
}
@end
