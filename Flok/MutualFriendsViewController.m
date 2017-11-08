//
//  MutualFriendsViewController.m
//  Flok
//
//  Created by Ritwik Ghosh on 15/10/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import "MutualFriendsViewController.h"
#import "MutualFriendTableViewCell.h"
#import "WebImageOperations.h"

@interface MutualFriendsViewController ()
{
    NSArray *arrFriends;
}
@end

@implementation MutualFriendsViewController
@synthesize facebookId;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblMain.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self fetchUserInfo ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fetchUserInfo
{
    
    NSString *strTemp=[NSString stringWithFormat:@"/%@/friends",facebookId];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:strTemp
                                  parameters:@{@"fields": @"id, name, email"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSDictionary  *userDetailsDic=(NSDictionary*)result;
        arrFriends=[[NSArray alloc] initWithArray:[userDetailsDic valueForKey:@"data"]];
        if (arrFriends.count>0) {
            
            [tblMain reloadData];
        }
        else{
           
        }
    }];
}

#pragma mark- Table datasource & delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        
    return [arrFriends count];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"CellIdentifier";
    MutualFriendTableViewCell *cell=(MutualFriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // cell=nil;
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MutualFriendTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
        NSDictionary *dic=[arrFriends objectAtIndex:indexPath.row];
        cell.lblName.text=[dic valueForKey:@"name"];
        cell.imgUser.layer.cornerRadius=cell.imgUser.frame.size.height/2;
         cell.imgUser.layer.masksToBounds=YES;
       // [cell.indicator startAnimating];
       // [self setImageWithurl:imgUrl andImageView:cell.imgUser and:cell.indicator];
    
    NSString *imgstr = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[dic valueForKey:@"id"]];
    
    if ([imgstr length]==0) {
        
        cell.imgUser.image=[UIImage imageNamed:@"no-profile"];
        
    }
    else{
        
        NSString* imageName=[imgstr lastPathComponent];
        if ([imageName isEqualToString:@"no.png"]) {
            cell.imgUser.image=[UIImage imageNamed:@"no-profile"];
            
        }else{
            
            [self setImageWithurlForFB:imgstr andImageView:cell.imgUser and:cell.indicator];
        }
    }
    
    
    return cell;
    
}

-(void)setImageWithurlForFB:(NSString*)url andImageView:(UIImageView*)imgview and:(UIActivityIndicatorView *)loder{
    
    [loder startAnimating];
    
    [WebImageOperations processImageDataWithURLString:url andBlock:^(NSData *imageData)
     {
         imgview.image=[UIImage imageWithData:imageData];
         // [imageData writeToFile:FilePath atomically:YES];
         [loder stopAnimating];
     }];
    //}
    
}

@end
