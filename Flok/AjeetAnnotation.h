//
//  AjeetAnnotation.h
//  Flok
//
//  Created by NITS_Mac4 on 19/08/16.
//  Copyright © 2016 Ajeet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface AjeetAnnotation : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *imageName;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)mytitle subtitle:(NSString *)mysubtitle Description:(NSString *)mydescription imagename:(NSString *)myimagename;



@end
