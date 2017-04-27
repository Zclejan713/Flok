//
//  Global.m
//  MyCityPins
//
//  Created by NITS_Mac4 on 05/01/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "Global.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
@implementation Global
//@synthesize delegate;
#pragma mark - Current location
+(instancetype)sharedInstance
{
    static Global *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[Global alloc] init];
        // Do any other initialisation stuff here
    });
    return obj;
}

+(NSString*)trimstring:(NSString *)mystr{
    return [mystr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSString *)checkingempty:(NSString*)InputString {
    
    if( (InputString == nil) || [self trimstring:InputString].length == 0 || (InputString ==
                                                                              (NSString*)[NSNull null])||([InputString isEqual:nil])||([InputString length] == 0)||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])||([InputString isEqualToString:@"NULL"]) ||([InputString isEqualToString:@"null"]) || ([InputString isEqualToString:@"<nil>"])))
        
        return @"";
    else
        return InputString ;
}

+(id)cleanJsonToObject:(id)data {
    NSError* error;
    if (data == (id)[NSNull null]){
        return [[NSObject alloc] init];
    }
    id jsonObject;
    if ([data isKindOfClass:[NSData class]]){
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else {
        jsonObject = data;
    }
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (NSInteger i = [array count]-1; i >= 0; i--) {
            id a = array[i];
            if (a == (id)[NSNull null]){
                [array removeObjectAtIndex:i];
            } else {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys]) {
            id d = dictionary[key];
            if (d == (id)[NSNull null]){
                dictionary[key] = @"";
            } else {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    } else {
        return jsonObject;
    }
}

+(BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIFont *)myboldfont:(CGFloat)fontSize {
    UIFont *fontt = [UIFont boldSystemFontOfSize:fontSize];
    return fontt;
}

+ (UIFont *)myfont:(CGFloat)fontSize {
    UIFont *fontt = [UIFont systemFontOfSize:fontSize];
    NSLog(@"system default font : %@",fontt.familyName);
    return fontt;
}

+(void)setPlaceholderColor:(UIColor *)color textfield:(UITextField *)textfield fontName:(NSString*)fontname fontSize:(float)fontsize{
    
    textfield.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:textfield.placeholder
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:fontname size:fontsize]
                                                 }];
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(void)animateView:(UIView*)view :(int)yOrigin
{
    [UIView setAnimationDuration:0.3];
    CGRect rect=view.frame;
    rect.origin.y=yOrigin;
    view.frame=rect;
    [UIView commitAnimations];
}

+(void) animate:(UIView*)view rect4Inch:(CGRect)rect4Inch rect3Inch:(CGRect)rect3Inch
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         (IS_IPHONE_5)?([view setFrame:rect4Inch]):([view setFrame:rect3Inch]);
                     }
                     completion:nil];
}

+(void) showNetworkError
{
    [self showOnlyAlert:@"Network is Not Reachable" :@"The network you trying to access is not Reachable" ];
}

+(void) showConnectionError
{
    [self showOnlyAlert:@"Connection Failed" :@"Please try again" ];
}
+(void) showOnlyAlert:(NSString*)title :(NSString*)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

+(NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


+(NSString*)changeDateString:(NSString*)strServerDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *serVerDate=[dateFormatter dateFromString:strServerDate];
    
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"MMM dd, yyyy hh:mm a"];
    NSString *strDate=[dateFormatter1 stringFromDate:serVerDate];
    return strDate;
    
}


//geocode by suman

//==========
+(CGSize)getImageSize:(NSString*)imageURL imageHolder:(UIImageView*)imgvw
{
    CGSize imageSize;
    
    if([imageURL isEqualToString:@""])
    {
        return imageSize;
    }
    NSString* imageName=[imageURL lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgvw.image=[UIImage imageWithContentsOfFile:FilePath];
    }
    else
    {
        //imgvw.image=[UIImage imageNamed:@"noimage"];
        [Global processImageDataWithURLString:imageURL andBlock:^(NSData *imageData)
         {
             if(imageData)
             {
                 imgvw.image=[UIImage imageWithData:imageData];
                 [imageData writeToFile:FilePath atomically:YES];
             }
         }];
    }
    
    return imgvw.image.size;
}


+(void)setImage:(NSString*)imageURL imageHolder:(UIImageView*)imgvw
{
    if([imageURL isEqualToString:@""])
    {
        imgvw.image=[UIImage imageNamed:@"noimage"];
        return;
    }
    NSString* imageName=[imageURL lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgvw.image=[UIImage imageWithContentsOfFile:FilePath];
        if(!imgvw.image)
        {
            imgvw.image=[UIImage imageNamed:@"noimage"];
        }
    }
    else
    {
        imgvw.image=[UIImage imageNamed:@"noimage"];
        [Global processImageDataWithURLString:imageURL andBlock:^(NSData *imageData)
         {
             if(!imageData)
             {
                 imgvw.image=[UIImage imageNamed:@"noimage"];
             }
             else
             {
                 imgvw.image=[UIImage imageWithData:imageData];
                 [imageData writeToFile:FilePath atomically:YES];
             }
         }];
    }
}

+(void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_main_queue();//dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
}

