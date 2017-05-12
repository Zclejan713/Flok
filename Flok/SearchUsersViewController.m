//
//  SearchUsersViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 22/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "SearchUsersViewController.h"
#import "FindFriendsViewController.h"
@interface SearchUsersViewController ()

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrGender=[[NSMutableArray alloc]initWithArray:@[@"Male",@"Female"]];
    last_Id=@"";
    
    NSLog(@"SearchUsersViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)adddonebutton:(UITextField*)tf
{
    UIToolbar * toolBar = [[UIToolbar alloc]init];
    toolBar.barTintColor=RGB(239, 244, 244);
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTap:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    tf.inputAccessoryView = toolBar;
    
}

-(void)doneTap:(UIButton*)sender
{
    [self.view endEditing:YES];
    tfGender.text=arrGender[selectedRow];
}

#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==tfGender) {
        if (arrGender.count==0) {
            return NO;
        }
        
        //[self.view endEditing:YES];
        myPickerView = [[UIPickerView alloc] init];
        myPickerView.delegate =(id) self;
        myPickerView.dataSource =(id) self;
        myPickerView.showsSelectionIndicator = YES;
        tfGender.inputView=myPickerView;
        [self adddonebutton:tfGender];
        
    }
    else{
        [self adddonebutton:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (arrGender.count>0) {
        NSString *str=arrGender[row];
        if ([str isEqualToString:@"Female"]) strGender=@"F";
        else strGender=@"M";
        
        selectedRow=row;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrGender.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    
    title = arrGender[row];
    
    return title;
}

#pragma mark- Webservice
- (IBAction)findfndTap:(UIButton *)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
 //   if(tfFname.text.length==0){
 //       [Global showOnlyAlert:@"Empty!" :@"Enter first name"];
 //   }
//    else    if(tfFname.text.length==0){
//        [Global showOnlyAlert:@"Empty!" :@"Enter first name"];
//    }
//    else    if(tfFname.text.length==0){
//        [Global showOnlyAlert:@"Empty!" :@"Enter first name"];
//    }
    
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    searchData=[NSString stringWithFormat:@"user_id=%@&full_name=%@&gender=%@&last_id=%@",userId,tfFname.text,tfGender.text,last_Id];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:searchData servicename:@"users/searchUser" serviceType:@"POST"];

   
}



#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/searchUser"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            FindFriendsViewController *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FindFriendsViewController"];
            vc.arrFind=[data valueForKey:@"all_users"];
            vc.searchData=searchData;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }
}

@end
