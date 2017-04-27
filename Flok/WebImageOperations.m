//
//  WebImageOperations.m
//  Quitchen_ipad
//
//  Created by Manab Mal on 12/03/13.
//  Copyright (c) 2013 manab63@gmail.com. All rights reserved.
//  Coded by Manab Mal

#import "WebImageOperations.h"
#import <QuartzCore/QuartzCore.h>
@implementation WebImageOperations

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
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
  //  downloadQueue=nil;
   //dispatch_release(downloadQueue);
    
}
@end
