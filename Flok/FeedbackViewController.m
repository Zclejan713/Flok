//
//  FeedbackViewController.m
//  CabApplication
//
//  Created by Ritwik Ghosh on 17/04/2015.
//  Copyright (c) 2015 nits. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "WebImageOperations.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize userData;
- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"FeedbackViewController");
    
    lblName.text=[userData valueForKey:@"full_name"];
    [self setImageWithurl:[userData valueForKey:@"user_image"] andImageView:profileImg];
    
    [self.navigationItem setTitle:@"Rating"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIImage *buttonImage = [UIImage imageNamed:@"back-button.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    profileImg.layer.cornerRadius=profileImg.frame.size.width/2;
    profileImg.layer.borderColor=[[UIColor whiteColor] CGColor];
    profileImg.layer.borderWidth=2.f;
    [profileImg.layer setMasksToBounds:YES];

    btnCancel.layer.cornerRadius=5.f;
    [btnCancel.layer setMasksToBounds:YES];
    
    btnSave.layer.cornerRadius=5.f;
    [btnSave.layer setMasksToBounds:YES];
    
    vw1.layer.cornerRadius=5.f;
    [vw1.layer setMasksToBounds:YES];
    
    vw2.layer.cornerRadius=5.f;
    [vw2.layer setMasksToBounds:YES];
    
     vw3.layer.cornerRadius=5.f;
    [vw3.layer setMasksToBounds:YES];
    
    tvComment.text = @"Please enter your feedback";
    tvComment.textColor = [UIColor lightGrayColor];


    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    slider=[[UISlider alloc]initWithFrame:CGRectMake(45, 1, 151, 40)];
    [slider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    
    [slider setMaximumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [slider setTintColor:[UIColor colorWithRed:255.0f/256.0f green:102.0f/256.0f blue:0.0 alpha:0.5]];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [slider addGestureRecognizer:gr];
    
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderChangedEnded:) forControlEvents:UIControlEventTouchUpInside];
    
    [self imageChange:slider];
    [viewStarRating addSubview:slider];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sliderChangedEnded:(id)sender
{
    UISlider *sliderA=(UISlider*)sender;
    NSLog(@"Value Changed");
    rating=sliderA.value*5;
    NSLog(@"rating value---%f",rating);
    //[self performSelector:@selector(saveAction:) withObject:nil afterDelay:0.01];
    
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
    if ([textView.text isEqualToString:@"Please enter your feedback"]) {
        tvComment.text = @"";
        tvComment.textColor = [UIColor blackColor];
        
    }
    return  YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view .frame = CGRectMake(self.view.frame.origin.x, 0,
                                      self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
-(void) textViewDidChange:(UITextView *)textView
{
    
    if(tvComment.text.length == 0){
        tvComment.textColor = [UIColor lightGrayColor];
        tvComment.text = @"Please enter your feedback";
        [tvComment resignFirstResponder];
    }
    
    
}
-(void)imageChange:(UISlider*)tSlider
{
    
    float value=slider.value;
    NSLog(@"float value=%f",value);
    
    if(value==0.0)
    {
        lblRating.text=@"0";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars"]]];
    }
    else if(value>0.0 && value<0.10)
    {
        lblRating.text=@"1";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st1.png"]]];
    }
    else if(value>0.10 && value<=0.20)
    {
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st2.png"]]];
    }
    else if(value>0.20 && value<=0.30)
    {
        lblRating.text=@"1.5";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st3.png"]]];
    }
    else if(value>0.30 && value<=0.40)
    {
        lblRating.text=@"2";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st4.png"]]];
    }
    else if(value>0.40 && value<=0.50)
    {
        lblRating.text=@"2.5";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st5.png"]]];
    }
    else if(value>0.50 && value<=0.60)
    {
        lblRating.text=@"3";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st6.png"]]];
    }
    else if(value>0.60 && value<=0.70)
    {
        lblRating.text=@"3.5";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st7.png"]]];
    }
    else if(value>0.70 && value<=0.80)
    {
        lblRating.text=@"4";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st8.png"]]];
    }
    else if(value>0.80 && value<=0.90)
    {
        lblRating.text=@"4.5";
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st9.png"]]];
    }
    else
    {
        [tSlider setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"st10.png"]]];
        lblRating.text=@"5";
    }
    
}
- (void)sliderTapped:(UIGestureRecognizer *)g
{
    UISlider* sliderG = (UISlider*)g.view;
    if (sliderG.highlighted) return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: sliderG];
    CGFloat percentage = pt.x / sliderG.bounds.size.width;
    CGFloat delta = percentage * (sliderG.maximumValue - sliderG.minimumValue);
    CGFloat fvalue = sliderG.minimumValue + delta;
    [sliderG setValue:fvalue animated:YES];
    rating=sliderG.value*5;
    NSLog(@"rating value---%.1f",rating);
    [self imageChange:sliderG];
}
-(void)sliderChanged:(id)sender
{
    UISlider *sliderA=(UISlider*)sender;
    rating=sliderA.value*5;
    NSLog(@"rating value---%.2f",rating);
    [self imageChange:sliderA];
}

-(IBAction)saveAction:(id)sender{
    NSString*rat=[NSString stringWithFormat:@"%.1f",rating];
    
   // [self ServiceCall:@"rating" :dataString];
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&flok_id=%@&reviewer_id=%@&rating=%@",[userData valueForKey:@"user_id"],[userData valueForKey:@"flok_id"],userId,rat];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/addUserRating" serviceType:@"POST"];
    

}
-(IBAction)cancelAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:NO];

}
-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview{
    
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
             BOOL finished=[imageData writeToFile:FilePath atomically:YES];
             if(finished)
             {
                 //[self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:FilePath isDirectory:NO]];
             }
             
         }];
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *myImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
         profileImg.image=myImage;
    }];
    
    
}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}

-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/addUserRating"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [[[UIAlertView alloc]initWithTitle:@"" message:@"You have successfully rated to this user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show ];
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        else{
            
            [[[UIAlertView alloc]initWithTitle:@"" message:[data valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show ];
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
