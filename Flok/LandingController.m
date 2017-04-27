//
//  ViewController.m
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "LandingController.h"
#import "AppDelegate.h"
#import "RegistraionPage1.h"

@interface LandingController ()
{
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignup;
    NSUserDefaults *prefs;
    
}

@end

@implementation LandingController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"LandingController");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=[UIColor clearColor];
    prefs=[NSUserDefaults standardUserDefaults];

    btnLogin.layer.cornerRadius=4;
    btnSignup.layer.cornerRadius=4;
    
    id dictprefs=[prefs objectForKey:@"rem_userdetail"];
    if ([dictprefs count]>0)
    {
        NSString *userid=[prefs objectForKey:@"rem_userdetail"][@"user_id"];
        if ([Global checkingempty:userid].length)
        {
            [self moveToTabBarController ];
           // [self moveToTabBarController];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)moveToTabBarController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC =(UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:myVC animated:YES];
}



#pragma mark facebookLogin

-(IBAction)facebookLoginAction:(id)sender
{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends",@"user_birthday", ]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error: %@",error);
             //[self showOnlyAlert:@"Sorry" :@"We cannot fetch this user's credential from facebook, Please try with another user."];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self fetchUserInfo];
              userDetailsDic=(NSDictionary*)result;
         }
     }];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        

        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,picture, email"}]
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
    NSLog(@"%@",[fbDic objectForKey:@"gender"]);
    
    NSString *fname;
    NSString *lname;
    
    NSArray *myArray = [[fbDic valueForKey:@"name"] componentsSeparatedByString:@" "];
    if (myArray.count>0) {
        fname=[myArray objectAtIndex:0];
    }
    
    if (myArray.count>1) {
        lname=[myArray objectAtIndex:1];
    }
    

    NSString *dataString=[NSString stringWithFormat:@"full_name=%@&email=%@&fb_user_id=%@&device_type=ios&device_token_id=%@",[fbDic valueForKey:@"name"],[fbDic valueForKey:@"email"],[fbDic valueForKey:@"id"],app.deviceToken];
    
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/facebookSignup" serviceType:@"POST"];
    
    
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
     if ([serviceName isEqualToString:@"users/facebookSignup"]){
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.fbUserDic=nil;
            NSDictionary *temp=data[@"UserDetails"];
            [prefs setObject:temp forKey:@"rem_userdetail"];
            [prefs setObject:[temp valueForKey:@"user_id"] forKey:@"userId"];
            [prefs synchronize];
            [self moveToTabBarController];
           // [AppWindow makeToast:@"Login successful" duration:2 position:CSToastPositionBottom];
            
        }else{
            RegistraionPage1 *vc=(RegistraionPage1*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegistraionPage1"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        
        
    }
}


@end