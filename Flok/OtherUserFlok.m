//
//  OtherUserFlok.m
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "OtherUserFlok.h"
#import "OtheruserflokCell.h"
#import "ChatPage.h"
#import "WebImageOperations.h"
#import "ChatViewController.h"
#import "JoinedMemberViewController.h"
#import "OtherUserViewController.h"
static CGFloat contractedSmallHeight=44;
static CGFloat commentFrame;
static CGFloat frameWidth;

@interface OtherUserFlok ()
{
   // NSMutableArray *arrOtheruserfolk;
    UITextView *descriptiontxt;
    
    
    __weak IBOutlet UITextView *FlokDetails;
    
    
    __weak IBOutlet UILabel *FlokStartDatelbl;
    
    __weak IBOutlet UILabel *flokshortDatelbl;
    
    __weak IBOutlet UILabel *enddatelbl;
    
    __weak IBOutlet UILabel *StartTimelbl;
    
    __weak IBOutlet UILabel *EndTimelbl;
}

@end

@implementation OtherUserFlok
@synthesize flokId,distance;
- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"OtherUserFlok");
    
    self.view.backgroundColor=[UIColor clearColor];
    btnView.layer.cornerRadius=4;
    btnView.layer.borderWidth=0.5;
    btnCommentPost.layer.borderWidth=2;
    btnJoinfolk.layer.cornerRadius = 3; // this value vary as per your desire
    btnJoinfolk.clipsToBounds = YES;
    imgUser.layer.cornerRadius =imgUser.frame.size.height/2;
    imgUser.clipsToBounds = YES;
    btnCommentPost.layer.borderColor=[[UIColor whiteColor] CGColor];
    btnView.layer.borderColor=appOrange.CGColor;
    imgBgBanner.hidden=YES;
    vwTransparent.hidden=YES;
    
    tblvw.backgroundColor=[UIColor clearColor];
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
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [vwComment setFrame:CGRectMake(0, self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
    if (app.isRemoveFromFlok==YES) {
       [self getFlokDetails];
        app.isRemoveFromFlok=NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    if (isCommentViewShow==YES) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                      self.view.frame.size.width, self.view.frame.size.height);
        
        vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height-vwComment.frame.size.height ,vwComment.frame.size.width,vwComment.frame.size.height);
        
         [UIView commitAnimations];
        
    }
    
    
   /* CGRect frameTbl=tblvw.frame;
    frameTbl.size.height=frameTbl.size.height+keyHeight;
    tblvw.frame=frameTbl;
   
    isKeyOpen=NO;
    [tfComment resignFirstResponder];*/

    
}
-(void)viewDidDisappear:(BOOL)animated{
    

    /* vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height);
    isKeyOpen=NO;
    [tfComment resignFirstResponder];*/
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    /* self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
     self.view.frame.size.width, self.view.frame.size.height);*/
    
    vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height-vwComment.frame.size.height ,vwComment.frame.size.width,vwComment.frame.size.height);
    
    CGRect frameTbl=tblvw.frame;
    frameTbl.size.height=frameTbl.size.height+keyHeight;
    tblvw.frame=frameTbl;
    [UIView commitAnimations];
    isKeyOpen=NO;
    [tfComment resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(IBAction)DoneAction:(id)sender{
    
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
-(IBAction)reportUserAction:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Report this post",@"Cancel", nil];
    
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
    
}
-(IBAction)viewProfile:(id)sender{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
    vc.OtherUserdic=DicFlok;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)joinfolkTap:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    if (btn.tag==5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Are you sure you want to leave?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        [alert setTag:5];
        
        [alert show];
       
    }else{
        if (isFlokLimited==NO) {
            
        NSString *Access_string=[DicFlok valueForKey:@"access"];
        if([Access_string isEqualToString:@"1"]||[Access_string isEqualToString:@"request based"]){
            
            BOOL access_type=[[DicFlok valueForKey:@"is_access"] boolValue];
            if (access_type==1) {
                NSString *strTime=[self getCurrentDate];
                NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@&date_time=%@",[DicFlok valueForKey:@"id"],userId,strTime];
                [[Global sharedInstance] setDelegate:(id)self];
                [[Global sharedInstance] serviceCall:dataString servicename:@"flok/joinFlok" serviceType:@"POST"];
                [vwComment setFrame:CGRectMake(0, self.view.frame.size.height-vwComment.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
                isCommentViewShow=YES;
                 [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height-vwComment.frame.size.height)];
                lblLocation.text=[DicFlok valueForKey:@"address"];
                btnShowMap.hidden=NO;
                vwHideMap.hidden=YES;
                isRecentJoin=YES;
                [Global showOnlyAlert:@"" :@"You have successfully joined."];
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"This flok is request-based" message:@"Do you want to request to join? Your profile will be submitted to the poster." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [alert setTag:2];
                [alert show];
                
            }
        }else{
            
            NSString *strTime=[self getCurrentDate];
            NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@&date_time=%@",[DicFlok valueForKey:@"id"],userId,strTime];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"flok/joinFlok" serviceType:@"POST"];
            [vwComment setFrame:CGRectMake(0, self.view.frame.size.height-vwComment.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
           // CGRect frame=tblvw.frame;
           // frame.size.height=frame.size.height-vwComment.frame.size.height;
          //  tblvw.frame=frame;
             [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height-vwComment.frame.size.height)];
            lblLocation.text=[DicFlok valueForKey:@"address"];
            btnShowMap.hidden=NO;
            vwHideMap.hidden=YES;
            isRecentJoin=YES;
            [Global showOnlyAlert:@"" :@"You have successfully joined."];
        }
        }else{
            [Global showOnlyAlert:@"Sorry" :@"Flok has reached its limit."]; 
        }
        
    }

}

- (IBAction)showJoinMember:(id)sender {
    NSString *user_Id=[DicFlok valueForKey:@"user_id"];
    BOOL isJoinByme=[[DicFlok valueForKey:@"is_joined_by_me"] intValue];
    if ([userId isEqualToString:user_Id]) {
        UIButton *btn=(UIButton*)sender;
        [Global disableAfterClick:btn];
        NSString *joinMember=[NSString stringWithFormat:@"%@",[DicFlok valueForKey:@"already_joined_count"]];
        if (![joinMember isEqualToString:@" "]) {
            JoinedMemberViewController *vc=(JoinedMemberViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JoinedMemberViewController"];
            vc.FlokId=[DicFlok valueForKey:@"id"];
            vc.Flokker=Flokker;
            vc.isAbleToReport=isAbleToReport;
            vc.isOP=isOP;
            vc.isExpired=[[DicFlok valueForKey:@"isExpired"] boolValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (isRecentJoin==YES){
        UIButton *btn=(UIButton*)sender;
        [Global disableAfterClick:btn];
        //NSString *joinMember=[NSString stringWithFormat:@"%@",[DicFlok valueForKey:@"already_joined_count"]];
        //if (![joinMember isEqualToString:@"0"]) {
            JoinedMemberViewController *vc=(JoinedMemberViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JoinedMemberViewController"];
            vc.FlokId=[DicFlok valueForKey:@"id"];
            vc.Flokker=Flokker;
            vc.isAbleToReport=isAbleToReport;
            vc.isOP=isOP;
            vc.isExpired=[[DicFlok valueForKey:@"isExpired"] boolValue];
            [self.navigationController pushViewController:vc animated:YES];
       // }
    }else {
        UIButton *btn=(UIButton*)sender;
        [Global disableAfterClick:btn];
        NSString *joinMember=[NSString stringWithFormat:@"%@",[DicFlok valueForKey:@"already_joined_count"]];
        if (![joinMember isEqualToString:@"0"]) {
            JoinedMemberViewController *vc=(JoinedMemberViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JoinedMemberViewController"];
            vc.FlokId=[DicFlok valueForKey:@"id"];
            vc.isAbleToReport=isAbleToReport;
            vc.isOP=isOP;
            vc.Flokker=Flokker;
            vc.isExpired=[[DicFlok valueForKey:@"isExpired"] boolValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
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
        
        //return arrMain.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(indexPath.row==0){
        
       // return 340;
        return 540;
    }
    else{
        
        if ([arrMain count])
        {
            //NSDictionary *dict=arrChat[indexPath.row];
          /*  NSString *strText;
            
            OtheruserflokCell *cell=[[NSBundle mainBundle]loadNibNamed:@"OtheruserflokCell" owner:self options:nil][0];
            
            UIFont *myfont=cell.tvDesc.font;
            myfont=[UIFont systemFontOfSize:12];
            
            float height=[self findHeightForText:[NSString stringWithFormat:@"%@",strText] havingSize:cell.tvDesc.frame.size andFont:myfont].height+cell.lblTime.frame.size.height+(79-20);
            return 79;*/
            
            NSDictionary *tempdic=[arrMain objectAtIndex:indexPath.row-1];
            
             //NSDictionary *tempdic=[arrMain objectAtIndex:indexPath.row];
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
         cell=nil;
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
        
    }
    
    else{
        
        static NSString *cellIdentifier=@"tcell";
        OtheruserflokCell *cell=(OtheruserflokCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell=[[NSBundle mainBundle]loadNibNamed:@"OtheruserflokCell" owner:self options:nil][0];
        //cell=nil;
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"OtheruserflokCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        if ([arrMain count])
        {
             NSDictionary *dict=arrMain[indexPath.row-1];
             //NSDictionary *dict=arrMain[indexPath.row];
            cell.lblName.text=[NSString stringWithFormat:@"%@",dict[@"user_name"]];
            cell.lblTime.text=[self calculateTime:[dict valueForKey:@"datetime"]];
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
    
    if (indexPath.row!=0) {
        
      NSDictionary *dic= [[NSMutableDictionary alloc] initWithDictionary:[arrMain objectAtIndex:indexPath.row-1]];
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.OtherUserdic=dic;
        [self.navigationController pushViewController:vc animated:YES];
        
    
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
           /* self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                          self.view.frame.size.width, self.view.frame.size.height);*/
            
            vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height-vwComment.frame.size.height ,vwComment.frame.size.width,vwComment.frame.size.height);
            
            CGRect frameTbl=tblvw.frame;
            frameTbl.size.height=frameTbl.size.height+keyHeight;
            tblvw.frame=frameTbl;
            [UIView commitAnimations];
            isKeyOpen=NO;
            [textView resignFirstResponder];
        }
        else{
            
            [textView resignFirstResponder];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            /*self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                          self.view.frame.size.width, self.view.frame.size.height);*/
            
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
       /* self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                      self.view.frame.size.width, self.view.frame.size.height);*/
        
        vwComment.frame = CGRectMake(vwComment.frame.origin.x,self.view.frame.size.height-vwComment.frame.size.height ,vwComment.frame.size.width,vwComment.frame.size.height);
        
        CGRect frameTbl=tblvw.frame;
        frameTbl.size.height=frameTbl.size.height+keyHeight;
        tblvw.frame=frameTbl;
        [UIView commitAnimations];
        isKeyOpen=NO;
        
      /*  [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        // commentFrame=self.view.frame.size.height-vwComment.frame.size.height-50;
        CGRect frame=vwComment.frame;
        frame.origin.y=self.view.frame.size.height-vwComment.frame.size.height-50;
        vwComment.frame=frame;
        //commentFrame=vwComment.frame.origin.y;
        [UIView commitAnimations];*/
    }
    
}

#pragma mark- Call Flok Details api
-(void)getFlokDetails{
    
    NSString *strTime=[self getLocateDate];
    //NSString *strTime=@"2016-12-28 11:55:15";
     NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@&current_time=%@",userId,flokId,strTime];
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
         NSLog(@"data----%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            vwMain.hidden=NO;
             DicFlok=[[NSDictionary alloc] initWithDictionary:[data valueForKey:@"allFloks"]];
            if (DicFlok.count>0) {
                [self setDataToVewpage:DicFlok];
               // arrMain=[[NSMutableArray alloc] initWithArray:[DicFlok valueForKey:@"comments"]];
               // [tblvw reloadData];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            

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
            
          //
           // btnJoinfolk.hidden=YES;
            [btnJoinfolk setTitle:@"Leave Flok" forState:UIControlStateNormal];
            [btnJoinfolk setTag:5];
            int intFlokLimit=[[data valueForKey:@"max_people"] intValue];
            int intjoinMember=[[data valueForKey:@"already_joined_count"] intValue];
            int remain=intFlokLimit - intjoinMember;
            lblLimit.text=[NSString stringWithFormat:@"%@",[data valueForKey:@"max_people"]];
            //lblJoin.text=[NSString stringWithFormat:@"%d",remain];
            lblJoin.text=[NSString stringWithFormat:@"%d/%d",remain,intFlokLimit];
            //NSString *joinMember=[NSString stringWithFormat:@"%@",[data valueForKey:@"already_joined_count"]];
            
            
            
            [self getFlokDetails ];
            //[btnJoinfolk setUserInteractionEnabled:NO];
        }
        else if ([[data valueForKey:@"Ack"] intValue]==2) {
            [Global showOnlyAlert:@"" :[data valueForKey:@"msg"]];
        }
    }else if([serviceName isEqualToString:@"users/leaveFlok"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            [self getFlokDetails ];
            [btnJoinfolk setTitle:@"Join" forState:UIControlStateNormal];
            [btnJoinfolk setTag:0];
        }
        
    }else if([serviceName isEqualToString:@"flok/reportToAdmin"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [Global showOnlyAlert:@"Flok!" :@"Successfully submitted"];
        }
        
    }
    
    else if([serviceName isEqualToString:@"flok/postFlokComment"]) {
    
        if ([[data valueForKey:@"Ack"] intValue]==1) {
           // [self getFlokDetails];
        }
        else{
         // [self getFlokDetails];
        }
    
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==1) {
        
        if(buttonIndex == 0)
            
        {
            [self reportToAdmin];
        }
    }
}
-(void)setDataToVewpage:(NSDictionary*)dict{
    
    DicFlok=dict;
   
    if ([userId isEqualToString:[dict valueForKey:@"user_id"]]) {
        arrMain=[[NSMutableArray alloc] initWithArray:[DicFlok valueForKey:@"comments"]];
        if (arrMain.count==0) {
            vwTalk.hidden=YES;
        }else{
            vwTalk.hidden=NO;
        }
        [tblvw reloadData];
        imgReport.hidden=YES;
        btnReport.hidden=YES;
    }
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
  //  lblDistance.text=[NSString stringWithFormat:@"%.01f Miles",[[dict valueForKey:@"distance"] floatValue]];
    lblDistance.text=[NSString stringWithFormat:@"%.01f Miles", [distance floatValue]];
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[[dict valueForKey:@"uploaded_by"] componentsSeparatedByString:@" "]];
    NSString *name=[array objectAtIndex:0];
    NSString *flokType=[dict valueForKey:@"type"];
    if ([flokType isEqualToString:@"local"]) {
       lblFname.text=name;
    }else{
        lblFname.text=[dict valueForKey:@"uploaded_by"];
    }
    
    lblTime.text=[self calculateTime:[dict valueForKey:@"date"]];
    lblPeople.text=[dict valueForKey:@"max_people"];
    lblPeople.backgroundColor=[UIColor clearColor];
    FlokDetails.backgroundColor=[UIColor clearColor];
    NSString *tempDes=[dict valueForKey:@"description"];
    if([tempDes length]==0)
    {
        _lblDescription.hidden=YES;
        _imgDesBorder.hidden=YES;
        tvDes.hidden=YES;
        
    }else{
        _lblDescription.hidden=NO;
        _imgDesBorder.hidden=NO;
        tvDes.hidden=NO;
 
    }
    FlokDetails.text=[dict valueForKey:@"description"];
    
    
    
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
   
    NSString *userImg=[dict valueForKey:@"uploaded_by_userImage"];
    if ([userImg length]==0) {
        imgUser.image=[UIImage imageNamed:@"no-profile"];
    }else{

        [self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:imgUser and:nil];
    }
    BOOL isJoinByme=[[dict valueForKey:@"is_joined_by_me"] intValue];
    BOOL alreadyJoin=[[dict valueForKey:@"already_joined_count"] intValue];
    BOOL isAccess=[[dict valueForKey:@"is_access"] intValue];
    NSString *Access_string=[dict valueForKey:@"access"];
   
     isAbleToReport=[[dict valueForKey:@"isExpired"] boolValue];
   // isAbleToReport=[[dict valueForKey:@"hrconvert"] boolValue];
    if (isJoinByme==YES) {
        if (isAccess==YES) {
            [btnJoinfolk setTitle:@"Leave Flok" forState:UIControlStateNormal];
            [btnJoinfolk setTag:5];
            
            arrMain=[[NSMutableArray alloc] initWithArray:[DicFlok valueForKey:@"comments"]];
            if (arrMain.count==0) {
                vwTalk.hidden=YES;
            }else{
                vwTalk.hidden=NO;
            }
            [tblvw reloadData];
            isCommentViewShow=YES;
            [vwComment setFrame:CGRectMake(0, self.view.frame.size.height-vwComment.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
            
            lblLocation.text=[dict valueForKey:@"address"];
            btnShowMap.hidden=NO;
            vwHideMap.hidden=YES;
            if([Access_string isEqualToString:@"1"]||[Access_string isEqualToString:@"request based"]){
                lblRequest.hidden=NO;
            }else{
                lblRequest.hidden=YES;
            }
            
        }else{
            [btnJoinfolk setTitle:@"Pending" forState:UIControlStateNormal];
            [btnJoinfolk setTag:5];
            btnJoinfolk.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [btnJoinfolk setUserInteractionEnabled:NO];
            
            if([Access_string isEqualToString:@"1"]||[Access_string isEqualToString:@"request based"]){
                lblRequest.hidden=NO;
                
                lblLocation.text=@"(Request-Based)";
                btnShowMap.hidden=YES;
                vwHideMap.hidden=NO;
                [vwComment setFrame:CGRectMake(0, self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
                [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height+vwComment.frame.size.height)];
                
            }else{
                lblLocation.text=[dict valueForKey:@"address"];
                btnShowMap.hidden=NO;
                vwHideMap.hidden=YES;
                lblRequest.hidden=YES;
                [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height+vwComment.frame.size.height)];
                [vwComment setFrame:CGRectMake(0, self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
            }
        }
    }else{
        if([Access_string isEqualToString:@"1"]||[Access_string isEqualToString:@"request based"]){
            
            if (isAccess==YES) {
                [btnJoinfolk setTitle:@"Join" forState:UIControlStateNormal];
                [btnJoinfolk setFrame:CGRectMake(self.view.frame.size.width-100, btnJoinfolk.frame.origin.y,90,btnJoinfolk.frame.size.height)];
                 btnJoinfolk.titleLabel.font = [UIFont systemFontOfSize:15.0];
            }else{
               [btnJoinfolk setTitle:@"Request to Join" forState:UIControlStateNormal];
               [btnJoinfolk setFrame:CGRectMake(self.view.frame.size.width-120, btnJoinfolk.frame.origin.y,110,btnJoinfolk.frame.size.height)];
                btnJoinfolk.titleLabel.font = [UIFont systemFontOfSize:13.0];
            }
            lblRequest.hidden=NO;
            [btnJoinfolk setTag:0];
           
            lblLocation.text=@"(Request-Based)";
            btnShowMap.hidden=YES;
            vwHideMap.hidden=NO;
            [vwComment setFrame:CGRectMake(0, self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
            [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height+vwComment.frame.size.height)];
            
        }else{
            [btnJoinfolk setTitle:@"Join" forState:UIControlStateNormal];
            btnJoinfolk.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [btnJoinfolk setTag:0];
            [btnJoinfolk setFrame:CGRectMake(self.view.frame.size.width-100, btnJoinfolk.frame.origin.y,90,btnJoinfolk.frame.size.height)];
            lblLocation.text=[dict valueForKey:@"address"];
            btnShowMap.hidden=NO;
            vwHideMap.hidden=YES;
            lblRequest.hidden=YES;
            [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height)];
            [vwComment setFrame:CGRectMake(0, self.view.frame.size.height-vwComment.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
            
            isCommentViewShow=YES;
            /////////// Ritwik /////////
            arrMain=[[NSMutableArray alloc] initWithArray:[DicFlok valueForKey:@"comments"]];
            if (arrMain.count==0) {
                vwTalk.hidden=YES;
            }else{
                vwTalk.hidden=NO;
            }
            [tblvw reloadData];
          //  [vwComment setFrame:CGRectMake(0, self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
        }
 
    }
    NSString *fullTimeStart=[self changeDateFormat:[dict valueForKey:@"start_date"] fullDate:YES];
    NSString *shortTimeStart=[self changeDateFormat:[dict valueForKey:@"start_date"] fullDate:NO];
    
    NSString *fullTimeEnd=[self changeDateFormat:[dict valueForKey:@"end_date"] fullDate:YES];
    NSString *shortTimeEnd=[self changeDateFormat:[dict valueForKey:@"end_date"] fullDate:NO];
    
    if ([fullTimeStart isEqualToString:fullTimeEnd]) {
        FlokStartDatelbl.text=[NSString stringWithFormat:@"%@",fullTimeStart ] ;
        flokshortDatelbl.text=[NSString stringWithFormat:@"%@ at %@ - %@",shortTimeStart,[dict valueForKey:@"start_time"],[dict valueForKey:@"end_time"]];
    }else{
        FlokStartDatelbl.text=[NSString stringWithFormat:@"%@ - %@",fullTimeStart,fullTimeEnd];
        
        flokshortDatelbl.text=[NSString stringWithFormat:@"%@ at %@ - %@ at %@",shortTimeStart,[dict valueForKey:@"start_time"],shortTimeEnd,[dict valueForKey:@"end_time"]];
    }
    
    BOOL isExp=[[dict valueForKey:@"isExpired"] boolValue];
    if (isExp==YES) {
       // btnJoinfolk.hidden=YES;               //  block in second phases
        [vwComment setFrame:CGRectMake(0, self.view.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
        [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height+vwComment.frame.size.height)];
    }

    NSString *user_Id=[dict valueForKey:@"user_id"];
    if ([userId isEqualToString:user_Id]) {
        btnJoinfolk.hidden=YES;
        isOP=YES;
        isCommentViewShow=YES;
        [vwComment setFrame:CGRectMake(0, self.view.frame.size.height-vwComment.frame.size.height,vwComment.frame.size.width,vwComment.frame.size.height)];
        // [tblvw setFrame:CGRectMake(0, tblvw.frame.origin.y,tblvw.frame.size.width,tblvw.frame.size.height-vwComment.frame.size.height)];
        lblLocation.text=[dict valueForKey:@"address"];
        btnShowMap.hidden=NO;
        vwHideMap.hidden=YES;
    }
    
    lblLimit.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"max_people"]];
    int intFlokLimit=[[dict valueForKey:@"max_people"] intValue];
    int intjoinMember=[[dict valueForKey:@"already_joined_count"] intValue];
    int remain=intFlokLimit - intjoinMember;
    lblLimit.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"max_people"]];
    lblJoin.text=[NSString stringWithFormat:@"%d/%d",remain,intFlokLimit];
    
    
    
    if([[dict valueForKey:@"floksImage"] length]>0){
    
    [self setImageWithurl:[dict valueForKey:@"floksImage"] andImageView:imgBanner and:nil];
    }
    else{
        imgBanner.image=[UIImage imageNamed:@"banner-pic"];
    }
    
    int maxLimit=[[dict valueForKey:@"max_people"] intValue];
    int joined=[[dict valueForKey:@"already_joined_count"] intValue];
    Flokker=[NSString stringWithFormat:@"Flokkers %d/%d",joined,maxLimit];
    lblJoin.text=[NSString stringWithFormat:@"%d/%d",joined,maxLimit];
    if (maxLimit>4) {
        int min=maxLimit/5;
        int middle=min*2;
        int half=min*3;
        int max=min*4;
        
        
        if (maxLimit==joined) {
            isFlokLimited=YES;
        }else{
            isFlokLimited=NO;
        }
        if (joined==0){
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"blankLimit-1"] forState:UIControlStateNormal];
        }else if (joined>0 && joined<min) {
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"lowLimit"] forState:UIControlStateNormal];
            
        }else if (joined>=min && joined<middle) {
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"middle"] forState:UIControlStateNormal];
        }
        else if (joined>=middle && joined<half){
            //imgLimit.image=[UIImage imageNamed:@"halfLimit"];
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"halfLimit-1"] forState:UIControlStateNormal];
        }else if (joined>=half && joined<max){
            //imgLimit.image=[UIImage imageNamed:@"maxLimit"];
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"maxLimit"] forState:UIControlStateNormal];
        }else if (joined>=max && joined<maxLimit){
            //imgLimit.image=[UIImage imageNamed:@"maxLimit"];
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"maxFull"] forState:UIControlStateNormal];
        }
        else if(joined==maxLimit){
            // imgLimit.image=[UIImage imageNamed:@"fulLimit"];
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"fullLimit-1"] forState:UIControlStateNormal];
        }
    }else{
        if (joined==0){
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"blankLimit-1"] forState:UIControlStateNormal];
        }else if (joined>0 && joined<maxLimit){
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"lowLimit"] forState:UIControlStateNormal];
        }else if(joined==maxLimit){
            // imgLimit.image=[UIImage imageNamed:@"fulLimit"];
            [btnLimit setBackgroundImage:[UIImage imageNamed:@"fullLimit-1"] forState:UIControlStateNormal];
        }
    }
    
    [self setImageWithurl:[dict valueForKey:@"floksImage"] andImageView:imgBgBanner and:nil];
    //[self setImageWithurl:[dict valueForKey:@"uploaded_by_userImage"] andImageView:imgUser and:nil];
   
}


