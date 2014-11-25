//
//  OTPDirectionsInputViewController.m
//  OpenTripPlanner
//
//  Created by asutula on 9/10/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>

#import "OTPAppDelegate.h"
#import "Response.h"
#import "OTPDirectionsInputViewController.h"
#import "OTPTransitTimesViewController.h"
#import "OTPItineraryViewController.h"
#import "OTPCallout.h"
#import "SMCalloutView.h"
#import "NSString+HMAC.h"

#import "ParametersViewController.h"
#import "WalkableParameter.h"

NSString * const kTransitModeTypeArray[] = {
    @"WALK,TRANSIT",
    @"BICYCLE,TRANSIT",
    @"BICYCLE",
    @"WALK"
};

NSString * const kArriveByArray[] = {
    @"false",
    @"true"
};

NSInteger count =0;
NSInteger intro_count = 0;


typedef enum {
    MARKER_TYPE_SELECTION = 10
} ActionSheetPurpose;

NSString *const planServicePath = @"/plan";
NSString *const searchNearbyTextDefault = @"Type your destination...";
NSString *const searchNearbyNoResultsPrefix = @"No places found for";
double minSearchRadius = 200.0;

@interface OTPDirectionsInputViewController ()
{
    RMAnnotation *_fromAnnotation;
    RMAnnotation *_toAnnotation;
    OTPGeocodedTextField *_textFieldToDisambiguate;
    NSArray *_placemarksToDisambiguate;
    UIImage *_fromPinImage;
    UIImage *_toPinImage;
    int _dragOffset;
    
    UIImage *_poiPinImage;
    UIImage *_showFromToEnabledImage;
    UIImage *_showFromToDisabledImage;
}

- (void)switchFromAndTo:(id)sender;
- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField;
- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;
- (void)panMapToCurrentGeocodedTextField;
- (void)updateViewsForCurrentUserLocation;
- (RMProjectedPoint)adjustPointForKeyboard:(CLLocationCoordinate2D)coordinate;

- (IBAction)showFromToMarkers:(id)sender;
@property (weak, nonatomic) IBOutlet OTPGeocodedTextField *searchNearbyText;
@property (weak, nonatomic) IBOutlet UIButton *showFromToButton;

@end

@implementation OTPDirectionsInputViewController

CLGeocoder *geocoder;
CLPlacemark *fromPlacemark;
CLPlacemark *toPlacemark;
NSNumber *topOfKeyboard;

Response *currentResponse;

CLLocation *currentLongPressLocation;
static NSString *OTPPOIAnnotation = @"OTPPOIAnnotation";
RMMarker *previousMarkerTapped;
NSMutableArray *poiAnnotationsOnMap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Chandra
    
    if (intro_count < 1){
        UIAlertView *intro = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Would you like to set preferences for better experience?" delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Set preferences", nil];
        
        intro.tag = 1;
        
        [intro show];
        
        intro_count = intro_count + 1;
        
    }
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _fromPinImage = [UIImage imageNamed:@"marker-start.png"];
    _toPinImage = [UIImage imageNamed:@"marker-end.png"];
    _poiPinImage = [UIImage imageNamed:@"marker-dropped.png"];
    
    _dragOffset = 0;
    
    self.goButton.enabled = NO;
    
    _showFromToEnabledImage = [UIImage imageNamed:@"overview.png"];
    _showFromToDisabledImage = [UIImage imageNamed:@"overview-disabled.png"];
    [self showFromToButtonEnabled:NO];
    
    
    int selectedModeIndex = [defaults integerForKey:@"selectedModeIndex"] < self.modeControl.numberOfSegments ? [defaults integerForKey:@"selectedModeIndex"] : 0;
    self.modeControl.selectedSegmentIndex = selectedModeIndex;
    // Vignesh: No support for multiple modes. Only WALK
    // [self modeChanged:self.modeControl];
    [self.modeControl setHidden:true];
    
    self.arriveOrDepartByIndex = [NSNumber numberWithInt:[defaults integerForKey:@"arriveOrDepartByIndex"]];
    self.date = [[NSDate alloc] init];
    // self.navBar.topItem.titleView = self.modeControl;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    geocoder = [[CLGeocoder alloc] init];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *mapUrl = nil;
    if (scale == 1) {
        mapUrl = @"http://a.tiles.mapbox.com/v3/openplans.map-ky03eiac.jsonp";
    } else {
        mapUrl = @"http://a.tiles.mapbox.com/v3/openplans.map-pq6tfzg7.jsonp";
    }
    RMMapBoxSource* source = [[RMMapBoxSource alloc] initWithReferenceURL:[NSURL URLWithString:mapUrl]];
    self.mapView.adjustTilesForRetinaDisplay = NO;
    self.mapView.tileSource = source;
    self.mapView.delegate = self;
    [self.mapView setConstraintsSouthWest:CLLocationCoordinate2DMake(33.2988912648916, -84.8327537259032) northEast:CLLocationCoordinate2DMake(34.2551952258634, -83.9477342897018)];
    
    float zoom = [defaults floatForKey:@"mapZoom"] == 0 ? 4 : [defaults floatForKey:@"mapZoom"];
    float lon = [defaults floatForKey:@"mapLon"] == 0 ? -95 : [defaults floatForKey:@"mapLon"];
    float lat = [defaults floatForKey:@"mapLat"] == 0 ? 40 : [defaults floatForKey:@"mapLat"];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lon)];
    [self.mapView setZoom:zoom];
	
    self.switchFromAndToButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"swap-addresses.png"], nil]];
    self.switchFromAndToButton.segmentedControlStyle = UISegmentedControlStyleBar;
    self.switchFromAndToButton.tintColor = [UIColor colorWithRed:0.086 green:0.639 blue:0.792 alpha:1.000];
    CGRect controlFrame = self.switchFromAndToButton.frame;
    controlFrame.size.height = 20.f;
    controlFrame.size.width = 20.f;
    
    self.switchFromAndToButton.frame = controlFrame;
    self.switchFromAndToButton.momentary = YES;
    self.switchFromAndToButton.center = CGPointMake(20, 40);
    [self.switchFromAndToButton addTarget:self action:@selector(switchFromAndTo:) forControlEvents:UIControlEventAllEvents];
    
    [self.textFieldContainer addSubview:self.switchFromAndToButton];
    
    self.textFieldContainer.hidden = true;
    
    UILabel *fromLabel = [[UILabel alloc] init];
    fromLabel.textColor = [UIColor grayColor];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.font = [UIFont systemFontOfSize:14];
    fromLabel.text = @"From: ";
    [fromLabel sizeToFit];
    
    self.fromTextField.leftViewMode = UITextFieldViewModeAlways;
    self.fromTextField.leftView = fromLabel;
    
    UILabel *toLabel = [[UILabel alloc] init];
    toLabel.textColor = [UIColor grayColor];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.font = [UIFont systemFontOfSize:14];
    toLabel.text = @"To: ";
    [toLabel sizeToFit];
    
    self.toTextField.leftViewMode = UITextFieldViewModeAlways;
    self.toTextField.leftView = toLabel;
    
    self.fromTextField.otherTextField = self.toTextField;
    self.toTextField.otherTextField = self.fromTextField;
    
    self.fromTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    self.toTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    if (!self.launchedFromUrl) {
        [self panToUserLocation:self];
    }
    
    previousMarkerTapped = nil;
    poiAnnotationsOnMap = [[NSMutableArray alloc] init];
    
    self.searchNearbyText.text = searchNearbyTextDefault;
    
    //*** Code by Chandra ***//
    UIButton *dropdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropdownButton.frame = CGRectMake(0, 0, 32, 32);
    [dropdownButton setImage:[UIImage imageNamed:@"dropdown1.png"] forState:UIControlStateNormal];
    [dropdownButton addTarget:self action:@selector(openView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:dropdownButton];
    self.navigationItem.rightBarButtonItem=barButton;
    
    //[dropdownButton release];
    //[barButton release];
    
    
    //**ends**//
    
}


- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (alertView.tag == 1){
        
        if (buttonIndex == 1){
            
            [self performSegueWithIdentifier:@"toSettings" sender:self];
            
        }
        
    }
}



- (void)go:(id)sender
{
    [TestFlight passCheckpoint:@"DIRECTIONS_GO"];
    [self initHUDWithLabel:@"Routing"];
	[HUD show:YES];
    
    [self planTripFrom:self.fromTextField.location.coordinate to:self.toTextField.location.coordinate];
    [self.fromTextField resignFirstResponder];
    [self.toTextField resignFirstResponder];
}

- (void)willShowKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    topOfKeyboard = [NSNumber numberWithFloat:keyboardRect.origin.y - keyboardRect.size.height];
    
    [self panMapToCurrentGeocodedTextField];
    
    if([self.searchNearbyText.text isEqualToString:searchNearbyTextDefault]) {
       self.searchNearbyText.text = @"";
    }
    self.searchNearbyText.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat offset=0;
        
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            offset = 0;
            //offset = keyboardRect.size.height;
        }else{
            offset = 0;
            //offset = keyboardRect.size.width;
        }
     
    
        self.userLocationButton.center = CGPointMake(self.userLocationButton.center.x, self.userLocationButton.center.y - offset);
        self.searchNearbyText.center = CGPointMake(self.searchNearbyText.center.x, self.searchNearbyText.center.y - offset);
    }];


}

- (void)willHideKeyboard:(NSNotification *)notification
{
    //CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    topOfKeyboard = nil;

    self.searchNearbyText.alpha = 0.7;
    NSString *txt = self.searchNearbyText.text = [self.searchNearbyText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(txt.length == 0) {
        self.searchNearbyText.text = searchNearbyTextDefault;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.5 animations:^{
        
        CGFloat offset;
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            offset = 0;
            //offset = keyboardRect.size.height;
        }else{
            offset = 0;
            //offset = keyboardRect.size.width;
        }
        
        self.userLocationButton.center = CGPointMake(self.userLocationButton.center.x, self.userLocationButton.center.y + offset);
        self.searchNearbyText.center = CGPointMake(self.searchNearbyText.center.x, self.searchNearbyText.center.y + offset);
    }];
}

