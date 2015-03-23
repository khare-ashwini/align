//
//  WalkableParameter.m
//  OpenTripPlanner
//
//  Created by GIS on 12/12/13.
//  Copyright (c) 2013 OpenPlans. All rights reserved.
//

#import "WalkableParameter.h"

@implementation WalkableParameter
+ (id)params {
    static WalkableParameter *wp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wp = [[self alloc] init];
    });
    return wp;
}
- (id)init {
    if (self = [super init]) {
        _traffic = 0;
        _greenery = 0;
        _crime = 0;
        _sidewalk = 0;
        _resiDensity = 0;
        _busiDensity = 0;
        _accessibility = 0;
        _intersection = 0;
        _slope = 0;
        _landVariation = 0;
        _crosswalk = 0;
    }
    return self;
}
@end
