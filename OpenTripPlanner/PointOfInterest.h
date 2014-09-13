//
//  PointOfInterest.h
//  WalkThisWay
//
//  Created by GIS on 1/27/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointOfInterest : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* longitude;
@property (nonatomic, strong) NSString* latitude;

- (void)setName:(NSString*)name Latitude:(NSString*)lat Longitude:(NSString*)lng;

@end
