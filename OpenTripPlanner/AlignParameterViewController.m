//
//  AlignParameterViewController.m
//  Chandra_Align
//
//  Created by Chandra Khatri on 9/28/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "AlignParameterViewController.h"
#import "WalkableParameter.h"
#import "CMPopTipView.h"

#define Tag_traffic = 1
#define Tag_greenery = 2
#define Tag_crime = 3
#define Tag_sidewalk = 4
#define Tag_slope = 5
#define Tag_residential = 6
#define Tag_business = 7
#define Tag_accessibility = 8
#define Tag_intersections = 9
#define Tag_landvariations = 10


@interface AlignParameterViewController ()

@end

@implementation AlignParameterViewController

@synthesize allParameterView, myParameterView;
@synthesize segmentedControl;

// Synthesize buttons
@synthesize trafficButton, greeneryButton, slopeButton,
            crimeButton, accessibilityButton, residentialButton,
            sidewalkButton, intersectionsButton, landvariationsButton,
            bottomBar;

// @review - Instance variables?
NSInteger traffic = 0;
NSInteger greenery = 0;
NSInteger crime = 0;
NSInteger sidewalk = 0;
NSInteger slope = 0;
NSInteger residential = 0;
NSInteger business = 0;
NSInteger accessibility = 0;
NSInteger intersections = 0;
NSInteger landvariations = 0;

NSInteger info_count = 0;
NSInteger count_essential = 1;


NSInteger parameter_array[10] = {0,0,0,0,0,0,0,0,0,0};

NSString  *parameter_names[10]={ @"Traffic",
                                 @"Greenery",
                                 @"Crime",
                                 @"Sidewalk",
                                 @"Slope",
                                 @"Residential",
                                 @"Business",
                                 @"Accessibility",
                                 @"Intersections",
                                 @"Landvariations"};

NSString *parameter_images[10]={@"pa_traffic_unclick-1.png",
                                @"pa_Greenery_unclick-1.png",
                                @"pa_Crime_unclick-1.png",
                                @"pa_Sidewalk_unclick-1.png",
                                @"pa_Slope_unclick-1.png",
                                @"pa_Residential_Density_unclick-1.png",
                                @"pa_Business_Density_unclick-1.png",
                                @"pa_Business_Density_unclick-1.png",
                                @"pa_Intersections_unclick-1.png",
                                @"pa_LandVariation_unclick-1.png"};

NSString  *parameter_primary_images[10]={@"pa_traffic_click_E-1.png",
                                         @"pa_Greenery_click_E-1.png",
                                         @"pa_Crime_click_E-1.png",
                                         @"pa_Sidewalk_click_E-1.png",
                                         @"pa_Slope_click_E-1.png",
                                         @"pa_Residential_Density_click_E-1.png",
                                         @"pa_Business_Density_click_E-1.png",
                                         @"pa_Business_Density_click_E-1.png",
                                         @"pa_Intersections_E-1.png",
                                         @"pa_LandVariation_click_E-1.png"};

NSString  *parameter_secondary_images[10]={@"pa_traffic_click_S-1.png",
                                           @"pa_Greenery_click_S-1.png",
                                           @"pa_Crime_click_S-1.png",
                                           @"pa_Sidewalk_click_S-1.png",
                                           @"pa_Slope_click_S-1.png",
                                           @"pa_Residential_Density_click_S-1.png",
                                           @"pa_Business_Density_click_S-1.png",
                                           @"pa_Business_Density_click_S-1.png",
                                           @"pa_Intersections_click_S-1.png",
                                           @"pa_LandVariation_click_S-1.png"};


