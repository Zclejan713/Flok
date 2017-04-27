//
//  AjeetAnnotation.m
//  Flok
//
//  Created by NITS_Mac4 on 19/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import "AjeetAnnotation.h"

@implementation AjeetAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)mytitle subtitle:(NSString *)mysubtitle Description:(NSString *)mydescription imagename:(NSString *)myimagename
{
    if (self = [super init]) {
        self.coordinate =coordinate;
        self.title = mytitle;
        self.subtitle=mysubtitle;
        self.imageName=myimagename;
    }
    return self;
    
}

@end
