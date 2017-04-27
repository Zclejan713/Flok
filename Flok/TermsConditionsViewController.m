//
//  TermsConditionsViewController.m
//  Teemedup
//
//  Created by NITS_Mac3 on 16/12/16.
//  Copyright © 2016 NITS. All rights reserved.
//

#import "TermsConditionsViewController.h"
#import "AppDelegate.h"
#import "Global.h"
@interface TermsConditionsViewController ()

@end

@implementation TermsConditionsViewController
@synthesize strLink;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    //strLink;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    if ([strLink isEqualToString:@"Privacy Policy"]) {
        urlAddress =@"privicy_policy.html";
        lblTitle.text=@"Privacy Policy";
    }else{
        lblTitle.text=@"Terms & Conditions";
        urlAddress =@"terms_of_use.html";
       
      // http://104.131.83.218/flok_new/terms_of_use.html
      // http://104.131.83.218/flok_new/privicy_policy.html

    }
    [self getTreams];
    // Do any additional setup after loading the view.
}

/**
 *  Webview to display html content
 *
 *  @param BOOL : Bool value to load
 *
 *  @return : yes or no
 */
#pragma UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request   navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result = _Authenticated;
    if (!_Authenticated) {
        _FailedRequest = request;
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [urlConnection start];
    }
    return result;
}

/**
 *  Webservice method for url authentication
 *
 *  @return : nothing
 */
#pragma NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = [NSURL URLWithString:@"your url"];
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)pResponse {
    _Authenticated = YES;
    [connection cancel];
    [webView loadRequest:_FailedRequest];
    
   // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
}

/**
 *  load data in webview
 *
 *  @param documentName : string to load
 *  @param webView1     : webview to display the content
 */
-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView1
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:@"zip"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView1 loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getTreams{
    //[self serviceCall:@"" servicename:strLink serviceType:@"GET"];
    /* NSString *dataString = [NSString stringWithFormat:@"action=getTerms"];
    //[self serviceCall:@"" servicename:strLink serviceType:@"GET"];*/
    
    [self serviceCall:@"" servicename:urlAddress serviceType:@"GET"];
    
    
}

#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    
    if ([serviceName isEqualToString:@"users/facebookSignup"]){
        
    }
}

/**
 *  Back method
 *
 *  @param sender : parameter
 */
-(IBAction)BackAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  webview to load contnent and display in precise manner
 *
 *  @param content : webview content
 */
- (void) createWebViewWithHTML:(NSString *)content{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background-color:transparent;\">"];
    
    //continue building the string
    [html appendString:content];
    [html appendString:@"</body></html>"];
    
    //instantiate the web view
    UIWebView *webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0,75,self.view.frame.size.width,self.view.frame.size.height-20)];
    
    //make the background transparent
    [webView1 setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [webView1 loadHTMLString:[html description] baseURL:nil];
    
    //add it to the subview
    [self.view addSubview:webView1];
    
}


-(void)serviceCall:(NSString *)dataString servicename:(NSString *)serviceName serviceType:(NSString*)serviceType
{
//    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
//    {
//        //[indicator stopAnimating];
//        [Global showNetworkError];
//        return;
//    }
   // [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",BASE_URL,serviceName,dataString]];
    
    NSURL *url;
    
    if ([serviceType isEqualToString:@"GET"])
    {
        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceName]];
        
    }else {
        
        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceName]];
    }
    
    
    NSLog(@"complete url: >>> %@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if ([serviceType isEqualToString:@"POST"])
    {
        request.HTTPBody = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    request.HTTPMethod = serviceType;
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if(error)
                                              {
                                                  NSLog(@"%@",[NSString stringWithFormat:@"Connection failed.: %@.", [error description]]);
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                      //[MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  });
                                                  return;
                                              }
                                              NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                                              for (NSHTTPCookie * cookie in cookies)
                                              {
                                                  NSLog(@"%@=%@", cookie.name, cookie.value);
                                              }
                                              
                                              // Update the View
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  //[MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                 // [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  NSString *strReturn=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                  
                                                  NSDictionary *tdict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                  NSDictionary *dict = [Global cleanJsonToObject:tdict];
                                                  // if ([ServiceName isEqualToString:@"coursedetails"])
                                                  if ([serviceName isEqualToString:urlAddress])
                                                  {
                                                      [self createWebViewWithHTML:strReturn];
                                                      if(dict.count>0)
                                                      {
                                                          
                                                        
                                                          [self createWebViewWithHTML:strReturn];
                                                          
                                                         
                                                          
                                                      }
                                                      
                                                  }
                                                  
                                                  
                                                  else
                                                  {
                                                      
                                                     
                                                      
                                                  }
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}

@end
