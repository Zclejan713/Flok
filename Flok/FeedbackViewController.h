//
//  FeedbackViewController.h
//  CabApplication
//
//  Created by Ritwik Ghosh on 17/04/2015.
//  Copyright (c) 2015 nits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController
{
    IBOutlet UIView *vw1;
    IBOutlet UIView *vw2;
    IBOutlet UIView *vw3;
    IBOutlet UITextView *tvComment;
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnCancel;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblRating;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIView *viewStarRating;
    UISlider *slider;
    float rating;
    
    
}
@property(retain,nonatomic)NSDictionary *userData;
@property(retain,nonatomic)IBOutlet UIImageView *imgReview;
@end
