//
//  ImagePreviewPage.m
//  Flok
//
//  Created by NITS_Mac4 on 19/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "ImagePreviewPage.h"
#import "AppDelegate.h"


@interface ImagePreviewPage ()

@end

@implementation ImagePreviewPage

- (void)viewDidLoad {
    [super viewDidLoad];
   NSLog(@"ImagePreviewPage");
    scrlMain.minimumZoomScale = 1.0;
    scrlMain.maximumZoomScale = 100.0;
    scrlMain.contentSize = imgv.frame.size;
    
    //[Global setImage:[_dictCame valueForKey:@"relatedpicture"] imageHolder:imgv];
    [imgv setImage:[UIImage imageNamed:@"banner-pic.png"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgv;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

- (IBAction)backTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





@end
