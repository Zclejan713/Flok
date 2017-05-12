  //
//  SettingPage.m
//  Flok
//
//  Created by NITS_Mac4 on 18/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "SettingPage.h"
#import "TermsConditionsViewController.h"

@interface SettingPage ()

@end

@implementation SettingPage
@synthesize isPrivate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
     NSLog(@"SettingPage");
    
    DistanceSlider.minimumValue = 0;
    DistanceSlider.maximumValue = 100;
    DistanceSlider.value = 10;
    
    miles=[[NSUserDefaults standardUserDefaults] objectForKey:@"miles"];
    scrlMain.contentSize=CGSizeMake(SCREEN_WIDTH, 580);
    
    slider = [[RangeSlider alloc] initWithFrame:CGRectMake(0, 0,vwTemp.frame.size.width, 30)]; // the slider enforces a height of 30, although I'm not sure that this is necessary
    
    slider.minimumRangeLength = 0.0; // this property enforces a minimum range size. By default it is set to 0.0
    
    [slider setMinThumbImage:[UIImage imageNamed:@"rangethumb.png"]]; // the two thumb controls are given custom images
    [slider setMaxThumbImage:[UIImage imageNamed:@"rangethumb.png"]];
    
    
    UIImage *image; // there are two track images, one for the range "track", and one for the filled in region of the track between the slider thumbs
    
    [slider setTrackImage:[[UIImage imageNamed:@"fullrange.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)]];
    
    image = [UIImage imageNamed:@"fillrange.png"];
    [slider setInRangeTrackImage:image];
    [slider addTarget:self action:@selector(reportForAge:) forControlEvents:UIControlEventValueChanged];
    reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 310, 30)]; // a label to see the values of the slider in this demo
    reportLabel.adjustsFontSizeToFitWidth = YES;
    reportLabel.textAlignment = NSTextAlignmentCenter;
    NSString *report = [NSString stringWithFormat:@"current slider range is %f to %f", slider.min, slider.max];
    
    reportLabel.text = report;
    [vwTemp addSubview:slider];
    
    if (isPrivate==YES) {
        [imgCheck setImage:[UIImage imageNamed:@"check"]];
        isCheck=YES;
    }else{
        [imgCheck setImage:[UIImage imageNamed:@"uncheck"]];
        isCheck=NO;
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    

    arrGender=[[NSMutableArray alloc]initWithArray:@[@"Male",@"Female",@"Both"]];
    UIButton *btnrad=[UIButton buttonWithType:UIButtonTypeSystem];
    if ([strGender isEqualToString:@"M"])
        btnrad.tag=1;
    else if ([strGender isEqualToString:@"F"])
        btnrad.tag=2;
    else
        btnrad.tag=1;
    [self radioTap:btnrad];
  
   // NSLog(@"--%f---%f",slider.max,slider.min);
    
    
    [self getUserSettingInfo];
    
   
}
- (IBAction)backTap:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)privacyPolicy:(id)sender{
  
    TermsConditionsViewController *vc=(TermsConditionsViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
    vc.strLink=@"Privacy Policy";
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)termsAndConditions:(id)sender{
    
    TermsConditionsViewController *vc=(TermsConditionsViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
    vc.strLink=@"Trams & Conditions";
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)checkBoxClick:(id)sender{
    
    if (isCheck) {
        [imgCheck setImage:[UIImage imageNamed:@"uncheck"]];
        isCheck=NO;
        [self setUserPrivacy:@"0"];
      
    }else{
        [imgCheck setImage:[UIImage imageNamed:@"check"]];
        isCheck=YES;
        [self setUserPrivacy:@"1"];
    }
}
-(void)setUserPrivacy:(NSString*)str{
    
  /*  NSString *str;
    if([mySwitch isOn]){
        str=@"1";
    } else{
        str=@"0";
    }*/
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@&profile_setting=%@",userId,str];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/updateprofilesetting" serviceType:@"POST"];
    
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    lblMiles.text =[NSString stringWithFormat:@"%@ miles",[@((int)sender.value) stringValue]];
    floatGender=sender.value;
    miles=[@((int)sender.value) stringValue];
    [prefs setObject:miles forKey:@"distance"];
    [prefs synchronize];
}

- (IBAction)ageSliderValueChanged:(UISlider *)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
   // lblAge.text =[NSString stringWithFormat:@"%@ year",[@((int)sender.value) stringValue]];
    age=[@((int)sender.value) stringValue];
    floatGender=sender.value;
}

