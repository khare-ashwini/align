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
@synthesize trafficButton, greeneryButton, slopeButton, crimeButton, accessibilityButton, residentialButton, sidewalkButton, intersectionsButton, landvariationsButton;

NSInteger traffic = 0;
NSInteger slope = 0;
NSInteger crime = 0;
NSInteger accessibility = 0;
NSInteger residential = 0;
NSInteger business = 0;
NSInteger greenery = 0;
NSInteger sidewalk = 0;
NSInteger intersections = 0;
NSInteger landvariations = 0;


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
    [super viewDidLoad];
    
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
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
    // Do any additional setup after loading the view.
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
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.allParameterView.hidden = NO;
            self.myParameterView.hidden = YES;
            break;
        case 1:
            self.allParameterView.hidden = YES;
            self.myParameterView.hidden = NO;
            break;
        default:
            break;
    }
    
}

- (IBAction)traffic:(id)sender {
    
    UIAlertView *trafficPopup = [[UIAlertView alloc] initWithTitle:@"Traffic!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    trafficPopup.tag = 1;
    
    [trafficPopup show];
    
}

- (IBAction)greenery:(id)sender {
    
    UIAlertView *greeneryPopup = [[UIAlertView alloc] initWithTitle:@"Greenery!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    greeneryPopup.tag = 2;
    [greeneryPopup show];
}


- (IBAction)crime:(id)sender {
    
    UIAlertView *crimePopup = [[UIAlertView alloc] initWithTitle:@"Crime!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    crimePopup.tag = 3;
    [crimePopup show];
}


- (IBAction)sidewalk:(id)sender {
    
    UIAlertView *sidewalkPopup = [[UIAlertView alloc] initWithTitle:@"Sidewalk!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    sidewalkPopup.tag = 4;
    [sidewalkPopup show];
}

- (IBAction)Slope:(id)sender {
    
    UIAlertView *slopePopup = [[UIAlertView alloc] initWithTitle:@"Slope!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    slopePopup.tag = 5;
    [slopePopup show];
}


- (IBAction)residentialDensity:(id)sender {
    
    UIAlertView *residentialPopup = [[UIAlertView alloc] initWithTitle:@"Residential Density!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    residentialPopup.tag = 6;
    [residentialPopup show];
}


- (IBAction)businessDensity:(id)sender {
    
    UIAlertView *businessPopup = [[UIAlertView alloc] initWithTitle:@"Business Density!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    businessPopup.tag =7;
    [businessPopup show];
}


- (IBAction)accessibility:(id)sender {
    
    
    UIAlertView *accessibilityPopup = [[UIAlertView alloc] initWithTitle:@"Accessibility!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    accessibilityPopup.tag = 8;
    [accessibilityPopup show];
}




- (IBAction)intersections:(id)sender {
    
    UIAlertView *intersectionsPopup = [[UIAlertView alloc] initWithTitle:@"Intersections!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    intersectionsPopup.tag = 9;
    [intersectionsPopup show];
}




- (IBAction)landVariables:(id)sender {
    
    UIAlertView *landvariationsPopup = [[UIAlertView alloc] initWithTitle:@"Landvariations!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    landvariationsPopup.tag = 10;
    [landvariationsPopup show];
}


- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1){
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"TRAFFIC!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            traffic = 5;
               [self.trafficButton setTitle:@"Traffic E!" forState:UIControlStateNormal];
        } else if (buttonIndex == 3){
            traffic = 2;
            [self.trafficButton setTitle:@"Traffic S!" forState:UIControlStateNormal];
            
        }
    } else if (alertView.tag == 2){
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"GREENERY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            greenery = 5;
            [self.greeneryButton setTitle:@"Greenery E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            greenery = 2;
            [self.greeneryButton setTitle:@"Greenery S!" forState:UIControlStateNormal];
        }
    }else if (alertView.tag == 3){
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"CRIME!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            crime = 5;
            [self.crimeButton setTitle:@"Crime E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            crime = 2;
            [self.crimeButton setTitle:@"Crime S!" forState:UIControlStateNormal];
            
        }
    }else if (alertView.tag == 4){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SIDEWALK!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            sidewalk = 5;
            [self.sidewalkButton setTitle:@"Sidewalk E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            sidewalk = 2;
            [self.sidewalkButton setTitle:@"Sidewalk S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 5){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SLOPE!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            slope = 5;
            [self.slopeButton setTitle:@"Slope E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            slope = 2;
            [self.slopeButton setTitle:@"Slope S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 6){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"RESIDENTIAL DENSITY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            residential = 5;
            [self.residentialButton setTitle:@"Residential Density E!" forState:UIControlStateNormal];
            
            
        } else if (buttonIndex == 3){
            residential = 2;
            [self.residentialButton setTitle:@"Residential Density S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 7){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"BUSINESS DENSITY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            business = 5;
            [self.businessButton setTitle:@"Business Density E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            business = 2;
            [self.businessButton setTitle:@"Business Density S!" forState:UIControlStateNormal];
            
        }
        
    } else if (alertView.tag == 8){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"ACCESSIBILITY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            accessibility = 5;
            [self.accessibilityButton setTitle:@"Accessibility E!" forState:UIControlStateNormal];
    
        } else if (buttonIndex == 3){
            accessibility = 2;
            [self.accessibilityButton setTitle:@"Accessibility S!" forState:UIControlStateNormal];
            
        }
        
    } else if (alertView.tag == 9){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"INTERSECTIONS!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            intersections = 5;
            [self.intersectionsButton setTitle:@"Intersections E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            intersections = 2;
            [self.intersectionsButton setTitle:@"Intersections S!" forState:UIControlStateNormal];
            
        }
        
    }else if (alertView.tag == 10){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"LAND VARIATIONS!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            landvariations = 5;
            [self.landvariationsButton setTitle:@"Land Variations E!" forState:UIControlStateNormal];
            
        } else if (buttonIndex == 3){
            landvariations = 2;
            [self.landvariationsButton setTitle:@"Land Variations S!" forState:UIControlStateNormal];
            
        }
        
    }
    
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