-(IBAction)showAddressOnMap:(id)sender{
    
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude=[[DicFlok valueForKey:@"lat"] floatValue];
    coordinate.longitude=[[DicFlok valueForKey:@"lang"] floatValue];
    
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
        
    } else{
        
        //using iOS 5 which has the Google Maps application
        
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
    }
}
-(IBAction)CommentPressed:(UIButton *)sender{
    
    NSLog(@"CommentPressed");
    
    if (tfComment.text .length==0|| [tfComment.text isEqualToString:@"Your comment"]) {
        
        
        [Global showOnlyAlert:@"Blank comment can not be  Post." :nil ];
        
    }
    else{
                NSString *userName=[userDic valueForKey:@"full_name"];
                NSString *image_url=[userDic valueForKey:@"image"];
        
                if ([image_url length]==0) {
                    image_url=@"";
                }
                //2017-03-02 07:02:28
                NSString *time=[self getCurrentDate];
                NSDictionary *tempDic=[NSDictionary dictionaryWithObjectsAndKeys:tfComment.text,@"uploaded_by",time,@"datetime",userName,@"user_name",image_url,@"uploaded_by_userImage", nil];
                [arrMain addObject:tempDic];
                if (arrMain.count==0) {
                   vwTalk.hidden=YES;
                }else{
                    vwTalk.hidden=NO;
                }
                [tblvw reloadData];
        
        
                dispatch_async(dispatch_get_main_queue(), ^{
        
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([tblvw numberOfRowsInSection:([tblvw numberOfSections]-1)]-1) inSection: ([tblvw numberOfSections]-1)];
                    [tblvw scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                });

        /*CGRect frame=tfComment.frame;
        frame.size.height=34;
        tfComment.frame=frame;
        
        CGRect vwframe=vwComment.frame;
        vwframe.size.height=60;
        vwframe.origin.y=commentFrame;
        vwComment.frame=vwframe;*/
        [self postCommentAPI];

    }
    
}
-(void)postCommentAPI{
     NSString *strTime=[self getCurrentDate];
    NSString *tempMessage=[Global addSpclCharecters:tfComment.text];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@&comment=%@&date_time=%@",userId,flokId,tempMessage,strTime];
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

-(void)reportToAdmin{
    
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&post_id=%@&reason=",userId,flokId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/reportToAdminFolk" serviceType:@"POST"];
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
        frameTbl.size.height=frameTbl.size.height-keyboardFrameBeginRect.size.height;
        isKeyOpen=YES;
    }
    tblvw.frame=frameTbl;
    [UIView commitAnimations];
}

