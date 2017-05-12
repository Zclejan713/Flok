//
//  LogInController.m
//  Ourtistry
//
//  Created by NITS_Mac1 on 22/03/16.
//  Copyright © 2016 NITS_Mac1. All rights reserved.
//

#import "LogInController.h"
#import "AppDelegate.h"
#import "RegistraionPage1.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LogInController ()
{
    NSUserDefaults *prefs;
}

@end

@implementation LogInController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"LogInController");
    self.view.backgroundColor=[UIColor clearColor];
    prefs=[NSUserDefaults standardUserDefaults];
    
    btnLogin.layer.cornerRadius=4;
    btnLogin.layer.borderWidth=2;
    btnLogin.layer.borderColor=[[UIColor whiteColor]CGColor];

    //scrlMain.contentSize=CGSizeMake(SCREEN_WIDTH, 750);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Keyboard notification
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UIScrollView *someScrollView = scrlMain;
    
    CGPoint bottomPoint = CGPointMake(0, CGRectGetMaxY([someScrollView bounds]));
    CGPoint convertedTableViewBottomPoint = [someScrollView convertPoint:bottomPoint
                                                                  toView:keyWindow];
    
    CGFloat keyboardOverlappedSpaceHeight = convertedTableViewBottomPoint.y - keyBoardFrame.origin.y;
    
    if (keyboardOverlappedSpaceHeight > 0)
    {
        UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(0, 0, keyboardOverlappedSpaceHeight+10, 0);
        [someScrollView setContentInset:tableViewInsets];
        //[scrlView scrollRectToVisible:tvDescribeYourself.frame animated:YES];
        
    }
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    UIEdgeInsets edgeinsets = UIEdgeInsetsZero;
    UIScrollView *someScrollView = scrlMain;
    [someScrollView setContentInset:edgeinsets];
}

-(UIToolbar *)keyboard_toolbar
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc]init];
    keyboardToolBar.barTintColor=RGB(239, 244, 244);
    [keyboardToolBar sizeToFit];
    keyboardToolBar.barStyle = UIBarStyleDefault;
    
    UIImage *backImage = [Global imageWithImage:[[UIImage imageNamed:@"prev"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] scaledToSize:CGSizeMake(20, 20)];
    UIImage *forwardImage =[Global imageWithImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] scaledToSize:CGSizeMake(20, 20)];
    keyboardToolBar.items=[NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(prev:)],
                           
                           [[UIBarButtonItem alloc]initWithImage:forwardImage style:UIBarButtonItemStylePlain target:self action:@selector(next:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)],
                           nil];
    
    return keyboardToolBar;
}

-(void)prev:(id)sender
{
    UIView *firstResponder;
    UIView *vw=scrlMain.subviews[0];
    for (UIView *view in vw.subviews) //: caused error
    {
        if (view.isFirstResponder)
        {
            firstResponder = view;
            //break;
        }
    }
    
    if (firstResponder==tfPassword)
    {
        [tfEmail becomeFirstResponder];
    }
    else if (firstResponder==tfEmail)
    {
        
    }
    
}

-(void)next:(id)sender
{
    UIView *firstResponder;
    UIView *vw=scrlMain.subviews[0];
    for (UIView *view in vw.subviews) //: caused error
    {
        if (view.isFirstResponder)
        {
            firstResponder = view;
            //break;
        }
    }
    
    //signin
    if (firstResponder==tfEmail)
    {
        [tfPassword becomeFirstResponder];
    }
    else if (firstResponder==tfPassword)
    {
        
    }
    
}

-(void)resignKeyboard:(id)sender
{
    UIView *vw=scrlMain.subviews[0];
    for (id view in vw.subviews){
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
            [self.view endEditing:YES];
            
        }
    }
}

#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView=[self keyboard_toolbar];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark button-action
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moveToTabBarController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC =(UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:myVC animated:YES];
}

