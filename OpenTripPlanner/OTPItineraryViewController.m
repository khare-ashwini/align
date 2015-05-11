//
//  OTPItineraryViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/14/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPAppDelegate.h"
#import "OTPItineraryViewController.h"
#import "Leg.h"
#import "ZUUIRevealController.h"
#import "OTPDirectionPanGestureRecognizer.h"
#import "OTPItineraryOverviewCell.h"
#import "OTPArrivalCell.h"
#import "OTPStepCell.h"
#import "OTPDistanceBasedLegCell.h"
#import "OTPStopBasedLegCell.h"
#import "OTPTransferCell.h"
#import "OTPUnitFormatter.h"
#import "OTPUnitData.h"
#import "OTPSelectedSegment.h"
#import <AVFoundation/AVFoundation.h>

@interface OTPItineraryViewController ()
{
    BOOL _mapShowing;
    NSArray *_distanceBasedModes;
    NSArray *_stopBasedModes;
    NSArray *_transferModes;
    NSDictionary *_modeDisplayStrings;
    NSDictionary *_relativeDirectionDisplayStrings;
    NSDictionary *_relativeDirectionIcons;
    NSDictionary *_absoluteDirectionDisplayStrings;
    NSDictionary *_modeIcons;
    NSMutableArray *_shapesForLegs;
    NSDictionary *_popuprModeIcons;
    NSIndexPath *_selectedIndexPath;
    NSArray *_stepModeFilteredLegs;
    NSArray *_allSteps;
    BOOL _shouldDisplaySteps;
    NSMutableArray *_primaryInstructionStrings;
    NSMutableArray *_secondaryInstructionStrings;
    NSMutableArray *_cellIcons;
    OTPItineraryOverlayViewController *_overlayViewController;
    OTPItineraryOverlayViewController *_mapOverlayViewController;
    
    RMAnnotation* modeAnnotation;
    RMAnnotation* modeAnnotationAlt;
    /* @Change : curbCuts */
    RMAnnotation* curbCuts;
}

- (void)resetLegsWithColor:(UIColor *)color;

@end

