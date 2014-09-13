//
//  WalkableParameter.h
//  OpenTripPlanner
//
//  Created by GIS on 12/12/13.
//  Copyright (c) 2013 OpenPlans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalkableParameter : NSObject
@property (nonatomic) int traffic;
@property (nonatomic) int greenery;
@property (nonatomic) int crime;
@property (nonatomic) int sidewalk;
@property (nonatomic) int resiDensity;
@property (nonatomic) int busiDensity;
@property (nonatomic) int accessibility;
@property (nonatomic) int intersection;
@property (nonatomic) int slope;
@property (nonatomic) int landVariation;
+ (id)params;
@end
