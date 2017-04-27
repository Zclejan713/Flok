//
//  EditProfileViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 07/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "EditProfileViewController.h"
#import "WebImageOperations.h"
#import "SecurityViewController.h"
@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"EditProfileViewController");
     scroll.contentSize=CGSizeMake(self.view.frame.size.width,900);
    
    imgTextBg.layer.cornerRadius=4;
    imgTextBg.layer.borderWidth=1;
    imgTextBg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    UIView *accessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    accessoryView.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btnDone=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 63, 40)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(DoneAction:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [accessoryView addSubview:btnDone];
    tvAboutMe.inputAccessoryView=accessoryView;
    tvAboutMe.text=@"Add bio to your profile";
    photoNo=1;
    imageId=@"";

    
    img1.layer.cornerRadius = 5;
    img1.layer.masksToBounds = YES;
    img2.layer.cornerRadius = 5;
    img2.layer.masksToBounds = YES;
    img3.layer.cornerRadius = 5;
    img3.layer.masksToBounds = YES;
    img4.layer.cornerRadius = 5;
    img4.layer.masksToBounds = YES;
    
    img1.layer.borderColor = [UIColor whiteColor].CGColor;
    img1.layer.borderWidth = 3.0f;
    img2.layer.borderColor = [UIColor whiteColor].CGColor;
    img2.layer.borderWidth = 3.0f;
    img3.layer.borderColor = [UIColor whiteColor].CGColor;
    img3.layer.borderWidth = 3.0f;
    img4.layer.borderColor = [UIColor whiteColor].CGColor;
    img4.layer.borderWidth = 3.0f;
    btnAdd.layer.borderColor = [UIColor whiteColor].CGColor;
    btnAdd.layer.borderWidth = 1.0f;
    
    [self getProfileInfo];
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];*/
    
    
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
-(void)viewWillAppear:(BOOL)animated{
    

    
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    int height = MIN(keyboardSize.height,keyboardSize.width);
    //int width = MAX(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        scroll.contentOffset = CGPointMake(0, height-170);
    } completion:NULL];
    
    
}
#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField==tfDob)
    {
        datepicker=[[UIDatePicker alloc]init];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker setMaximumDate:[NSDate date]];
        textField.inputView=datepicker;
        
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectdatemonthyear:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [textField setInputAccessoryView:toolBar];
        
    }
    else{
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            scroll.contentOffset = CGPointMake(0, textField.frame.origin.y-200);
        } completion:NULL];
        
        NSLog(@"textView.frame.origin.y %f",textField.frame.origin.y-250);

      //  textField.inputAccessoryView=[self keyboard_toolbar];
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        scroll.contentOffset = CGPointMake(0, 0);
    }completion:NULL];
    return YES;
}
#pragma mark- Textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        scroll.contentOffset = CGPointMake(0, textView.frame.origin.y-200);
    } completion:NULL];
    
        return YES;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
       // scroll.contentSize=CGSizeMake(self.view.frame.size.width,1050);
        [textView resignFirstResponder];
        return NO; // or true, whetever you's like
    }
    
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add bio to your profile"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add bio to your profile";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
-(IBAction)getFriendView:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwFriend setFrame:CGRectMake(0, 0, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    [UIView commitAnimations];
}
    
