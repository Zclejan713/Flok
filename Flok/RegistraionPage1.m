//
//  RegistraionPage1.m
//  Ourtistry
//
//  Created by NITS_Mac1 on 22/03/16.
//  Copyright © 2016 NITS_Mac1. All rights reserved.
//

#import "RegistraionPage1.h"
#import "AppDelegate.h"
#import "RegistraionPage2.h"
#import "TermsConditionsViewController.h"

@interface RegistraionPage1 ()
{
    UIDatePicker *datepickerDate,*datepickerMonth,*datepickerYear;
    UIDatePicker *datepicker;
}

@end

@implementation RegistraionPage1
{
    NSUserDefaults *prefs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"RegistraionPage1");
    
    
    self.view.backgroundColor=[UIColor clearColor];
    prefs=[NSUserDefaults standardUserDefaults];

    btnSignup.layer.cornerRadius=4;
    btnSignup.layer.borderWidth=2;
    btnSignup.layer.borderColor=[[UIColor whiteColor]CGColor];
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [Global myScrollheight:scrlMain];
    scrlMain.contentSize=CGSizeMake(scrlMain.frame.size.width,650);
    [Global setPlaceholderColor:RGB(133, 133, 133) textfield:tfDate fontName:@"Roboto-Regular" fontSize:14];
    [Global setPlaceholderColor:RGB(133, 133, 133) textfield:tfMonth fontName:@"Roboto-Regular" fontSize:14];
    [Global setPlaceholderColor:RGB(133, 133, 133) textfield:tfYear fontName:@"Roboto-Regular" fontSize:14];
    
    arrGender=[[NSMutableArray alloc]initWithArray:@[@"Male",@"Female"]];
    imgUrl=@"";
    [tvTerms setEditable:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [tvTerms addGestureRecognizer:tap];
    
    vwTransparent.hidden=YES;
    vwAlert.hidden=YES;
    
    vwAlert.layer.cornerRadius=5.0f;
    vwAlert.layer.borderColor=[[UIColor blackColor] CGColor];
    vwAlert.layer.borderWidth=2.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    vwTransparent.hidden=YES;
    vwAlert.hidden=YES;
    isAlertShow=NO;
}
#pragma mark- Method
- (IBAction)backTap:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)forwardTap:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];

    UIViewController *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"RegistraionPage3"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)moveToTabBarController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVC =(UIViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:myVC animated:YES];
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



- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

#pragma mark- Keyboard notification
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if (app.fbUserDic) {
        tfFullname.text=[app.fbUserDic valueForKey:@"name"];
        tfEmail.text=[app.fbUserDic valueForKey:@"email"];
        tfPwd.text=@"***************";
        [tfPwd setUserInteractionEnabled:NO];
        imgUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[app.fbUserDic valueForKey:@"id"]];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UIScrollView *someScrollView = scrlMain;
    
    CGPoint bottomPoint = CGPointMake(0, CGRectGetMaxY([someScrollView bounds]));
    CGPoint convertedTableViewBottomPoint = [someScrollView convertPoint:bottomPoint
                                                                  toView:keyWindow];
    
    CGFloat keyboardOverlappedSpaceHeight = convertedTableViewBottomPoint.y - keyBoardFrame.origin.y;
    
    if (keyboardOverlappedSpaceHeight > 0)
    {
        UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(0, 0, keyboardOverlappedSpaceHeight+10, 0);
        [someScrollView setContentInset:tableViewInsets];
        //[scrlView scrollRectToVisible:tvDescribeYourself.frame animated:YES];
        
    }
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    UIEdgeInsets edgeinsets = UIEdgeInsetsZero;
    UIScrollView *someScrollView = scrlMain;
    [someScrollView setContentInset:edgeinsets];
}

-(UIToolbar *)keyboard_toolbar
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc]init];
    keyboardToolBar.barTintColor=RGB(239, 244, 244);
    [keyboardToolBar sizeToFit];
    keyboardToolBar.barStyle = UIBarStyleDefault;
    
    UIImage *backImage = [Global imageWithImage:[[UIImage imageNamed:@"prev"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] scaledToSize:CGSizeMake(20, 20)];
    UIImage *forwardImage =[Global imageWithImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] scaledToSize:CGSizeMake(20, 20)];
    keyboardToolBar.items=[NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(prev:)],
                           
                           [[UIBarButtonItem alloc]initWithImage:forwardImage style:UIBarButtonItemStylePlain target:self action:@selector(next:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard:)],
                           nil];
    
    return keyboardToolBar;
}

