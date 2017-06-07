//
//  FindFriendsViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 21/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "FindFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FindpepleTableViewCell.h"
#import "OtherUserViewController.h"
#import "PhoneContactTableViewCell.h"
#import "WebImageOperations.h"
#import <Accounts/Accounts.h>

@interface FindFriendsViewController ()

@end

@implementation FindFriendsViewController
@synthesize arrFind,searchData,tfSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"FindFriendsViewController");
    
    
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    tblInvite.hidden=YES;
    vwInvite.hidden=YES;
    UIView *accessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    accessoryView.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btnDone=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 63, 40)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(DoneAction:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [accessoryView addSubview:btnDone];
    searchBar.inputAccessoryView=accessoryView;
    filteredContentList=[[NSMutableArray alloc] init];
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    last_Id=@"";
    [vwSync setFrame:CGRectMake(0, self.view.frame.size.height, vwSync.frame.size.width,self.view.frame.size.height)];
    
    vwSocial.hidden=YES;
    vwSearch.hidden=NO;
    btnSync.layer.cornerRadius=5;
    btnSync.layer.masksToBounds=YES;
    [btnContact setBackgroundImage:[UIImage imageNamed:@"orange_phone"] forState:UIControlStateNormal];
    
     
}

-(IBAction)doneAction:(id)sender{
    
   [self moveToTabBarController]; 
}
-(IBAction)findPeopleAction:(id)sender{
    vwSocial.hidden=YES;
    vwSearch.hidden=NO;
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [btnInvitePeople setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1]];
    [btnInvitePeople setTintColor:[UIColor whiteColor]];
    [btnInvitePeople setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFindPeople setBackgroundColor:[UIColor whiteColor] ];
    [btnFindPeople setTitleColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [tblFind reloadData];
    tblInvite.hidden=YES;
    vwInvite.hidden=YES;
    tblFind.hidden=NO;
}
-(IBAction)invitePeopleAction:(id)sender{
    vwSocial.hidden=NO;
    vwSearch.hidden=YES;
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [btnFindPeople setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1]];
    [btnFindPeople setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnInvitePeople setBackgroundColor:[UIColor whiteColor]];
    [btnInvitePeople setTintColor:[UIColor colorWithRed:12.0/255.0 green:78.0/255.0 blue:99.0/255.0 alpha:1]];
    
    [btnInvitePeople setTitleColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    tblFind.hidden=YES;
    vwInvite.hidden=NO;
    tblInvite.hidden=NO;
    
    NSString *is_Sync=[[NSUserDefaults standardUserDefaults] objectForKey:@"SyncContact"];
    if (![is_Sync isEqualToString:@"yes"]) {
        [self getSyncView ];
    }else{
        [self getPhoneNO:self ];
    }
}
- (IBAction)segmentSwitch:(id)sender {
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        
    }
    else{
        isFacebook=YES;
        if (arrFacebook.count>0) {
            [tblInvite reloadData];
        }else{
            
           [self getFacebook];
        }
        
    }
}
-(IBAction)myContact:(id)sender{
      isFacebook=NO;
   
     [btnContact setBackgroundImage:[UIImage imageNamed:@"orange_phone"] forState:UIControlStateNormal];
     [btnFb setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
     [tblInvite reloadData];
}
-(IBAction)facebook:(id)sender{
    [btnContact setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [btnFb setBackgroundImage:[UIImage imageNamed:@"face_hover"] forState:UIControlStateNormal];
    isFacebook=YES;
    if (arrFacebook.count>0) {
        [tblInvite reloadData];
    }else{
        
        [self getFacebook];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    //[self getAllUser];
    [self performSelector:@selector(getAllUser) withObject:nil afterDelay:0.2];
}
-(IBAction)backAction:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getAllUser{
    
    NSString *strSearch;
   
    if ([tfSearch.text length]==0) {
        strSearch=@"";
    }
    
    searchData=[NSString stringWithFormat:@"user_id=%@&full_name=%@&gender=&last_id=%@",userId,strSearch,last_Id];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:searchData servicename:@"users/searchUser" serviceType:@"POST"];

}

-(void)getAllContactUser{
    

    NSString * result = [[arrPhone valueForKey:@"description"] componentsJoinedByString:@","];
    NSString *datastring=[NSString stringWithFormat:@"user_id=%@&phone=%@",userId,result];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:datastring servicename:@"users/getUsersByPhone" serviceType:@"POST"];
    
}
-(IBAction)followAction:(UIButton*)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    FindpepleTableViewCell *cell=(FindpepleTableViewCell *)superView1;
    NSIndexPath *indexPath= [tblFind indexPathForCell:cell];
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrFind objectAtIndex:indexPath.row]];
    int status=[[oldDic valueForKey:@"is_friend"] intValue];
    if (status==0) {
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"is_friend"];
        [arrFind replaceObjectAtIndex:indexPath.row withObject:dic];

       NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithDictionary:[arrFind objectAtIndex:indexPath.row]];
    
    NSString *strTime=[self getCurrentDate];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,[Dic valueForKey:@"id"],strTime];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }
}

