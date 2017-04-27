//
//  TermsConditionsViewController.h
//  Teemedup
//
//  Created by NITS_Mac3 on 16/12/16.
//  Copyright © 2016 NITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsConditionsViewController : UIViewController
{
    IBOutlet UITextView *tvAgreement;
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *lblTitle;
    BOOL _Authenticated;
    NSURLRequest *_FailedRequest;
    NSString *urlAddress;
}
@property(retain,nonatomic)NSString *strLink;
@end
