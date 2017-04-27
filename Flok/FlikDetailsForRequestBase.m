//
//  FlikDetailsForRequestBase.m
//  Flok
//
//  Created by NITS_Mac3 on 19/10/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "FlikDetailsForRequestBase.h"
#import "OtheruserflokCell.h"
#import "ChatPage.h"
#import "WebImageOperations.h"
#import "ChatViewController.h"
#import "JoinedMemberViewController.h"
#import "OtherUserViewController.h"
static CGFloat contractedSmallHeight=44;
static CGFloat commentFrame;
static CGFloat frameWidth;


@implementation FlikDetailsForRequestBase{






}
@synthesize flokId;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"FlikDetailsForRequestBase");
    
    self.view.backgroundColor=[UIColor clearColor];
    btnView.layer.cornerRadius=4;
    btnView.layer.borderWidth=0.5;
    btnView.layer.borderColor=appOrange.CGColor;
    imgBgBanner.hidden=YES;
    vwTransparent.hidden=YES;
    
    tfComment.text=@"Your comment";
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    //[self getCommentAPI];
    
    [self performSelector:@selector(getProfileInfo)  withObject:nil afterDelay:0.3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    
    UIView *accessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    accessoryView.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btnDone=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 63, 40)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(DoneAction:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [accessoryView addSubview:btnDone];
    tfComment.inputAccessoryView=accessoryView;

    [self getFlokDetails];
    
    vwMain.autoresizingMask =(UIViewAutoresizingFlexibleLeftMargin |
                              UIViewAutoresizingFlexibleRightMargin);
    vwMain.hidden=YES;
    
    if (IS_IPHONE_4) {
        frameWidth=27;
    }
    else if (IS_IPHONE_5) {
        frameWidth=30;
    }
    else if (IS_IPHONE_6){
        frameWidth=35;
    }
    else if (IS_IPHONE_6Plus){
        frameWidth=38;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(IBAction)DoneAction:(id)sender{
    [tfComment resignFirstResponder];
}
-(IBAction)cancelZoomImage:(id)sender{
    imgBgBanner.hidden=YES;
    vwTransparent.hidden=YES;
}
-(IBAction)ZoomCoverImage:(id)sender{
    imgBgBanner.hidden=NO;
    vwTransparent.hidden=NO;
}
#pragma mark- Method
- (IBAction)backTap:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)chatTap:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    if (![userId isEqualToString:[DicFlok valueForKey:@"user_id"]]) {
        ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
        vc.dataDic=DicFlok;
        vc.strFriendId=[DicFlok valueForKey:@"user_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)searchTap:(id)sender {
}

- (IBAction)featherTap:(UIButton *)sender {
}

- (IBAction)viewPhtTap:(UIButton *)sender {
    
    imgBgBanner.hidden=NO;
    vwTransparent.hidden=NO;
}
-(IBAction)viewProfile:(id)sender{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
    vc.OtherUserdic=DicFlok;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)joinfolkTap:(id)sender {
    
    
    BOOL access_type=[[DicFlok valueForKey:@"is_access"] boolValue];
    if (access_type==1) {
       
        NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@",[DicFlok valueForKey:@"id"],userId];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/joinFlok" serviceType:@"POST"];
        

    }else{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"This flok is request-based" message:@"Do you want to request to join? Your profile will be submitted to the poster." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        [alert show];
        
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        //UIButton *btn=(UIButton*)sender;
        //[Global disableAfterClick:btn];
        
        NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@",[DicFlok valueForKey:@"id"],userId];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/joinFlok" serviceType:@"POST"];
    }
    // else do your stuff for the rest of the buttons (firstOtherButtonIndex, secondOtherButtonIndex, etc)
}


    
    
    /* ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
     
     [self.navigationController pushViewController:vc animated:YES];*/