- (IBAction)radioTap:(UIButton*)btnTap
{
    
    [Global disableAfterClick:btnTap];
    
    [self.view endEditing:YES];
    if (btnTap.tag==1)
        strGender=@"M";
    else if (btnTap.tag==2)
        strGender=@"F";

}
- (void)reportForAge:(RangeSlider *)sender {
    
    sliderMin=[NSString stringWithFormat:@"%f",slider.min];
    sliderMax =[NSString stringWithFormat:@"%f",slider.max];
    floatMin=slider.min;
    floatMax=slider.max;
    NSLog(@"check slider value %f---%f",slider.min ,slider.max);
    lblMinAge.text=[NSString stringWithFormat:@"%.f", 16+(44.5*slider.min)];
    lblMaxAge.text=[NSString stringWithFormat:@"%.f",16+(44.0*slider.max)];
    
    
    

    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)saveSetting:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    if (miles.length==0) {
      //  [AppWindow makeToast:@"Please select distance" duration:2 position:CSToastPositionBottom];
    }
    
    if (tfGender.text.length==0) {
     //   [AppWindow makeToast:@"Please select distance" duration:2 position:CSToastPositionBottom];
    }
    
    [self SaveInfo];
}
#pragma mark- Service  api
-(void)SaveInfo{
    
   /* NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:lblMinAge.text forKey:@"MinAge"];
    [prefs setObject:lblMaxAge.text forKey:@"MaxAge"];
    [prefs setObject:sliderMin forKey:@"Min"];
    [prefs setObject:sliderMax forKey:@"Max"];
    [prefs synchronize];*/
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"distance=%@&gender=%@&age_range=%@&user_id=%@&min_age=%@&max_age=%@&sliderMin=%f&sliderMax=%f&sliderGender=%f&is_visible=",miles,tfGender.text,age,userId,lblMinAge.text,lblMaxAge.text,floatMin,floatMax,floatGender];
    
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/updateSettings" serviceType:@"POST"];
    
    [[NSUserDefaults standardUserDefaults] setObject:miles forKey:@"miles"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)getUserSettingInfo{

    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/getSettingsDetails" serviceType:@"POST"];
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/updateSettings"])
    {
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            [Global showOnlyAlert:@"Success" :@"Data saved successfully" ];
        }
       
        
    }else if ([serviceName isEqualToString:@"users/getSettingsDetails"]){
        
      if ([[data valueForKey:@"Ack"] intValue]==1) {
          NSDictionary *dict=[data valueForKey:@"settings"];
          //age=[dict valueForKey:@"age_range"];
          tfGender.text=[dict valueForKey:@"gender"];
          lblMiles.text=[NSString stringWithFormat:@"%@ miles",[dict valueForKey:@"distance"]];
          
         
          NSString *max=[NSString stringWithFormat:@"%@",[dict objectForKey:@"max_age"]];
          NSString *min=[NSString stringWithFormat:@"%@",[dict objectForKey:@"min_age"]];
          
         // float floatMax=[[dict objectForKey:@"max_age"] floatValue];
         // float floatMin=[[dict objectForKey:@"max_age"] floatValue];
          
         floatMax=[[dict objectForKey:@"sliderMax"] floatValue];
         floatMin=[[dict objectForKey:@"sliderMin"] floatValue];
         floatGender=[[dict objectForKey:@"sliderGender"] floatValue];
          DistanceSlider.value=floatGender;
          sliderMin=[NSString stringWithFormat:@"%@",[dict objectForKey:@"min_age"]];
          sliderMax=[NSString stringWithFormat:@"%@",[dict objectForKey:@"max_age"]];
          
          if ([max length]!=0) {
              lblMaxAge.text=max;
              //[slider setMax:floatMax];
          }else{
              lblMaxAge.text=@"60";
          }
          if ([min length]!=0) {
              lblMinAge.text=min;
              
          }else{
              lblMinAge.text=@"16";
          }
          
          if (floatMax!=0) {
              
              [slider setMax:floatMax];
          }
          
          if (floatMin!=0) {
              
              [slider setMin:floatMin];
          }
          
      }
        
        
    }
}

#pragma mark- Picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (arrGender.count>0) {
        NSString *str=arrGender[row];
        if ([str isEqualToString:@"Female"]) {
           strGender=@"M";
        }else if ([str isEqualToString:@"Male"]){
          strGender=@"M";
        }else if ([str isEqualToString:@"Both"]){
            strGender=@"B";
        }
        
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


- (IBAction)emailButtonPressed:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"flokhelp@gmail.com"]];
        [composeViewController setSubject:@"Flok"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(error)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alrt show];
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
    

@end
