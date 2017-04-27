//
//  ChatViewController.m
//  RishtaBliss
//
//  Created by NITS_Mac3 on 05/07/16.
//  Copyright © 2016 Suman. All rights reserved.
//

#import "ChatViewController.h"
#import "WebImageOperations.h"
#import "ChatUserCell.h"
#import "ChatOtherCell.h"
#import "OtherUserViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize strFriendId,productDic,dataDic,isBlock;
- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor=[UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    strFromId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    strToId=strFriendId;
    lblTitle.text=_strProductName;
    arrChat=[[NSMutableArray alloc]init];

    last_id=@"0";
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)uploadPhoto:(id)sender{
    [tvChat resignFirstResponder];
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    [picker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    [self presentViewController:picker animated:YES completion:Nil];
    
   /* if (iskeyboardDidShow) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame=vwChat.frame;
            frame.origin.y=frame.origin.y+keyboardFrame.size.height;
            //  frame.origin.y=frame.origin.y+215;
            vwChat.frame=frame;
            
            CGRect frameTbl=tblChat.frame;
            frameTbl.size.height=frameTbl.size.height+keyboardFrame.size.height;
            // frameTbl.size.height=frameTbl.size.height+215;
            tblChat.frame=frameTbl;
            
        }completion:^(BOOL complete){
            if(arrChat.count>0)
            {
                NSIndexPath* ipath = [NSIndexPath indexPathForRow: arrChat.count-1 inSection: 0];
                @try {
                    [tblChat scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }];
        iskeyboardDidShow=NO;
    }*/
}
-(IBAction)blockUserAction:(id)sender{
   
    if (isBlock!=YES) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Block", nil];
        
        [actionSheet showInView:self.view];
        [actionSheet setTag:1];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Unblock", nil];
        
        [actionSheet showInView:self.view];
        [actionSheet setTag:2];
    }
   
    
}
- (void)keyboardDidShow:(NSNotification *)note
{
    NSDictionary* keyboardInfo = [note userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardFrame = [keyboardFrameBegin CGRectValue];
    //keyHeight=keyboardFrameBeginRect.size.height;

    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    if (!iskeyboardDidShow) {
        [tvChat becomeFirstResponder];
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame=vwChat.frame;
            frame.origin.y=frame.origin.y-keyboardFrame.size.height;
            vwChat.frame=frame;
            
            CGRect frameTbl=tblChat.frame;
            frameTbl.size.height=frameTbl.size.height-keyboardFrame.size.height;
            tblChat.frame=frameTbl;
            
        }completion:^(BOOL complete){
            
            if(arrChat.count>0)
            {
                NSIndexPath* ipath = [NSIndexPath indexPathForRow: arrChat.count-1 inSection: 0];
                @try {
                    [tblChat scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }];
        
        iskeyboardDidShow=YES;
    }
    
}

- (void)keyboardDidHide:(NSNotification *)note
{
    NSDictionary* keyboardInfo = [note userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardFrame = [keyboardFrameBegin CGRectValue];
    
    if (iskeyboardDidShow) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame=vwChat.frame;
            frame.origin.y=frame.origin.y+keyboardFrame.size.height;
          //  frame.origin.y=frame.origin.y+215;
            vwChat.frame=frame;
            
            CGRect frameTbl=tblChat.frame;
            frameTbl.size.height=frameTbl.size.height+keyboardFrame.size.height;
           // frameTbl.size.height=frameTbl.size.height+215;
            tblChat.frame=frameTbl;
            
        }completion:^(BOOL complete){
            if(arrChat.count>0)
            {
                NSIndexPath* ipath = [NSIndexPath indexPathForRow: arrChat.count-1 inSection: 0];
                @try {
                    [tblChat scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }];
        iskeyboardDidShow=NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    tvChat.autocorrectionType=UITextAutocorrectionTypeDefault;
    
    if (isBlock==YES) {
        [btnDone setTag:2];
    }else{
        [btnDone setTag:1];
    }
    

    [self getChatMessage];
    
    timerForChat = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                    target:self
                                                  selector:@selector(getChatMessage)
                                                  userInfo:nil
                                                   repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timerForChat invalidate];
    timerForChat=nil;
}

-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

/*-(NSString*)convertStringToDateThenString:(NSString *)strDate{
    NSString *strReturnDate;
    
    //ajeet> dateformat
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter1 dateFromString:strDate];
    
    if ([[NSCalendar currentCalendar] isDateInToday:[dateFormatter1 dateFromString:strDate]])
    {
        strReturnDate=@"Today";
    }
    else if ([[NSCalendar currentCalendar] isDateInYesterday:[dateFormatter1 dateFromString:strDate]])
    {
        strReturnDate=@"Yesterday";
    }
    else
    {
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"dd MMM yyyy hh:mma"];
        NSString *stringDate = [dateFormatter2 stringFromDate:dateFromString];
        strReturnDate = stringDate;
    }
    
    return strReturnDate;
    
}*/

- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 24;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}
-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview {
    
    NSString* imageName=[url lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgview.image=[UIImage imageWithContentsOfFile:FilePath];
        
    }
    else
    {
        [WebImageOperations processImageDataWithURLString:url andBlock:^(NSData *imageData)
         {
             imgview.image=[UIImage imageWithData:imageData];
             [imageData writeToFile:FilePath atomically:YES];
             //[loder stopAnimating];
             
             
         }];
    }
    
}

- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text)
    {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

#pragma mark - Textfield delegate
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark -TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrChat.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[arrChat objectAtIndex:indexPath.row];
    
    if ([[dict valueForKey:@"sender_id"] isEqualToString:userId]) {
        BOOL isImg=[[dict valueForKey:@"type"] boolValue];
        if (isImg!=YES) {
            return 210;
        }else{
            
            NSString *text =[[dict valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            CGFloat width = SCREEN_WIDTH-123;
            UIFont *font = [UIFont systemFontOfSize:13.0f];
            CGFloat extraheight=0.0f;
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:text
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            extraheight=rect.size.height;
            NSLog(@"%f,extraheight",extraheight+55);
            return 40+extraheight;
           /* UIFont *myFont=[UIFont fontWithName:@"Helvetica" size:13];
            CGSize maximumSize = CGSizeMake(300, 9999);
            NSString *myString =[dict valueForKey:@"message"];
           
            CGSize myStringSize = [myString sizeWithFont:myFont
                                       constrainedToSize:maximumSize
                                           lineBreakMode:10];
            if (myStringSize.height<47) {
               return 62;
            }else{
                
                UITextView *tvDes = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 256, 47)];
                tvDes.text=[dict valueForKey:@"message"];
                CGRect tvFrame=tvDes.frame;
                tvFrame.size.height=tvDes.contentSize.height+20;
                tvDes.frame=tvFrame;
                NSLog(@"cell height--%f",tvDes.frame.size.height+20);
                return tvDes.frame.size.height+58;
            }
           // NSLog(@"cell height--%f",myStringSize.height);
            
            
            // NSLog(@"cell height--%f",[self findHeightForText:[dict valueForKey:@"messge"] havingWidth:157 andFont:myFont].height+58);
           // return [self findHeightForText:[dict valueForKey:@"messge"] havingWidth:195 andFont:myFont].height+58;*/
            
        }
       
    }
    else{
        
        BOOL isImg=[[dict valueForKey:@"type"] boolValue];
        if (isImg!=YES) {
            return 210;
        }else{
            NSString *text =[[dict valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            CGFloat width = SCREEN_WIDTH-123;
            UIFont *font = [UIFont systemFontOfSize:13.0f];
            CGFloat extraheight=0.0f;
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:text
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            extraheight=rect.size.height;
            NSLog(@"%f,extraheight*****",extraheight+55);
            return 40+extraheight;
            /*UIFont *myFont=[UIFont fontWithName:@"Helvetica" size:13];
            CGSize maximumSize = CGSizeMake(300, 9999);
            NSString *myString =[dict valueForKey:@"message"];
            
            CGSize myStringSize = [myString sizeWithFont:myFont
                                       constrainedToSize:maximumSize
                                           lineBreakMode:10];
            NSLog(@"cell height--%f",myStringSize.height);
            //return myStringSize.height+95;
            if (myStringSize.height<47) {
                return 55;
            }else{
                UITextView *tvDes = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 256, 47)];
                tvDes.text=[dict valueForKey:@"message"];
                CGRect tvFrame=tvDes.frame;
                tvFrame.size.height=tvDes.contentSize.height+20;
                tvDes.frame=tvFrame;
                NSLog(@"cell height--%f",tvDes.frame.size.height+20);
                return tvDes.frame.size.height+20;
            }*/
            
        }
       
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *cellIdentifier=@"cellIdentifier";
    NSDictionary *dict=[arrChat objectAtIndex:indexPath.row];
    
    NSString *chatUserId=[NSString stringWithFormat:@"%ld",[[dict valueForKey:@"from"]integerValue]];
    
    NSLog(@"chatUserId=%@",chatUserId);
    
    if ([[dict valueForKey:@"sender_id"]integerValue]==[[prefs valueForKey:@"userId"] integerValue])
    {
        NSLog(@"strFromId=%@",strFromId);
        
        ChatUserCell *tCell=(ChatUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (tCell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ChatUserCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
        }
        tCell.selectionStyle=UITableViewCellSelectionStyleNone;
         fromimage=[dict valueForKey:@"sender_image"];
        
       
        if ([fromimage length]==0) {
            
            tCell.imgUser.image=[UIImage imageNamed:@"no-profile"];
            fromimage=@"";
            
        }else{
           
             [self setImageWithurl:fromimage andImageView:tCell.imgUser];
        }
       
        tCell.imgUser.layer.cornerRadius=tCell.imgUser.frame.size.width/2;
        tCell.imgUser.layer.masksToBounds=YES;
        NSString *strTime=[self calculateTime:[dict valueForKey:@"date"]];
        if ([strTime length]!=0) {
          tCell.lblTime.text=[self calculateTime:[dict valueForKey:@"date"]];
        }
        BOOL isImg=[[dict valueForKey:@"type"] boolValue];
        if (isImg!=YES) {
            [self setImageWithurl:[dict valueForKey:@"message"] andImageView:tCell.imgMsg];
            tCell.tvTxt.hidden=YES;
            tCell.vwMsg.hidden=YES;
            tCell.lblMsg.hidden=YES;
            tCell.imgMsg.layer.borderWidth=2.0;
            tCell.imgMsg.layer.cornerRadius=5.0;
            tCell.imgMsg.layer.masksToBounds=YES;
            tCell.imgMsg.layer.borderColor=[[UIColor colorWithRed:235/255.0 green:63.0/255.0 blue:1/255.0 alpha:1] CGColor];
            CGRect frame=tCell.contentView.frame;
            frame.size.height=220;
            tCell.contentView.frame=frame;
            tCell.lblTime.hidden=YES;
            
            
        }else{
            NSString *text =[[dict valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            CGFloat width = SCREEN_WIDTH-123;
            UIFont *font = [UIFont systemFontOfSize:13.0f];
            CGFloat extraheight=0.0f;
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:text
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            
            extraheight=rect.size.height;
            CGRect tvFrame=tCell.vwMsg.frame;
            tvFrame.size.height=tvFrame.size.height+extraheight-20;
            tCell.vwMsg.frame=tvFrame;
            
            CGRect lblFrame=tCell.lblMsg.frame;
            lblFrame.size.height=lblFrame.size.height+extraheight;
            tCell.lblMsg.frame=lblFrame;
            
            CGRect timeFrame=tCell.lblTime.frame;
            timeFrame.origin.y=tCell.vwMsg.frame.size.height-20;
            tCell.lblTime.frame=timeFrame;
            
            tCell.lblMsg.text=[dict valueForKey:@"message"];
            //return myStringSize.height+95;
           /* if (myextraheightStringSize<47) {
                CGRect tvFrame=tCell.tvTxt.frame;
                tvFrame.size.height=58;
                tCell.tvTxt.frame=tvFrame;
            }else{
                CGRect tvFrame=tCell.tvTxt.frame;
                tvFrame.size.height=tCell.tvTxt.contentSize.height+20;
                tCell.tvTxt.frame=tvFrame;
            }
            CGRect tvFrame=tCell.tvTxt.frame;
            tvFrame.size.height=tCell.tvTxt.contentSize.height+20;
            tCell.tvTxt.frame=tvFrame;*/
            
            tCell.tvTxt.hidden=NO;
            tCell.vwMsg.hidden=NO;
            tCell.lblMsg.hidden=NO;
            tCell.imgMsg.hidden=YES;
            tCell.lblTime.hidden=NO;
            }
       
        
        tCell.vwMsg.layer.cornerRadius=2.0;
//        tCell.lblTime.frame=CGRectMake(tCell.lblTime.frame.origin.x, tCell.tvTxt.frame.origin.y+tCell.tvTxt.frame.size.height-20, 126, 21);
        
        
        UILongPressGestureRecognizer *lpgr= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.delegate = self;
        lpgr.delaysTouchesBegan = YES;
        [tCell.tvTxt setUserInteractionEnabled:NO];
        [tCell.contentView addGestureRecognizer:lpgr];
        [tCell.contentView setUserInteractionEnabled:YES];
       
        return tCell;
    }
    else
    {
        ChatOtherCell *tCell=(ChatOtherCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (tCell==nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ChatOtherCell" owner:self options:nil];
            tCell=[nib objectAtIndex:0];
        }
        tCell.selectionStyle=UITableViewCellSelectionStyleNone;
        fromimage=[dict valueForKey:@"sender_image"];
        if ([fromimage length]==0) {
            
            tCell.imgUser.image=[UIImage imageNamed:@"no-profile"];
            
        }else{
            
            [self setImageWithurl:fromimage andImageView:tCell.imgUser];
        }
        NSString *text =[[dict valueForKey:@"message"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        CGFloat width = SCREEN_WIDTH-123;
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        CGFloat extraheight=0.0f;
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        
        extraheight=rect.size.height;
        CGRect tvFrame=tCell.vwMsg.frame;
        tvFrame.size.height=tvFrame.size.height+extraheight-20;
        tCell.vwMsg.frame=tvFrame;
        
        CGRect lblFrame=tCell.lblMsg.frame;
        lblFrame.size.height=lblFrame.size.height+extraheight;
        tCell.lblMsg.frame=lblFrame;
        
        CGRect timeFrame=tCell.lblTime.frame;
        timeFrame.origin.y=tCell.vwMsg.frame.size.height-20;
        tCell.lblTime.frame=timeFrame;

        tCell.imgUser.layer.cornerRadius=tCell.imgUser.frame.size.width/2;
        tCell.imgUser.layer.masksToBounds=YES;
        
        tCell.lblTime.text=[self calculateTime:[dict valueForKey:@"date"]];
        //tCell.tvTxt.text=[dict valueForKey:@"message"];
        tCell.lblMsg.text=[dict valueForKey:@"message"];
        lblTitle.text=[dict valueForKey:@"sender_name"];
        tCell.vwMsg.layer.cornerRadius=2.0;

        
        BOOL isImg=[[dict valueForKey:@"type"] boolValue];
        if (isImg!=YES) {
            [self setImageWithurl:[dict valueForKey:@"message"] andImageView:tCell.imgMsg];
            tCell.tvTxt.hidden=YES;
            tCell.vwMsg.hidden=YES;
            tCell.lblMsg.hidden=YES;
            tCell.imgMsg.layer.borderWidth=2.0;
            tCell.imgMsg.layer.cornerRadius=5.0;
            tCell.imgMsg.layer.masksToBounds=YES;
            tCell.imgMsg.layer.borderColor=[[UIColor colorWithRed:235/255.0 green:63.0/255.0 blue:1/255.0 alpha:1] CGColor];
            CGRect frame=tCell.contentView.frame;
            frame.size.height=220;
            tCell.contentView.frame=frame;
            
           
            
        }else{
            tCell.tvTxt.text=[dict valueForKey:@"message"];
            tCell.tvTxt.hidden=NO;
            tCell.imgMsg.hidden=YES;
            
            tCell.tvTxt.hidden=NO;
            tCell.vwMsg.hidden=NO;
            tCell.lblMsg.hidden=NO  ;
        }
        return tCell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDic=[arrChat objectAtIndex:indexPath.row];
     NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[tempDic valueForKey:@"sender_id"],@"user_id",nil];
    NSString *userId100=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if([[dic objectForKey:@"user_id"] isEqualToString:userId100]){
    
    }else{
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherUserViewController *vc=(OtherUserViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OtherUserViewController"];
        vc.OtherUserdic=dic;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
  
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:tblChat];
    selectdIndexPath = [tblChat indexPathForRowAtPoint:p];
    
    if (selectdIndexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete your message?" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
        
        [actionSheet showInView:self.view];
        [actionSheet setTag:4];
    }
}
#pragma mark - Webservice
-(IBAction)btnSendPressed:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    
    if ([btn tag]==1) {
        NSString *url;
        NSArray *arr=[[NSArray alloc] initWithArray:[productDic objectForKey:@"image"]];
        if (arr.count>0) {
            url=[arr objectAtIndex:0];
        }
        NSString *strTime=[self getCurrentDate];
        
        if ([tvChat.text length]!=0) {
            
            NSString *strMessage=tvChat.text;
            NSString *tempMessage=[Global addSpclCharecters:tvChat.text];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            NSString *dataString=[NSString stringWithFormat:@"sender_id=%@&receiver_id=%@&flok_id=%@&message=%@&date_time=%@",strFromId,strFriendId,@"0",tempMessage,strTime];
            
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"flok/sendChat" serviceType:@"POST"];
            
            
            NSDictionary *tempDic=[NSDictionary dictionaryWithObjectsAndKeys:strMessage,@"message",strFromId,@"sender_id",strToId,@"receiver_id",strTime,@"date",@"1",@"type",fromimage,@"sender_image",nil];
            
            [arrChat addObject:tempDic];
            [tblChat reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrChat.count-1 inSection:0];
            [tblChat scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:YES];
            tvChat.text=@"";
            
        }
    }else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Unblock", nil];
        
        [actionSheet showInView:self.view];
        [actionSheet setTag:2];
        
        [tvChat resignFirstResponder];
    }
    
    
   
}

-(void)getChatMessage
{
    
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&reciver_id=%@&flok_id=%@&last_id=0",strToId,strFromId,@"0"];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/getChatMsg" serviceType:@"POST"];
    
    
}
-(void)sendChatMessage:(NSString*)text
{
    
    NSString *dataString=[NSString stringWithFormat:@"sender_id=%@&receiver_id=%@&flok_id=%@&message=%@",strFromId,strFriendId,@"0",text];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"flok/sendChat" serviceType:@"POST"];
    
}

-(void)uploadOnlyPhoto:(NSString*)ServiceName :(UIImageView*)upload_Img;
{
    
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,ServiceName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120000];
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = [NSString stringWithFormat:@"--"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
     NSString *strTime=[self getCurrentDate];
    
    //==============
    if([ServiceName isEqualToString:@"flok/sendChat"])
    {
        
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"sender_id":[strFromId dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"receiver_id":[strFriendId dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"flok_id":[@"" dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"message":[@"" dataUsingEncoding:NSUTF8StringEncoding]];
         myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"date_time":[strTime dataUsingEncoding:NSUTF8StringEncoding]];
        
        myRequestData=[Global makeData:myRequestData :boundary :@"File":@"jpg":@"message_photo":UIImageJPEGRepresentation(upload_Img.image, 0.7)];
        
       
    }
    //===========
    
    
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:myRequestData];
    
    // Configure the Session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    
    // post the request and handle response
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                  // Handle the Response
                                                  if(error)
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [SVProgressHUD dismiss];
                                                      });
                                                      return;
                                                  }
                                                  NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                                                  for (NSHTTPCookie * cookie in cookies)
                                                  {
                                                      strSessName=cookie.name;
                                                      strSessVal=cookie.value;
                                                      
                                                  }
                                                  
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [SVProgressHUD dismiss];
                                                      
                                                      if([ServiceName isEqualToString:@"flok/sendChat"])
                                                      {
                                                          NSDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                          NSLog(@"the post value:%@",dict);
                                                          
                                                          dict=[Global cleanJsonToObject:dict];
                                                          
                                                          if ([[dict objectForKey:@"Ack"] integerValue]==1)
                                                          {
                                                              
                                                               //[Global showOnlyAlert:@"Error" :dict[@"msg"]];
                                                              
                                                          }
                                                          else{
                                                              //[Global showOnlyAlert:@"Error" :dict[@"msg"]];
                                                          }
                                                      }
                                                      
                                                  });
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
    
}
-(NSString *)getCurrentDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    return timeStamp;
}


-(void)reloadChatPage:(NSDictionary*)chatDic{
    
    strFromId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    strToId=[chatDic valueForKey:@"user_id"];
    [self getChatMessage];
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"flok/getChatMsg"])
    {
        
        if ([[data valueForKey:@"ACK"] intValue]==1) {
            
            NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
            arrTemp=[[data objectForKey:@"chats"] mutableCopy];
            
            int arrCount=arrTemp.count;
            if (arrCount>count) {
                count=arrCount;
                arrTemp = [[NSMutableArray alloc]initWithArray: [[arrTemp reverseObjectEnumerator] allObjects]];
                arrChat=arrTemp;
                NSDictionary *dict=[arrTemp lastObject];
                last_id=[dict valueForKey:@"id"];
                [tblChat reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrChat.count-1 inSection:0];
                [tblChat scrollToRowAtIndexPath:indexPath
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:YES];

            }else if (arrCount==count){
                arrTemp = [[NSMutableArray alloc]initWithArray: [[arrTemp reverseObjectEnumerator] allObjects]];
                NSDictionary *dict=[arrTemp lastObject];
                NSString *last=[dict valueForKey:@"id"];
                if (![last_id isEqualToString:last]) {
                    
                    arrChat=arrTemp;
                    NSDictionary *dict2=[arrTemp lastObject];
                    last_id=[dict2 valueForKey:@"id"];
                    [tblChat reloadData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrChat.count-1 inSection:0];
                    [tblChat scrollToRowAtIndexPath:indexPath
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:YES];
                }
                
            }
        }
        else{
            
            
            return ;
            
        }
        
    }else if([serviceName isEqualToString:@"users/messagedelete"])
    {
       if ([[data valueForKey:@"ACK"] intValue]==1) {
           
           NSDictionary *dict=[arrChat objectAtIndex:selectdIndexPath.row];
           [arrChat removeObject:dict];
           [tblChat reloadData];
       }
        
    }

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==1) {
       
        if(buttonIndex == 0)
            
        {
            [self blockUser];
        }
    }else if (actionSheet.tag==2){
        if(buttonIndex == 0)
            
        {
            [self unBlockUser];
        }
    }else if (actionSheet.tag==4){
        if(buttonIndex == 0)
            
        {
            [self deleteMessage];
        }
    }
    
}

#pragma mark UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
     UIImage *image = info[UIImagePickerControllerOriginalImage];
     uploadImg=[[UIImageView alloc] initWithImage:image];
    
         [picker dismissViewControllerAnimated:YES completion:^{
             [self uploadOnlyPhoto:@"flok/sendChat" :uploadImg];
         }];
     
 }

-(void)blockUser{
    
   // NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&blocked_user_id=%@",userId,strFriendId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/block" serviceType:@"POST"];
    [btnDone setTag:2];
    isBlock=YES;
}
-(void)unBlockUser{
    
   // NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&blocked_user_id=%@",userId,strFriendId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/unblock" serviceType:@"POST"];
    [btnDone setTag:1];
    isBlock=NO;
    
}

-(void)deleteMessage{
    
    NSDictionary *dict=[arrChat objectAtIndex:selectdIndexPath.row];
    //NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&message_id=%@",userId,[dict valueForKey:@"id"]];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/messagedelete" serviceType:@"POST"];

}
-(void)uploadMsgImg{
    
}

@end
