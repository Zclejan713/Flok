//
//  HashTagFeed.h
//  Flok
//
//  Created by NITS_Mac3 on 08/12/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HashTagFeed : UIViewController
{
    IBOutlet UITableView *tblMain;
    NSMutableArray *arrList;
    NSString *userId;
    NSString *latitude;
    NSString *longitude;
    NSDictionary *tempDic;
    NSIndexPath *tempIndexPath;
}
@property(nonatomic ,retain)NSString *hashtag;
@end