-(void)prev:(id)sender
{
    UIView *firstResponder;
    UIView *vw=scrlMain.subviews[0];
    for (UIView *view in vw.subviews) //: caused error
    {
        if (view.isFirstResponder)
        {
            firstResponder = view;
            //break;
        }
    }
    
    if (firstResponder==tfPwd)
    {
        [tfUsername becomeFirstResponder];
    }
    else if (firstResponder==tfUsername)
    {
        [tfEmail becomeFirstResponder];
    }
    else if (firstResponder==tfEmail)
    {
        [tfYear becomeFirstResponder];
    }
    else if (firstResponder==tfYear)
    {
        [tfMonth becomeFirstResponder];
    }
    else if (firstResponder==tfMonth)
    {
        [tfDate becomeFirstResponder];
    }
    else if (firstResponder==tfDate)
    {
        [tfFullname becomeFirstResponder];
    }
    else if (firstResponder==tfFullname)
    {

    }

}

-(void)next:(id)sender
{
    UIView *firstResponder;
    UIView *vw=scrlMain.subviews[0];
    for (UIView *view in vw.subviews) //: caused error
    {
        if (view.isFirstResponder)
        {
            firstResponder = view;
            //break;
        }
    }
    
    if (firstResponder==tfFullname)
    {
        [tfDate becomeFirstResponder];
    }
    else if (firstResponder==tfDate)
    {
        [tfMonth becomeFirstResponder];
    }
    else if (firstResponder==tfMonth)
    {
        [tfYear becomeFirstResponder];
    }
    else if (firstResponder==tfYear)
    {
        [tfEmail becomeFirstResponder];
    }
    else if (firstResponder==tfEmail)
    {
        [tfUsername becomeFirstResponder];
    }
    else if (firstResponder==tfUsername)
    {
        [tfPwd becomeFirstResponder];
    }
    else if (firstResponder==tfPwd)
    {
        
    }
    
}

-(void)resignKeyboard:(id)sender
{
    UIView *vw=scrlMain.subviews[0];
    for (id view in vw.subviews){
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
            [self.view endEditing:YES];
            
        }
    }
}

#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==tfDate || textField==tfMonth || textField==tfYear)
    {
        datepicker=[[UIDatePicker alloc]init];
        datepicker.datePickerMode=UIDatePickerModeDate;
      
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-20];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:-80];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        [datepicker setMaximumDate:maxDate];
        [datepicker setMinimumDate:minDate];
        
        textField.inputView=datepicker;
        
        
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectdatemonthyear:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [textField setInputAccessoryView:toolBar];

    }else if (textField==tfGender) {
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
        textField.inputAccessoryView=[self keyboard_toolbar];
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
-(void)selectdatemonthyear:(id)sender
{
    NSDateFormatter *dateFormat1=[[NSDateFormatter alloc]init];
    dateFormat1.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat1 setDateFormat:@"MM"];
    tfMonth.text=[NSString stringWithFormat:@"%@",[dateFormat1  stringFromDate:datepicker.date]];
    [tfDate resignFirstResponder];
    
    
    NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"dd"];
    tfDate.text=[NSString stringWithFormat:@"%@",[dateFormat2  stringFromDate:datepicker.date]];
    [tfMonth resignFirstResponder];

    
    NSDateFormatter *dateFormat3=[[NSDateFormatter alloc]init];
    [dateFormat3 setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat3 setDateFormat:@"YYYY"];
    tfYear.text=[NSString stringWithFormat:@"%@",[dateFormat3 stringFromDate:datepicker.date]];
    [tfYear resignFirstResponder];

}

#pragma mark- Date Picker
-(void)selectedDate:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd"];
    tfDate.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datepickerDate.date]];
    [tfDate resignFirstResponder];
    
}

-(void)selectedMonth:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM"];
    tfMonth.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datepickerMonth.date]];
    [tfMonth resignFirstResponder];
    
}

-(void)selectedYear:(id)sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY"];
    tfYear.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datepickerYear.date]];
    [tfYear resignFirstResponder];
}

