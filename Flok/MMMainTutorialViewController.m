//
//  MMMainTutorialViewController.m
//  ParkApp - знакомства и бесплатные парковки паркап parkup
//
//  Created by Manab Kumar Mal on 19/05/15.
//  Copyright (c) 2015 Manab. All rights reserved.
//

#import "MMMainTutorialViewController.h"
#import "AppDelegate.h"
#import "LandingController.h"




@interface MMMainTutorialViewController ()

@end

@implementation MMMainTutorialViewController
@synthesize pageHeader,pageHeader1,pageImages;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=true;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [self loadAll];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadAll
{
    self.navigationController.navigationBarHidden=true;
    self.automaticallyAdjustsScrollViewInsets = NO;
    index=0;
    pgctrl.currentPage=0;
    
    
    pageImages = @[@"tutorial.png",@"tutorial-2.png",@"tutorial-3.png",];
    
    //Set the Tuttorail Pages in Scroll View by imageview
    for(int i=0;i<pageImages.count;i++)
    {
        UIImageView *imgvw1=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, scrollView.frame.size.height)];
        imgvw1.image=[UIImage imageNamed:NSLocalizedString([pageImages objectAtIndex:i],nil)];
        [scrollView addSubview:imgvw1];
    }
    [scrollView setContentSize:CGSizeMake(pageImages.count*self.view.frame.size.width, scrollView.frame.size.height)];
    pgctrl.currentPage=0;
    
    [self.view bringSubviewToFront:btnClose];
    //lblHeader.text=NSLocalizedString([pageHeader objectAtIndex:0],nil);
    //lblHeader1.text=NSLocalizedString([pageHeader1 objectAtIndex:0],nil);
    
}
-(void)viewDidLayoutSubviews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(IBAction)btnClosePress:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;

    if(page==pageImages.count-1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [UIView animateWithDuration:1.0 animations:^{
            [scrollView setContentOffset:CGPointMake((page+1)*scrollView.frame.size.width, scrollView.frame.origin.y)];
        }];
    }
    
}
-(IBAction)btnPreviousPress:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if(page==0)
    {
        }
    else
    {
        [UIView animateWithDuration:1.0 animations:^{
            [scrollView setContentOffset:CGPointMake((page-1)*scrollView.frame.size.width, scrollView.frame.origin.y)];
        }];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView1
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView];

    if(translation.x<=0)
    {
        int page = scrollView1.contentOffset.x / scrollView1.frame.size.width;
        
        if(page==pageImages.count-1)
        {
          //  [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"tutorial" forKey:@"tutorial"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LandingController *myVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LandingController"]; //or the homeController
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:myVc];
            
            self.window =[[[UIApplication sharedApplication] windows] objectAtIndex:0];
            self.window.rootViewController =navController;
            [self.window makeKeyAndVisible];
            myVc.view.alpha = 0.7;
            
            [UIView animateWithDuration:2.0 animations:^{
                myVc.view.alpha = 1.0;
            }];
        }
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