@implementation OTPItineraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    
    self.navigationController.delegate = self;
    _mapShowing = NO;

    // WALK, BICYCLE, CAR, TRAM, SUBWAY, RAIL, BUS, FERRY, CABLE_CAR, GONDOLA, FUNICULAR, TRANSFER
    
    _distanceBasedModes = @[@"WALK", @"BICYCLE", @"CAR"];
    _stopBasedModes = @[@"TRAM", @"SUBWAY", @"RAIL", @"BUS", @"FERRY", @"CABLE_CAR", @"GONDOLA", @"FUNICULAR"];
    _transferModes = @[@"TRANSFER"];
    
    _modeIcons = @{
    @"WALK" : [UIImage imageNamed:@"walk_32.png"],
    @"BICYCLE" : [UIImage imageNamed:@"bike_32.png"],
    @"CAR" : [UIImage imageNamed:@"car_32.png"],
    @"TRAM" : [UIImage imageNamed:@"cable-car_32.png"],
    @"SUBWAY" : [UIImage imageNamed:@"train_32.png"],
    @"RAIL" : [UIImage imageNamed:@"train_32.png"],
    @"BUS" : [UIImage imageNamed:@"bus_32.png"],
    @"FERRY" : [UIImage imageNamed:@"ferry_32.png"],
    @"CABLE_CAR" : [UIImage imageNamed:@"cable-car_32.png"],
    @"GONDOLA" : [UIImage imageNamed:@"gondola_32.png"],
    @"TRANSFER" : [UIImage imageNamed:@"transfer_32.png"],
    @"FUNICULAR" : [UIImage imageNamed:@"funicular_32.png"]
    };
    
    _modeDisplayStrings = @{
    @"WALK" : @"Walk",
    @"BICYCLE" : @"Bike",
    @"CAR" : @"Drive",
    @"TRAM" : @"Tram",
    @"SUBWAY" : @"Subway",
    @"RAIL" : @"Train",
    @"BUS" : @"Bus",
    @"FERRY" : @"Ferry",
    @"CABLE_CAR" : @"Cable car",
    @"GONDOLA" : @"Gondola",
    @"FUNICULAR" : @"Funicular",
    @"TRANSFER" : @"Transfer"
    };
    
    _relativeDirectionIcons = @{
    @"HARD_LEFT" : [UIImage imageNamed:@"hard-left_32.png"],
    @"LEFT" : [UIImage imageNamed:@"hard-left_32.png"],
    @"SLIGHTLY_LEFT" : [UIImage imageNamed:@"slight-left_32.png"],
    @"CONTINUE" : [UIImage imageNamed:@"continue_32.png"],
    @"SLIGHTLY_RIGHT" : [UIImage imageNamed:@"slight-right_32.png"],
    @"RIGHT" : [UIImage imageNamed:@"hard-right_32.png"],
    @"HARD_RIGHT" : [UIImage imageNamed:@"hard-right_32.png"],
    @"CIRCLE_CLOCKWISE" : [UIImage imageNamed:@"clockwise_32.png"],
    @"CIRCLE_COUNTERCLOCKWISE" : [UIImage imageNamed:@"counterclockwise_32.png"],
    @"ELEVATOR" : [UIImage imageNamed:@"elevator_32.png"]
    };
    
    _relativeDirectionDisplayStrings = @{
    @"HARD_LEFT" : @"Hard left",
    @"LEFT" : @"Left",
    @"SLIGHTLY_LEFT" : @"Slight left",
    @"CONTINUE" : @"Continue",
    @"SLIGHTLY_RIGHT" : @"Slight right",
    @"RIGHT" : @"Right",
    @"HARD_RIGHT" : @"Hard right",
    @"CIRCLE_CLOCKWISE" : @"Circle clockwise",
    @"CIRCLE_COUNTERCLOCKWISE" : @"Circle counterclockwise",
    @"ELEVATOR" : @"Elevator"
    };
    
    _absoluteDirectionDisplayStrings = @{
    @"NORTH" : @"north",
    @"NORTHEAST" : @"northeast",
    @"EAST" : @"east",
    @"SOUTHEAST" : @"southeast",
    @"SOUTH" : @"south",
    @"SOUTHWEST" : @"southwest",
    @"WEST" : @"west",
    @"NORTHWEST" : @"northwest"
    };
    
    _popuprModeIcons = @{
    @"WALK" : [UIImage imageNamed:@"popup-walk.png"],
    @"WALK-ALT" : [UIImage imageNamed:@"popup-walk-left.png"],
    @"BICYCLE" : [UIImage imageNamed:@"popup-bike.png"],
    @"CAR" : [UIImage imageNamed:@"popup-car.png"],
    @"TRAM" : [UIImage imageNamed:@"popup-cable-car.png"],
    @"SUBWAY" : [UIImage imageNamed:@"popup-train.png"],
    @"RAIL" : [UIImage imageNamed:@"popup-train.png"],
    @"BUS" : [UIImage imageNamed:@"popup-bus.png"],
    @"FERRY" : [UIImage imageNamed:@"popup-ferry.png"],
    @"CABLE_CAR" : [UIImage imageNamed:@"popup-cable-car.png"],
    @"GONDOLA" : [UIImage imageNamed:@"popup-gondola.png"],
    @"TRANSFER" : [UIImage imageNamed:@"popup-transfer.png"],
    @"FUNICULAR" : [UIImage imageNamed:@"popup-funicular.png"]
    };
    
    _shapesForLegs = [[NSMutableArray alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mode == %@ OR mode == %@ OR mode == %@", @"BICYCLE", @"WALK", @"CAR"];
    _stepModeFilteredLegs = [self.itinerary.legs filteredArrayUsingPredicate:predicate];
    _allSteps = [self.itinerary.legs valueForKeyPath:@"@unionOfArrays.steps"];
    if (_stepModeFilteredLegs.count == self.itinerary.legs.count) {
        _shouldDisplaySteps = YES;
    } else {
        _shouldDisplaySteps = NO;
    }
    
    _primaryInstructionStrings = [[NSMutableArray alloc] init];
    _secondaryInstructionStrings = [[NSMutableArray alloc] init];
    _cellIcons = [[NSMutableArray alloc] init];

    if (_shouldDisplaySteps) {
        for (int i = 0; i < _allSteps.count; i++) {
            Step *step = [_allSteps objectAtIndex:i];
            Leg *leg;
            for (Leg* legToTest in self.itinerary.legs) {
                if ([legToTest.steps containsObject:step]) {
                    leg = legToTest;
                    break;
                }
            }
            
           // NSLog(@"|||||||||| Steps ||||||||| %@", leg.steps);
            NSString *instruction;
            if ([leg.steps indexOfObject:step] == 0) {
                instruction = [NSString stringWithFormat:@"%@ %@ on %@ for %d feet",
                                         [_modeDisplayStrings objectForKey:leg.mode],
                                         [_absoluteDirectionDisplayStrings objectForKey:step.absoluteDirection],
                                         step.streetName, step.distance.intValue];
                [_cellIcons insertObject:[_modeIcons objectForKey:leg.mode] atIndex:i];
                
                //Speech for each step
                AVSpeechUtterance *utterance = [AVSpeechUtterance
                                                speechUtteranceWithString:instruction];
                utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
                
            } else {
            
                instruction = [NSString stringWithFormat:@"%@ on %@ for %d feet",
                                         [_relativeDirectionDisplayStrings objectForKey:step.relativeDirection],
                                         step.streetName, step.distance.intValue];
                [_cellIcons insertObject:[_relativeDirectionIcons objectForKey:step.relativeDirection] atIndex:i];
                //Speech for each step
                AVSpeechUtterance *utterance = [AVSpeechUtterance
                                                speechUtteranceWithString:instruction];
                utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
            [_primaryInstructionStrings insertObject:instruction atIndex:i];
            [_secondaryInstructionStrings insertObject:[NSNull null] atIndex:i];
        }
    } else {
        
        for (int i = 0; i < self.itinerary.legs.count; i++) {
           // NSLog(@"|||||||||| Count ||||||||| @", self.itinerary.legs.count);
            Leg *leg = [self.itinerary.legs objectAtIndex:i];
            
            // distance based leg
            if ([_distanceBasedModes containsObject:leg.mode]) {
                [_cellIcons insertObject:[_modeIcons objectForKey:leg.mode] atIndex:i];
                [_primaryInstructionStrings insertObject:[NSString stringWithFormat:@"%@ to %@", [_modeDisplayStrings objectForKey:leg.mode], leg.to.name.capitalizedString] atIndex:i];
                [_secondaryInstructionStrings insertObject:[NSNull null] atIndex:i];
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"%@ to %@", [_modeDisplayStrings objectForKey:leg.mode], leg.to.name.capitalizedString]];
                utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
                
            // stop based leg
            } else if ([_stopBasedModes containsObject:leg.mode]) {
                [_cellIcons insertObject:[_modeIcons objectForKey:leg.mode] atIndex:i];
                
                NSString *destination = leg.headsign.capitalizedString;
                if(destination == nil) {
                    destination = leg.to.name.capitalizedString;
                }
                
                [_primaryInstructionStrings insertObject:[NSString stringWithFormat: @"Take the %@ %@ towards %@", leg.route.capitalizedString, ((NSString*)[_modeDisplayStrings objectForKey:leg.mode]).lowercaseString, destination] atIndex:i];
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance
                                                speechUtteranceWithString:[NSString stringWithFormat: @"Take the %@ %@ towards %@", leg.route.capitalizedString, ((NSString*)[_modeDisplayStrings objectForKey:leg.mode]).lowercaseString, destination]];
                
                utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
                [_secondaryInstructionStrings insertObject:[NSString stringWithFormat:@"Get off at %@", leg.to.name.capitalizedString] atIndex:i];
                
            // transfer leg
            } else if ([_transferModes containsObject:leg.mode]) {
                [_cellIcons insertObject:[_modeIcons objectForKey:leg.mode] atIndex:i];
                Leg *nextLeg = [self.itinerary.legs objectAtIndex:i+1];
                [_primaryInstructionStrings insertObject:[NSString stringWithFormat:@"Transfer to the %@ %@", nextLeg.route.capitalizedString, ((NSString*)[_modeDisplayStrings objectForKey:nextLeg.mode]).lowercaseString] atIndex:i];
                [_secondaryInstructionStrings insertObject:[NSNull null] atIndex:i];
            }
        }
    }
    [_primaryInstructionStrings addObject:[NSString stringWithFormat:@"Arrive at %@", self.toTextField.text]];
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:[NSString stringWithFormat:@"Arrive at Destination"]];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
    [_secondaryInstructionStrings addObject:[NSNull null]];
    
    self.itineraryTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryTableViewController"];
    self.itineraryTableViewController.tableView.dataSource = self;
    self.itineraryTableViewController.tableView.delegate = self;
    
    self.itineraryMapViewController = ((OTPAppDelegate *)[[UIApplication sharedApplication] delegate]).itineraryMapViewController;
    self.itineraryMapViewController.mapView.delegate = self;
    self.itineraryMapViewController.mapView.topPadding = 100;
    self.itineraryMapViewController.mapView.showsUserLocation = self.mapShowedUserLocation;
    
    self.frontViewController = self.itineraryTableViewController;
    self.rearViewController = self.itineraryMapViewController;
    self.frontViewShadowRadius = 5;
    self.rearViewRevealWidth = 260;
    self.maxRearViewRevealOverdraw = 0;
    self.toggleAnimationDuration = 0.1;
    self.itineraryMapViewController.instructionLabel.hidden = FALSE;
    self.delegate = self;
    
    OTPDirectionPanGestureRecognizer *navigationBarPanGestureRecognizer = [[OTPDirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(revealGesture:)];
    navigationBarPanGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.frontViewController.view addGestureRecognizer:navigationBarPanGestureRecognizer];
    
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DID_SHOW_ITINERARY_OVERLAY"]) {
        _overlayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryOverlay"];
        _overlayViewController.delegate = self;
        _overlayViewController.view.alpha = 0;
        [self.navigationController.view addSubview:_overlayViewController.view];
        [UIView animateWithDuration:0.5 animations:^{
            _overlayViewController.view.alpha = 1;
        }];
    }
    
    [super viewDidLoad];
    [self repositionItineraryTable];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
     if (viewController != self) {
        self.itineraryMapViewController.mapView.delegate = nil;
        ((OTPAppDelegate *)[[UIApplication sharedApplication] delegate]).itineraryMapViewController.mapView.delegate = nil;
        self.itineraryMapViewController = nil;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        [self displayItinerary];
        [self displayItineraryOverview];
    }
}

