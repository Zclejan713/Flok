//
//  WebImageOperations.h
//  Quitchen_ipad
//
//  Created by Manab Mal on 12/03/13.
//  Copyright (c) 2013 manab63@gmail.com. All rights reserved.
//  Coded by Manab Mal

#import <Foundation/Foundation.h>

@interface WebImageOperations : NSObject
{
}
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;
@end