- (void)updateTextField:(OTPGeocodedTextField *)textField withText:(NSString *)text andLocation:(CLLocation *)location
{
    // Set the text field properties so its views reflect current data
    [textField setText:text andLocation:location];
    
    // Enable/disable go button
    if (textField.isGeocoded && textField.otherTextField.isGeocoded) {
        self.goButton.enabled = YES;
        [self showFromToButtonEnabled:YES];
    } else {
        self.goButton.enabled = NO;
        [self showFromToButtonEnabled:NO];
    }
    
    // Manage map annotations
    // If we are not geocoded, check if any corresponding map annotations exist and remove them
    if (!textField.isGeocoded) {
        // If the text field is associated with a pin, remove it from the map
        if (textField == self.fromTextField && _fromAnnotation != nil) {
            [self.mapView removeAnnotation:_fromAnnotation];
            _fromAnnotation = nil;
        } else if (textField == self.toTextField && _toAnnotation != nil) {
            [self.mapView removeAnnotation:_toAnnotation];
            _toAnnotation = nil;
        }
    } else {
        if (!textField.isCurrentLocation) {
            // We are geocoded and user location, so add an annotation to the map
            RMAnnotation* placeAnnotation = [RMAnnotation
                                             annotationWithMapView:self.mapView
                                             coordinate:location.coordinate
                                             andTitle:nil];
            
            if (textField == self.fromTextField) {
                _fromAnnotation = placeAnnotation;
            } else {
                _toAnnotation = placeAnnotation;
            }
            
            [self.mapView addAnnotation:placeAnnotation];
            
            if (_fromTextField.isGeocoded && _toTextField.isGeocoded && ![placeAnnotation isAnnotationWithinBounds:self.mapView.bounds]) {
                [self showFromAndToLocations];
            }
        }
        if (self.fromTextField.isFirstResponder || self.toTextField.isFirstResponder) {
            //if ((!textField.otherTextField.isGeocoded && textField.otherTextField.isFirstResponder) || !textField.otherTextField.isFirstResponder) {
                //[self.mapView setCenterProjectedPoint:[self adjustPointForKeyboard:location.coordinate] animated:YES];
            //}
        }
    }
}


#pragma mark OTP methods

