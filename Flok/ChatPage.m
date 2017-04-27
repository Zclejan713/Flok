//
//  ChatPage.m
//  Flok
//
//  Created by NITS_Mac4 on 17/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "ChatPage.h"
#import "ChatCell.h"



@interface ChatPage ()
{
    NSMutableArray *arrChat;
    
}


@end

@implementation ChatPage


#pragma mark- View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    NSLog(@"ChatPage");
    btnSend.layer.cornerRadius=btnSend.frame.size.height/2;
    btnSend.layer.masksToBounds=YES;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark- keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    //CGSize keyboardSize=[[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSValue* keyboardFrameBegin=[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    
    [UIView animateWithDuration:0.3 animations:^{
        vwSend.frame = CGRectMake(vwSend.frame.origin.x,keyboardFrameBeginRect.origin.y-vwSend.frame.size.height,vwSend.frame.size.width,vwSend.frame.size.height);
        CGRect frameTbl=tblChat.frame;
        frameTbl.size.height=frameTbl.size.height-keyboardFrameBeginRect.size.height+vwSend.frame.size.height;
        tblChat.frame=frameTbl;
    
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    //CGSize keyboardSize=[[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSValue* keyboardFrameBegin=[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    [UIView animateWithDuration:0.3 animations:^{
        vwSend.frame = CGRectMake(vwSend.frame.origin.x,keyboardFrameBeginRect.origin.y-vwSend.frame.size.height,vwSend.frame.size.width,vwSend.frame.size.height);
        CGRect frameTbl=tblChat.frame;
        frameTbl.size.height=SCREEN_HEIGHT-(60+vwSend.frame.size.height);
        tblChat.frame=frameTbl;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- Method
- (IBAction)backTap:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)infoTap:(UIButton *)sender {
}

#pragma mark- Table delegate & datasource
- (CGSize)findHeightForText:(NSString* )text havingSize:(CGSize)frameSize andFont:(UIFont *)font {
    
    CGFloat widthValue=frameSize.width;
    CGFloat heightValue=frameSize.height;
    CGSize size = CGSizeZero;
    if (font==nil) {
        font=[UIFont systemFontOfSize:12];
    }
    
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    if(size.height<heightValue)
    {
        size.height=heightValue;
    }
    else
    {
        //size.height=size.height+10;
    }
    return size;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblChat)
    {
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblChat)
    {
        if ([arrChat count])
        {
            //NSDictionary *dict=arrChat[indexPath.row];
            NSString *strText;

            ChatCell *cell=[[NSBundle mainBundle]loadNibNamed:@"ChatCell" owner:self options:nil][0];
            
            UIFont *myfont=cell.tvDesc.font;
            myfont=[UIFont systemFontOfSize:12];
            
            float height=[self findHeightForText:[NSString stringWithFormat:@"%@",strText] havingSize:cell.tvDesc.frame.size andFont:myfont].height+cell.lblTime.frame.size.height+(92-20);
            return height;

        }
    }
    
    return 92;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblChat)
    {
        NSString *cellIdentifier=@"tcell";
        ChatCell *cell=(ChatCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell=[[NSBundle mainBundle]loadNibNamed:@"ChatCell" owner:self options:nil][0];
        
        if ([arrChat count])
        {
            NSDictionary *dict=arrChat[indexPath.row];
            cell.lblName.text=[NSString stringWithFormat:@"%@",dict[@"user_name"]];
            cell.lblTime.text=[NSString stringWithFormat:@"%@",dict[@"date_time"]];
            
            NSString *strText=cell.tvDesc.text;

            
            UIFont *myfont=cell.tvDesc.font;
            myfont=[UIFont systemFontOfSize:12];
            CGRect tvFrame=cell.tvDesc.frame;
            tvFrame.size.height=[self findHeightForText:strText havingSize:cell.tvDesc.frame.size andFont:myfont].height;
            cell.tvDesc.frame=tvFrame;
            
            CGRect frameTime=cell.lblTime.frame;
            frameTime.origin.y=cell.tvDesc.frame.size.height+1;
            cell.lblTime.frame=frameTime;
            
            CGRect frmbody=cell.vwBody.frame;
            frmbody.size.height=cell.lblTime.frame.origin.y+cell.lblTime.frame.size.height+5;
            cell.vwBody.frame=frmbody;
            
            
            CGRect frmbg=cell.vwBg.frame;
            frmbg.size.height=cell.vwBg.frame.origin.y+cell.vwBg.frame.size.height+8;
            cell.vwBg.frame=frmbg;

        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblChat)
    {
        
    }
    
}

#pragma mark- Textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *str=[textView.text stringByReplacingCharactersInRange:range withString:text];
    str=[str stringByReplacingOccurrencesOfString:@"  " withString:@""];
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
}



@end
