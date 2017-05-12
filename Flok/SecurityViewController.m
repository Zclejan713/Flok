//
//  SecurityViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 25/01/17.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import "SecurityViewController.h"
#import "AppDelegate.h"
#import "Global.h"
@interface SecurityViewController ()

@end

@implementation SecurityViewController
    @synthesize isPrivate;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isPrivate==YES) {
       // [mySwitch setSelected:YES];
        [mySwitch setOn:YES animated:YES];
    }else{
       // [mySwitch setSelected:NO];
        [mySwitch setOn:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveSetting:(id)sender{
    [self setUserPrivacy];
    
}
-(IBAction)changeSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
    } else{
        NSLog(@"Switch is OFF");
    }
    
}
    
-(void)setUserPrivacy{
    NSString *str;
    if([mySwitch isOn]){
        str=@"1";
    } else{
        str=@"0";
    }

    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&profile_setting=%@",userId,str];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/updateprofilesetting" serviceType:@"POST"];
    
    
}
#pragma mark WebServiceCallDeleGate Methods
    
-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/updateprofilesetting"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [Global showOnlyAlert:@"Success" :@"Data saved successfully" ];
        }
        
    }
}
   
    
@end
