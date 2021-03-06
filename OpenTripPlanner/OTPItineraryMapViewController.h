//
//  OTPItineraryMapViewController.h
//  OpenTripPlanner
//
//  Created by asutula on 10/1/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouteMe.h"
#import "Itinerary.h"
#import "OTPInsetLabel.h"


@interface OTPItineraryMapViewController : UIViewController

@property (strong, nonatomic) IBOutlet RMMapView *mapView;
@property (strong, nonatomic) IBOutlet OTPInsetLabel *instructionLabel;
@property (nonatomic, strong) RMUserLocation *userLocation;
@property (nonatomic) BOOL needsPanToUserLocation;
@property (weak, nonatomic) IBOutlet UILabel *itineraryTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *legendButton;

@property (weak, nonatomic) IBOutlet UIButton *goHomeBtn;

- (IBAction)walkSignalIcon:(id)sender;
- (IBAction)curbCutIcon:(id)sender;
- (IBAction)panToUserLocation:(id)sender;
- (void)enableUserLocation;
- (void)updateViewsForCurrentUserLocation;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end
