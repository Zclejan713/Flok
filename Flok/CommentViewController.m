//
//  CommentViewController.m
//  Flok
//
//  Created by Ritwik Ghosh on 27/07/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
{
    float keyHeight;
}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)postAction:(id)sender {
    
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
    
    _vwComment.frame = CGRectMake(_vwComment.frame.origin.x,self.view.frame.size.height-_vwComment.frame.size.height ,_vwComment.frame.size.width,_vwComment.frame.size.height);
    
    CGRect frameTbl=_tblMain.frame;
    frameTbl.size.height=frameTbl.size.height+keyHeight;
    _tblMain.frame=frameTbl;
    [UIView commitAnimations];
    isKeyOpen=NO;
    [_tvComment resignFirstResponder];
}

#pragma mark- Textview delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([_tvComment.text isEqualToString:@"Add your comment"]) {
        _tvComment.text = @"";
        _tvComment.textColor = [UIColor blackColor];
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
            
            CGRect vwframe=_vwComment.frame;
            vwframe.size.height=60;
            vwframe.origin.y=commentFrame;
            _vwComment.frame=vwframe;
            
            [textView resignFirstResponder];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            /* self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
             self.view.frame.size.width, self.view.frame.size.height);*/
            
            _vwComment.frame = CGRectMake(_vwComment.frame.origin.x,self.view.frame.size.height-_vwComment.frame.size.height ,_vwComment.frame.size.width,_vwComment.frame.size.height);
            
            CGRect frameTbl=_tblMain.frame;
            frameTbl.size.height=frameTbl.size.height+keyHeight;
            _tblMain.frame=frameTbl;
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
        tfComment.text = @"Add your comment";
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
@end
