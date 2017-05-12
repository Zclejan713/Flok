//
//  SearchLocationViewController.m
//  Flok
//
//  Created by NITS_Mac3 on 05/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "myAnnotation.h"
#import "Global.h"
#import "AddressCell.h"
@interface SearchLocationViewController ()

@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"SearchLocationViewController");
    
    tblSearch.hidden=YES;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [locationManager startUpdatingLocation];
    [self showCurrentLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- Textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [indicator startAnimating];
    [myTimerName invalidate];
     myTimerName = [NSTimer scheduledTimerWithTimeInterval: 0.5f
                                                   target:self
                                                 selector:@selector(handleTimer:)
                                                 userInfo:searchStr
                                                  repeats:NO];
    return YES;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return  arrSearched.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  return 55.0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
   // cell.contentView.backgroundColor=[UIColor colorWithRed:12.0/255.0 green:78.0/255.0 blue:99.0/255.0 alpha:1];
    UIImageView *locImg =[[UIImageView alloc] initWithFrame:CGRectMake(0,15,16,16)];
    locImg.image=[UIImage imageNamed:@"locationIcon"];
    [cell addSubview:locImg];
    cell.textLabel.text=[dict valueForKey:@"description"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    cell.textLabel.textColor=[UIColor grayColor];
    return cell;*/
    static NSString *cellIdentifier=@"CellIdentifier";
    AddressCell *cell=(AddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddressCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
    cell.lblAddress.textColor=[UIColor lightGrayColor];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[dict valueForKey:@"description"]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tfSearch.text.length-1)];
    
    [cell.lblAddress setAttributedText:string];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    tblSearch.hidden=YES;
    [tfSearch resignFirstResponder];
    NSDictionary *dict=[arrSearched objectAtIndex:indexPath.row];
    tfSearch.text=[dict valueForKey:@"description"];
    tblSearch.hidden=YES;
    [myTimerName invalidate];
    [self getLocationFromAddressString:tfSearch.text];
    AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.flokLocation=tfSearch.text;
    
    CGRect frame =mapView.frame;
    frame.size.height=frame.size.height+250;
    frame.origin.y=66;
    mapView.frame=frame;
    
}

#pragma mark- Location auto populate

-(void)handleTimer:(NSTimer*)timer
{
    NSString *str=(NSString*)[timer userInfo];
    //Update Values in Label here

    NSString *strLoc=[Global addSpclCharecters:str];
    NSString *key=@"AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU";
    NSURL *dataUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=%@",strLoc,key]];
    
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:dataUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10000]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [indicator stopAnimating];
                               if(data)
                               {
                                   
                                
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                       arrSearched=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"predictions"]];
                                       
                                       
                                       
                                       if(arrSearched.count>0)
                                       {
                                           [tblSearch reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                           tblSearch.hidden=NO;
                                           if (!isMapheight) {
                                               CGRect frame =mapView.frame;
                                               frame.size.height=frame.size.height-250;
                                               frame.origin.y=66;
                                               mapView.frame=frame;
                                               isMapheight=YES;
                                           }
                                           [tblSearch reloadData];
                                       }
                                       else
                                       {
                                           tblSearch.hidden=NO;
                                           [tblSearch reloadData];
                                       }
                                   });
                                   
                               }
                               
                           }];
}

-(void)getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    
    AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.flokLat=[NSString stringWithFormat:@"%f",center.latitude];
    app.flokLang=[NSString stringWithFormat:@"%f",center.longitude];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latitude;
    newRegion.center.longitude = longitude;
    newRegion.span.latitudeDelta = 0.008388;
    newRegion.span.longitudeDelta = 0.016243;
    [mapView setRegion:newRegion animated:YES];
    
    myAnnotation *myannotation= [[myAnnotation alloc] initWithCoordinate:center title:@"User" Description:@"Description"];
    [mapView addAnnotation:myannotation];
    //green_lacation
    
}

  //  Show my current location on map view

-(IBAction)showCurrentLocation
{
    CLLocationCoordinate2D center = [self getLocation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, VIEW_SIZE, VIEW_SIZE);
    [mapView setRegion:viewRegion animated:NO];
}

-(CLLocationCoordinate2D) getLocation{
    locationManager =[[CLLocationManager alloc] init];
    locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.delegate = self;
        locationManager.distanceFilter = 0.5;
        [locationManager startUpdatingLocation];
        //[self showCurrentLocation:nil];
    }
#endif
    if ( [CLLocationManager locationServicesEnabled] ) {
        locationManager.delegate = self;
        locationManager.distanceFilter = 0.5;
        [locationManager startUpdatingLocation];
        
        // [self showCurrentLocation:nil];
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

@end