-(NSInteger)cellCount {
    
    // Check if we have any BIKE and/or WALK and/or CAR only legs
    if (_shouldDisplaySteps) {
        return _allSteps.count + 3;
    }
    return self.itinerary.legs.count + 3;  // +3 for overview, final arrival info and feedback
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self cellCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm a";
    
    UITableViewCell *cell = nil;
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    // Overview cell
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"OverviewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Set from/to in itinerary overview cell
        ((OTPItineraryOverviewCell *)cell).fromLabel.text = self.fromTextField.text;
        ((OTPItineraryOverviewCell *)cell).toLabel.text = self.toTextField.text;
        cell.selectedBackgroundView = selectedView;
        return cell;
    }
    
    // Feedback cell
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 2) || (_shouldDisplaySteps && indexPath.row == _allSteps.count + 2)) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCell"];
        cell.selectedBackgroundView = selectedView;
        return cell;
    }
    
    NSString *primaryInstruction = [_primaryInstructionStrings objectAtIndex:indexPath.row-1];
    NSString *secondaryInstruction = [_secondaryInstructionStrings objectAtIndex:indexPath.row-1];
    
    // Arrival cell
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 1) || (_shouldDisplaySteps && indexPath.row == _allSteps.count + 1)) {
        
        static NSString *CellIdentifier = @"ArrivalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        ((OTPArrivalCell *)cell).destinationText.text = primaryInstruction;
        ((OTPArrivalCell *)cell).arrivalTime.text = [dateFormatter stringFromDate:self.itinerary.endTime];
    } else {
        // use steps as segments
        if (_shouldDisplaySteps) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"StepCell"];
            ((OTPStepCell *)cell).instructionLabel.text = primaryInstruction;
            ((OTPStepCell *)cell).iconView.image = [_cellIcons objectAtIndex:indexPath.row-1];
            
            // multi-leg, non walk, bike, car itinerary: don't use steps as legs
        } else {
            Leg *leg = [self.itinerary.legs objectAtIndex:indexPath.row-1];
            
            // walk leg
            if ([_distanceBasedModes containsObject:leg.mode]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DistanceBasedLegCell"];
                
                ((OTPDistanceBasedLegCell *)cell).iconView.image = [_cellIcons objectAtIndex:indexPath.row-1];
                ((OTPDistanceBasedLegCell *)cell).instructionLabel.text = primaryInstruction;
                
                NSNumber *duration = [NSNumber numberWithFloat:roundf(leg.duration.floatValue/1000/60)];
                NSString *unitLabel = duration.intValue == 1 ? @"min" : @"min";
                ((OTPDistanceBasedLegCell *)cell).timeLabel.text = [NSString stringWithFormat:@"%i %@", duration.intValue, unitLabel];
                
                OTPUnitFormatter *unitFormatter = [[OTPUnitFormatter alloc] init];
                unitFormatter.cutoffMultiplier = @3.28084F;
                unitFormatter.unitData = @[
                [OTPUnitData unitDataWithCutoff:@100 multiplier:@3.28084F roundingIncrement:@10 singularLabel:@"foot" pluralLabel:@"feet"],
                [OTPUnitData unitDataWithCutoff:@528 multiplier:@3.28084F roundingIncrement:@100 singularLabel:@"foot" pluralLabel:@"feet"],
                [OTPUnitData unitDataWithCutoff:@INT_MAX multiplier:@0.000621371F roundingIncrement:@0.1F singularLabel:@"mile" pluralLabel:@"miles"]
                ];
                
                ((OTPDistanceBasedLegCell *)cell).distanceLabel.text = [unitFormatter numberToString:leg.distance];
                
                // stopbased leg
            } else if ([_stopBasedModes containsObject:leg.mode]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"StopBasedLegCell"];
                
                ((OTPStopBasedLegCell *)cell).iconView.image = [_cellIcons objectAtIndex:indexPath.row-1];
                
                ((OTPStopBasedLegCell *)cell).instructionLabel.text = primaryInstruction;
                
                ((OTPStopBasedLegCell *)cell).departureTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:leg.startTime]];
                
                int intermediateStops = leg.intermediateStops.count + 1;
                NSString *stopUnitLabel = intermediateStops == 1 ? @"stop" : @"stops";
                ((OTPStopBasedLegCell *)cell).stopsLabel.text = [NSString stringWithFormat:@"%u %@", intermediateStops, stopUnitLabel];
                
                ((OTPStopBasedLegCell *)cell).toLabel.text = secondaryInstruction;
                
                // transfer leg
            } else if ([_transferModes containsObject:leg.mode]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"TransferBasedLegCell"];
                ((OTPTransferCell *)cell).iconView.image = [_cellIcons objectAtIndex:indexPath.row-1];
                
                ((OTPTransferCell *)cell).instructionLabel.text = primaryInstruction;
            }
        }
    }
    cell.selectedBackgroundView = selectedView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Overview cell
    if (indexPath.row == 0) {
        return 80;
    }
    
    // Feedback cell
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 2) || (_shouldDisplaySteps && indexPath.row == _allSteps.count + 2)) {
        return 60;
    }
    
    NSString *primaryInstruction = [_primaryInstructionStrings objectAtIndex:indexPath.row-1];
    NSString *secondaryInstruction = [_secondaryInstructionStrings objectAtIndex:indexPath.row-1];
    
    // Arrival cell
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 1) || (_shouldDisplaySteps && indexPath.row == _allSteps.count + 1)) {
        
        float height = [primaryInstruction sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(193, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        return MAX(60, 8 + height + 8);
    } else {
        // use steps as segments
        if (_shouldDisplaySteps) {
            float height = [primaryInstruction sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
            return MAX(60, 8 + height + 8);
            
        // Multi-leg, non walk, bike, car itinerary: don't use steps as legs
        } else {
            Leg *leg = [self.itinerary.legs objectAtIndex:indexPath.row-1];
            // Distance based leg
            if ([_distanceBasedModes containsObject:leg.mode]) {
                float height = [primaryInstruction sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(191, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
                return MAX(60, 8 + height + 8);
                
            // Stop based leg
            } else if ([_stopBasedModes containsObject:leg.mode]) {
                float height1 = [primaryInstruction sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(191, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
                float height2 = [secondaryInstruction sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(191, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
                return MAX(60, 8 + height1 + 10 + height2 + 8);
                
            // Transfer leg
            } else if ([_transferModes containsObject:leg.mode]) {
                float height = [primaryInstruction sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
                return MAX(60, 8 + height + 8);
            }
        }
    }
    return 60;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Don't select the feedback cell
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 2) || (_shouldDisplaySteps && indexPath.row == _allSteps.count + 2)) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    
    // Show the map if the selected cell is not the feedback cell
    if (!_mapShowing &&
        !((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 2) || (_shouldDisplaySteps && indexPath.row == _allSteps.count + 2))) {
        [self resizeMapViewController];
        [self revealToggle:self];
    }
    
    // Overview cell selected
    if (indexPath.row == 0) {
        [TestFlight passCheckpoint:@"ITINERARY_DISPLAY_OVERVIEW"];
        /*
        [UIView animateWithDuration:0.3 animations:^{
            self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y - self.itineraryMapViewController.instructionLabel.bounds.size.height);
            
            self.itineraryMapViewController.goHomeBtn.center = CGPointMake(self.itineraryMapViewController.goHomeBtn.center.x, (self.itineraryMapViewController.goHomeBtn.bounds.size.height/2 + 10));
        } completion:^(BOOL finished) {
            self.itineraryMapViewController.instructionLabel.hidden = YES;
        }];
         */
        self.itineraryMapViewController.mapView.topPadding = 0;
        
        Leg *leg = [self.itinerary.legs lastObject];
        [self moveAnnotationWRTPlace:leg.from andPlace:leg.to];
        
        // [self resetLegsWithColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
        [self displayItineraryOverview];
        return;
    }
    
    // Feedback cell
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 2) ||
        (_shouldDisplaySteps && indexPath.row == _allSteps.count + 2)) {
        return;
    }
    
    NSString *primaryInstruction = [_primaryInstructionStrings objectAtIndex:indexPath.row-1];
    NSObject *secondaryInstruction = [_secondaryInstructionStrings objectAtIndex:indexPath.row-1];
    NSString *instruction = secondaryInstruction == [NSNull null] ?
    [NSString stringWithFormat:@"%@.", primaryInstruction] :
    [NSString stringWithFormat:@"%@ and %@.", primaryInstruction, [(NSString *)secondaryInstruction stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[(NSString *)secondaryInstruction substringToIndex:1].lowercaseString]];
    
    self.itineraryMapViewController.instructionLabel.text = instruction;
    [self.itineraryMapViewController.instructionLabel resizeHeightToFitText];
    if (self.itineraryMapViewController.instructionLabel.isHidden) {
       // self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.center.y - self.itineraryMapViewController.instructionLabel.bounds.size.height);
        self.itineraryMapViewController.instructionLabel.hidden = NO;
        /*
        [UIView animateWithDuration:0.3 animations:^{
            self.itineraryMapViewController.instructionLabel.center = CGPointMake(self.itineraryMapViewController.instructionLabel.center.x, self.itineraryMapViewController.instructionLabel.bounds.size.height/2);

            self.itineraryMapViewController.goHomeBtn.center = CGPointMake(self.itineraryMapViewController.goHomeBtn.center.x, (self.itineraryMapViewController.instructionLabel.bounds.size.height + self.itineraryMapViewController.goHomeBtn.bounds.size.height/2) + 10);
        }];
         */
    }
   // self.itineraryMapViewController.mapView.topPadding = self.itineraryMapViewController.instructionLabel.bounds.size.height;
    
    // Arrival cell (the last cell) selected
    if ((!_shouldDisplaySteps && indexPath.row == self.itinerary.legs.count + 1) ||
               (_shouldDisplaySteps && indexPath.row == _allSteps.count + 1)) {
        [TestFlight passCheckpoint:@"ITINERARY_DISPLAY_ARRIVAL"];
        // [self resetLegsWithColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];
        Leg *leg = [self.itinerary.legs lastObject];
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(leg.to.lat.floatValue - 0.001, leg.to.lon.floatValue - 0.001);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(leg.to.lat.floatValue + 0.001, leg.to.lon.floatValue + 0.001);
        
        [self moveAnnotationWRTPlace:leg.to andPlace:leg.from];
        
        [self.itineraryMapViewController.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
    // Handle step based segments
    //@ToDo Add Voice Command here.
    } else if (_shouldDisplaySteps) {
        [TestFlight passCheckpoint:@"ITINERARY_DISPLAY_STEP"];
        Step *step = [_allSteps objectAtIndex:indexPath.row-1];
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(step.lat.doubleValue - 0.002, step.lon.doubleValue - 0.002);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(step.lat.doubleValue + 0.002, step.lon.doubleValue + 0.002);
        
        [self moveAnnotationWRTStepAndDest:step];
        instruction = [NSString stringWithFormat:@"%@ on %@ for %d feet",
        [_relativeDirectionDisplayStrings objectForKey:step.relativeDirection],
         step.streetName, step.distance.intValue];
        AVSpeechUtterance *utterance = [AVSpeechUtterance
                                        speechUtteranceWithString:instruction];
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        [synth speakUtterance:utterance];
        
        //[self.itineraryMapViewController.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
    // Handle leg based segments
    } else {
        [TestFlight passCheckpoint:@"ITINERARY_DISPLAY_LEG"];
        [self resetLegsWithColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5]];
        RMShape *shape = [_shapesForLegs objectAtIndex:indexPath.row - 1];
        shape.lineColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
        Leg *leg = [self.itinerary.legs objectAtIndex:indexPath.row - 1];
        [self displayLeg:leg];
    }
}

- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
    if (revealController.currentFrontViewPosition == FrontViewPositionLeft) return;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"DID_SHOW_ITINERARY_MAP_OVERLAY"]) {
        _mapOverlayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryMapOverlay"];
        _mapOverlayViewController.delegate = self;
        _mapOverlayViewController.view.alpha = 0;
        [self.navigationController.view addSubview:_mapOverlayViewController.view];
        [UIView animateWithDuration:0.5 animations:^{
            _mapOverlayViewController.view.alpha = 1;
        }];
    }
    
    _mapShowing = YES;
    if (_selectedIndexPath == nil) {
        [TestFlight passCheckpoint:@"ITINERARY_SHOW_MAP_WITH_SWIPE"];
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        [TestFlight passCheckpoint:@"ITINERARY_SHOW_MAP_FROM_TAP"];
    }
    [self.itineraryTableViewController.tableView selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    ((OTPItineraryMapViewController *) rearViewController).itineraryTypeLabel.text = self.itinerary.title;
}

- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController
{
    if (revealController.currentFrontViewPosition != FrontViewPositionLeft) return;
    [TestFlight passCheckpoint:@"ITINERARY_HIDE_MAP_WITH_SWIPE"];
    _mapShowing = NO;
    [self.itineraryTableViewController.tableView deselectRowAtIndexPath:[self.itineraryTableViewController.tableView indexPathForSelectedRow] animated:YES];
}

//@ Todo : look at the critical bug of routing in chore trips
- (void) displayItinerary
{
    [self.itineraryMapViewController.mapView removeAllAnnotations];
    
    //NSLog(@"display Itinerary called");
    int legCounter = 0;
    RMAnnotation* curbCutAnnotation;
    for (Leg* leg in self.itinerary.legs) {
        
        
       if (legCounter == 0) {
            // start marker:
            RMAnnotation* startAnnotation = [RMAnnotation
                                             annotationWithMapView:self.itineraryMapViewController.mapView
                                             coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                             andTitle:nil];
            RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-start.png"]];
            startAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [startAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.itineraryMapViewController.mapView addAnnotation:startAnnotation];
            
        }
        if (legCounter == self.itinerary.legs.count - 1) {
            // end marker:
            RMAnnotation* endAnnotation = [RMAnnotation
                                           annotationWithMapView:self.itineraryMapViewController.mapView
                                           coordinate:CLLocationCoordinate2DMake(leg.to.lat.floatValue, leg.to.lon.floatValue)
                                           andTitle:leg.from.name];
            RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"marker-end.png"]];
            endAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [endAnnotation.userInfo setObject:marker forKey:@"layer"];
           [self.itineraryMapViewController.mapView addAnnotation:endAnnotation];
        }
        
        _allSteps = [self.itinerary.legs valueForKeyPath:@"@unionOfArrays.steps"];
        
        /*
        for(int i=1; i<_allSteps.count; i++){
            Step *step = [_allSteps objectAtIndex:i];
            /*Change Adds notation 33.776475, -84.387259
            NSLog(@"Annotation Called");
            curbCutAnnotation = [RMAnnotation
                                 annotationWithMapView:self.itineraryMapViewController.mapView
                                 coordinate:CLLocationCoordinate2DMake(step.lat.floatValue, step.lon.floatValue)
                                 andTitle:@"Curb"];
            RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"popup-funicular.png"]];
            curbCutAnnotation.userInfo = [[NSMutableDictionary alloc] init];
            [curbCutAnnotation.userInfo setObject:marker forKey:@"layer"];
            [self.itineraryMapViewController.mapView addAnnotation:curbCutAnnotation];
            /*End Adds Notation

        }
        
        */
        // Retrieve local JSON file called example.json
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"node" ofType:@"json"];
        // Load the file into an NSData object called JSONData
        NSError *error = nil;
        NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        
        /*Test - Start parsing of JSON points*/
        // Create an Objective-C object from JSON Data
        id JSONObject = [NSJSONSerialization
                         JSONObjectWithData:JSONData
                         options:NSJSONReadingAllowFragments
                         error:&error];
        
        NSArray *features = [JSONObject valueForKey:@"features"];
        
        /* Get sw and last */
        
        Leg* start = [self.itinerary.legs objectAtIndex:0];
        
        float epsilon = 0.002;
        float max_lat = start.to.lat.floatValue + epsilon;
        float min_lat = start.to.lat.floatValue - epsilon;
        float max_lon = start.to.lon.floatValue + epsilon;
        float min_lon = start.to.lon.floatValue - epsilon;
        
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(start.to.lat.floatValue - 0.001, start.to.lon.floatValue - 0.001);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(start.to.lat.floatValue + 0.001, start.to.lon.floatValue + 0.001);
        
        /* Adds Curb Cut Flag & Walk Signal */
        
        for(NSDictionary *dic in features){
            NSDictionary* attributes = [dic valueForKey:@"attributes"];
            NSString *Lat = [attributes valueForKey:@"Lat"];
            NSString *Long = [attributes valueForKey:@"Long"];
            NSString *curbCutFlag = [attributes valueForKey:@"CURB_CUT"];
         //   NSString *n = @"0";
            NSLog(@"Curb Cut Flag : %@", curbCutFlag);
            
            float cur_lat = [Lat floatValue];
            float cur_lon = [Long floatValue];
            
            if( cur_lat >= min_lat &&
                cur_lat <= max_lat &&
                cur_lon >= min_lon &&
                cur_lon <= max_lon
                ){
                if([curbCutFlag integerValue] == 0){
                    curbCutAnnotation = [RMAnnotation
                                     annotationWithMapView:self.itineraryMapViewController.mapView
                                     coordinate:CLLocationCoordinate2DMake([Lat floatValue], [Long floatValue])
                                     andTitle:@"Curb"];
                    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"troublespot_32.png"]];
                    curbCutAnnotation.userInfo = [[NSMutableDictionary alloc] init];
                    [curbCutAnnotation.userInfo setObject:marker forKey:@"layer"];
                    [self.itineraryMapViewController.mapView addAnnotation:curbCutAnnotation];
                }
                
                NSString *walkSignalFlag = [attributes valueForKey:@"WALK_SIG"];
                if([walkSignalFlag integerValue] == 0){
                    curbCutAnnotation = [RMAnnotation
                                         annotationWithMapView:self.itineraryMapViewController.mapView
                                         coordinate:CLLocationCoordinate2DMake([Lat floatValue], [Long floatValue])
                                         andTitle:@"Curb"];
                    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"troublespot_32.png"]];
                    curbCutAnnotation.userInfo = [[NSMutableDictionary alloc] init];
                    [curbCutAnnotation.userInfo setObject:marker forKey:@"layer"];
                    [self.itineraryMapViewController.mapView addAnnotation:curbCutAnnotation];
                }
            }

            /*End Adds Notation */
        }
        //NSString *test = [JSONObject valueForKey:@"displayFieldName"];
        //NSLog(@"displayFieldName %@", test);
        
        // map mode popup:
        modeAnnotation = [RMAnnotation
                                        annotationWithMapView:self.itineraryMapViewController.mapView
                                        coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                                        andTitle:leg.mode];
        
        RMMarker *popupMarker = [[RMMarker alloc] initWithUIImage:[_popuprModeIcons objectForKey:leg.mode]];
        modeAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [modeAnnotation.userInfo setObject:popupMarker forKey:@"layer"];
        [self.itineraryMapViewController.mapView addAnnotation:modeAnnotation];
        
        
        /*Change Adds notation 33.776475, -84.387259
        NSLog(@"Annotation Called");
        RMAnnotation* curbCutAnnotation = [RMAnnotation
                                       annotationWithMapView:self.itineraryMapViewController.mapView
                                       coordinate:CLLocationCoordinate2DMake(33.776475, -84.387259)
                                       andTitle:leg.from.name];
        RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"popup-ferry.png"]];
        curbCutAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [curbCutAnnotation.userInfo setObject:marker forKey:@"layer"];
        [self.itineraryMapViewController.mapView addAnnotation:curbCutAnnotation];
        /*End Adds Notation */
        
        id altObj = [_popuprModeIcons objectForKey:[NSString stringWithFormat:@"%@-ALT", leg.mode]];
        if(altObj == nil) {
            modeAnnotationAlt = nil;
        } else {
            modeAnnotationAlt = [RMAnnotation
                              annotationWithMapView:self.itineraryMapViewController.mapView
                              coordinate:CLLocationCoordinate2DMake(leg.from.lat.floatValue, leg.from.lon.floatValue)
                              andTitle:leg.mode];
            
            RMMarker *popupMarker = [[RMMarker alloc] initWithUIImage:altObj];
            modeAnnotationAlt.userInfo = [[NSMutableDictionary alloc] init];
            [modeAnnotationAlt.userInfo setObject:popupMarker forKey:@"layer"];
            popupMarker.hidden = YES;
            [self.itineraryMapViewController.mapView addAnnotation:modeAnnotationAlt];
        }

       // NSLog(@"Leg Counter: %i", legCounter);
        
        
        int counter = 0;
        RMShape *polyline = [[RMShape alloc] initWithView:self.itineraryMapViewController.mapView];

        
        for (CLLocation *loc in leg.decodedLegGeometry) {
           // if(counter > 5) break;
           // if(counter > 5){
                
                polyline.lineWidth = 3;
                polyline.lineCap = kCALineCapRound;
                polyline.lineJoin = kCALineJoinRound;
                polyline.lineColor =  [UIColor colorWithRed:1 green:0 blue:1 alpha:0.5];
           // }
           // else{
        
                polyline.lineWidth = 6;
                polyline.lineCap = kCALineCapRound;
                polyline.lineJoin = kCALineJoinRound;
                polyline.lineColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
           // }
           // NSLog(@"Loc Counter: %i", counter);
            if (counter == 0) {
                [polyline moveToCoordinate:loc.coordinate];
            } else {
                [polyline addLineToCoordinate:loc.coordinate];
            }
            [_shapesForLegs addObject:polyline];
            counter++;
        }
        
        //[_shapesForLegs addObject:polyline];
        
        RMAnnotation *polylineAnnotation = [[RMAnnotation alloc] init];
        [polylineAnnotation setMapView:self.itineraryMapViewController.mapView];
        polylineAnnotation.coordinate = ((CLLocation*)[leg.decodedLegGeometry objectAtIndex:0]).coordinate;
        [polylineAnnotation setBoundingBoxFromLocations:leg.decodedLegGeometry];
        polylineAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [polylineAnnotation.userInfo setObject:polyline forKey:@"layer"];
        [self.itineraryMapViewController.mapView addAnnotation:polylineAnnotation];
        
        
        //        RMShape *bbox = [[RMShape alloc] initWithView:self.itineraryMapViewController.mapView];
        //        bbox.lineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //        bbox.lineWidth = 2;
        //        bbox.lineCap = kCALineCapRound;
        //        bbox.lineJoin = kCALineJoinRound;
        //        bbox.zPosition = 0;
        //
        //        [bbox moveToCoordinate:leg.bounds.swCorner];
        //        [bbox addLineToCoordinate:CLLocationCoordinate2DMake(leg.bounds.swCorner.latitude, leg.bounds.neCorner.longitude)];
        //        [bbox addLineToCoordinate:leg.bounds.neCorner];
        //        [bbox addLineToCoordinate:CLLocationCoordinate2DMake(leg.bounds.neCorner.latitude, leg.bounds.swCorner.longitude)];
        //        [bbox closePath];
        //
        //        RMAnnotation *bboxAnnotation = [[RMAnnotation alloc] init];
        //        [bboxAnnotation setMapView:self.itineraryMapViewController.mapView];
        //        bboxAnnotation.coordinate = leg.bounds.swCorner;
        //        [bboxAnnotation setBoundingBoxFromLocations:leg.decodedLegGeometry];
        //        bboxAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        //        [bboxAnnotation.userInfo setObject:bbox forKey:@"layer"];
        //        [self.itineraryMapViewController.mapView addAnnotation:bboxAnnotation];
        
        legCounter++;
    }
    
    if(self.otherItinerary != nil) {
        [self displayOtherItinerary];
    }
}