-(IBAction)followOnPhoneAction:(UIButton*)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    PhoneContactTableViewCell *cell=(PhoneContactTableViewCell *)superView1;
    NSIndexPath *indexPath= [tblInvite indexPathForCell:cell];
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrContact objectAtIndex:indexPath.row]];
    NSMutableDictionary *valuedict=[[NSMutableDictionary alloc] initWithDictionary:[self checkuser:[oldDic valueForKey:@"Phone"]]];
    int status=[[valuedict valueForKey:@"is_friend"] intValue];
    if (status==0) {
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        [valuedict setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"is_friend"];
        
        NSString *strTime=[self getCurrentDate];
        NSString *otherUserId=[self getUserIdPhone:[oldDic valueForKey:@"Phone"]];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,otherUserId,strTime];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }
}
-(IBAction)followOnFacebookAction:(UIButton*)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    id superView1 = sender.superview;
    while (superView1 && ![superView1 isKindOfClass:[UITableViewCell class]]) {
        superView1 = [superView1 superview];
    }
    
    FindpepleTableViewCell *cell=(FindpepleTableViewCell *)superView1;
    NSIndexPath *indexPath= [tblInvite indexPathForCell:cell];
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrFacebook objectAtIndex:indexPath.row]];
    int status=[[oldDic valueForKey:@"is_friend"] intValue];
    if (status==0) {
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"is_friend"];
        [arrFacebook replaceObjectAtIndex:indexPath.row withObject:dic];
        
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithDictionary:[arrFacebook objectAtIndex:indexPath.row]];
        
        NSString *strTime=[self getCurrentDate];
        NSString *otherUserId=[self getUserId:[Dic valueForKey:@"id"]];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@&date_time=%@",userId,otherUserId,strTime];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }
}

