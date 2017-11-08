//
//  MMMainTutorialViewController.h
//  ParkApp - знакомства и бесплатные парковки паркап parkup
//
//  Created by Manab Kumar Mal on 19/05/15.
//  Copyright (c) 2015 Manab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMainTutorialViewController : UIViewController<UIScrollViewDelegate>
{
    int index; //Save the index of the Scrolled Tutorials
    IBOutlet  UIScrollView *scrollView; //Main scrollview for the Tutorial pages
    IBOutlet UIPageControl *pgctrl; //PageController
    IBOutlet UILabel *lblHeader; //Header Label of the Tutorial pages
    IBOutlet UIButton *btnClose; //Corner Cross Button
    IBOutlet UILabel *lblHeader1;
}
@property (strong, nonatomic) NSArray *pageImages; //This is to save the tutorial images
@property (strong, nonatomic) NSArray *pageHeader; //THis is to save the tutorial page Headers
@property (strong, nonatomic) NSArray *pageHeader1; //THis is to save the tutorial page Headers
@property (strong,nonatomic) UIWindow *window;
@property NSString *comingFrom;
-(IBAction)btnClosePress:(id)sender;
@end