- (void) displayOtherItinerary {
    for (Leg* leg in self.otherItinerary.legs) {
        RMShape *polyline = [[RMShape alloc] initWithView:self.itineraryMapViewController.mapView];
        polyline.lineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        polyline.lineWidth = 6;
        polyline.lineCap = kCALineCapRound;
        polyline.lineJoin = kCALineJoinRound;
        
        int counter = 0;
        
        for (CLLocation *loc in leg.decodedLegGeometry) {
            if (counter == 0) {
                [polyline moveToCoordinate:loc.coordinate];
            } else {
                [polyline addLineToCoordinate:loc.coordinate];
            }
            counter++;
        }
        
        RMAnnotation *polylineAnnotation = [[RMAnnotation alloc] init];
        [polylineAnnotation setMapView:self.itineraryMapViewController.mapView];
        polylineAnnotation.coordinate = ((CLLocation*)[leg.decodedLegGeometry objectAtIndex:0]).coordinate;
        [polylineAnnotation setBoundingBoxFromLocations:leg.decodedLegGeometry];
        polylineAnnotation.userInfo = [[NSMutableDictionary alloc] init];
        [polylineAnnotation.userInfo setObject:polyline forKey:@"layer"];
        [self.itineraryMapViewController.mapView addAnnotation:polylineAnnotation];
    }
}

