//
//  LikeUsersViewController.h
//  Tchin
//
//  Created by NITS_Mac3 on 11/08/17.
//  Copyright © 2017 NITS_Mac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeUsersViewController : UIViewController
@property (retain, nonatomic) NSMutableDictionary *dictPost;
@property (weak, nonatomic) IBOutlet UITableView *tblMain;
@end
