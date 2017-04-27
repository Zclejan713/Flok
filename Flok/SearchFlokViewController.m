//
//  SearchFlokViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 23/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "SearchFlokViewController.h"
#import "SearchFlokTableViewCell.h"
#import "FindpepleTableViewCell.h"
#import "WebImageOperations.h"
#import "OtherUserFlok.h"
#import "OtherUserViewController.h"
#import "HashTagFeed.h"
@interface SearchFlokViewController (){

  NSTimer *searchTimer;

}

@end

@implementation SearchFlokViewController
@synthesize tfSearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"SearchFlokViewController");
    
    [tfSearch becomeFirstResponder];
    
    [tfSearch addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    tblMain.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self performSelector:@selector(searchApiCall:) withObject:tfSearch.text afterDelay:0.2];
}
-(void)textFieldDidChange :(UITextField *)textField{
    
    // if a timer is already active, prevent it from firing
    if (searchTimer != nil) {
        [searchTimer invalidate];
        searchTimer = nil;
    }
    
    // reschedule the search: in 1.0 second, call the searchForKeyword: method on the new textfield content
    searchTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                   target: self
                                                 selector: @selector(searchForKeyword:)
                                                 userInfo: tfSearch.text
                                                  repeats: NO];
    
}

- (void) searchForKeyword:(NSTimer *)timer
{
    [arrFlok removeAllObjects];
    [arrUser removeAllObjects];
     NSLog(@"keyword-----%@",tfSearch.text);
    [self performSelector:@selector(searchApiCall:) withObject:tfSearch.text afterDelay:0.2];
    
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

#pragma mark- Textfield delegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    NSLog(@"11111111");
//    return YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    
//    if([textField.text length] != 0) {
//        isSearching = YES;
//        
//         NSLog(@"Text isssssss  - %@",textField.text);
//        [self searchTableList:textField.text];
//
//    }
//    else {
//        isSearching = NO;
//    }
//    [tblMain reloadData];
//    return YES;
//}
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    
//      NSLog(@"2222222");
//    
//    if ([textField.text length]==0) {
//        isSearching=NO;
//        [tblMain reloadData];
//    }
//    [textField resignFirstResponder];
//    [tfSearch resignFirstResponder];
//    return YES;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
     return YES;
}
-(IBAction)searchAction:(id)sender{
    
    [self searchTableList:tfSearch.text];
     //[tfSearch resignFirstResponder];
}

- (void)searchTableList:(NSString*)string {
    //NSString *searchString = searchBar.text;
    NSLog(@"Text change - %@",string);
    NSLog(@"Text ****  - %@",string);
    
    
    if ([string length]>=2) {
        [self performSelector:@selector(searchApiCall:) withObject:string afterDelay:0.2];
        
    }
}
-(void)searchApiCall:(NSString*)text{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"key=%@&user_id=%@",text,userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/searchAll" serviceType:@"POST"];
}

#pragma mark UITableView-delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isHashtag==YES) {
        return 3;
    }else{
      return 3;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0)
    {
        return [arrHashTag count];
    }
    else if (section==1)
    {
        return [arrFlok count];
    }
    else{
        return [arrUser count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 44;//[arrFlok count];
    }else if (indexPath.section==1)
    {
        return 44;
    }
    else{
        return 55;//[arrUser count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }else{
        return 22;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    /* Create custom view to display section header... */
   
    //NSString *string =[list objectAtIndex:section];
    /* Section header is in 0th index... */
    //[label setText:string];
    //[view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]]; //your background color...
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
        static NSString *cellIdentifier=@"tcell";
        SearchFlokTableViewCell *cell=(SearchFlokTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SearchFlokTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            
        }
       // NSDictionary *dict=[arrHashTag objectAtIndex:indexPath.row];
        cell.lblTitle.text=[arrHashTag objectAtIndex:indexPath.row];
        cell.imgIcon.image=[UIImage imageNamed:@"icon"];
        return cell;
    }else if (indexPath.section==1) {
        static NSString *cellIdentifier=@"tcell";
        SearchFlokTableViewCell *cell=(SearchFlokTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SearchFlokTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            
        }
        NSDictionary *dict=[arrFlok objectAtIndex:indexPath.row];
        cell.lblTitle.text=[dict valueForKey:@"title"];
        
        return cell;
    }
    else {
        static NSString *cellIdentifier=@"tcell";
        FindpepleTableViewCell *cell=(FindpepleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"FindpepleTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            
        }
         NSDictionary *dic=[arrUser objectAtIndex:indexPath.row];
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
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        //NSDictionary *dict=[arrFlok objectAtIndex:indexPath.row];
        HashTagFeed *vc=(HashTagFeed*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HashTagFeed"];
        vc.hashtag=[arrHashTag objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1) {
        
        NSDictionary *dict=[arrFlok objectAtIndex:indexPath.row];
        OtherUserFlok *vc=(OtherUserFlok*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"OtherUserFlok"];
        vc.flokId=[dict valueForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        NSDictionary *dict=[arrUser objectAtIndex:indexPath.row];
         NSLog(@"ki ase dekhi-----%@",dict);
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.OtherUserdic=dict;
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
    
    FindpepleTableViewCell *cell=(FindpepleTableViewCell *)superView1;
    
    
    NSIndexPath *indexPath= [tblMain indexPathForCell:cell];
    
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:[arrUser objectAtIndex:indexPath.row]];
    
    
    int status=[[oldDic valueForKey:@"is_friend"] intValue];
    if (status==0) {
        [cell.btnFollow setBackgroundImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"is_friend"];
        [arrUser replaceObjectAtIndex:indexPath.row withObject:dic];
        
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithDictionary:[arrUser objectAtIndex:indexPath.row]];
        
         NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&follow_id=%@",userId,[Dic valueForKey:@"user_id"]];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/follow" serviceType:@"POST"];
    }
}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/searchAll"])
    {
         NSLog(@"data------%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            NSArray *arr1=[data valueForKey:@"allFloks"];
            NSArray *arr2=[data valueForKey:@"all_users"];
           // NSDictionary *dd=[[NSDictionary alloc] initWithDictionary:[data valueForKey:@"alltags"]]
            NSArray *arr3=[[NSArray alloc] initWithArray:[data valueForKey:@"alltags"]] ;
            
            
            if ([arr1 count]) {
                arrFlok=[[NSMutableArray alloc] initWithArray:arr1];

            }
            else{
                arrFlok=[[NSMutableArray alloc] init];

            }
            
            if ([arr2 count]) {
                arrUser=[[NSMutableArray alloc] initWithArray:arr2];
                
            }
            else{
                arrUser=[[NSMutableArray alloc] init];
                
            }
            
            if ([arr3 count]) {
                NSDictionary *dd=[[NSDictionary alloc] initWithDictionary:[arr3 objectAtIndex:0]];
                arrHashTag=[[NSMutableArray alloc] initWithArray:[dd valueForKey:@"hashtag"]];
                isHashtag=YES;
                
            }
            else{
                arrHashTag=[[NSMutableArray alloc] init];
                isHashtag=NO;
                
            }
            [tblMain reloadData];
        }
        else{
            arrFlok=arrUser=[[NSMutableArray alloc] init];

        }
        [tblMain reloadData];
        //[tfSearch resignFirstResponder];

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