- (IBAction)showJoinMember:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    JoinedMemberViewController *vc=(JoinedMemberViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JoinedMemberViewController"];
    vc.FlokId=[DicFlok valueForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)locationTap:(UIButton *)sender {
}

#pragma mark- Table delegate & datasource
- (CGSize)findHeightForText:(NSString* )text havingSize:(CGSize)frameSize andFont:(UIFont *)font {
    
    CGFloat widthValue=frameSize.width;
    CGFloat heightValue=frameSize.height;
    CGSize size = CGSizeZero;
    if (text)
    {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    if(size.height<heightValue)
    {
        size.height=heightValue;
    }
    else
    {
        size.height=size.height+10;
    }
    return size;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblvw)
    {
        return arrMain.count+1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        //return 340;
        return 272;
    }else{
        
        if ([arrMain count])
        {
            
            NSDictionary *tempdic=[arrMain objectAtIndex:indexPath.row-1];
            NSString *str =[tempdic valueForKey:@"uploaded_by"];
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
            CGSize maximumSize = CGSizeMake(252, MAXFLOAT);
            CGSize strSize = [str sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
            strSize=CGSizeMake(maximumSize.width, strSize.height);
            
            if (strSize.height<15) {
                return 79+strSize.height+5;
            }else{
                return 79+strSize.height;
            }
            
        }
        return 79;
    }
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellIdentifier=@"CellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell=nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        //  [vwMain setFrame:CGRectMake(0, 0, self.view.frame.size.width, 362)];
        [cell.contentView addSubview:vwMain];
        //  [vwMain setUserInteractionEnabled:YES];
        [vwComment setUserInteractionEnabled:YES];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //[cell.contentView setBackgroundColor:[UIColor grayColor]];
        return cell;
    }else{
        static NSString *cellIdentifier=@"tcell";
        OtheruserflokCell *cell=(OtheruserflokCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell=[[NSBundle mainBundle]loadNibNamed:@"OtheruserflokCell" owner:self options:nil][0];
        cell=nil;
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"OtheruserflokCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        if ([arrMain count])
        {
            NSDictionary *dict=arrMain[indexPath.row-1];
            cell.lblName.text=[NSString stringWithFormat:@"%@",dict[@"user_name"]];
            // cell.lblTime.text=[NSString stringWithFormat:@"%@",dict[@"date_time"]];
            cell.tvDesc.text=[NSString stringWithFormat:@"%@",dict[@"uploaded_by"]];
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
            CGSize maximumSize = CGSizeMake(252, MAXFLOAT);
            CGSize strSize = [cell.tvDesc.text sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
            strSize=CGSizeMake(maximumSize.width, strSize.height);
            
            
            
            NSString *strText=cell.tvDesc.text;
            
            
            UIFont *myfont=cell.tvDesc.font;
            myfont=[UIFont systemFontOfSize:12];
            CGRect tvFrame=cell.tvDesc.frame;
            tvFrame.size.height=[self findHeightForText:strText havingSize:cell.tvDesc.frame.size andFont:myfont].height;
            cell.tvDesc.frame=tvFrame;
            
            CGRect frameTime=cell.lblTime.frame;
            frameTime.origin.y=frameTime.origin.y+strSize.height;
            cell.lblTime.frame=frameTime;
            
            
            CGRect frmbg=cell.vwBg.frame;
            frmbg.size.height=cell.vwBg.frame.size.height+strSize.height;
            cell.vwBg.frame=frmbg;
            
            CGRect frameSeparator=cell.lblSeparator.frame;
            frameSeparator.origin.y=frameSeparator.origin.y+strSize.height;
            cell.lblSeparator.frame=frameSeparator;
            
            [self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:cell.imgv  and:nil];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblvw)
    {
        
    }
    
}
#pragma mark- Textview delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([tfComment.text isEqualToString:@"Your comment"]) {
        tfComment.text = @"";
        tfComment.textColor = [UIColor blackColor];
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        if ([textView.text length]==0) {
            CGRect frame=textView.frame;
            frame.size.height=34;
            textView.frame=frame;
            
            CGRect vwframe=vwComment.frame;
            vwframe.size.height=60;
            vwframe.origin.y=commentFrame;
            vwComment.frame=vwframe;
            
            [textView resignFirstResponder];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                          self.view.frame.size.width, self.view.frame.size.height);
            
            vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height-vwComment.frame.size.height ,vwComment.frame.size.width,vwComment.frame.size.height);
            
            CGRect frameTbl=tblvw.frame;
            frameTbl.size.height=frameTbl.size.height+keyHeight;
            tblvw.frame=frameTbl;
            [UIView commitAnimations];
            isKeyOpen=NO;
            [textView resignFirstResponder];
        }else{
            [textView resignFirstResponder];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                          self.view.frame.size.width, self.view.frame.size.height);
            
            vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height-vwComment.frame.size.height ,vwComment.frame.size.width,vwComment.frame.size.height);
            
            CGRect frameTbl=tblvw.frame;
            frameTbl.size.height=frameTbl.size.height+keyHeight;
            tblvw.frame=frameTbl;
            [UIView commitAnimations];
            isKeyOpen=NO;
        }
        
        
        return YES;
    }
    
    
    
    if ([textView.text length]<frameWidth) {
        CGRect frame=textView.frame;
        frame.size.height=34;
        textView.frame=frame;
        
        CGRect vwframe=vwComment.frame;
        vwframe.size.height=60;
        vwframe.origin.y=commentFrame;
        vwComment.frame=vwframe;
        stageOne=NO;
        stageTwo=NO;
        stageThree=NO;
        stagelast=NO;
    }
    if ([textView.text length]>50 && [textView.text length]<=80) {
        CGRect frame=textView.frame;
        frame.size.height=34;
        textView.frame=frame;
        
        CGRect vwframe=vwComment.frame;
        vwframe.size.height=60;
        vwframe.origin.y=commentFrame;
        vwComment.frame=vwframe;
        stageOne=NO;
        stageTwo=NO;
        stageThree=NO;
        stagelast=NO;
    }
    
    if ([textView.text length]>frameWidth*4){
        if (stagelast) {
            return YES;
        }else{
            CGRect frame=textView.frame;
            frame.size.height=90;
            textView.frame=frame;
            
            CGRect vwframe=vwComment.frame;
            vwframe.size.height=130;
            vwframe.origin.y=vwComment.frame.origin.y-15;
            vwComment.frame=vwframe;
            stagelast=YES;
            return YES;
        }
    }
    if ([textView.text length]>frameWidth*3){
        if (stageThree) {
            return YES;
        }else{
            CGRect frame=textView.frame;
            frame.size.height=80;
            textView.frame=frame;
            
            CGRect vwframe=vwComment.frame;
            vwframe.size.height=105;
            vwframe.origin.y=vwComment.frame.origin.y-15;
            vwComment.frame=vwframe;
            stageThree=YES;
            return YES;
        }
    }
    if ([textView.text length]>frameWidth*2){
        if (stageTwo) {
            return YES;
        }else{
            CGRect frame=textView.frame;
            frame.size.height=65;
            textView.frame=frame;
            
            CGRect vwframe=vwComment.frame;
            vwframe.size.height=90;
            vwframe.origin.y=vwComment.frame.origin.y-15;
            vwComment.frame=vwframe;
            stageTwo=YES;
            return YES;
        }
    }
    if ([textView.text length]>frameWidth) {
        if (stageOne) {
            return YES;
        }else{
            CGRect frame=textView.frame;
            frame.size.height=50;
            textView.frame=frame;
            
            CGRect vwframe=vwComment.frame;
            vwframe.size.height=75;
            vwframe.origin.y=vwComment.frame.origin.y-15;
            vwComment.frame=vwframe;
            stageOne=YES;
            return YES;
        }
        
    }
    return YES;
}
-(void) textViewDidChange:(UITextView *)textView
{
    
    if(tfComment.text.length == 0){
        tfComment.textColor = [UIColor lightGrayColor];
        tfComment.text = @"Your comment";
        [tfComment resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        // commentFrame=self.view.frame.size.height-vwComment.frame.size.height-50;
        CGRect frame=vwComment.frame;
        frame.origin.y=self.view.frame.size.height-vwComment.frame.size.height-50;
        vwComment.frame=frame;
        //commentFrame=vwComment.frame.origin.y;
        [UIView commitAnimations];
    }
    
}

#pragma mark- Call Flok Details api
-(void)getFlokDetails{
    
    
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,flokId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/flokDetails" serviceType:@"POST"];
}

#pragma mark- call ProfileInfo api
-(void)getProfileInfo{
    
    
    NSString *dataString=[NSString stringWithFormat:@"id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/userprofile" serviceType:@"POST"];
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"flok/flokDetails"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            vwMain.hidden=NO;
            DicFlok=[data valueForKey:@"allFloks"];
            [self setDataToVewpage:DicFlok];
            arrMain=[[NSMutableArray alloc] initWithArray:[DicFlok valueForKey:@"comments"]];
            [tblvw reloadData];
        }
        else{
            [Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
            
        }
        
    }else if([serviceName isEqualToString:@"flok/listFlokComments"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            
        }
        
    }else if([serviceName isEqualToString:@"users/userprofile"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            userDic=[data valueForKey:@"UserDetails"];
        }
    }
    else if([serviceName isEqualToString:@"flok/joinFlok"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            //[Global showOnlyAlert:@"" :@"You have successfully joined"];
            btnJoinfolk.hidden=YES;
            
            NSString *flokLimit=[NSString stringWithFormat:@"%@",[data valueForKey:@"max_people"]];
            NSString *joinMember=[NSString stringWithFormat:@"%@",[data valueForKey:@"already_joined_count"]];
            lblLimit.text=[NSString stringWithFormat:@"%@/%@",joinMember,flokLimit];
            
            //[btnJoinfolk setUserInteractionEnabled:NO];
        }else if ([[data valueForKey:@"Ack"] intValue]==2) {
            [Global showOnlyAlert:@"" :[data valueForKey:@"msg"]];
        }
    }
}


