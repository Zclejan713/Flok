//
//  ViewController.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface LandingController : UIViewController
{
    NSDictionary *userDetailsDic;
     UITabBar *tabBar ;
}
@property (strong,nonatomic) UIWindow *window;
@end