-(IBAction)goToAccountSetting:(id)sender{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecurityViewController *vc=(SecurityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SecurityViewController"];
    vc.isPrivate=isPrivate;
    [self.navigationController pushViewController:vc animated:YES];
}
    
#pragma mark- call user details  api
-(void)getProfileInfo{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/userprofile" serviceType:@"POST"];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
-(void)setDataToVewpage:(NSDictionary*)dict{
    
    //NSString * str=[dict valueForKey:@"full_name"];
    //NSArray * arr = [str componentsSeparatedByString:@" "];
    isPrivate=[[dict valueForKey:@"profile_setting"] boolValue];
    if (isPrivate==YES) {
        lblPrivacy.text=@"Private";
    }else{
       lblPrivacy.text=@"Public";
    }
    tfFirstName.text=[dict valueForKey:@"full_name"];
    tfDob.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"dob"]];
    tvAboutMe.text=[dict valueForKey:@"about_me"];
    tfPhone.text=[dict valueForKey:@"phone"];
    tfEmail.text=[dict valueForKey:@"email"];
    tfUserName.text=[dict valueForKey:@"username"];
    
    tfWork.text=[dict valueForKey:@"work"];
    tfSchool.text=[dict valueForKey:@"school"];
    
    NSString *userImg=[dict valueForKey:@"image"];
    
    if ([userImg length]==0) {
        profileImg.image=[UIImage imageNamed:@"no-profile"];
    }else{
        
        [self setImageWithurl:[dict valueForKey:@"image"] andImageView:profileImg and:nil];
    }
    arrImage=[[NSArray alloc] initWithArray:[dict valueForKey:@"allimages"]];
    [self profileScrollImage:[dict valueForKey:@"allimages"]];
}

-(void)profileScrollImage:(NSMutableArray*)myarr
{
    for (int i=0; i<myarr.count; i++) {
        NSDictionary *dict=[myarr objectAtIndex:i];
        if (i==0) {
            [self setImageWithurl:[dict valueForKey:@"image"] andImageView:img1 and:nil];
        }else if (i==1){
             [self setImageWithurl:[dict valueForKey:@"image"] andImageView:img2 and:nil];
        }else if (i==2){
            [self setImageWithurl:[dict valueForKey:@"image"] andImageView:img3 and:nil];
        }else if (i==3){
            [self setImageWithurl:[dict valueForKey:@"image"] andImageView:img4 and:nil];
        }
    }
}
-(IBAction)editProfileAction:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
    
    isImageEdit=YES;
}

#pragma mark- Webservice
- (IBAction)saveAction:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [self.view endEditing:YES];
    
    if (tfFirstName.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your full name"];
    }
//    else if (tvAboutMe.text.length==0)
//    {
//        [Global showOnlyAlert:@"Empty!" :@"Add bio to your profile"];
//    }
    else if (tfWork.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your work"];
    }
    else if (tfSchool.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your school"];
    }
    
    else
    {
        //NSString *age=[NSString stringWithFormat:@"%@",tfDob.text];
       NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        strName=[NSString stringWithFormat:@"%@ %@",tfFirstName.text,tfLastName.text];
               
        if (isImageEdit==YES) {
           // [self uploadPhoto:@"users/updateProfile"];
        }else{
            NSString *dataString=[NSString stringWithFormat:@"work=%@&school=%@&about_me=%@&user_id=%@",tfWork.text,tfSchool.text,tvAboutMe.text,userId];
            [[Global sharedInstance] setDelegate:(id)self];
            [[Global sharedInstance] serviceCall:dataString servicename:@"users/updateProfile" serviceType:@"POST"];
        }
        
    }
}
-(IBAction)addImage1:(id)sender{
    
    //add2.hidden=YES;
    photoNo=1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
}
-(IBAction)addImage2:(id)sender{
    
    //add2.hidden=YES;
    photoNo=2;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
}
-(IBAction)addImage3:(id)sender{
    //add3.hidden=YES;
    photoNo=3;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
    
}
-(IBAction)addImage4:(id)sender{
   // add4.hidden=YES;
    photoNo=4;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/userprofile"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            NSDictionary *DicFlok=[data valueForKey:@"UserDetails"];
            [self setDataToVewpage:DicFlok];
        }
        else{
            [Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
            
        }
        
    }else if([serviceName isEqualToString:@"users/updateProfile"])
    {
        
        NSDictionary *DicFlok=[data valueForKey:@"UserDetails"];
        [self setDataToVewpage:DicFlok];
    }
}