- (void)displayItineraryOverview
{
    [self.itineraryMapViewController.mapView zoomWithLatitudeLongitudeBoundsSouthWest:self.itinerary.bounds.swCorner northEast:self.itinerary.bounds.neCorner animated:YES];
}

- (void)displayLeg:(Leg *)leg
{
    [self.itineraryMapViewController.mapView zoomWithLatitudeLongitudeBoundsSouthWest:leg.bounds.swCorner northEast:leg.bounds.neCorner animated:YES];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMapLayer* l = [annotation.userInfo objectForKey:@"layer"];
    if ([l isKindOfClass:[RMShape class]]) {
        l.zPosition = -999.0;
    }
    return l;
}

- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation
{
    self.itineraryMapViewController.userLocation = userLocation;
    if (self.itineraryMapViewController.needsPanToUserLocation) {
        [self.itineraryMapViewController updateViewsForCurrentUserLocation];
    }
}

- (void)resetLegsWithColor:(UIColor *)color
{
    for (RMShape *shape in _shapesForLegs) {
        shape.lineColor = color;
    }
}

- (void)userClosedOverlay:(UIView *)overlay
{
    if (overlay.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DID_SHOW_ITINERARY_OVERLAY"];
    } else if (overlay.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DID_SHOW_ITINERARY_MAP_OVERLAY"];
    }
}

