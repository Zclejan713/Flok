//
//  SecurityViewController.h
//  Flok
//
//  Created by NITS_Mac3 on 25/01/17.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecurityViewController : UIViewController
    {
        IBOutlet UISwitch *mySwitch;
    }
    @property (assign)BOOL isPrivate;
@end