-(void)setDataToVewpage:(NSDictionary*)dict{
    DicFlok=dict;
    lblTitle.text=[dict valueForKey:@"title"];
    NSString *tempLike=[NSString stringWithFormat:@"%@",[dict valueForKey:@"likecount"]];
    NSString *tempDisLike=[NSString stringWithFormat:@"%@",[dict valueForKey:@"dislikecount"]];
    if ([tempLike length]==0) {
        lblLikecount.text=[NSString stringWithFormat:@"(0)"];
    }else{
        lblLikecount.text=[NSString stringWithFormat:@"(%@)",[dict valueForKey:@"likecount"]];
    }
    if ([tempDisLike length]==0) {
        lblDislikecount.text=[NSString stringWithFormat:@"(0)"];
    }else{
        lblDislikecount.text=[NSString stringWithFormat:@"(%@)",[dict valueForKey:@"dislikecount"]];
    }
    
    tvDes.text=[dict valueForKey:@"description"];
    lblTime.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
    lblLocation.text=[dict valueForKey:@"address"];
    lblPeople.text=[dict valueForKey:@"max_people"];
    NSString *userImg=[dict valueForKey:@"uploaded_by_userImage"];
    
    if ([userImg length]==0) {
        imgUser.image=[UIImage imageNamed:@"no-profile"];
    }else{
        
        [self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:imgUser and:nil];
    }
    BOOL isJoinByme=[[dict valueForKey:@"is_joined_by_me"] intValue];
    if (isJoinByme) {
        // [btnJoinfolk setUserInteractionEnabled:NO];
        btnJoinfolk.hidden=YES;
    }else{
        btnJoinfolk.hidden=NO;
        // [btnJoinfolk setUserInteractionEnabled:YES];
    }
    // NSString *isJoinByme=[[dict valueForKey:@"is_joined_by_me"] intValue];
    NSString *user_Id=[dict valueForKey:@"user_id"];
    if ([userId isEqualToString:user_Id]) {
        btnJoinfolk.hidden=YES;
    }
    NSString *Access_string=[dict valueForKey:@"access"];
    if([Access_string isEqualToString:@"1"]||[Access_string isEqualToString:@"request based"]){
        
        lblRequest.hidden=NO;
    }
    else{
        lblRequest.hidden=YES;
        
    }
    if([[dict valueForKey:@"start_date"] length]>0){
        
        FlokStartDatelbl.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"start_date"]];
    }
    else{
        FlokStartDatelbl.text=@"Not Available";
    }
    
    if([[dict valueForKey:@"end_date"] length]>0){
        enddatelbl.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"end_date"]];
    }
    else{
        enddatelbl.text=@"Not Available";
    }
    
    
    if([[dict valueForKey:@"start_time"] length]>0){
        
        StartTimelbl.text=[dict valueForKey:@"start_time"];
    }
    else{
        StartTimelbl.text=@"Not Available";
    }
    
    if([[dict valueForKey:@"end_time"] length]>0){
        EndTimelbl.text=[dict valueForKey:@"end_time"];
    }
    else{
        EndTimelbl.text=@"Not Available";
    }
    NSString *flokLimit=[NSString stringWithFormat:@"%@",[dict valueForKey:@"max_people"]];
    NSString *joinMember=[NSString stringWithFormat:@"%@",[dict valueForKey:@"already_joined_count"]];
    lblLimit.text=[NSString stringWithFormat:@"%@/%@",joinMember,flokLimit];
    [self setImageWithurl:[dict valueForKey:@"floksImage"] andImageView:imgBanner and:nil];
    [self setImageWithurl:[dict valueForKey:@"floksImage"] andImageView:imgBgBanner and:nil];
    //[self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:imgUser and:nil];
    
        
}