+(NSMutableData*)makeData:(NSMutableData *)myRequestData :(NSString*)boundary :(NSString*)dataType :(NSString*)extention :(NSString*)name :(NSData*)data
{
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    if([dataType isEqualToString:@"String"])
    {
        [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"ddMMyyyyHHmmss";
        NSString *strDate=[dateFormatter stringFromDate:[NSDate date]];
        int randNum = rand() % (999999999 - 100000000) + 999999999; //create the random number.
        NSString *num = [NSString stringWithFormat:@"%d", randNum]; //Make the number into a string.
        NSString *imgstr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"suman_%@%@.%@\"\r\n",name,strDate,num,extention];
        NSLog(@"image file name: >>> %@",imgstr);
        [myRequestData appendData:[imgstr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:data];
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return myRequestData;
}
//end =================

+(void)myScrollheight:(UIScrollView*)scroller{
    float scrollViewHeight = 0;
    for (UIView *child in scroller.subviews) {
        if (!child.hidden) {
            float childHeight = child.frame.origin.y + child.frame.size.height;
            if (childHeight > scrollViewHeight)
                scrollViewHeight = childHeight;
        }
    }
    scroller.showsHorizontalScrollIndicator = YES;
    scroller.showsVerticalScrollIndicator = YES;
    [scroller setContentSize:(CGSizeMake(scroller.frame.size.width, scrollViewHeight))];
}

+(CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

+(void)setSegmentedControl:(UISegmentedControl *)segmentedControl
              selectedColor:(UIColor *)selectedColor
            deselectedColor:(UIColor *)deselectedColor
{
    for (int i = 0; i < segmentedControl.subviews.count; i++)
    {
        id subView = [segmentedControl.subviews objectAtIndex:i];
        
        if ([subView respondsToSelector:@selector(isSelected)] && [subView isSelected])
            [subView setTintColor:selectedColor];
        else if ([subView respondsToSelector:@selector(isSelected)] && ![subView isSelected])
            [subView setTintColor:deselectedColor];
    }
}



+ (NSString *)toBase64String:(NSString *)string {
    // Create NSData object
    NSData *nsdata = [string
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    NSLog(@"Encoded: %@", base64Encoded);
    
    // Let's go the other way...
    
    // NSData from the Base64 encoded str
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:base64Encoded options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    NSLog(@"Decoded: %@", base64Decoded);
    
    return base64Encoded;
}
+(NSString*)dictToString:(NSMutableDictionary*)dictToSend
{
    NSData *jsonData=[NSJSONSerialization  dataWithJSONObject:dictToSend options:0 error:nil];
    NSString *dataString=[[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    return dataString;
}

+(NSString*)trimImage:(NSString *)myimg
{
    NSString *strpht=[[[NSString stringWithFormat:@"%@",myimg]  stringByReplacingOccurrencesOfString:@"\\" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return strpht;
}

+(void)clearUserdefault
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    
}
+(void)disableAfterClick:(UIButton*)btn{
    
    if ([btn isKindOfClass:[UIButton class]]) {
       
        [btn setUserInteractionEnabled:NO];
        [NSTimer scheduledTimerWithTimeInterval:3.0f
                                         target:self
                                       selector:@selector(buttonEnable:)
                                       userInfo:btn
                                        repeats:NO];
    }
    
}
+(void)buttonEnable:(NSTimer *)timer{
    UIButton *btn=timer.userInfo;
    [btn setUserInteractionEnabled:YES];
}
+(NSString*)addSpclCharecters:(NSString*)strurl
{
    NSString  *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)strurl,NULL,(CFStringRef)@"!*'();@&+$,/?%#[]~=_-.:",kCFStringEncodingUTF8 ));
    return encodedString;
    
}

-(void)serviceCall:(NSString *)dataString servicename:(NSString *)serviceName serviceType:(NSString*)serviceType
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [SVProgressHUD dismiss];
        [Global showNetworkError];
        return;
    }
    if ([serviceName isEqualToString:@"flok/getChatMsg"] ||[serviceName isEqualToString:@"flok/sendChat"]) {
        
      
    }else{
       //  [SVProgressHUD showWithStatus:@"Please wait.."];
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url;
    if ([serviceType isEqualToString:@"POST"])
    {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceName]];
        
    }else{
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",BASE_URL,serviceName,dataString]];
    }
    
    NSLog(@"complete url: >>> %@",url);
    NSLog(@"datastring: >>> %@",dataString);
    
    
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1200000000000000];
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
                                                      [SVProgressHUD dismiss];
                                                      
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
                                                  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                  [SVProgressHUD dismiss];
                                                  
                                                 /* NSString *strReturn=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];*/
                                                  NSDictionary *tdict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                      NSDictionary *dict=[Global cleanJsonToObject:tdict];
                                                      
                                                      if (dict.count>0) {
                                                          
                                                          if (self.delegate) {
                                                              [self.delegate WebServiceCallFinishWithData:dict withFlag:serviceName];
                                                             // self.delegate = nil;//...ritwik
                                                          }
                                                          
                                                      }else{
                                                          
                                                          if (self.delegate) {
                                                              [self.delegate webserviceCallFailOrError:@"Some Server Problem Encountered" withFlag:serviceName];
                                                              self.delegate = nil;
                                                          }
                                                          
                                                      }
                                                  
                                                  
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}





@end
