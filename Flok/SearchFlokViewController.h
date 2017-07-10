//
//  SearchFlokViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 23/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SearchFlokViewController : UIViewController
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tblMain;
    IBOutlet UIView *vwSearch;
    IBOutlet UIView *vwNoData;
    NSMutableArray *arrFlok;
    NSMutableArray *arrUser;
    NSMutableArray *arrHashTag;
    BOOL isSearching;
    BOOL isHashtag;
}
@property(nonatomic,strong)IBOutlet UITextField *tfSearch;
@end