-(NSString *)getLocateDate{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time=[dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return time;
    
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

-(IBAction)flokLike:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    int temp=[lblLikecount.text intValue]+1;
    
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:DicFlok];
    int status=[[oldDic valueForKey:@"isLikedByMe"] intValue];
    if (status==0) {
        lblLikecount.text=[NSString stringWithFormat:@"(%@)",[NSString stringWithFormat:@"%d",temp]];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        int totalVote=[[dic valueForKey:@"likecount"] intValue]+1;
        [dic setObject:[NSString stringWithFormat:@"%d",totalVote ] forKey:@"likecount"];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"isLikedByMe"];
       // [arrMain replaceObjectAtIndex:[btn tag] withObject:dic];
        
        NSString *postid=[oldDic valueForKey:@"id"];
        //NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,postid];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/like" serviceType:@"POST"];
        
    }

}

-(IBAction)flokDisLike:(UIButton *)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    int temp=[lblDislikecount.text intValue]+1;
    NSMutableDictionary *oldDic = [[NSMutableDictionary alloc] initWithDictionary:DicFlok];
    
    int status=[[oldDic valueForKey:@"isDisLikedByMe"] intValue];
    if (status==0) {
        lblDislikecount.text=[NSString stringWithFormat:@"(%@)",[NSString stringWithFormat:@"%d",temp]];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] initWithDictionary:oldDic];
        int totalVote=[[dic valueForKey:@"dislikecount"] intValue]+1;
        [dic setObject:[NSString stringWithFormat:@"%d",totalVote ] forKey:@"dislikecount"];
        [dic setObject:[NSString stringWithFormat:@"%d",1 ] forKey:@"isDisLikedByMe"];
       // [arrMain replaceObjectAtIndex:[btn tag] withObject:dic];
        
        NSString *postid=[oldDic valueForKey:@"id"];
        //NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@",userId,postid];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"flok/dislike" serviceType:@"POST"];
    }
    
}

