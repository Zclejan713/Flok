//
//  SearchLocationViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 05/09/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
@interface SearchLocationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSTimer *myTimerName;
    UIActivityIndicatorView *indicator;
    NSArray *arrSearched;
    IBOutlet UITableView *tblSearch;
    IBOutlet MKMapView *mapView;
    IBOutlet UITextField *tfSearch;
    MKPointAnnotation *annotationPoint ;
    CLLocationManager *locationManager;
    BOOL isMapheight;
   
}
@end