-(IBAction)btnNewUserSignUpPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC =(UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"RegistraionPage1"];
    [self.navigationController pushViewController:myVC animated:YES];
}


#pragma mark- Webservice
-(IBAction)btnLogInPressed:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    
    if (tfEmail.text.length==0)
    {
        [AppWindow makeToast:@"Please enter your email" duration:2 position:CSToastPositionBottom];
    }
    else if (![Global validateEmail:tfEmail.text])
    {
        [AppWindow makeToast:@"Please enter a valid email" duration:2 position:CSToastPositionBottom];
    }
    else if (tfPassword.text.length==0)
    {
        [AppWindow makeToast:@"Please enter your password" duration:2 position:CSToastPositionBottom];
    }
    else
    {
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *dataString=[NSString stringWithFormat:@"email=%@&password=%@&device_type=ios&device_token_id=%@",tfEmail.text,tfPassword.text,app.deviceToken];
        
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:@"users/appsignin" serviceType:@"POST"];
    
    }
    
}


#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
   [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/appsignin"])
    {
    
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            NSDictionary *temp=data[@"UserDetails"];
            [prefs setObject:temp forKey:@"rem_userdetail"];
            [prefs setObject:[data valueForKey:@"user_id"] forKey:@"userId"];
            [prefs synchronize];
            [self moveToTabBarController];
            
            [AppWindow makeToast:@"Login successful" duration:2 position:CSToastPositionBottom];
            
        }
        else{
            [Global showOnlyAlert:@"Flok!" :[data valueForKey:@"msg"]];
            return ;
            
        }
        
    }else if ([serviceName isEqualToString:@"users/facebookSignup"]){
        
            if ([[data valueForKey:@"Ack"] intValue]==1) {
                AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
                app.fbUserDic=nil;
                NSDictionary *temp=data[@"UserDetails"];
                [prefs setObject:temp forKey:@"rem_userdetail"];
                [prefs setObject:[data valueForKey:@"user_id"] forKey:@"userId"];
                [prefs synchronize];
                [self moveToTabBarController];
                
               // [AppWindow makeToast:@"Login successful" duration:2 position:CSToastPositionBottom];

            }else{
                RegistraionPage1 *vc=(RegistraionPage1*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegistraionPage1"];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        
        
    }
}


#pragma mark facebookLogin

-(IBAction)facebookLoginAction:(id)sender
{
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/{user-id}/friends"
                                  parameters:@{@"fields": @"id, name,picture.type(large), email"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"result is:%@",result);
        userDetailsDic=(NSDictionary*)result;
    }];
    
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name,picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"result is:%@",result);
                 userDetailsDic=(NSDictionary*)result;
                 NSString *strEmail=[userDetailsDic valueForKey:@"email"];
                 if ([strEmail length]==0) {
                     // vwEamil.hidden=NO;
                 }else{
                     [self fbSignIn:userDetailsDic ];
                     // [self facebookCheck:[userDetailsDic valueForKey:@"id"]];   //fb login api call
                 }
                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
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
-(void)fbSignIn:(NSDictionary*)fbDic{
    AppDelegate  *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.fbUserDic=[[NSMutableDictionary alloc] initWithDictionary:fbDic];
  
    NSString *fname;
    NSString *lname;
    
    NSArray *myArray = [[fbDic valueForKey:@"name"] componentsSeparatedByString:@" "];
    if (myArray.count>0) {
        fname=[myArray objectAtIndex:0];
    }
    
    if (myArray.count>1) {
        lname=[myArray objectAtIndex:1];
    }
       
  
    NSString *dataString=[NSString stringWithFormat:@"full_name=%@email=%@&fb_user_id=%@&device_type=ios&device_token_id=%@",[fbDic valueForKey:@""],[fbDic valueForKey:@""],[fbDic valueForKey:@""],app.deviceToken];
    
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/facebookSignup" serviceType:@"POST"];
   
    
}




@end