- (void)planTripFrom:(CLLocationCoordinate2D)startPoint to:(CLLocationCoordinate2D)endPoint
{
    // TODO: Look at how time zone plays into all this.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // If the tracked date is before now, set the tracked date to now.
    self.date = [[[NSDate alloc] init] laterDate:self.date];
    NSString *dateString = [dateFormatter stringFromDate:self.date];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:self.date];
    
    
    //NSString *fromString = [NSString stringWithFormat:@"%f,%f", startPoint.latitude, startPoint.longitude];
    //Chandra adding the default location as the user's current location if start location not specified
    NSString *fromString = @"";
    if(startPoint.longitude == 0){
        fromString = [NSString stringWithFormat:@"%f,%f", self.userLocation.location.coordinate.latitude, self.userLocation.location.coordinate.longitude];
    }else{
        fromString = [NSString stringWithFormat:@"%f,%f", startPoint.latitude, startPoint.longitude];
    }
    
    
    
    NSString *toString = [NSString stringWithFormat:@"%f,%f", endPoint.latitude, endPoint.longitude];
    
    // Vignesh: Commenting since WALK is the only supported mode
    // NSString *mode = kTransitModeTypeArray[self.modeControl.selectedSegmentIndex];
    NSString *mode = @"WALK";
    NSString *arriveBy = kArriveByArray[self.arriveOrDepartByIndex.intValue];
    
    // If your server supports HMAC authentication...
    // NSString *secret = @"< Your shared secret >";
    // NSString *apiKey = @"< Your API key >";
    // NSString *signature = [[[apiKey stringByAppendingString:fromString] stringByAppendingString:toString] HMACWithSecret:secret];
    
    WalkableParameter *wp = [WalkableParameter params];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                   @"optimize", @"SAFE",
                                   @"time", timeString,
                                   @"arriveBy", arriveBy,
                                   // @"routerId", @"req-241",
                                   @"maxWalkDistance", @"2000",
                                   @"fromPlace", fromString,
                                   @"toPlace", toString,
                                   @"fromLabel", self.fromTextField.text,
                                   @"toLabel", self.toTextField.text,
                                   @"date", dateString,
                                   @"mode", mode,
                                   @"showIntermediateStops", @"true",
                                   @"wsWTTraffic", [NSString stringWithFormat:@"%d",wp.traffic],
                                   @"wsWTNDVI", [NSString stringWithFormat:@"%d",wp.greenery],
                                   @"wsWTCrime", [NSString stringWithFormat:@"%d",wp.crime],
                                   @"wsWTSidewalk", [NSString stringWithFormat:@"%d",wp.sidewalk],
                                   @"wsWTResDen", [NSString stringWithFormat:@"%d",wp.resiDensity],
                                   @"wsWTBusDen", [NSString stringWithFormat:@"%d",wp.busiDensity],
                                   @"wsWTAccess", [NSString stringWithFormat:@"%d",wp.accessibility],
                                   @"wsWTIntersect", [NSString stringWithFormat:@"%d",wp.intersection],
                                   @"wsWTSlope", [NSString stringWithFormat:@"%d",wp.slope],
                                   @"wsWTLandVar", [NSString stringWithFormat:@"%d",wp.landVariation],
                                   // @"apiKey", apiKey,
                                   // @"signature", signature,
                                   nil];
    
    NSString* resourcePath = [planServicePath stringByAppendingQueryParameters:params];
    
    _OTPResponse = nil;
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void)geocodeStringInTextField:(OTPGeocodedTextField *)textField
{
    BOOL isSearchNearbyTextField = [self isSearchNearbyTextField:textField];    
    
    // Create a region based on either the user's current location or the map center
    // using a width of the larger of the width of the displayed map area or 200km.
    CLLocationCoordinate2D regionCoordinate;
    if (self.userLocation != nil && self.mapView.showsUserLocation) {
        regionCoordinate = self.userLocation.location.coordinate;
    } else {
        regionCoordinate = self.mapView.centerCoordinate;
    }
    double radius = 0;
    
    if(isSearchNearbyTextField){
        [self initHUDWithLabel:@"Searching"];
        [HUD show:YES];
        
        if(poiAnnotationsOnMap.count == 0) {
            radius = MAX(self.mapView.projectedViewSize.width/2, 100000);
        } else {
            radius = MAX(MAX(self.mapView.projectedViewSize.height,self.mapView.projectedViewSize.width)/2, minSearchRadius);
        }
    }
    else {
        UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingIndicator startAnimating];
        textField.rightView = loadingIndicator;
        
        radius = MAX(self.mapView.projectedViewSize.width/2, 100000);
    }
    
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:regionCoordinate radius:radius identifier:@"GEOCODE_REGION"];
    
    [geocoder geocodeAddressString:textField.text inRegion:region completionHandler:^(NSArray* placemarks, NSError* error) {
        [HUD hide:YES];
        BOOL showNoPOIError = NO;
        
        if (placemarks.count == 0) {
            // no results
            if(isSearchNearbyTextField){
                if(poiAnnotationsOnMap.count == 0) {
                    showNoPOIError = YES;
                }
            } else {
                [textField setText:textField.text andLocation:nil];
            }
        } else if (placemarks.count > 1) {
            // TODO: disambigate
            _textFieldToDisambiguate = textField;
            _placemarksToDisambiguate = placemarks;
            [self performSegueWithIdentifier:@"DisambiguateGeocode" sender:self];
        } else {
            // Got one result, process it.
            CLPlacemark *result = [placemarks objectAtIndex:0];
            
            // Filter out the country
            NSArray *formattedAddressLines = (NSArray *)[result.addressDictionary objectForKey:@"FormattedAddressLines"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", result.country];
            NSArray *filteredAddressLines = [formattedAddressLines filteredArrayUsingPredicate:predicate];

            if(isSearchNearbyTextField) {
                if([region containsCoordinate:result.location.coordinate]) {
                    [self addGeocodedPOIAndRenderPOIs:result withAddress:[filteredAddressLines componentsJoinedByString:@", "]];
                } else if(poiAnnotationsOnMap.count == 0) {
                    showNoPOIError = YES;
                } else {
                    [self renderPOIsOnMap];
                }
            } else {
                [self updateTextField:textField withText:[filteredAddressLines componentsJoinedByString:@", "] andLocation:result.location];
            }
        }
        
        if(showNoPOIError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ '%@'",searchNearbyNoResultsPrefix,textField.text] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

- (void)switchFromAndTo:(id)sender
{
    [TestFlight passCheckpoint:@"DIRECTIONS_SWITCH_FROM_TO"];
    
    [self.fromTextField switchValuesWithOther];
    
    RMAnnotation *tmpAnnotation = _fromAnnotation;
    _fromAnnotation = _toAnnotation;
    _toAnnotation = tmpAnnotation;
    
    [(RMMarker*)_fromAnnotation.layer replaceUIImage:_fromPinImage];
    [(RMMarker*)_toAnnotation.layer replaceUIImage:_toPinImage];
    
    [self panMapToCurrentGeocodedTextField];
}

- (IBAction)modeChanged:(id)sender {
    [TestFlight passCheckpoint:@"DIRECTIONS_CHANGE_MODE"];
    if (((UISegmentedControl *)sender).selectedSegmentIndex < 2) {
        self.timeButton.enabled = YES;
    } else {
        self.timeButton.enabled = NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:((UISegmentedControl *)sender).selectedSegmentIndex forKey:@"selectedModeIndex"];
    [defaults synchronize];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [TestFlight passCheckpoint:@"DIRECTIONS_DID_TYPE_INTO_TEXTFIELD"];
    [self panMapToCurrentGeocodedTextField];
}

- (void)updatedTextField:(id)sender
{
    OTPGeocodedTextField *textField = (OTPGeocodedTextField *)sender;
    textField.location = nil;
    
    self.goButton.enabled = NO;
    [self showFromToButtonEnabled:NO];
    
    // If the text field is associated with a pin, remove it from the map
    // TODO: This needs to be DRY... Code repeated above.
    if (textField == self.fromTextField && _fromAnnotation != nil) {
        [self.mapView removeAnnotation:_fromAnnotation];
        _fromAnnotation = nil;
    } else if (textField == self.toTextField && _toAnnotation != nil) {
        [self.mapView removeAnnotation:_toAnnotation];
        _toAnnotation = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    OTPGeocodedTextField *field = (OTPGeocodedTextField *)textField;
    if([self isSearchNearbyTextField:field]) {
        [self searchPlace];
    } else if (!field.isGeocoded && field.text.length > 0) {
        [self geocodeStringInTextField:field];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    OTPGeocodedTextField *field = (OTPGeocodedTextField *)textField;
    
    // If the other text field has valid geocoded data, we don't need to do anything
    if ([field.otherTextField isGeocoded]) {
        [textField resignFirstResponder];
        return YES;
    } else if([self isSearchNearbyTextField:field]) {
        [textField resignFirstResponder];
        return YES;
    }
    
    // The other text field needs input so make it the first responder
    [((OTPGeocodedTextField *)textField).otherTextField becomeFirstResponder];
    return YES;
}

- (void)panToUserLocation:(id)sender
{
    [TestFlight passCheckpoint:@"DIRECTIONS_PAN_TO_USER_LOCATION"];
    self.needsPanToUserLocation = YES;
    
    //NSLog (@"----User Location--- %f",self.mapView.centerCoordinate.latitude) ;
    //NSLog (@"----User Location--- %f",self.mapView.centerCoordinate.longitude) ;
    [self enableUserLocation];
}

- (IBAction)touchAboutButton:(id)sender
{
    [self performSegueWithIdentifier:@"showAbout" sender:self];    
}

- (void)enableUserLocation
{
    self.mapView.showsUserLocation = YES;
    [self updateViewsForCurrentUserLocation];
}

- (void)updateViewsForCurrentUserLocation
{
    if (self.userLocation == nil) {
        return;
    }
    
    // Show user location on the map
    if (self.needsPanToUserLocation) {
        CLLocationCoordinate2D adjustedCoord = [self.mapView projectedPointToCoordinate:[self adjustPointForKeyboard:self.userLocation.coordinate]];
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(adjustedCoord.latitude - 0.0015, adjustedCoord.longitude - 0.0015);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(adjustedCoord.latitude + 0.0015, adjustedCoord.longitude + 0.0015);
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
        self.needsPanToUserLocation = NO;
    } else if (self.needsShowFromAndToLocations) {
        [self showFromAndToLocations];
        self.needsShowFromAndToLocations = NO;
    }
}

#pragma mark RMMapViewDelegate methods

- (void)mapView:(RMMapView *)mapView didUpdateUserLocation:(RMUserLocation *)userLocation
{
    self.userLocation = userLocation;
    // Keep any current location input field up to date
    if (self.fromTextField.isCurrentLocation) {
        [self.fromTextField setText:self.fromTextField.text andLocation:userLocation.location];
    } else if (self.toTextField.isCurrentLocation) {
        [self.toTextField setText:self.toTextField.text andLocation:userLocation.location];
    }
    if (self.needsPanToUserLocation || self.needsShowFromAndToLocations) {
        [self updateViewsForCurrentUserLocation];
    }
}

- (void)mapView:(RMMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    // Alert user that location couldn't be detirmined.
    [TestFlight passCheckpoint:@"DIRECTIONS_FAILED_TO_LOCATE_USER"];
}

- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    if ((self.fromTextField.isFirstResponder || self.toTextField.isFirstResponder) && self.fromTextField.isGeocoded && self.toTextField.isGeocoded) {
        [self showFromAndToLocations];
    }
    [self.view endEditing:YES];
}

- (void)longSingleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    [self.view endEditing:YES];
 
    CLLocationCoordinate2D coord = [self.mapView pixelToCoordinate:point];
    currentLongPressLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Start here", @"End here", @"Share a Tweet", nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    actionSheet.tag = MARKER_TYPE_SELECTION;
    [actionSheet showInView:self.view];
}

- (void)tapOnAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    if([OTPPOIAnnotation isEqualToString:annotation.annotationType]) {
        RMMapLayer *ml = annotation.layer;
        if([ml isKindOfClass:[RMMarker class]]) {
            RMMarker *marker = (RMMarker*) ml;
            marker.label.hidden = !marker.label.hidden;
            
            if(marker.label.hidden) {
                previousMarkerTapped = nil;
            } else {
                if(previousMarkerTapped != nil) {
                    previousMarkerTapped.label.hidden = YES;
                }
                previousMarkerTapped = marker;
            }
        }
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    BOOL isPOIAnnotation = NO;
    UIImage *image;
    if (annotation == _fromAnnotation) {
        image = _fromPinImage;
    } else if (annotation == _toAnnotation) {
        image = _toPinImage;
    } else {
        if([OTPPOIAnnotation isEqualToString:annotation.annotationType]) {
            isPOIAnnotation = YES;
        } else {
            return nil;
        }
    }
    
    RMMarker *marker;
    if(isPOIAnnotation) {
        image = _poiPinImage;
        marker = [[RMMarker alloc] initWithUIImage:image];
        
        CGPoint labelPosition = CGPointMake(marker.position.x, marker.position.y);
        [marker changeLabelUsingText:annotation.title position:labelPosition];
        
        marker.textBackgroundColor = [UIColor blackColor];
        marker.textForegroundColor = [UIColor whiteColor];
        marker.label.userInteractionEnabled = NO;
        marker.enableDragging = NO;
        
        CGRect labelBounds = marker.label.bounds;
        marker.label.transform = CGAffineTransformMakeTranslation(labelBounds.size.width/-3, labelBounds.size.height/-1);
        
        marker.label.hidden = YES;
    } else {
        marker = [[RMMarker alloc] initWithUIImage:image];
        marker.enableDragging = YES;
        marker.zPosition = 10;
    }
    
    if ([annotation isAnnotationWithinBounds:self.mapView.bounds]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(annotation.position.x, 0)];
        animation.toValue = [NSValue valueWithCGPoint:annotation.position];
        animation.duration = 0.2;
        animation.delegate = self;
        [marker addAnimation:animation forKey:@"position"];
    }
    return marker;
}

- (BOOL)mapView:(RMMapView *)map shouldDragAnnotation:(RMAnnotation *)annotation
{
    [self.view endEditing:YES];
    
    if([OTPPOIAnnotation isEqualToString:annotation.annotationType]){
        return NO;
    }
    
    return YES;
}

- (void)mapView:(RMMapView *)map didDragAnnotation:(RMAnnotation *)annotation withDelta:(CGPoint)delta
{
    if (_dragOffset < 10) {
        delta.y = delta.y + _dragOffset;
    }
    annotation.position = CGPointMake(annotation.position.x - delta.x, annotation.position.y - delta.y);
    _dragOffset++;
}

- (void)mapView:(RMMapView *)map didEndDragAnnotation:(RMAnnotation *)annotation
{
    [TestFlight passCheckpoint:@"DIRECTIONS_DRAGGED_PIN"];
    annotation.coordinate = [map pixelToCoordinate:annotation.position];
    _dragOffset = 0;
    
    OTPGeocodedTextField *textField;
    if (annotation == _fromAnnotation) {
        textField = self.fromTextField;
    } else {
        textField = self.toTextField;
    }
    textField.text = @"Dropped Pin";
    textField.location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_fromTextField.isGeocoded && _toTextField.isGeocoded && self.needsShowFromAndToLocations) {
        [self showFromAndToLocations];
    }
}

- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:map.centerCoordinate.longitude forKey:@"mapLon"];
    [defaults setFloat:map.centerCoordinate.latitude forKey:@"mapLat"];
    [defaults setFloat:map.zoom forKey:@"mapZoom"];
    [defaults synchronize];
}