//parameter_buttons = [NSArray arrayWithObjects:UIbutton traffic_button,UIButton greenery_button,UIButton crime_button,nil];

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    
    //UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:scrollView];
    //[scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*2)];
    [super viewDidLoad];
    
    WalkableParameter *wp = [WalkableParameter params];
    wp.traffic = traffic;
    wp.greenery = greenery;
    wp.crime = crime;
    wp.sidewalk = sidewalk;
    wp.slope = slope;
    wp.resiDensity = residential;
    wp.busiDensity = business;
    wp.accessibility = accessibility;
    wp.intersection = intersections;
    wp.landVariation = landvariations;
    
    
    if (info_count < 1){
        UIAlertView *intro = [[UIAlertView alloc] initWithTitle:@"Information"
                                                  message:@"You can set upto 5 essential parameters"
                                                  delegate:self
                                                  cancelButtonTitle:@"Ok, Got it."
                                                  otherButtonTitles: nil];
        
        intro.tag = 1;
        [intro show];
    // Review - Set Flag Instead?
        info_count = info_count + 1;
    }
    
    
   // UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 450)];
    
    //[self.view addSubview:scrollView];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)parameterSegment:(UISegmentedControl *)sender {
    
    NSMutableArray *buttons_primary = [[NSMutableArray alloc] init];
    NSMutableArray *buttons_secondary = [[NSMutableArray alloc] init];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    int count = 0;
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.allParameterView.hidden = NO;
            self.myParameterView.hidden = YES;
            
            /*
            for (UIView* subV in self.myParameterView) {
                if ([subV isKindOfClass:[UIButton class]])
                    [subV removeFromSuperview];
            }
            */
            
            
            for (UIView *btn in buttons_primary){
                [btn removeFromSuperview];
            }
            for (UIView *btn in buttons_secondary){
                [btn removeFromSuperview];
            }
            
            for (UIView *lbl in labels){
                [lbl removeFromSuperview];
            }
            
            
            [buttons_primary makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [buttons_primary removeAllObjects];
            [buttons_secondary makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [buttons_secondary removeAllObjects];
            [labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [labels removeAllObjects];
            
            /*
            for (int i = 0 ; i < count; i++){
                [(UIButton*)[self.myParameterView viewWithTag:i]  removeFromSuperview];
            }
            count = 0;
            */
            
            break;
            
        }
        case 1:
        {
            self.allParameterView.hidden = YES;
            self.myParameterView.hidden = NO;
            
            for (UIView *btn in buttons_primary){
                [btn removeFromSuperview];
            }
            for (UIView *btn in buttons_secondary){
                [btn removeFromSuperview];
            }
            
            for (UIView *lbl in labels){
                [lbl removeFromSuperview];
            }
            
            [buttons_primary makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [buttons_primary removeAllObjects];
            [buttons_secondary makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [buttons_secondary removeAllObjects];
            [labels makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [labels removeAllObjects];
            
            
             for (int i = 0 ; i < count; i++){
                 [(UIButton*)[self.myParameterView viewWithTag:i]  removeFromSuperview];
             }
             count = 0;
            
            
            for (UIView *view in self.view.subviews)
            {
                if ([view isMemberOfClass:[UIButton class]])
                {
                    [(UIButton *)view removeFromSuperview];
                }
            }
            
            
            NSInteger x = 80;
            NSInteger y = 50;
            NSInteger height = 42;
            NSInteger width = 157;
            //NSMutableArray *buttons_primary = [[NSMutableArray alloc] init];
            //NSMutableArray *buttons_secondary = [[NSMutableArray alloc] init];
            NSInteger essential_state = 0;
            NSInteger secondary_state = 0;
            
            for (NSInteger i=0; i<10; i++){
                
                if (parameter_array[i] == 2){
                    essential_state = 1;
                }
                if(parameter_array[i] == 1){
                    secondary_state = 1;
                }
            }
            
            for (NSInteger i = 0; i < 10; i++){
                if (parameter_array[i] == 2){
                    //NSString *title = parameter_names[i];
                    
                    NSString *image_name = parameter_primary_images[i];
                    
                    UIButton *button = [[UIButton alloc]init];
                    
                    //button.frame = CGRectMake(x,y, width, height);
                    //[button setTitle:title forState:UIControlStateNormal];
                
                    //[[button layer] setCornerRadius:8.0f];
                    
                    //[[button layer] setMasksToBounds:YES];
                    //[button setBackgroundColor:[UIColor blueColor]];
                    [button setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    //[[button layer] setBorderWidth:1.0f];
                    
                    //[self.myParameterView addSubview:button];
                    
                    button.tag = count;
                    count += 1;
                    
                    [buttons_primary addObject:button];
                    
                    //y= y+35;
                    
                } else if (parameter_array[i] == 1){
                    
                    //NSString *title = parameter_names[i];
                    NSString *image_name = parameter_secondary_images[i];
                    UIButton *button = [[UIButton alloc]init];
                    
                    //button.frame = CGRectMake(x,y, width, height);
                    //[button setTitle:title forState:UIControlStateNormal];
                    [button setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    button.tag = count;
                    count += 1;
                    
                    [buttons_secondary addObject:button];
                }
            }
            
            if (essential_state == 1){
                
                NSLog(@"Primary label., %i", y);
                UILabel *essential_label = [[UILabel alloc] initWithFrame:CGRectMake(70,y, 200,40)];
                //[[essential_label layer] set];
                essential_label.textColor = [UIColor whiteColor];
                essential_label.text = @"Essential Parameters";
                [labels addObject:essential_label];
                //essential_label.textAlignment = NSTextAlignmentCenter;
                
                //essential_label.tag = count;
                //count = count +1;
                
                [self.myParameterView addSubview:essential_label];
                
                //Review look at constants
                y += 35;
            }
            
            for (UIButton *button in buttons_primary){
                NSLog(@"button %i", y);
                button.frame = CGRectMake(x,y, width, height);
                //[button setTitle:title forState:UIControlStateNormal];
                //[[button layer] setCornerRadius:8.0f];
                
                [[button layer] setMasksToBounds:YES];
                //[button setBackgroundColor:[UIColor blueColor]];
                //[button setImage:[UIImage imageNamed:@"crime2.png"] forState:UIControlStateNormal];
                //[[button layer] setBorderWidth:1.0f];
                
                [self.myParameterView addSubview:button];
                
                y += 42;
            }
            
            if (secondary_state == 1){
                NSLog(@"secondary %i", y);
                UILabel *secondary_label = [[UILabel alloc] initWithFrame:CGRectMake(70,y, 200,40)];
                //[[essential_label layer] set];
                secondary_label.textColor = [UIColor whiteColor];
                secondary_label.text = @"Secondary Parameters";
                
                //secondary_label.textAlignment = NSTextAlignmentCenter;
                [labels addObject:secondary_label];
                
                //secondary_label.tag = count;
                //count = count +1;
                
                [self.myParameterView addSubview:secondary_label];
                
                y += 35;
            }
            
            for (UIButton *button in buttons_secondary){
                
                NSLog(@"button %i", y);
                
                button.frame = CGRectMake(x,y, width, height);
                //[button setTitle:title forState:UIControlStateNormal];
                //[[button layer] setCornerRadius:8.0f];
                
                [[button layer] setMasksToBounds:YES];
                //[button setBackgroundColor:[UIColor blueColor]];
                //[[button layer] setBorderWidth:1.0f];
                
                [self.myParameterView addSubview:button];
                
                y += 42;
            }
            
            break;
        }
        default:
            break;
    }
    
}

// Review - Add Template Method

- (IBAction)traffic:(id)sender {
    
    UIAlertView *trafficPopup = [[UIAlertView alloc] initWithTitle:@"Traffic"
                                                     message:@"" delegate:self
                                                     cancelButtonTitle:@"No Preference"
                                                     otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    trafficPopup.tag = 1;
    [trafficPopup show];
    
}

- (IBAction)greenery:(id)sender {
    
    UIAlertView *greeneryPopup = [[UIAlertView alloc] initWithTitle:@"Greenery"
                                                      message:@""
                                                      delegate:self
                                                      cancelButtonTitle:@"No Preference"
                                                      otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    greeneryPopup.tag = 2;
    [greeneryPopup show];
}


- (IBAction)crime:(id)sender {
    
    UIAlertView *crimePopup = [[UIAlertView alloc] initWithTitle:@"Crime"
                                                   message:@""
                                                   delegate:self
                                                   cancelButtonTitle:@"No Preference"
                                                   otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    crimePopup.tag = 3;
    [crimePopup show];
}


- (IBAction)sidewalk:(id)sender {
    
    UIAlertView *sidewalkPopup = [[UIAlertView alloc] initWithTitle:@"Sidewalk"
                                                      message:@""
                                                      delegate:self
                                                      cancelButtonTitle:@"No Preference"
                                                      otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    sidewalkPopup.tag = 4;
    [sidewalkPopup show];
}

- (IBAction)Slope:(id)sender {
    
    UIAlertView *slopePopup = [[UIAlertView alloc] initWithTitle:@"Slope"
                                                   message:@""
                                                   delegate:self
                                                   cancelButtonTitle:@"No Preference"
                                                   otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    slopePopup.tag = 5;
    [slopePopup show];
}


- (IBAction)residentialDensity:(id)sender {
    
    UIAlertView *residentialPopup = [[UIAlertView alloc] initWithTitle:@"Residential Density"
                                                         message:@""
                                                         delegate:self
                                                         cancelButtonTitle:@"No Preference"
                                                         otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    residentialPopup.tag = 6;
    [residentialPopup show];
}


- (IBAction)businessDensity:(id)sender {
    
    UIAlertView *businessPopup = [[UIAlertView alloc] initWithTitle:@"Business Density"
                                                      message:@""
                                                      delegate:self
                                                      cancelButtonTitle:@"No Preference"
                                                      otherButtonTitles:@"Information",@"Set as essential", @"Set as secondary", nil];
    
    businessPopup.tag = 7;
    [businessPopup show];
}


- (IBAction)accessibility:(id)sender {
    
    
    UIAlertView *accessibilityPopup = [[UIAlertView alloc] initWithTitle:@"Accessibility!"
                                                           message:@""
                                                           delegate:self
                                                           cancelButtonTitle:@"No Preference"
                                                           otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    accessibilityPopup.tag = 8;
    [accessibilityPopup show];
}


- (IBAction)intersections:(id)sender {
    
    UIAlertView *intersectionsPopup = [[UIAlertView alloc] initWithTitle:@"Intersections!"
                                                           message:@""
                                                           delegate:self
                                                           cancelButtonTitle:@"No Preference"
                                                           otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    intersectionsPopup.tag = 9;
    [intersectionsPopup show];
}


- (IBAction)landVariables:(id)sender {
    
    UIAlertView *landvariationsPopup = [[UIAlertView alloc] initWithTitle:@"Landvariations!"
                                                            message:@""
                                                            delegate:self
                                                            cancelButtonTitle:@"No Preference"
                                                            otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    landvariationsPopup.tag = 10;
    [landvariationsPopup show];
}
/*
 overMaximumEssentialAlert
 Displays pop-up when no. of esssential parameters > UPPER_BOUND(=5)
 */

-(void) overMaximumEssentialAlert{
    UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                  message:@"Maximum number of essential parameters allowed is 5"
                                                  delegate:self cancelButtonTitle:@"Ok, Got it"
                                                  otherButtonTitles: nil];
    [infoAlert show];
}

/*
 alertView: clickButtonAtIndex:
 Handles - 
 1. Setting essential / parameter, along with substituting the images
 2. Display another alertView for more traffic information
 3. Check for upper count of number of parameters
*/
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 1){
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"TRAFFIC"
                                                                     message:@"This parameter indicates the real-time traffic on roads"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Done"
                                                           otherButtonTitles: nil];
                [alertView2 show];
                
            } else if (buttonIndex == 2){
                
                if (count_essential < 6){
                    count_essential += 1;
                    // Review - why is this being set to 5
                    traffic = 5;
                    parameter_array[0] = 2;
                    //[self.trafficButton setTitle:@"Traffic E!" forState:UIControlStateNormal];
                    NSString *image_name = parameter_primary_images[0];
                    [self.trafficButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                // Review - why is being set to2
                traffic = 2;
                parameter_array[0] = 1;
                NSString *image_name = parameter_secondary_images[0];
                [self.trafficButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.trafficButton setTitle:@"Traffic S!" forState:UIControlStateNormal];
                
            }
            break;
            
        case 2:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"GREENERY"
                                                               message:@"This parameter indicates the greenery on the way."
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential = count_essential +1;
                    greenery = 5;
                    parameter_array[1] = 2;
                    //[self.greeneryButton setTitle:@"Greenery E!" forState:UIControlStateNormal];
                    NSString *image_name = parameter_primary_images[1];
                    [self.greeneryButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                greenery = 2;
                parameter_array[1] = 1;
                NSString *image_name = parameter_secondary_images[1];
                [self.greeneryButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                
                //[self.greeneryButton setTitle:@"Greenery S!" forState:UIControlStateNormal];
            }
            break;
            
        case 3:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"CRIME"
                                                               message:@"This parameter indicates the level of crime on the routes."
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential += 1;
                    crime = 5;
                    parameter_array[2] = 2;
                    NSString *image_name = parameter_primary_images[2];
                    [self.crimeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.crimeButton setTitle:@"Crime E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                crime = 2;
                parameter_array[2] = 1;
                NSString *image_name = parameter_secondary_images[2];
                [self.crimeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.crimeButton setTitle:@"Crime S!" forState:UIControlStateNormal];
                
            }
            break;
        
        case 4:
            if (buttonIndex == 1){
                
    
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SIDEWALK"
                                                               message:@"This parameter indicates the importance to sidewalks."
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential += 1;
                    sidewalk = 5;
                    parameter_array[3] = 2;
                    NSString *image_name = parameter_primary_images[3];
                    [self.sidewalkButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.sidewalkButton setTitle:@"Sidewalk E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                sidewalk = 2;
                parameter_array[3] = 1;
                NSString *image_name = parameter_secondary_images[3];
                [self.sidewalkButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.sidewalkButton setTitle:@"Sidewalk S!" forState:UIControlStateNormal];
                
            }
            break;
            
        case 5:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SLOPE"
                                                               message:@"This parameter indicates the slope of the road. Can be useful for people on wheelchair."
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential = count_essential +1;
                    slope = 5;
                    parameter_array[4] = 2;
                    NSString *image_name = parameter_primary_images[4];
                    [self.slopeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.slopeButton setTitle:@"Slope E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                slope = 2;
                parameter_array[4] = 1;
                NSString *image_name = parameter_secondary_images[4];
                [self.slopeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.slopeButton setTitle:@"Slope S!" forState:UIControlStateNormal];
                
            }
            break;
            
        case 6:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"RESIDENTIAL DENSITY"
                                                               message:@"This parameter indicates the residential density of the routes."
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                
                if (count_essential < 6){
                    count_essential = count_essential +1;
                    residential = 5;
                    parameter_array[5] = 2;
                    NSString *image_name = parameter_primary_images[5];
                    [self.residentialButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.residentialButton setTitle:@"Residential Density E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                
                residential = 2;
                parameter_array[5] = 1;
                NSString *image_name = parameter_secondary_images[5];
                [self.residentialButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.residentialButton setTitle:@"Residential Density S!" forState:UIControlStateNormal];
            }
            break;
            
        case 7:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"BUSINESS DENSITY"
                                                               message:@"This parameter indicates the business density of the routes"
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential = count_essential +1;
                    business = 5;
                    parameter_array[6] = 2;
                    NSString *image_name = parameter_primary_images[6];
                    [self.businessButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.businessButton setTitle:@"Business Density E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                business = 2;
                parameter_array[6] = 1;
                NSString *image_name = parameter_secondary_images[6];
                [self.businessButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.businessButton setTitle:@"Business Density S!" forState:UIControlStateNormal];
                
            }
            break;
            
        case 8:
            if (buttonIndex == 1){
                
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"ACCESSIBILITY"
                                                               message:@"This parameter indicates the level of accessibility on the roads."
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential += 1;
                    accessibility = 5;
                    parameter_array[7] = 2;
                    NSString *image_name = parameter_primary_images[7];
                    [self.accessibilityButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.accessibilityButton setTitle:@"Accessibility E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                accessibility = 2;
                parameter_array[7] = 1;
                NSString *image_name = parameter_secondary_images[7];
                [self.accessibilityButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.accessibilityButton setTitle:@"Accessibility S!" forState:UIControlStateNormal];
                
            }
            break;
            
        case 9:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"INTERSECTIONS"
                                                               message:@"This parameter indicates the importance to intersections"
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential = count_essential +1;
                    intersections = 5;
                    parameter_array[8] = 2;
                    NSString *image_name = parameter_primary_images[8];
                    [self.intersectionsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.intersectionsButton setTitle:@"Intersections E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                intersections = 2;
                parameter_array[8] = 1;
                NSString *image_name = parameter_secondary_images[8];
                [self.intersectionsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.intersectionsButton setTitle:@"Intersections S!" forState:UIControlStateNormal];
                
            }
            break;
            
        case 10:
            if (buttonIndex == 1){
                
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"LAND VARIATIONS"
                                                               message:@"This parameter indicates the light environment along your walk. It may influence your walk in night"
                                                               delegate:self
                                                               cancelButtonTitle:@"Done"
                                                               otherButtonTitles: nil];
                [alertView2 show];
                
                
            } else if (buttonIndex == 2){
                if (count_essential < 6){
                    count_essential = count_essential +1;
                    landvariations = 5;
                    parameter_array[9] = 2;
                    NSString *image_name = parameter_primary_images[9];
                    [self.landvariationsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                    
                    //[self.landvariationsButton setTitle:@"Land Variations E!" forState:UIControlStateNormal];
                }
                else{
                    [self overMaximumEssentialAlert];
                }
                
            } else if (buttonIndex == 3){
                landvariations = 2;
                parameter_array[9] = 1;
                NSString *image_name = parameter_secondary_images[9];
                [self.landvariationsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.landvariationsButton setTitle:@"Land Variations S!" forState:UIControlStateNormal];
                
            }
            break;
            
            
        default:
            break;
    }
    /*
    if (alertView.tag == 1){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"TRAFFIC"
                                                           message:@"This parameter indicates the real-time traffic on roads"
                                                           delegate:self
                                                           cancelButtonTitle:@"Done"
                                                           otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            
            if (count_essential < 6){
                count_essential += 1;
                // Review - why is this being set to 5
                traffic = 5;
                parameter_array[0] = 2;
                //[self.trafficButton setTitle:@"Traffic E!" forState:UIControlStateNormal];
                NSString *image_name = parameter_primary_images[0];
                [self.trafficButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            }
            else{
                [self overMaximumEssentialAlert];
            }
            
        } else if (buttonIndex == 3){
            // Review - why is being set to2 
            traffic = 2;
            parameter_array[0] = 1;
            NSString *image_name = parameter_secondary_images[0];
            [self.trafficButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.trafficButton setTitle:@"Traffic S!" forState:UIControlStateNormal];
            
        }
    } else if (alertView.tag == 2){
        if (buttonIndex == 1){
            
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"GREENERY" message:@"This parameter indicates the greenery on the way." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
        
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                greenery = 5;
                parameter_array[1] = 2;
                //[self.greeneryButton setTitle:@"Greenery E!" forState:UIControlStateNormal];
                NSString *image_name = parameter_primary_images[1];
                [self.greeneryButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            greenery = 2;
            parameter_array[1] = 1;
            NSString *image_name = parameter_secondary_images[1];
            [self.greeneryButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            
            //[self.greeneryButton setTitle:@"Greenery S!" forState:UIControlStateNormal];
        }
    }else if (alertView.tag == 3){
        if (buttonIndex == 1){
            
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"CRIME" message:@"This parameter indicates the level of crime on the routes." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                crime = 5;
                parameter_array[2] = 2;
                NSString *image_name = parameter_primary_images[2];
                [self.crimeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.crimeButton setTitle:@"Crime E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            crime = 2;
            parameter_array[2] = 1;
            NSString *image_name = parameter_secondary_images[2];
            [self.crimeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.crimeButton setTitle:@"Crime S!" forState:UIControlStateNormal];
            
        }
    }else if (alertView.tag == 4){
        
        if (buttonIndex == 1){
            
            
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SIDEWALK" message:@"This parameter indicates the importance to sidewalks." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
                
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                sidewalk = 5;
                parameter_array[3] = 2;
                NSString *image_name = parameter_primary_images[3];
                [self.sidewalkButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.sidewalkButton setTitle:@"Sidewalk E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            sidewalk = 2;
            parameter_array[3] = 1;
            NSString *image_name = parameter_secondary_images[3];
            [self.sidewalkButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.sidewalkButton setTitle:@"Sidewalk S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 5){
        
        if (buttonIndex == 1){
            
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SLOPE" message:@"This parameter indicates the slope of the road. Can be useful for people on wheelchair." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                slope = 5;
                parameter_array[4] = 2;
                NSString *image_name = parameter_primary_images[4];
                [self.slopeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.slopeButton setTitle:@"Slope E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            slope = 2;
            parameter_array[4] = 1;
            NSString *image_name = parameter_secondary_images[4];
            [self.slopeButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.slopeButton setTitle:@"Slope S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 6){
        
        if (buttonIndex == 1){
            
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"RESIDENTIAL DENSITY" message:@"This parameter indicates the residential density of the routes." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                residential = 5;
                parameter_array[5] = 2;
                NSString *image_name = parameter_primary_images[5];
                [self.residentialButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.residentialButton setTitle:@"Residential Density E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            
            residential = 2;
            parameter_array[5] = 1;
            NSString *image_name = parameter_secondary_images[5];
            [self.residentialButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.residentialButton setTitle:@"Residential Density S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 7){
        
        if (buttonIndex == 1){
            
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"BUSINESS DENSITY" message:@"This parameter indicates the business density of the routes" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
                [alertView2 show];
            
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                business = 5;
                parameter_array[6] = 2;
                NSString *image_name = parameter_primary_images[6];
                [self.businessButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.businessButton setTitle:@"Business Density E!" forState:UIControlStateNormal];
            }
            else{
                
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            business = 2;
            parameter_array[6] = 1;
            NSString *image_name = parameter_secondary_images[6];
            [self.businessButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.businessButton setTitle:@"Business Density S!" forState:UIControlStateNormal];
            
        }
        
    } else if (alertView.tag == 8){
        
        if (buttonIndex == 1){
            
            
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"ACCESSIBILITY" message:@"This parameter indicates the level of accessibility on the roads." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
                [alertView2 show];
            
        
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                accessibility = 5;
                parameter_array[7] = 2;
                NSString *image_name = parameter_primary_images[7];
                [self.accessibilityButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.accessibilityButton setTitle:@"Accessibility E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
    
        } else if (buttonIndex == 3){
            accessibility = 2;
            parameter_array[7] = 1;
            NSString *image_name = parameter_secondary_images[7];
            [self.accessibilityButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.accessibilityButton setTitle:@"Accessibility S!" forState:UIControlStateNormal];
            
        }
        
    } else if (alertView.tag == 9){
        
        if (buttonIndex == 1){
            
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"INTERSECTIONS" message:@"This parameter indicates the importance to intersections" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
                [alertView2 show];
            
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                intersections = 5;
                parameter_array[8] = 2;
                NSString *image_name = parameter_primary_images[8];
                [self.intersectionsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.intersectionsButton setTitle:@"Intersections E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            intersections = 2;
            parameter_array[8] = 1;
            NSString *image_name = parameter_secondary_images[8];
            [self.intersectionsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.intersectionsButton setTitle:@"Intersections S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 10){
        
        if (buttonIndex == 1){
            
                UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"LAND VARIATIONS" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
                [alertView2 show];
            
            
        } else if (buttonIndex == 2){
            if (count_essential < 6){
                count_essential = count_essential +1;
                landvariations = 5;
                parameter_array[9] = 2;
                NSString *image_name = parameter_primary_images[9];
                [self.landvariationsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
                
                //[self.landvariationsButton setTitle:@"Land Variations E!" forState:UIControlStateNormal];
            }
            else{
                UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Maximum number of essential parameters allowed is 5" delegate:self cancelButtonTitle:@"Ok, Got it" otherButtonTitles: nil];
                [infoAlert show];
            }
            
        } else if (buttonIndex == 3){
            landvariations = 2;
            parameter_array[9] = 1;
            NSString *image_name = parameter_secondary_images[9];
            [self.landvariationsButton setImage:[UIImage imageNamed:image_name] forState:UIControlStateNormal];
            
            //[self.landvariationsButton setTitle:@"Land Variations S!" forState:UIControlStateNormal];
            
        }
        
    }
     */
    
}


- (IBAction)done:(id)sender {
    
    WalkableParameter *wp = [WalkableParameter params];
    wp.traffic = traffic;
    wp.greenery = greenery;
    wp.crime = crime;
    wp.sidewalk = sidewalk;
    wp.resiDensity = residential;
    wp.busiDensity = business;
    wp.accessibility = accessibility;
    wp.intersection = intersections;
    wp.slope = slope;
    wp.landVariation = landvariations;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