-(CLLocationCoordinate2D) getLocation{
    
    CLLocationManager *locationManager;
    locationManager =[[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *location=[locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
    
}

#pragma mark- Webservice
- (IBAction)signupTap:(id)sender {
    [self.view endEditing:YES];
    [self forwardTap:self];
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];

    if (tfFullname.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your full name"];
    }
    else if (tfDate.text.length==0 || tfMonth.text.length==0 || tfYear.text.length==0)
    {
        //[Global showOnlyAlert:@"Empty!" :@"Please enter your Date of birth"];
        vwAlert.hidden=NO;
        vwTransparent.hidden=NO;
        isAlertShow=YES;
    }
    else if (tfGender.text.length==0)
    {
        if (isAlertShow==NO) {
            vwAlert.hidden=NO;
            vwTransparent.hidden=NO;
        }
        //[Global showOnlyAlert:@"Empty!" :@"Please enter your gender"];
    }
    else if (tfEmail.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your email"];
    }
    else if ([Global validateEmail:tfEmail.text]==NO)
    {
        [Global showOnlyAlert:@"Not valid!" :@"Please enter a valid email"];
    }
    else if (tfUsername.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your username"];
    }
    else if (tfPwd.text.length==0)
    {
        [Global showOnlyAlert:@"Empty!" :@"Please enter your password"];
    }
    else
    {
        NSString *age;
        
        if ([tfYear.text length]==0) {
            age=@"";
        }else{
            age=[NSString stringWithFormat:@"%@-%@-%@",tfYear.text,tfMonth.text,tfDate.text];
        }
        
        CLLocationCoordinate2D coordinate=[self getLocation];
        CGFloat mylat=coordinate.latitude;
        CGFloat mylong=coordinate.longitude;
        NSString *fbId=[app.fbUserDic valueForKey:@"id"];
        if ([fbId length]==0) {
            fbId=@"";
        }
        #if TARGET_IPHONE_SIMULATOR
        mylat=22.5726;
        mylong=88.3639;

        #endif
        app.fbUserDic=nil;
        NSString *action=@"users/appsignup";
        NSString *dataString=[NSString stringWithFormat:@"full_name=%@&dob=%@&email=%@&username=%@&gender=%@&fb_user_id=%@&password=%@&profile_image=%@&device_type=ios&device_token_id=%@&lat=%f&lang=%f",tfFullname.text,age,tfEmail.text,tfUsername.text,tfGender.text,fbId,tfPwd.text,imgUrl,app.deviceToken,mylat,mylong];
       
        isAlertShow=NO;
        [[Global sharedInstance] setDelegate:(id)self];
        [[Global sharedInstance] serviceCall:dataString servicename:action serviceType:@"POST"];
        //[self moveToTabBarController];
        
    }
}
-(IBAction)confirmSignup:(id)sender{
    
    NSString *age;
    
    if ([tfYear.text length]==0) {
        age=@"";
    }else{
        age=[NSString stringWithFormat:@"%@-%@-%@",tfYear.text,tfMonth.text,tfDate.text];
    }
    
    CLLocationCoordinate2D coordinate=[self getLocation];
    CGFloat mylat=coordinate.latitude;
    CGFloat mylong=coordinate.longitude;
    NSString *fbId=[app.fbUserDic valueForKey:@"id"];
    if ([fbId length]==0) {
        fbId=@"";
    }
   #if TARGET_IPHONE_SIMULATOR
    mylat=22.5726;
    mylong=88.3639;
    
    #endif
    app.fbUserDic=nil;
    NSString *action=@"users/appsignup";
    NSString *dataString=[NSString stringWithFormat:@"full_name=%@&dob=%@&email=%@&username=%@&gender=%@&fb_user_id=%@&password=%@&profile_image=%@&device_type=ios&device_token_id=%@&lat=%f&lang=%f",tfFullname.text,age,tfEmail.text,tfUsername.text,tfGender.text,fbId,tfPwd.text,imgUrl,app.deviceToken,mylat,mylong];
    
    isAlertShow=NO;
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:action serviceType:@"POST"];
    
    vwTransparent.hidden=YES;
    vwAlert.hidden=YES;
}
-(IBAction)cancelAlert:(id)sender{
    
    vwTransparent.hidden=YES;
    vwAlert.hidden=YES;
    isAlertShow=NO;
    
}
#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if([serviceName isEqualToString:@"users/appsignup"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            
            NSDictionary *temp=data[@"UserDetails"];
            [prefs setObject:temp forKey:@"rem_userdetail"];
            [prefs setObject:[temp valueForKey:@"user_id"] forKey:@"userId"];
            [prefs synchronize];
            [self forwardTap:self];
            
        }else{
            [Global showOnlyAlert:@"Error" :[data valueForKey:@"msg"]];
        }
        
    }
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


-(void)doneTap:(UIButton*)sender
{
    [self.view endEditing:YES];
    tfGender.text=arrGender[selectedRow];
}


- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    
    UITextView *textView =  (UITextView *)recognizer.view;
    // [self getHashTag:textView];
    CGPoint location = [recognizer locationInView:textView];
    NSLog(@"Tap Gesture Coordinates: %.2f %.2f -- %@", location.x, location.y,textView.text);
    
    CGPoint position = CGPointMake(location.x, location.y);
    //get location in text from textposition at point
    UITextPosition *tapPosition = [textView closestPositionToPoint:position];
    
    //fetch the word at this position (or nil, if not available)
    UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    NSString *tappedSentence =[NSString stringWithFormat:@"%@",[textView textInRange:textRange]];//;
    //  NSString *tappedSentence2 = [textView lineAtPosition:CGPointMake(location.x, location.y)];
    NSLog(@"selected :%@ -- %@ ",tappedSentence,tapPosition);
    
    if ([tappedSentence isEqualToString:@"Privacy"] || [tappedSentence isEqualToString:@"Policy"]) {
        
        TermsConditionsViewController *vc=(TermsConditionsViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
        vc.strLink=@"Privacy Policy";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([tappedSentence isEqualToString:@"Terms"] || [tappedSentence isEqualToString:@"Conditions"]) {
        TermsConditionsViewController *vc=(TermsConditionsViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TermsConditionsViewController"];
        vc.strLink=@"Trams & Conditions";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

@end
