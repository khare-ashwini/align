//
//  PointOfInterest.m
//  WalkThisWay
//
//  Created by GIS on 1/27/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "PointOfInterest.h"

@implementation PointOfInterest
- (void)setName:(NSString*)name Latitude:(NSString*)lat Longitude:(NSString*)lng{
    self.name = name;
    self.latitude = lat;
    self.longitude=lng;
}
@end