-(IBAction)CommentPressed:(UIButton *)sender{
    
    
    // NSDictionary *userDic=[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userDetails"];
    
    // [indicator startAnimating];
    if ([tfComment.text length]!=0) {
        NSString *userName=[userDic valueForKey:@"full_name"];
        NSString *image_url=[userDic valueForKey:@"image"];
        if ([image_url length]==0) {
            image_url=@"";
        }
        NSString *time=[self getCurrentDate];
        NSDictionary *tempDic=[NSDictionary dictionaryWithObjectsAndKeys:tfComment.text,@"uploaded_by",time,@"datetime",userName,@"user_name",image_url,@"uploaded_by_userImage", nil];
        [arrMain addObject:tempDic];
        [tblvw reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([tblvw numberOfRowsInSection:([tblvw numberOfSections]-1)]-1) inSection: ([tblvw numberOfSections]-1)];
            [tblvw scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
        [self postCommentAPI];
        
    }
    CGRect frame=tfComment.frame;
    frame.size.height=34;
    tfComment.frame=frame;
    
    CGRect vwframe=vwComment.frame;
    vwframe.size.height=60;
    vwframe.origin.y=commentFrame;
    vwComment.frame=vwframe;
}
-(void)postCommentAPI{
    
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@&comment=%@",userId,flokId,tfComment.text];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/postFlokComment" serviceType:@"POST"];
    tfComment.text=nil;
    
}
-(void)getCommentAPI{
    
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,flokId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/listFlokComments" serviceType:@"POST"];
    tfComment.text=nil;
    
    
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

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    keyHeight=keyboardFrameBeginRect.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    vwComment.frame = CGRectMake(vwComment.frame.origin.x,keyboardFrameBeginRect.origin.y-vwComment.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height);
    commentFrame=keyboardFrameBeginRect.origin.y-60;
    CGRect frameTbl=tblvw.frame;
    if (!isKeyOpen) {
        frameTbl.size.height=frameTbl.size.height-keyboardFrameBeginRect.size.height+50;
        isKeyOpen=YES;
    }
    tblvw.frame=frameTbl;
    [UIView commitAnimations];
}

-(NSString *)getCurrentDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *time=[dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return time;
    
}

@end