-(void)timeInterval:(NSString*)startDate endDate:(NSString*)endDate{
    
    //NSString *startDate = @"2016-02-24 10:25:11 +0000";
   // NSString *endDate = @"2016-02-24 10:26:11 +0000";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *start = [formatter dateFromString:startDate];
    NSDate *end = [formatter dateFromString:endDate];
    
    NSTimeInterval interval = [end timeIntervalSinceDate:start];
    NSLog(@"time interval:%f", interval);
}

/*-(NSString *)getCurrentDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    //  return timeStamp;
    
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
}*/
-(NSString *)getCurrentDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    return timeStamp;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==5) {
        if (buttonIndex==1) {
            
            NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@",[DicFlok valueForKey:@"id"],userId];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/leaveFlok" serviceType:@"POST"];
           
            
        }
    }else if (alertView.tag==2){
        if (buttonIndex == 1) {
            //UIButton *btn=(UIButton*)sender;
            //[Global disableAfterClick:btn];
            NSString *strTime=[self getCurrentDate];
            [Global showOnlyAlert:@"" :@"A request has been sent."];
            NSString *dataString=[NSString stringWithFormat:@"flok_id=%@&user_id=%@&date_time=%@",[DicFlok valueForKey:@"id"],userId,strTime];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"flok/joinFlok" serviceType:@"POST"];
        }
    }

}

-(NSString*)changeDateFormat:(NSString*)dateString fullDate:(BOOL)isFull{
    
   // NSString *dateString = @"11-13-2013";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSString *newDateString;
    if (isFull==YES) {
        [dateFormatter setDateFormat:@"MMMM dd"];
        newDateString= [dateFormatter stringFromDate:date];
    }else{
        [dateFormatter setDateFormat:@"MMM dd"];
        newDateString= [dateFormatter stringFromDate:date];
    }
    
    return newDateString;
}

@end