-(IBAction)inviteFriend:(UIButton*)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    FindpepleTableViewCell *cell=(FindpepleTableViewCell*)[tblFind cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrFind objectAtIndex:indexPath.row]];
    NSString *status=[NSString stringWithFormat:@"%@",[oldDic valueForKey:@"friendStatus"]];
    if ([status isEqualToString:@"2"]) {
        [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        cell.lblFriend.hidden=YES;
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        [dic setObject:@"0" forKey:@"friendStatus"];
        [arrFind replaceObjectAtIndex:indexPath.row withObject:dic];
        
    }else{
        [btn setUserInteractionEnabled:NO];
        // cell.lblFriend.hidden=NO;
        [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
        
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        [dic setObject:@"2" forKey:@"friendStatus"];
        [arrFind replaceObjectAtIndex:indexPath.row withObject:dic];
        
      
    }
    
    
    
}
-(void)getSyncView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwSync setFrame:CGRectMake(0, 0, vwSync.frame.size.width, vwSync.frame.size.height)];
    [UIView commitAnimations];
}
-(IBAction)SyncMyContact:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"SyncContact"];
    [self getPhoneNO:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwSync setFrame:CGRectMake(0, self.view.frame.size.height, vwSync.frame.size.width, vwSync.frame.size.height)];
    [UIView commitAnimations];
    
}
-(IBAction)notNow:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwSync setFrame:CGRectMake(0, self.view.frame.size.height, vwSync.frame.size.width, vwSync.frame.size.height)];
    [UIView commitAnimations];
    
    [btnInvitePeople setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1]];
    [btnInvitePeople setTintColor:[UIColor whiteColor]];
    [btnInvitePeople setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFindPeople setBackgroundColor:[UIColor whiteColor] ];
    [btnFindPeople setTitleColor:[UIColor colorWithRed:235.0/255.0 green:68.0/255.0 blue:1.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    [tblFind reloadData];
    tblInvite.hidden=YES;
    vwInvite.hidden=YES;
    //vwSearch.hidden=YES;
    vwSocial.hidden=YES;
    vwSearch.hidden=NO;
    tblFind.hidden=NO;

    
}
-(IBAction)facebookInvite:(id)sender{
    //[self facebookPost:self];
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1239811496039270"];
    //optionally set previewImageURL
   // content.appInvitePreviewImageURL = [NSURL URLWithString:@"http://echollection.imnwebhosting.com/images/echocollection.png"];
    
    [FBSDKAppInviteDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog
       didFailWithError:(NSError *)error{
    
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog
 didCompleteWithResults:(NSError *)error{
    
}
-(IBAction)indexChanged:(UISegmentedControl *)sender
{
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
            
            break;
        case 1:
            
            break;
        default:
            break;
    }
}
-(IBAction)getPhoneNO:(id)sender{
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL)
    { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
}
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    arrContact = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[[NSMutableDictionary alloc]init];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        NSString *firstname=(__bridge_transfer NSString *)firstName;
        NSString *lastname = (__bridge_transfer NSString *)lastName;
        
        
        //NSString *lastname=(__bridge NSString *)lastName;
        //NSString *firstname=(__bridge NSString *)firstName;
        
        if (lastname.length<=0) {
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ ",firstname] forKey:@"name"];
        }
        else{
            [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        }
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0)
        {
            [dOfPerson setObject:(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        CFRelease(eMail);
        //For Phone number
        NSString* mobileLabel;
        
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            mobileLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(__bridge_transfer NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
            }
            else if ([mobileLabel isEqualToString:(__bridge_transfer NSString *)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                break ;
            }
            
        }
        CFRelease(phones);
        [arrContact addObject:dOfPerson];
        
    }
    CFRelease(allPeople);
    //NSLog(@"Contacts = %@",arrContact);
    tblInvite.hidden=NO;
    
    [tblInvite reloadData];
    
    arrPhone=[[NSMutableArray alloc] initWithArray:[arrContact valueForKey:@"Phone"]];
    [arrPhone removeObjectIdenticalTo:[NSNull null]];
    [self getAllContactUser];
    //[self getAppUser:arrPhone];
    if (arrContact.count!=0) {
        arrSelected=[[NSMutableArray alloc] init];
        for (int i=0; i<[arrContact count]; i++) {
            [arrSelected addObject:@"0"];
        }
    }
    
    
}
-(NSDictionary*)checkuser:(NSString*)phone{
    NSDictionary *dict=[[NSDictionary alloc] init];
    for (int i=0; i<arrUsers.count; i++) {
        NSDictionary *dic=[arrUsers objectAtIndex:i];
        if ([phone isEqualToString:[dic valueForKey:@"phone"]]) {
            return dic;
            break;
        }
    }
    return dict;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {

        return arrFind.count;
    
    }else{
        if (isFacebook) {
           return arrFacebook.count;
        }else{
            if (arrUsers.count>0) {
                return arrContact.count;
            }else{
                return 0;
            }
        }
        
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"CellIdentifier";
    FindpepleTableViewCell *cell=(FindpepleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell=nil;
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"FindpepleTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    if (tableView.tag==1) {
        NSDictionary *dic;
        if (isSearching) {
            dic=[arrFind objectAtIndex:indexPath.row];
        }else{
            dic=[arrFind objectAtIndex:indexPath.row];
        }
        
        cell.lblName.text=[dic valueForKey:@"full_name"];
        cell.lblUserName.text=[dic valueForKey:@"username"];
        BOOL isFollow=[[dic valueForKey:@"is_friend"] boolValue];
        if (isFollow) {
            //cell.btnFollow.hidden=YES;
            [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        }else{
           // cell.btnFollow.hidden=NO;
            [cell.btnFollow addTarget:self action:@selector(followAction:)forControlEvents:UIControlEventTouchUpInside];
            [cell.btnFollow setTag:indexPath.row];
            [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
        }
        
        
        NSString *imgUrl=[dic valueForKey:@"user_image"];
        
        if ([imgUrl length]==0) {
            cell.img.image=[UIImage imageNamed:@"no-profile"];
        }else{
            [cell.indicator startAnimating];
            [self setImageWithurl:imgUrl andImageView:cell.img and:cell.indicator];
        }
        cell.img.layer.cornerRadius =5;
        cell.img.layer.masksToBounds = YES;
        cell.btnInvite.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        
        if (isFacebook==YES) {
            
            static NSString *cellIdentifier=@"CellIdentifier";
            FindpepleTableViewCell *cell=(FindpepleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell=nil;
            if (cell==nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"FindpepleTableViewCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
            }
            
                NSDictionary *dic=[arrFacebook objectAtIndex:indexPath.row];
                NSString *imgfb=[[[dic valueForKey:@"picture"]  valueForKey:@"data"] valueForKey:@"url"];
                [self setImageWithurl:imgfb andImageView:cell.img and:cell.indicator];
                cell.lblName.text=[dic valueForKey:@"name"];
               NSDictionary *userdict=[self getUsername:[dic valueForKey:@"id"]];
              if(userdict){
                 cell.lblUserName.text=[userdict valueForKey:@"username"];
              }
                BOOL isAppUser=[self chekisExisting:[dic valueForKey:@"id"]];
            
                 if (isAppUser) {
                     cell.btnInvite.hidden=YES;
                     //BOOL isFollow=[[dic valueForKey:@"is_friend"] boolValue];
                     BOOL isFollow=[self chekisFriend:[dic valueForKey:@"id"]];
                     if (isFollow) {
                         //cell.btnFollow.hidden=YES;
                         [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
                     }else{
                         // cell.btnFollow.hidden=NO;
                         [cell.btnFollow addTarget:self action:@selector(followOnFacebookAction:)forControlEvents:UIControlEventTouchUpInside];
                         [cell.btnFollow setTag:indexPath.row];
                         [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
                     }
                 }else{
                     cell.btnInvite.hidden=NO;
                 }
            
                cell.img.layer.cornerRadius =5;
                cell.img.layer.masksToBounds = YES;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
        }else{
            static NSString *cellIdentifier=@"CellIdentifier";
            PhoneContactTableViewCell *tcell=(PhoneContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            tcell=nil;
            if (tcell==nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PhoneContactTableViewCell" owner:self options:nil];
                tcell=[nib objectAtIndex:0];
                
            }
            NSDictionary *dic=[arrContact objectAtIndex:indexPath.row];
            NSString *name=[dic valueForKey:@"name"];
            NSString *phone=[dic valueForKey:@"Phone"];
            
            if ([name isEqualToString:@"(null)"]) {
                
            }else{
                tcell.lblName.text=[dic valueForKey:@"name"];
                
            }
            if ([phone isEqualToString:@"(null)"]) {
                
            }else{
                tcell.lblEmail.text=[dic valueForKey:@"Phone"];
            }
            
            NSDictionary *dict=[self checkuser:[dic valueForKey:@"Phone"]];
            if (dict.count!=0) {
                tcell.btnInvite.hidden=YES;
                tcell.btnFollow.hidden=NO;
                BOOL isFollow=[[dict valueForKey:@"is_friend"] boolValue];
                if (isFollow) {
                    //cell.btnFollow.hidden=YES;
                    [tcell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
                }else{
                    // cell.btnFollow.hidden=NO;
                    [tcell.btnFollow addTarget:self action:@selector(followOnPhoneAction:)forControlEvents:UIControlEventTouchUpInside];
                    [tcell.btnFollow setTag:indexPath.row];
                    [tcell.btnFollow setBackgroundImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
                }
                //[tcell.btnInvite setBackgroundImage:[UIImage imageNamed:@"round_bg_y"] forState:UIControlStateNormal];
            }else{
                tcell.btnInvite.hidden=NO;
                tcell.btnFollow.hidden=YES;
            }
            
            tcell.btnInvite.layer.cornerRadius =5;
            tcell.btnInvite.layer.masksToBounds = YES;
            
            tcell.selectionStyle=UITableViewCellSelectionStyleNone;
            tcell.selectionStyle=UITableViewCellSelectionStyleNone;
            return tcell;
        }
        
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic;
    if (tableView.tag==2) {
        
        if (isFacebook) {
            
            NSDictionary *dic=[arrFacebook objectAtIndex:indexPath.row];
            NSDictionary *userdict=[self getUsername:[dic valueForKey:@"id"]];
            if(userdict.count>0){
           // [dic setObject:[dic valueForKey:@"id"] forKey:@"user_id"];
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
            vc.OtherUserdic=userdict;
            [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        
    }else{
       
      dic = [[NSMutableDictionary alloc] initWithDictionary:[arrFind objectAtIndex:indexPath.row]];
      
        [dic setObject:[dic valueForKey:@"id"] forKey:@"user_id"];
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.OtherUserdic=dic;
        [self.navigationController pushViewController:vc animated:YES];

    }
    

}
-(IBAction)sendSMS:(NSString*)phoneNO {
    
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = @"I just found this amazing app to collect, manage and share quoteable phrases. Check out www.Echollection.com!";
        controller.recipients = [NSArray arrayWithObjects:phoneNO, nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch(result) {
        case MessageComposeResultCancelled:
            // user canceled sms
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            // user sent sms
            //perhaps put an alert here and dismiss the view on one of the alerts buttons
            break;
        case MessageComposeResultFailed:
            // sms send failed
            //perhaps put an alert here and dismiss the view when the alert is canceled
            break;
        default:
            break;
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}
-(IBAction)DoneAction:(id)sender{
    
    [tfSearch resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [filteredContentList removeAllObjects];
    
    if([textField.text length] != 0) {
        isSearching = YES;
        NSLog(@"Text  - %@",textField.text);
        [self searchTableList:textField.text];
    }else if ([textField.text length]== 0){
      [self getAllUser];  
    }
    else {
        isSearching = NO;
    }
    [tblFind reloadData];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text length]==0) {
        isSearching=NO;
        [tblFind reloadData];
    }
    [textField resignFirstResponder];
    [tfSearch resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)searchAction:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [self searchTableList:tfSearch.text];
    [tfSearch resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    // [self searchTableList:searchBar.text];
    //  [searchBar resignFirstResponder];
}

- (void)searchTableList:(NSString*)string {
    //NSString *searchString = searchBar.text;
    NSLog(@"Text change - %@",string);
    NSLog(@"Text ****  - %@",string);
    
    
    if ([string length]>=2) {
        [self performSelector:@selector(searchUser:) withObject:string afterDelay:0.2];
         
        }
        
    
    
  /*  for (NSDictionary *dic in arrFind) {
        NSString *tempStr=[dic valueForKey:@"fullname"];
        if (string.length<=tempStr.length) {
            NSComparisonResult result = [tempStr compare:string options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [string length])];
            if (result == NSOrderedSame) {
                [filteredContentList addObject:dic];
            }
        }
    }*/
}
-(void)getAppUser:(NSArray*)arr{
   // NSString *phone = [[arr valueForKey:@"description"] componentsJoinedByString:@","];
   // NSString *dataString = [NSString stringWithFormat:@"auth=fcea920f7412b5da7be0cf42b8c93759&action=checkcontactList&phone=%@&user_id=2=%@",phone,userId];
   // [self ServiceCall:@"getAppUser" :dataString];
    
}
-(void)searchUser:(NSString *)author{
  //  indicator.hidden=NO;
  //  [indicator startAnimating];
   
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&full_name=%@&gender=&last_id=%@",userId,author,last_Id];
    
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/searchUser" serviceType:@"POST"];
    
    
}
-(BOOL)checkAppUserbyPhoneNo:(NSString*)phoneNo{
    NSString *temp=[phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog (@"Result: %@", temp);
    for (int i=0; i<arrAppUser.count; i++) {
        NSDictionary*dic=[arrAppUser objectAtIndex:i];
        if ([[dic valueForKey:@"phone"] isEqualToString:temp]) {
            return YES;
        }
        
    }
    return NO;
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
    // [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
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

#pragma mark facebookLogin

-(IBAction)facebookLoginAction:(id)sender
{
    if (!accountStore) accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *fbActType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             FbAppId, ACFacebookAppIdKey,[NSArray arrayWithObject:@"email"] , ACFacebookPermissionsKey,
                             nil];
    
    
    [accountStore requestAccessToAccountsWithType:fbActType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            //Success to get the user information
            NSArray *accounts = [accountStore accountsWithAccountType:fbActType];
            faceBookAc = [accounts lastObject];
            // [self getUserInfo];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               
                               
                               [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
                               FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                               login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
                               [login logInWithReadPermissions:@[@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                   if (error)
                                   {
                                       // Process error
                                       
                                       
                                   }
                                   else if (result.isCancelled)
                                   {
                                       // Handle cancellations
                                       
                                       
                                   }
                                   else
                                   {
                                       
                                       
                                       [self getFacebookProfile:result.token];
                                   }
                                   [login logOut];
                               }];
                               
                               
                           });
            
            
        }
    }
     ];
    
    
}

- (void)getFacebookProfile: (FBSDKAccessToken *)token
{
    NSString *urlString = [NSString
                           stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",
                           token.tokenString];
    
    NSURL *feedURL = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:feedURL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:100];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if(response1!=nil && requestError==nil)
    {
        
        [self cancelButtonAction:response1];
    }
    else
    {
        //  [self buttonUserIneration:true];
        
        [[[UIAlertView alloc]initWithTitle:@"Cannot Proceed" message:@"There are some unknown error occurred logging in with facebook, Please reenable facebook service in iPhone settings for this application and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show ];
    }
}
-(void)cancelButtonAction:(NSData *)responseData
{
    NSMutableDictionary *DictUser=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil]];
    
    NSLog(@"fb details-%@",DictUser);
    
    
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/searchUser"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
           
            arrFind=[data valueForKey:@"all_users"];
            [tblFind reloadData];
            
        }
        
    }else if([serviceName isEqualToString:@"users/getUsersByPhone"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
           
            arrUsers=[data valueForKey:@"usersList"];
            [tblInvite reloadData];
            
        }
    }else if([serviceName isEqualToString:@"users/getUsersByfacebook"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            arrAppFbUser=[data valueForKey:@"usersList"];
            [tblInvite reloadData];
            
        }
    }else if([serviceName isEqualToString:@"users/follow"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            
            
        }
    }
}


-(void)moveToTabBarController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC =(UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:myVC animated:YES];
}
-(void)getFacebook{

    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:@"me/friends"
                                               parameters:@{@"fields": @"id, name,picture, email"}
                                               HTTPMethod:@"GET"];
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                       id result,
                                                       NSError *error) {
                     NSLog(@"result is:%@",result);
                     userDetailsDic=[[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)result];
                     arrFacebook=[[NSMutableArray alloc] initWithArray:[userDetailsDic valueForKey:@"data"]];
                     [self checkAllFbuser:arrFacebook];
                     // [tblInvite reloadData];
                 }];
        
        
    }else{
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [login
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends",@"user_birthday", ]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error: %@",error);
                 //[self showOnlyAlert:@"Sorry" :@"We cannot fetch this user's credential from facebook, Please try with another user."];
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:@"me/friends"
                                               parameters:@{@"fields": @"id, name, email"}
                                               HTTPMethod:@"GET"];
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                       id result,
                                                       NSError *error) {
                 NSLog(@"Logged in");
                 [self fetchUserInfo];
                 userDetailsDic=(NSDictionary*)result;
                 arrFacebook=[[NSMutableArray alloc] initWithArray:[userDetailsDic valueForKey:@"data"]];
                 [self checkAllFbuser:arrFacebook];
                 //[tblInvite reloadData];
                 
                  }];
             }
         }];
    }
    
}
-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        
        
        
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"me/friends"
                                      parameters:@{@"fields": @"id, name, email"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            NSLog(@"result is:%@",result);
            userDetailsDic=[[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)result];
        }];
        
        
    }
    
}
- (void) clearFBCache
{
    [FBSDKProfile setCurrentProfile:[FBSDKProfile new]];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        if([[cookie domain] isEqualToString:@"facebook"]) {
            
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}
-(void)checkAllFbuser:(NSArray*)arr{
    NSArray *temp=[arr valueForKey:@"id"];
    NSString * result = [[temp valueForKey:@"description"] componentsJoinedByString:@","];
    NSString *datastring=[NSString stringWithFormat:@"user_id=%@&fb_id=%@",userId,result];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:datastring servicename:@"users/getUsersByfacebook" serviceType:@"POST"];
}
-(BOOL)chekisExisting:(NSString*)FbId{
    
    if (arrAppFbUser.count>0) {
        for (int i=0; i<arrAppFbUser.count; i++) {
            NSString *temp=[[arrAppFbUser objectAtIndex:i] valueForKey:@"fb_user_id"];
            if ([temp isEqualToString:FbId]) {
                 return YES;
            }
        }
        // /id
        return NO;
    }else{
        return NO;
    }
    return NO;
}
-(NSDictionary*)getUsername:(NSString*)FbId{
    
    NSDictionary *dict;
    if (arrAppFbUser.count>0) {
        for (int i=0; i<arrAppFbUser.count; i++) {
           NSDictionary* tempDict=[arrAppFbUser objectAtIndex:i];
            NSString *temp=[[arrAppFbUser objectAtIndex:i] valueForKey:@"fb_user_id"];
            if ([temp isEqualToString:FbId]) {
               return  dict=tempDict;
            }
        }

    }
    return dict;
}
-(BOOL)chekisFriend:(NSString*)FbId{
    
    if (arrAppFbUser.count>0) {
        for (int i=0; i<arrAppFbUser.count; i++) {
            NSDictionary *dict=[arrAppFbUser objectAtIndex:i];
            NSString *temp=[[arrAppFbUser objectAtIndex:i] valueForKey:@"fb_user_id"];
            if ([temp isEqualToString:FbId]) {
                BOOL isFriend=[[dict valueForKey:@"is_friend"] boolValue];
                if (isFriend==YES) {
                    return YES;
                }else{
                   return NO;
                }
            }
        }
        // /id
        return NO;
    }else{
        return NO;
    }
    return NO;
}

-(NSString*)getUserId:(NSString*)FbId{
    
    if (arrAppFbUser.count>0) {
        for (int i=0; i<arrAppFbUser.count; i++) {
           // NSDictionary *dict=[arrAppFbUser objectAtIndex:i];
            NSString *temp=[[arrAppFbUser objectAtIndex:i] valueForKey:@"fb_user_id"];
            if ([temp isEqualToString:FbId]) {
               
                return  [[arrAppFbUser objectAtIndex:i] valueForKey:@"user_id"];
            }
        }
    }
    return @"0";
}
-(NSString*)getUserIdPhone:(NSString*)phone{
    
    if (arrUsers.count>0) {
        for (int i=0; i<arrUsers.count; i++) {
            // NSDictionary *dict=[arrAppFbUser objectAtIndex:i];
            NSString *temp=[[arrUsers objectAtIndex:i] valueForKey:@"phone"];
            if ([temp isEqualToString:phone]) {
                
                return  [[arrUsers objectAtIndex:i] valueForKey:@"user_id"];
            }
        }
    }
    return @"0";
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
