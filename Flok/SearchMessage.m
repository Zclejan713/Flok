//
//  SearchMessage.m
//  Flok
//
//  Created by NITS_Mac5 on 21/11/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "SearchMessage.h"
#import "AppDelegate.h"
#import "Global.h"
#import "WebImageOperations.h"
#import "ChatViewController.h"


@interface SearchMessage ()<UITextFieldDelegate>{


    __weak IBOutlet UITableView *searchTable;
      NSMutableArray *searchrr;
     NSTimer *searchTimer;

    __weak IBOutlet UITextField *searchTextF;
    CGFloat SystemWidth;
    NSString *userId;
    
    
    __weak IBOutlet UILabel *noalertlabel;

}

@end

@implementation SearchMessage

- (void)viewDidLoad {
    [super viewDidLoad];
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    // Do any additional setup after loading the view.
    SystemWidth=self.view.frame.size.width;
    searchrr=[[NSMutableArray alloc]init];
    [searchTextF addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    searchTable.hidden=YES;
    noalertlabel.hidden=YES;
    searchTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
-(void)textFieldDidChange :(UITextField *)textField{
    
    // if a timer is already active, prevent it from firing
    if (searchTimer != nil) {
        [searchTimer invalidate];
        searchTimer = nil;
    }
    
    // reschedule the search: in 1.0 second, call the searchForKeyword: method on the new textfield content
    searchTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                   target: self
                                                 selector: @selector(searchForKeyword:)
                                                 userInfo: searchTextF.text
                                                  repeats: NO];
    
}

- (void) searchForKeyword:(NSTimer *)timer
{
    NSLog(@"keyword-----%@",searchTextF.text);
    [searchrr removeAllObjects];
    [self show_searchResult];
    
}

-(void)show_searchResult{
 
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&username=%@",userId,searchTextF.text];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/messageuserlist" serviceType:@"POST"];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
     return YES;


}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/messageuserlist"])
    {
        NSLog(@"data-------%@",data);
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            NSArray *userlistarr=[data objectForKey:@"usersList"];
            for (NSDictionary *dic in userlistarr) {
                [searchrr addObject:dic];
            }
            
            if(searchrr.count>0){
            
                searchTable.hidden=NO;
                [searchTable reloadData];
                noalertlabel.hidden=YES;
            }
            else{
                searchTable.hidden=YES;
                noalertlabel.hidden=NO;
            }
            

        }
        else{
              searchTable.hidden=YES;
              noalertlabel.hidden=NO;
            return ;
            
        }
        
    }
    
}


#pragma mark Save image

-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview and:(UIActivityIndicatorView *)loder{
    
    [loder startAnimating];
    NSString* imageName=[url lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgview.image=[UIImage imageWithContentsOfFile:FilePath];
        [loder stopAnimating];
    }
    else
    {
        [WebImageOperations processImageDataWithURLString:url andBlock:^(NSData *imageData)
         {
             imgview.image=[UIImage imageWithData:imageData];
             [imageData writeToFile:FilePath atomically:YES];
             [loder stopAnimating];
         }];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
  
        return [searchrr count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict=[searchrr objectAtIndex:indexPath.row];
    
    UIView *whitebackview=[[UIView alloc]initWithFrame:CGRectMake(0, 88.8, SystemWidth, 1.2)];
    [whitebackview setBackgroundColor:[UIColor lightGrayColor]];
     whitebackview.alpha=0.2;
    [cell addSubview:whitebackview];
    
    UIImageView *search_image=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 50, 50)];
    search_image.layer.cornerRadius=search_image.frame.size.width/2;
    search_image.image=[UIImage imageNamed:@"demo"];
     NSString *userImg=[dict valueForKey:@"user_image"];
    
    if ([userImg length]==0) {
        search_image.image=[UIImage imageNamed:@"no-profile"];
    }
    else{
        
        [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:search_image and:nil];
    }
    search_image.clipsToBounds=YES;
    [cell addSubview:search_image];
    
    
    UILabel * searchname_lbl=[[UILabel alloc]initWithFrame:CGRectMake(15+50+15, 22, 280, 20)];
    searchname_lbl.textAlignment=NSTextAlignmentLeft;
    searchname_lbl.textColor=[UIColor blackColor];
    searchname_lbl.font=[UIFont systemFontOfSize:15.0f];
    searchname_lbl.text=[dict objectForKey:@"full_name"];
    [cell addSubview:searchname_lbl];
    
    UILabel * searchtype_lbl=[[UILabel alloc]initWithFrame:CGRectMake(15+50+15, 22+20+2, 280, 20)];
    searchtype_lbl.textAlignment=NSTextAlignmentLeft;
    searchtype_lbl.textColor=[UIColor lightGrayColor];
    searchtype_lbl.font=[UIFont systemFontOfSize:12.0f];
    [cell addSubview:searchtype_lbl];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[searchrr objectAtIndex:indexPath.row];
    ChatViewController *vc=(ChatViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatViewController"];
    vc.strFriendId=[dict valueForKey:@"user_id"];
    vc.isBlock=[[dict valueForKey:@"is_blocked"] boolValue];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
