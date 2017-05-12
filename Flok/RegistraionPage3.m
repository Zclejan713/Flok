//
//  RegistraionPage3.m
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "RegistraionPage3.h"
#import "FindFriendsViewController.h"

@interface RegistraionPage3 ()
{
    NSMutableArray *arrGender;
    UIPickerView *myPickerView;
    NSString *strGender;
    NSInteger selectedRow;
    
    NSUserDefaults *prefs;
    
}

@end

@implementation RegistraionPage3

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"RegistraionPage3");
    self.view.backgroundColor=[UIColor clearColor];
    prefs=[NSUserDefaults standardUserDefaults];
    
    btnFnd.layer.cornerRadius=4;
    btnFnd.layer.borderWidth=2;
    btnFnd.layer.borderColor=[[UIColor whiteColor]CGColor];

    arrGender=[[NSMutableArray alloc]initWithArray:@[@"Male",@"Female"]];
    UIButton *btnrad=[UIButton buttonWithType:UIButtonTypeSystem];
    if ([strGender isEqualToString:@"M"])
        btnrad.tag=1;
    else if ([strGender isEqualToString:@"F"])
        btnrad.tag=2;
    else
        btnrad.tag=1;
    [self radioTap:btnrad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)radioTap:(UIButton*)btnTap
{
    [self.view endEditing:YES];
    if (btnTap.tag==1){
        
    }else if (btnTap.tag==2){
        
        [self moveToTabBarController];
        }

    
    for (id vw in vwRadio.subviews)
    {
        if ([vw isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)vw;
            if (btn.tag==btnTap.tag)
            {
                UIImageView *imgSelected=[vwRadio viewWithTag:btnTap.tag];
                imgSelected.image=radio_check;
            }
            else
            {
                UIImageView *imgSelected=[vwRadio viewWithTag:btn.tag];
                imgSelected.image=radio_uncheck;
            }
        }
    }
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
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
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
    
  /*  if(tfFname.text.length==0){
        [Global showOnlyAlert:@"Empty!" :@"Enter first name"];
        return ;
    }
    else    if(tfFname.text.length==0){
        [Global showOnlyAlert:@"Empty!" :@"Enter first name"];
        return ;
    }
    else    if(tfFname.text.length==0){
        [Global showOnlyAlert:@"Empty!" :@"Enter first name"];
        return ;
    }*/
    
    id temp=[prefs objectForKey:@"rem_userdetail"];
    NSString *userId=temp[@"id"];
    userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&first_name=%@&last_name=%@&gender=%@",userId,tfFname.text,tfLname.text,tfGender.text];
    
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/searchUser" serviceType:@"POST"];
    
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
            //vc.searchData=searchData;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }
}

-(void)moveToTabBarController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC =(UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:myVC animated:YES];
}








@end