- (void)presentFeedbackView
{
    if ([MFMailComposeViewController canSendMail]) {
        OTPAppDelegate *deleage = (OTPAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *line = @"Please provide feedback above this line and leave everything below this line intact.";
        
        NSMutableArray *legStrings = [[NSMutableArray alloc] init];
        [legStrings addObject:self.itinerary.startTime];
        for (Leg *leg in self.itinerary.legs) {
            NSString *legString = [NSString stringWithFormat:@"%@(%@)", leg.mode, leg.route];
            [legStrings addObject:legString];
        }
        NSString *legsString = [legStrings componentsJoinedByString:@", "];
        
        NSString *body = [NSString stringWithFormat:@"\n\n\n\n%@\n\n%@\n\n%@", line, deleage.currentUrlString, legsString];
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        controller.navigationBar.tintColor = [UIColor colorWithRed:0.004 green:0.694 blue:0.831 alpha:1.000];
        [controller setToRecipients:@[@"< Feedback email address >"]];
        [controller setSubject:@"Directions Feedback"];
        [controller setMessageBody:body isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact" message:@"Mail your feedback at subhro.guha@coa.gatech.edu ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You" message:@"Your feedback will be used to improve OTP Mobile." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [TestFlight passCheckpoint:@"ITINERARY_DONE"];
    self.itineraryMapViewController.mapView.delegate = nil;
    ((OTPAppDelegate *)[[UIApplication sharedApplication] delegate]).itineraryMapViewController.mapView.delegate = nil;
    self.itineraryMapViewController = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _mapShowing = NO;
}

- (void) moveAnnotationWRTPlace:(Place *)place andPlace:(Place *) otherPlace {
    Step *step = [[Step alloc] init];
    step.lat = place.lat;
    step.lon = place.lon;
    [self moveAnnotationWRTStep:step andPlace:otherPlace];
}

- (void) moveAnnotationWRTStepAndDest:(Step *) step {
    [self moveAnnotationWRTStep:step andPlace:(((Leg *)[self.itinerary.legs lastObject])).to];
}

- (void) moveAnnotationWRTStep:(Step *) step andPlace:(Place *) place {
    RMAnnotation *annoToShow = modeAnnotation;
    
    if(modeAnnotationAlt != nil) {
        RMAnnotation *annoToHide = modeAnnotationAlt;
        if(![self isStep:step westOfPlace:place]) {
            annoToHide = modeAnnotation;
            annoToShow = modeAnnotationAlt;
        }
        ((RMMarker*)[annoToHide.userInfo objectForKey:@"layer"]).hidden = true;
    }
    annoToShow.coordinate = CLLocationCoordinate2DMake(step.lat.floatValue, step.lon.floatValue);
    ((RMMarker*)[annoToShow.userInfo objectForKey:@"layer"]).hidden = false;
}

- (BOOL) isStep:(Step *) step westOfPlace:(Place *) place {
    // May not be the best logic
    BOOL isWest = YES;
    if((step.lon.floatValue > 0 && place.lon.floatValue > 0) || (step.lon.floatValue < 0 && place.lon.floatValue < 0)) {
        if(step.lon.floatValue > place.lon.floatValue) {
            isWest = NO;
        }
    } else if(step.lon.floatValue > place.lon.floatValue) {
        isWest = NO;
    }
    
    return isWest;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(_mapShowing) {
        [self resizeMapViewController];
        [self revealToggle:self];
        [self revealToggle:self];
        [self repositionItineraryTable];
    }
}

- (void) resizeMapViewController {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth;
    CGRect currRect = self.itineraryMapViewController.view.frame;
    CGFloat newWidth;
    CGFloat newHeight;
    CGFloat iosVersionYOffsetDelta = 0.0;
    
    if([self isDeviceVersion:7.0]) {
        iosVersionYOffsetDelta = self.navigationController.navigationBar.frame.size.height;
    }
    
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        screenWidth = screenRect.size.width;
        newWidth = screenRect.size.width;
        newHeight = screenRect.size.height - self.itineraryMapViewController.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    } else {
        screenWidth = screenRect.size.height;
        newWidth = screenRect.size.height;
        newHeight = screenRect.size.width - self.itineraryMapViewController.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    self.rearViewRevealWidth = screenWidth - 60;
    
    self.itineraryMapViewController.view.frame = CGRectMake(currRect.origin.x, iosVersionYOffsetDelta, newWidth, newHeight);
}

- (void) repositionItineraryTable {
    if([self isDeviceVersion:7.0]) {
        CGFloat iosVersionYOffsetDelta = self.navigationController.navigationBar.frame.size.height;
        
        CGRect currRect = self.itineraryTableViewController.view.frame;
        self.itineraryTableViewController.view.frame = CGRectMake(currRect.origin.x, iosVersionYOffsetDelta, currRect.size.width, currRect.size.height);
    }
}

- (BOOL) isDeviceVersion:(float) minVersion {
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(osVersion >= minVersion) {
        return YES;
    }
    
    return NO;
}

@end
