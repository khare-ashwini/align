//
//  AlignParameterViewController.h
//  Chandra_Align
//
//  Created by Chandra Khatri on 9/28/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WalkableParameter.h"
#import "CMPopTipView.h"

@interface AlignParameterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *allParameterView;
@property (weak, nonatomic) IBOutlet UIView *myParameterView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)parameterSegment:(id)sender;
- (IBAction)traffic:(id)sender;
- (IBAction)greenery:(id)sender;
- (IBAction)crime:(id)sender;
- (IBAction)sidewalk:(id)sender;
- (IBAction)Slope:(id)sender;
- (IBAction)residentialDensity:(id)sender;
- (IBAction)businessDensity:(id)sender;
- (IBAction)accessibility:(id)sender;
- (IBAction)intersections:(id)sender;
- (IBAction)landVariables:(id)sender;

- (IBAction)done:(id)sender;

@end