- (void)afterMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:map.centerCoordinate.longitude forKey:@"mapLon"];
    [defaults setFloat:map.centerCoordinate.latitude forKey:@"mapLat"];
    [defaults setFloat:map.zoom forKey:@"mapZoom"];
    [defaults synchronize];
}

#pragma mark OTPTransitTimeViewControllerDelegate methods

- (void)transitTimeViewController:(OTPTransitTimeViewController *)transitTimeViewController didChooseArrivingOrDepartingIndex:(NSNumber *)arrivingOrDepartingIndex atTime:(NSDate *)time
{
    self.arriveOrDepartByIndex = arrivingOrDepartingIndex;
    self.date = time;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:arrivingOrDepartingIndex.intValue forKey:@"arriveOrDepartByIndex"];
    [defaults synchronize];
}

#pragma mark OTPGeocodeDisambigationViewControllerDelegate methods
- (void)userSelectedPlacemark:(CLPlacemark *)placemark
{
    // Filter out the country
    NSArray *formattedAddressLines = (NSArray *)[placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", placemark.country];
    NSArray *filteredAddressLines = [formattedAddressLines filteredArrayUsingPredicate:predicate];
    
    if([self isSearchNearbyTextField:_textFieldToDisambiguate]) {
        [self addGeocodedPOIAndRenderPOIs:placemark withAddress:[filteredAddressLines componentsJoinedByString:@", "]];
    } else {
        [self updateTextField:_textFieldToDisambiguate withText:[filteredAddressLines componentsJoinedByString:@", "] andLocation:placemark.location];
    }
}

- (void)userCanceledDisambiguation
{
    if([self isSearchNearbyTextField:_textFieldToDisambiguate]) {
        // There could be POIs got from the local server call. So add those.
        if(poiAnnotationsOnMap.count > 0){
            [self renderPOIsOnMap];
        }
    } else {
        [self updateTextField:_textFieldToDisambiguate withText:nil andLocation:nil];
    }
}

#pragma mark RKObjectLoaderDelegate methods

RKResponse* _OTPResponse = nil;

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    if([request.resourcePath hasPrefix:planServicePath]) {
        [TestFlight passCheckpoint:@"DIRECTIONS_RECEIVED_RESPONSE_FROM_API"];
        //NSLog(@"Loaded payload: %@", [response bodyAsString]);
        _OTPResponse = response;
        
        // Save the URL so we can display it in the feedback email if needed.
        OTPAppDelegate *deleage = (OTPAppDelegate *)[[UIApplication sharedApplication] delegate];
        deleage.currentUrlString = request.URL.absoluteString;
        NSLog (@"Testing---:%@", deleage.currentUrlString);
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    [TestFlight passCheckpoint:@"DIRECTIONS_LOADED_PLAN_FROM_API_RESPONSE"];
    //NSLog(@"Loaded plan: %@", objects);
    [HUD hide:YES];
    
    BOOL doPOIGeocoding = NO;
    currentResponse = (Response*)[objects objectAtIndex:0];
    
    if (currentResponse.error != nil) {
        if([currentResponse.error.msg hasPrefix:searchNearbyNoResultsPrefix]) {
            doPOIGeocoding = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:currentResponse.error.msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            return;
        }
    } else if (currentResponse.placeSearchResult != nil) {
        [self preparePOIsToMap:currentResponse.placeSearchResult.places];
        doPOIGeocoding = YES;
    }
    
    if(doPOIGeocoding) {
        [self geocodeStringInTextField:self.searchNearbyText];
        return;
    }
    
    [self performSegueWithIdentifier:@"ExploreItineraries" sender:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    //NSLog(@"Hit error: %@", error);
    [TestFlight passCheckpoint:@"DIRECTIONS_RECEIVED_ERROR_FROM_API"];
    [HUD hide:YES];

    BOOL displayError = NO;
    
    if(_OTPResponse != nil) {
        NSString *OTPError = [_OTPResponse bodyAsString];
        OTPError = [OTPError stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                              
        if([OTPError hasSuffix:@"is out of range"]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"We're not yet able to plan trips across cities. Try a trip completely within your start or ending city." delegate:nil cancelButtonTitle:@"Got It" otherButtonTitles:nil];
            [alert show];
        } else {
            displayError = YES;
        }
    } else {
        displayError = YES;
    }
    
    if(displayError) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // pass itineraries to next view controller
    if ([segue.identifier isEqualToString:@"ExploreItineraries"]) {
        UINavigationController *navController = (UINavigationController*)segue.destinationViewController;
        // If we only have one itinerary, just display it instead of the list of itineraries.
        if (currentResponse.plan.itineraries.count == 1) {
            OTPItineraryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryViewController"];
            vc.itinerary = [currentResponse.plan.itineraries objectAtIndex:0];
            vc.fromTextField = self.fromTextField;
            vc.toTextField = self.toTextField;
            if (self.mapView.showsUserLocation) {
                vc.mapShowedUserLocation = YES;
            } else {
                vc.mapShowedUserLocation = NO;
            }
            [navController setViewControllers:[NSArray arrayWithObject:vc] animated:NO];
            return;
        }
        // Otherwise, display the list of itineraries.
        OTPTransitTimesViewController *vc = (OTPTransitTimesViewController*)navController.topViewController;
        vc.itineraries = currentResponse.plan.itineraries;
        vc.fromTextField = self.fromTextField;
        vc.toTextField = self.toTextField;
        if (self.mapView.showsUserLocation) {
            vc.mapShowedUserLocation = YES;
        } else {
            vc.mapShowedUserLocation = NO;
        }
    } else if ([segue.identifier isEqualToString:@"TransitTimes"]) {
        OTPTransitTimeViewController *vc = (OTPTransitTimeViewController *)segue.destinationViewController;
        vc.delegate = self;
        // If the current date is in the past, update it.
        self.date = [[[NSDate alloc] init] laterDate:self.date];
        vc.date = self.date;
        vc.selectedSegment = self.arriveOrDepartByIndex;
    } else if ([segue.identifier isEqualToString:@"DisambiguateGeocode"]) {
        UINavigationController *vc = (UINavigationController *)segue.destinationViewController;
        ((OTPGeocodeDisambigationViewController *)vc.topViewController).placemarks = _placemarksToDisambiguate;
        ((OTPGeocodeDisambigationViewController *)vc.topViewController).delegate = self;
    }
}

- (void)panMapToCurrentGeocodedTextField
{
    OTPGeocodedTextField *field;
    if (self.fromTextField.isFirstResponder) {
        field = self.fromTextField;
    } else if (self.toTextField.isFirstResponder) {
        field = self.toTextField;
    }
    if (field && field.isGeocoded) {
        CLLocationCoordinate2D adjustedCoord = [self.mapView projectedPointToCoordinate:[self adjustPointForKeyboard:field.location.coordinate]];
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(adjustedCoord.latitude - 0.0085, adjustedCoord.longitude - 0.0085);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(adjustedCoord.latitude + 0.0085, adjustedCoord.longitude + 0.0085);
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
    }
}

- (void)showFromAndToLocations
{
    NSMutableArray *validLocations = [[NSMutableArray alloc] init];
    if (self.fromTextField.location.coordinate.latitude != 0.0 && self.fromTextField.location.coordinate.latitude != 0.0) {
        [validLocations addObject:self.fromTextField.location];
    }
    if (self.toTextField.location.coordinate.latitude != 0.0 && self.toTextField.location.coordinate.latitude != 0.0) {
        [validLocations addObject:self.toTextField.location];
    }
    if (validLocations.count == 0) {
        return;
    }
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(1000, 1000);
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(-1000, -1000);
    for (CLLocation *location in validLocations) {
        sw.latitude = MIN(sw.latitude, location.coordinate.latitude);
        sw.longitude = MIN(sw.longitude, location.coordinate.longitude);
        ne.latitude = MAX(ne.latitude, location.coordinate.latitude);
        ne.longitude = MAX(ne.longitude, location.coordinate.longitude);
    }
    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
}

- (RMProjectedPoint)adjustPointForKeyboard:(CLLocationCoordinate2D)coordinate
{
    RMProjectedPoint projectedLocation = [self.mapView coordinateToProjectedPoint:coordinate];
    
    if (!topOfKeyboard) {
        return projectedLocation;
    }
    
    CGPoint mapCenterScreen = [self.view convertPoint:self.mapView.center toView:nil];
    CGRect mapRectScreen = [self.view convertRect:self.mapView.frame toView:nil];
    CGFloat shift = mapCenterScreen.y - topOfKeyboard.floatValue + ((topOfKeyboard.floatValue - mapRectScreen.origin.y) * 0.4);
    
    projectedLocation.y = projectedLocation.y - shift * self.mapView.metersPerPixel;
    
    return projectedLocation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// A method to convert an enum to string
-(NSString*) transitModeTypeEnumToString:(kTransitModeType)enumVal
{
    return kTransitModeTypeArray[enumVal];
}

// A method to retrieve the int value from the C array of NSStrings
-(kTransitModeType) transitModeTypeStringToEnum:(NSString*)strVal
{
    int retVal=nil;
    for(int i=0; i < sizeof(kTransitModeTypeArray)-1; i++)
    {
        if([(NSString*)kTransitModeTypeArray[i] isEqual:strVal])
        {
            retVal = i;
            break;
        }
    }
    return (kTransitModeType)retVal;
}

- (void)viewDidUnload {
    [self setTimeButton:nil];
    [super viewDidUnload];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case MARKER_TYPE_SELECTION:
            [self handleMarkerTypeSelection:buttonIndex];
            break;
    }
}

- (void)handleMarkerTypeSelection:(NSInteger) buttonIndex {
    OTPGeocodedTextField *textField;
    RMAnnotation *targetAnnotation;
    switch (buttonIndex)
    {
        case 0: // Start here
            textField = self.fromTextField;
            targetAnnotation = _fromAnnotation;
            break;
        case 1: // End here
            textField = self.toTextField;
            targetAnnotation = _toAnnotation;
            break;
        case 2: // Send a tweet
            [self shareATweet];
            return;
            break;
        case 3: // Cancel
            currentLongPressLocation = nil;
            return;
            break;
    }
    
    self.needsShowFromAndToLocations = YES;
    
    if(targetAnnotation != nil) {
        [self.mapView removeAnnotation:targetAnnotation];
        targetAnnotation = nil;
    }
    [self updateTextField:textField withText:@"Dropped Pin" andLocation:currentLongPressLocation];
}

- (void) shareATweet {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"A nice app to find walkable routes #WalkThisWay"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)searchPlace {
    if(![searchNearbyTextDefault isEqualToString:self.searchNearbyText.text]) {
        [self.mapView removeAnnotations:poiAnnotationsOnMap];
        [poiAnnotationsOnMap removeAllObjects];
        [self getNearbyPOIs:self.searchNearbyText.text];
    }
}

- (void) preparePOIsToMap:(NSArray*)places {
    for(PointOfInterest *poi in places) {
        CLLocationCoordinate2D regionCoordinate = CLLocationCoordinate2DMake([poi.latitude doubleValue],
                                                                             [poi.longitude doubleValue]);
        
        RMAnnotation *poiAnnotation = [RMAnnotation annotationWithMapView:self.mapView coordinate:regionCoordinate
                                                                 andTitle:poi.name];
        poiAnnotation.annotationType = OTPPOIAnnotation;
        [poiAnnotationsOnMap addObject:poiAnnotation];
    }
}

- (void) renderPOIsOnMap {
    self.needsShowFromAndToLocations = NO;
    
    if(poiAnnotationsOnMap.count > 0) {
        CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(1000, 1000);
        CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(-1000, -1000);
        for (CLLocation *location in poiAnnotationsOnMap) {
            sw.latitude = MIN(sw.latitude, location.coordinate.latitude);
            sw.longitude = MIN(sw.longitude, location.coordinate.longitude);
            ne.latitude = MAX(ne.latitude, location.coordinate.latitude);
            ne.longitude = MAX(ne.longitude, location.coordinate.longitude);
        }
        [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:YES];
    }
    
    [self.mapView addAnnotations:poiAnnotationsOnMap];
}

- (IBAction)showFromToMarkers:(id)sender {
    [self showFromAndToLocations];
}

- (void) getNearbyPOIs:(NSString*) keyword {
    [self initHUDWithLabel:@"Searching"];
    [HUD show:YES];
    
    CLLocationDistance radius = MAX(MAX(self.mapView.projectedViewSize.height,self.mapView.projectedViewSize.width)/2,minSearchRadius);
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                   @"q", keyword,
                                   @"rad", [NSString stringWithFormat:@"%f",radius],
                                   @"lat", [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.latitude],
                                   @"lng", [NSString stringWithFormat:@"%f",self.mapView.centerCoordinate.longitude],
                                   nil];
    
    NSString* resourcePath = [@"/places/search" stringByAppendingQueryParameters:params];
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (BOOL)isSearchNearbyTextField:(OTPGeocodedTextField*)textField {
    return ([textField isEqual:self.searchNearbyText]);
}

- (void)initHUDWithLabel:(NSString*)label {
    if(HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.dimBackground = NO;
        HUD.removeFromSuperViewOnHide = YES;
    }
    HUD.labelText=label;
    [self.view addSubview:HUD];
}

- (void) addGeocodedPOIAndRenderPOIs:(CLPlacemark *)geocodedPOI withAddress:(NSString *) address {
    if(poiAnnotationsOnMap.count==0){
        [[self searchNearbyText] setText:address andLocation:geocodedPOI.location];
    }
    
    PointOfInterest *poi = [[PointOfInterest alloc] init];
    [poi setName:@"" Latitude:[NSString stringWithFormat:@"%f",geocodedPOI.location.coordinate.latitude] Longitude:[NSString stringWithFormat:@"%f",geocodedPOI.location.coordinate.longitude]];
    [self preparePOIsToMap:[[NSArray alloc] initWithObjects:poi, nil]];
    
    [self renderPOIsOnMap];
}

- (void) showFromToButtonEnabled:(BOOL) enabled {
    UIImage *img;
    UIControlState state;
    if(enabled) {
        img = _showFromToEnabledImage;
        state = UIControlStateNormal;
    } else {
        img = _showFromToDisabledImage;
        state = UIControlStateDisabled;
    }
    
    [self.showFromToButton setImage:img forState:state];
    self.showFromToButton.enabled = enabled;
}


//by Chandra



- (IBAction)buttonClicked:(id)sender{
    
    if (count <1){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [_dropdownView setBackgroundColor:[UIColor whiteColor]];
        _dropdownView.alpha =0;
        [UIView commitAnimations];
        count += 1;
    }
    
    
    if (_dropdownView.alpha ==0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [_dropdownView setBackgroundColor:[UIColor colorWithRed:(0/255.0) green:(150/255.0) blue:(255/255.0) alpha:1]];
        _dropdownView.alpha =0.9;
        [UIView commitAnimations];
        
        
    } else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [_dropdownView setBackgroundColor:[UIColor whiteColor]];
        _dropdownView.alpha =0;
        [UIView commitAnimations];
        
    }
    
    
    
    
}

//ends


@end