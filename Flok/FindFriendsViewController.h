//
//  FindFriendsViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 21/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Social/SocialDefines.h>


@interface FindFriendsViewController : UIViewController<MFMessageComposeViewControllerDelegate,FBSDKAppInviteDialogDelegate>
{
    
    IBOutlet UITableView *tblFind;
    IBOutlet UITableView *tblInvite;
    IBOutlet UIView *vwInvite;
    IBOutlet UIButton *btnFindPeople;
    IBOutlet UIButton *btnInvitePeople;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnContact;
    IBOutlet UIButton *btnSync;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISearchBar *searchBar;
    
    IBOutlet UIView *vwSync;
    IBOutlet UIView *vwSearch;
    IBOutlet UIView *vwSocial;
    IBOutlet UIActivityIndicatorView *indicator;
    NSMutableArray *arrInvite;
    NSMutableArray *arrContact;
    NSMutableArray *arrSelected;
    NSMutableArray *filteredContentList;
    NSArray *arrAppUser;
    NSMutableArray *arrPhone;
    NSMutableArray *arrFacebook;
    NSArray *arrSection;
    NSArray *animalSectionTitles;
    //NSArray *arrUsers;
    NSArray *arrAppFbUser;
    NSString *strSessName,*strSessVal;
    NSMutableString *paramString;
    NSMutableDictionary *userDetailsDic;
    AppDelegate *app;
    BOOL isSearching;
    BOOL isFacebook;
    NSString *userId;
    NSString *last_Id;
    ACAccountStore *accountStore;
    ACAccount *faceBookAc;
    ACAccountType *accType;
    NSMutableArray *arrUsers;
    
}
@property(nonatomic,strong)IBOutlet UITextField *tfSearch;
@property(retain,nonatomic)NSString *searchData;
@property(retain,nonatomic)NSMutableArray *arrFind;
@end
