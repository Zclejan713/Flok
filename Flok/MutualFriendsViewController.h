//
//  MutualFriendsViewController.h
//  Flok
//
//  Created by Ritwik Ghosh on 15/10/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MutualFriendsViewController : UIViewController{
    IBOutlet UITableView *tblMain;
}
@property(nonatomic ,retain)NSString *facebookId;

@end