-(void)uploadPhoto:(NSString*)ServiceName
{
    
    [SVProgressHUD showWithStatus:@"Please wait.."];
   
    
    
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,ServiceName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120000];
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = [NSString stringWithFormat:@"--"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //==============
    if([ServiceName isEqualToString:@"users/updateProfile"])
    {
        
        NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        strName=[NSString stringWithFormat:@"%@ %@",tfFirstName.text,tfLastName.text];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"user_id":[userId dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"full_name":[strName dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"email":[tfEmail.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"dob":[tfDob.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"username":[tfUserName.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"phone":[tfPhone.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"about_me":[tvAboutMe.text dataUsingEncoding:NSUTF8StringEncoding]];
       
        myRequestData=[Global makeData:myRequestData :boundary :@"File":@"jpg":@"profile_image":UIImageJPEGRepresentation(profileImg.image, 0.7)];
        
        
        
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
                                                      
                                                      if([ServiceName isEqualToString:@"users/updateProfile"])
                                                      {
                                                          NSDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                          NSLog(@"the post value:%@",dict);
                                                          
                                                          dict=[Global cleanJsonToObject:dict];
                                                          
                                                          if ([[dict objectForKey:@"ACK"] integerValue]==1)
                                                          {
                                                              [Global showOnlyAlert:@"Success" :@"Changes have been made successfully"];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                              
                                                              
                                                          }
                                                          else{
                                                              [Global showOnlyAlert:@"Error" :dict[@"msg"]];
                                                          }
                                                      }
                                                      
                                                  });
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
    
}


-(void)uploadOnlyPhoto:(NSString*)ServiceName :(UIImageView*)uploadImg;
{
    
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,ServiceName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120000];
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = [NSString stringWithFormat:@"--"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //==============
    if([ServiceName isEqualToString:@"users/adduserimage"])
    {
        
        NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"user_id":[userId dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"image_id":[imageId dataUsingEncoding:NSUTF8StringEncoding]];
       
        myRequestData=[Global makeData:myRequestData :boundary :@"File":@"jpg":@"image":UIImageJPEGRepresentation(uploadImg.image, 0.7)];
        
        
        
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
                                                      
                                                      if([ServiceName isEqualToString:@"users/adduserimage"])
                                                      {
                                                          NSDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                          NSLog(@"the post value:%@",dict);
                                                          
                                                          dict=[Global cleanJsonToObject:dict];
                                                          
                                                          if ([[dict objectForKey:@"Ack"] integerValue]==1)
                                                          {
                                                             // [Global showOnlyAlert:@"Success" :@"Changes have been made successfully"];
                                                              //[self.navigationController popViewControllerAnimated:YES];
                                                               [self getProfileInfo];
                                                              
                                                          }
                                                          else{
                                                              [Global showOnlyAlert:@"Error" :dict[@"msg"]];
                                                          }
                                                      }
                                                      
                                                  });
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
        
    {
        
      /*  UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:Nil];*/
        [self showCamera];
    }
    else if(buttonIndex == 1)
        
    {
       /* UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        [picker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
        [self presentViewController:picker animated:YES completion:Nil];*/
         [self openPhotoAlbum];
    }
}
#pragma mark UIImagePickerController delegate

/*- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        [self updateEditButtonEnabled];
        [self openEditor:nil];
        
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor:nil];
        }];
    }
}*/

-(void)ownPostEchoAlert{
    
  //  [self showOnlyAlert:@"We're Sorry..." :@"Users are not allowed to echo their own posts." :self];
}
-(void)ownPostLikeAlert{
    
   // [self showOnlyAlert:@"We're Sorry..." :@"Users are not allowed to like their own posts." :self];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *myImage = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = myImage;
        [self updateEditButtonEnabled];
        [self openEditor:nil];
       
        
        

    }];
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

-(IBAction)DoneAction:(id)sender{
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        scroll.contentOffset = CGPointMake(0, 0);
    }completion:NULL];
    [tvAboutMe  resignFirstResponder];
    
}
-(IBAction)resignKeyboard:(id)sender{
    
    [tfPhone  resignFirstResponder];
    //[tfUserName  resignFirstResponder];
   // [tfEmail  resignFirstResponder];
  //  [tfUserName  resignFirstResponder];
    
}

#pragma mark- Date Picker
-(void)selectedDate:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd"];
    tfDob.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datepickerDate.date]];
    [tfDob resignFirstResponder];
    
}

