//
//  UpdateProfileViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 11/05/17.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "Global.h"
@interface UpdateProfileViewController ()
{
    NSArray *arrGender;
}
@end

@implementation UpdateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnSignup.layer.cornerRadius=4;
    btnSignup.layer.borderWidth=2;
    btnSignup.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    [Global setPlaceholderColor:RGB(133, 133, 133) textfield:tfDate fontName:@"Roboto-Regular" fontSize:14];
    [Global setPlaceholderColor:RGB(133, 133, 133) textfield:tfMonth fontName:@"Roboto-Regular" fontSize:14];
    [Global setPlaceholderColor:RGB(133, 133, 133) textfield:tfYear fontName:@"Roboto-Regular" fontSize:14];
    
    arrGender=[[NSMutableArray alloc]initWithArray:@[@"Male",@"Female"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==tfDate || textField==tfMonth || textField==tfYear)
    {
        datepicker=[[UIDatePicker alloc]init];
        datepicker.datePickerMode=UIDatePickerModeDate;
        //  [datepicker setMaximumDate:[NSDate date]];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-12];
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

@end
