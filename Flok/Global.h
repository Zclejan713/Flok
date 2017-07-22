//
//  Global.h
//  MyCityPins
//
//  Created by NITS_Mac4 on 05/01/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <sys/utsname.h>
#import <CoreLocation/CoreLocation.h>


//#define BASE_URL @"https://192.169.245.132/flok/"
#define BASE_URL @"http://findyourflok.com/"



#define DEVICE_NAME   [[UIDevice currentDevice] name]
#define SystemVersion [[[UIDevice currentDevice]systemVersion]floatValue]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4     ((IS_IPHONE && [[UIScreen mainScreen] bounds].size.height <= 480.0f)?YES:NO) //320,480
#define IS_IPHONE_5     (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)//320,568
#define IS_IPHONE_6     (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 667)?YES:NO)//375,667
#define IS_IPHONE_6Plus (([UIScreen mainScreen].scale == 3.0f && [UIScreen mainScreen].bounds.size.height == 736)?YES:NO)//414,736
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define VIEW_SIZE 1500


#define alltrim(mystr) [mystr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#define RGB(r, g, b)   [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define showAlert(title,msg,canceltitle,other1,other2)  [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:canceltitle otherButtonTitles:other1,other2,nil]show]


#define blueclr RGB(20,160,238)
#define appOrange RGB(249,91,21)//#f95b15
#define appOrangedark RGB(229,75,7)//#e54b07
#define appGreen RGB(0,128,12)
#define METERS_PER_MILE 1609.344
#define FbAppId @"1237531842933902"

#define radio_check [UIImage imageNamed:@"radio"]
#define radio_uncheck [UIImage imageNamed:@"radio-h"]

#define AppWindow [UIApplication sharedApplication].keyWindow
#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif

@protocol WebServiceCallDeleGate <NSObject>

@required

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName;
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName;

@optional
@end


@interface Global : NSObject
{

}
@property (nonatomic,strong) id <WebServiceCallDeleGate> delegate;

+ (instancetype)sharedInstance;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(void)animateView:(UIView*)view :(int)yOrigin;
+(void) showNetworkError;
+(void) showConnectionError;
+(void) showOnlyAlert:(NSString*)title :(NSString*)message;
+(void) animate:(UIView*)view rect4Inch:(CGRect)rect4Inch rect3Inch:(CGRect)rect3Inch;
+(NSString*)machineName;
+(void)disableAfterClick:(UIButton*)btn;

+(NSString*)addSpclCharecters:(NSString*)strurl;
+(NSString*)trimstring:(NSString *)mystr;
+(NSString *)checkingempty:(NSString*)InputString;
+(id)cleanJsonToObject:(id)data;
+(BOOL)validateEmail:(NSString*)email;
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(UIImage *)imageFromColor:(UIColor *)color;
+ (UIFont *)myfont:(CGFloat)fontSize;
+ (UIFont *)myboldfont:(CGFloat)fontSize;
+(void)setPlaceholderColor:(UIColor *)color textfield:(UITextField *)textfield fontName:(NSString*)fontname fontSize:(float)fontsize;
+(void)myScrollheight:(UIScrollView*)scroller;
+(CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+(void)setSegmentedControl:(UISegmentedControl *)segmentedControl
             selectedColor:(UIColor *)selectedColor
           deselectedColor:(UIColor *)deselectedColor;

+(NSString*)changeDateString:(NSString*)strServerDate;
//====================================================
+(void)setImage:(NSString*)imageURL imageHolder:(UIImageView*)imgvw;
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;
+(NSMutableData*)makeData:(NSMutableData *)myRequestData :(NSString*)boundary :(NSString*)dataType :(NSString*)extention :(NSString*)name :(NSData*)data;
//======================================================
+ (NSString *)toBase64String:(NSString *)string;
+(CGSize)getImageSize:(NSString*)imageURL imageHolder:(UIImageView*)imgvw;
+(NSString*)dictToString:(NSMutableDictionary*)dictToSend;
+(NSString*)trimImage:(NSString *)myimg;
+(void)clearUserdefault;


//=========================================   Service Call          ==============================

-(void)serviceCall:(NSString *)dataString servicename:(NSString *)serviceName serviceType:(NSString*)serviceType;



@end