/*-(void)selectedMonth:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM"];
    tfMonth.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datepickerMonth.date]];
    [tfMonth resignFirstResponder];
    
}

-(void)selectedYear:(id)sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY"];
    tfYear.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datepickerYear.date]];
    [tfYear resignFirstResponder];
}
*/
-(void)selectdatemonthyear:(id)sender
{
    NSDateFormatter *dateFormat1=[[NSDateFormatter alloc]init];
    dateFormat1.dateStyle=NSDateFormatterMediumStyle;
   [dateFormat1 setDateFormat:@"yyyy-MM-dd"];
    tfDob.text=[NSString stringWithFormat:@"%@",[dateFormat1  stringFromDate:datepicker.date]];
    [tfDob resignFirstResponder];
    
    
   /* NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"MM"];
    tfMonth.text=[NSString stringWithFormat:@"%@",[dateFormat2  stringFromDate:datepicker.date]];
    [tfMonth resignFirstResponder];
    
    
    NSDateFormatter *dateFormat3=[[NSDateFormatter alloc]init];
    [dateFormat3 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat3 setDateFormat:@"YYYY"];
    tfYear.text=[NSString stringWithFormat:@"%@",[dateFormat3 stringFromDate:datepicker.date]];
    [tfYear resignFirstResponder];*/
    
}

-(UIToolbar *)keyboard_toolbar
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc]init];
    keyboardToolBar.barTintColor=RGB(239, 244, 244);
    [keyboardToolBar sizeToFit];
    keyboardToolBar.barStyle = UIBarStyleDefault;
    
  //  UIImage *backImage = [Global imageWithImage:[[UIImage imageNamed:@"prev"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] scaledToSize:CGSizeMake(20, 20)];
 //   UIImage *forwardImage =[Global imageWithImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] scaledToSize:CGSizeMake(20, 20)];
    keyboardToolBar.items=[NSArray arrayWithObjects:
                         //  [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(prev:)],
                           
                           //[[UIBarButtonItem alloc]initWithImage:forwardImage style:UIBarButtonItemStylePlain target:self action:@selector(next:)],
                           
                          // [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)],
                           nil];
    
    return keyboardToolBar;
}


#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = croppedImage;
    //tempImg=self.imageView.image;
    if (photoNo==1) {
        
        img1.image=self.imageView.image;
        img1.hidden=NO;
        img2.hidden=NO;
        profileImg.image=self.imageView.image;
        //add2.hidden=NO;
        if(arrImage.count>0){
            imageId=[[arrImage objectAtIndex:0] valueForKey:@"id"];
        }
        [self uploadOnlyPhoto:@"users/adduserimage" :profileImg];
    }else if (photoNo==2) {
        
        add2.hidden=NO;
        img3.hidden=NO;
        // add3.hidden=NO;
        img2.image=self.imageView.image;
        if(arrImage.count>1){
            imageId=[[arrImage objectAtIndex:1] valueForKey:@"id"];
        }
        [self uploadOnlyPhoto:@"users/adduserimage" :img2];
    }else if (photoNo==3) {
        
        add3.hidden=NO;
        img4.hidden=NO;
        // add4.hidden=NO;
        img3.image=self.imageView.image;
        if(arrImage.count>2){
            imageId=[[arrImage objectAtIndex:2] valueForKey:@"id"];
        }
        [self uploadOnlyPhoto:@"users/adduserimage" :img3];
    }else if (photoNo==4) {
        
         //add4.hidden=YES;
        img4.image=self.imageView.image;
        if(arrImage.count>3){
            imageId=[[arrImage objectAtIndex:3] valueForKey:@"id"];
        }
        [self uploadOnlyPhoto:@"users/adduserimage" :img4];
    }
   // [self UpdateProfileImage];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)updateEditButtonEnabled
{
    self.editButton.enabled = !!self.imageView.image;
}
#pragma mark - Action methods

- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.imageView.image;
    
    UIImage *image = self.imageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}
@end

