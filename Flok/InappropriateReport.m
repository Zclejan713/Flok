//
//  InappropriateReport.m
//  Flok
//
//  Created by NITS_Mac3 on 14/12/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "InappropriateReport.h"
#import "WebImageOperations.h"
#import "Global.h"
@interface InappropriateReport ()

@end

@implementation InappropriateReport
@synthesize OtherUserId,OtherUserImg,OtherUserName;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    vwBg.layer.cornerRadius=5.f;
    vwBg.layer.borderColor=[[UIColor grayColor] CGColor];
    vwBg.layer.borderWidth=1.0f;
    tvDes.text=@"Enter your description";
    [tvDes setTextColor:[UIColor lightGrayColor]];
    lblName.text=OtherUserName;
    [self setImageWithurl:OtherUserImg andImageView:imgProfile and:nil];
    [self adddonebutton:tvDes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)submitAction:(id)sender{
    //http://104.131.83.218/flok_new/users/reportToAdmin

    if ([tvDes.text length]!=0) {
        NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        NSString *dataString=[NSString stringWithFormat:@"user_id=%@&block_user_id=%@&reason=%@",userId,OtherUserId,tvDes.text];
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/reportToAdmin" serviceType:@"POST"];
    }
}


#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}

-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/reportToAdmin"])
    {
         [Global showOnlyAlert:@"successfully submitted!" :nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- Textview delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([tvDes.text isEqualToString:@"Enter your description"]) {
        tvDes.text=@"";
        [tvDes setTextColor:[UIColor blackColor]];
    }
    if (isKeyBoard==NO) {
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            scroll.contentOffset = CGPointMake(0, textView.frame.origin.y+80);
        } completion:NULL];
        isKeyBoard=YES;
    }
   
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            scroll.contentOffset = CGPointMake(0, 0);
        }completion:NULL];
            
        isKeyBoard=NO;
    }
    return  YES;
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


-(void)adddonebutton:(UITextView*)tf
{
    UIToolbar * toolBar = [[UIToolbar alloc]init];
    toolBar.barTintColor=RGB(239, 244, 244);
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTap:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    tf.inputAccessoryView = toolBar;
    
}
-(void)doneTap:(UIButton*)sender
{
    [tvDes resignFirstResponder];
}
@end
