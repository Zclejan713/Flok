//
//  AppDelegate.m
//  Flok
//
//  Created by NITS_Mac4 on 16/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "AppDelegate.h"
#import "TreePage.h"
#import "NotificationPage.h"
#import "MessagePage.h"
#import "MePage.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize isRemoveFromFlok,profileDic;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   // [[UITabBar appearance]setTintColor:appOrange];
    self.window.backgroundColor = [UIColor whiteColor];
   // [[UIApplication
   //   sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //tabbar
       //[tabBarController setDelegate:self];
    [[UITabBar appearance] setTintColor:appOrangedark];
  //  [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
   // UIImage *whiteBackground = [UIImage imageNamed:@"whiteBackground"];
   // [[UITabBar appearance] setSelectionIndicatorImage:whiteBackground];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"simulator");
    NSString *tokenhardcode = @"71fe8a342f37e0b12e6ace5a055cb154aa56080cf194110fc3143305388c75a6";
    [[NSUserDefaults standardUserDefaults] setObject:tokenhardcode forKey:@"rem_devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _deviceToken=tokenhardcode;
#else
    NSLog(@"device");
#endif

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)device_Token
{
    NSString* newToken = [device_Token description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    _deviceToken=newToken;

}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSString *jsonString =[[userInfo objectForKey:@"aps"]  valueForKey:@"data"];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSString *notificationType =[NSString stringWithFormat:@"%@",[json valueForKey:@"type"]];
    NSDictionary *temp = json;
    
    if ([notificationType isEqualToString:@"test_push"]) {
        
       
        if ([[self topViewController]isKindOfClass:[TreePage class]]) {
            TreePage *vc=(TreePage*)[self topViewController];
            [vc changeTabBarIcon];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            //[UIView setAnimationDelay:0.1];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [vc.btnBubble setFrame:CGRectMake(vc.btnBubble.frame.origin.x,172, vc.btnBubble.frame.size.width, vc.btnBubble.frame.size.height)];
            [vc newflok:self];
            [UIView commitAnimations];

        }else if ([[self topViewController]isKindOfClass:[MessagePage class]]) {
            MessagePage *vc=(MessagePage*)[self topViewController];
            [vc changeTreeTabBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[MePage class]]) {
            MePage *vc=(MePage*)[self topViewController];
            [vc changeTreeTabBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[MessagePage class]]) {
            NotificationPage *vc=(NotificationPage*)[self topViewController];
            [vc changeTreeTabBarIcon];
            
        }
        
    }
    else if ([notificationType isEqualToString:@"FOLLOWREQUEST"] || [notificationType isEqualToString:@"FOLLOW"] || [notificationType isEqualToString:@"JOIN_REQUEST"] || [notificationType isEqualToString:@"ACCEPTED_JOIN_REQUEST"] || [notificationType isEqualToString:@"COMMENT"] || [notificationType isEqualToString:@"Like"] || [notificationType isEqualToString:@"Dislike"] ||  [notificationType isEqualToString:@"INVITE"] || [notificationType isEqualToString:@"JOINED"]) {
        
        if ([[self topViewController]isKindOfClass:[NotificationPage class]]) {
            NotificationPage *vc=(NotificationPage*)[self topViewController];
            [vc getNnotificationList];
            [vc changeTabBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[TreePage class]]) {
            TreePage *vc=(TreePage*)[self topViewController];
            [vc changeNotificationTabBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[MessagePage class]]) {
            MessagePage *vc=(MessagePage*)[self topViewController];
            [vc changeNotificationTabBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[MePage class]]) {
            MePage *vc=(MePage*)[self topViewController];
            [vc changeNotificationTabBarIcon];
            
        }
    }else if ([notificationType isEqualToString:@"SENDMESSAGE"] ) {
        
        if ([[self topViewController]isKindOfClass:[MessagePage class]]) {
            MessagePage *vc=(MessagePage*)[self topViewController];
            [vc getMessageList];
            [vc changeTabBarIcon];
           
            
        }else if ([[self topViewController]isKindOfClass:[TreePage class]]) {
            TreePage *vc=(TreePage*)[self topViewController];
            [vc changeMessageTabBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[MessagePage class]]) {
            NotificationPage *vc=(NotificationPage*)[self topViewController];
            [vc changeTabMessageBarIcon];
            
        }else if ([[self topViewController]isKindOfClass:[MePage class]]) {
            MePage *vc=(MePage*)[self topViewController];
            [vc changeMessageTabBarIcon];
            
        }
    }

    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else
    {
        return rootViewController;
    }
}

@end
