//
//  AppDelegate.h
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "HCSStarRatingView.h"
#import "AjeetAnnotation.h"
#import "Global.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>





@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong,nonatomic) UIWindow *window;
@property(retain,nonatomic)NSMutableDictionary *fbUserDic;
@property (strong,nonatomic) NSString *deviceToken;
@property (strong,nonatomic) NSString *flokLocation;
@property (strong,nonatomic) NSString *flokLat;
@property (strong,nonatomic) NSString *flokLang;
@property(strong,nonatomic)UITabBarController *tabBarController;
@property (retain,nonatomic) NSDictionary *profileDic;
@property (assign)BOOL isRemoveFromFlok;
@end

