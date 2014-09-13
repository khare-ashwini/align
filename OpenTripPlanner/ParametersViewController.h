//
//  ParametersViewController.h
//  OpenTripPlanner
//
//  Created by GIS on 12/5/13.
//  Copyright (c) 2013 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalkableParameter.h"
#import "CMPopTipView.h"

@interface ParametersViewController : UIViewController <CMPopTipViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;

@property (weak, nonatomic) IBOutlet UIButton *verticalSeparatorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *trafficImg;
@property (weak, nonatomic) IBOutlet UIStepper *trafficStepper;
@property (weak, nonatomic) IBOutlet UIImageView *greeneryImg;
@property (weak, nonatomic) IBOutlet UIStepper *greeneryStepper;
@property (weak, nonatomic) IBOutlet UIImageView *crimeImg;
@property (weak, nonatomic) IBOutlet UIStepper *crimeStepper;
@property (weak, nonatomic) IBOutlet UIImageView *sidewalkImg;
@property (weak, nonatomic) IBOutlet UIStepper *sidewalkStepper;
@property (weak, nonatomic) IBOutlet UIImageView *resDensityImg;
@property (weak, nonatomic) IBOutlet UIStepper *resDensityStepper;
@property (weak, nonatomic) IBOutlet UIImageView *busDensityImg;
@property (weak, nonatomic) IBOutlet UIStepper *busDensityStepper;
@property (weak, nonatomic) IBOutlet UIImageView *accessibilityImg;
@property (weak, nonatomic) IBOutlet UIStepper *accessibilityStepper;
@property (weak, nonatomic) IBOutlet UIImageView *intersectionsImg;
@property (weak, nonatomic) IBOutlet UIStepper *intersectionsStepper;
@property (weak, nonatomic) IBOutlet UIImageView *slopeImg;
@property (weak, nonatomic) IBOutlet UIStepper *slopeStepper;
@property (weak, nonatomic) IBOutlet UIImageView *landVarImg;
@property (weak, nonatomic) IBOutlet UIStepper *landVarStepper;

- (IBAction)stepperChanged:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end