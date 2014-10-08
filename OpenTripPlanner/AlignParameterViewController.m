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

NSInteger temp_traffic = 0;
NSInteger temp_slope = 0;
NSInteger temp_crime = 0;
NSInteger temp_accessibility = 0;
NSInteger temp_residential = 0;
NSInteger temp_business = 0;
NSInteger temp_greenery = 0;
NSInteger temp_sidewalk = 0;
NSInteger temp_intersections = 0;
NSInteger temp_landvariations = 0;

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
    if (temp_traffic ==1){
        
        [sender setTitle:@"Traffic E!" forState:UIControlStateNormal];
        temp_traffic = 0;
    }else if (temp_traffic==2){
        
        [sender setTitle:@"Traffic S!" forState:UIControlStateNormal];
        temp_traffic = 0;
    }
    UIAlertView *trafficPopup = [[UIAlertView alloc] initWithTitle:@"Traffic!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    trafficPopup.tag = 1;
    
    [trafficPopup show];
    
}

- (IBAction)greenery:(id)sender {
    
    if (temp_greenery ==1){
        [sender setTitle:@"Greenery E!" forState:UIControlStateNormal];
        temp_greenery = 0;
        
    }else if (temp_greenery == 2){
        [sender setTitle:@"Greenery S!" forState:UIControlStateNormal];
        temp_greenery = 0;
        
    }
    UIAlertView *greeneryPopup = [[UIAlertView alloc] initWithTitle:@"Greenery!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    greeneryPopup.tag = 2;
    [greeneryPopup show];
}


- (IBAction)crime:(id)sender {
    
    if (temp_crime ==1){
        [sender setTitle:@"Crime E!" forState:UIControlStateNormal];
        temp_crime = 0;
    }else if (temp_crime ==2){
        [sender setTitle:@"Crime S!" forState:UIControlStateNormal];
        temp_crime = 0;
    }
    UIAlertView *crimePopup = [[UIAlertView alloc] initWithTitle:@"Crime!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    crimePopup.tag = 3;
    [crimePopup show];
}


- (IBAction)sidewalk:(id)sender {
    if (temp_sidewalk ==1){
        [sender setTitle:@"Sidewalk E!" forState:UIControlStateNormal];
        temp_sidewalk = 0;
    }else if (temp_sidewalk==2){
        [sender setTitle:@"Sidewalk S!" forState:UIControlStateNormal];
        temp_sidewalk = 0;
    }
    UIAlertView *sidewalkPopup = [[UIAlertView alloc] initWithTitle:@"Sidewalk!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    sidewalkPopup.tag = 4;
    [sidewalkPopup show];
}

- (IBAction)Slope:(id)sender {
    
    if (temp_slope ==1){
        [sender setTitle:@"Slope E!" forState:UIControlStateNormal];
        temp_slope = 0;
    }else if (temp_slope ==2){
        [sender setTitle:@"Slope S!" forState:UIControlStateNormal];
        temp_slope = 0;
    }
    UIAlertView *slopePopup = [[UIAlertView alloc] initWithTitle:@"Slope!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    slopePopup.tag = 5;
    [slopePopup show];
}


- (IBAction)residentialDensity:(id)sender {
    if (temp_residential ==1){
        [sender setTitle:@"ResidentialDensity E!" forState:UIControlStateNormal];
        temp_residential = 0;
    }else if (temp_residential ==2){
        [sender setTitle:@"ResidentialDensity S!" forState:UIControlStateNormal];
        temp_residential = 0;
    }
    UIAlertView *residentialPopup = [[UIAlertView alloc] initWithTitle:@"Residential Density!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    residentialPopup.tag = 6;
    [residentialPopup show];
}


- (IBAction)businessDensity:(id)sender {
    if (temp_business ==1){
        [sender setTitle:@"BusinessDensity E!" forState:UIControlStateNormal];
        temp_business = 0;
    }else if (temp_business ==2){
        [sender setTitle:@"BusinessDensity S!" forState:UIControlStateNormal];
        temp_business = 0;
    }
    UIAlertView *businessPopup = [[UIAlertView alloc] initWithTitle:@"Business Density!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    businessPopup.tag =7;
    [businessPopup show];
}


- (IBAction)accessibility:(id)sender {
    
    if (temp_accessibility ==1){
        [sender setTitle:@"Accessibility E!" forState:UIControlStateNormal];
        temp_accessibility = 0;
    }else if (temp_accessibility ==2){
        [sender setTitle:@"Accessibility S!" forState:UIControlStateNormal];
        temp_accessibility = 0;
    }
    UIAlertView *accessibilityPopup = [[UIAlertView alloc] initWithTitle:@"Accessibility!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    accessibilityPopup.tag = 8;
    [accessibilityPopup show];
}




- (IBAction)intersections:(id)sender {
    if (temp_intersections ==1){
        [sender setTitle:@"Intersections E!" forState:UIControlStateNormal];
        temp_intersections = 0;
    }else if (temp_intersections ==2){
        [sender setTitle:@"Intersections S!" forState:UIControlStateNormal];
        temp_intersections = 0;
    }
    UIAlertView *intersectionsPopup = [[UIAlertView alloc] initWithTitle:@"Intersections!" message:@"" delegate:self cancelButtonTitle:@"No Preference" otherButtonTitles:@"Introduction",@"Set as essential", @"Set as secondary", nil];
    
    intersectionsPopup.tag = 9;
    [intersectionsPopup show];
}




- (IBAction)landVariables:(id)sender {
    if (temp_landvariations ==1){
        [sender setTitle:@"Landvariations E!" forState:UIControlStateNormal];
        temp_landvariations = 0;
    }else if (temp_landvariations ==2){
        [sender setTitle:@"Landvariations S!" forState:UIControlStateNormal];
        temp_landvariations = 0;
    }
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
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_traffic = 1;
        } else if (buttonIndex == 3){
            traffic = 2;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_traffic = 2;
        }
    } else if (alertView.tag == 2){
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"GREENERY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            greenery = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_greenery = 1;
        } else if (buttonIndex == 3){
            greenery = 2;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_greenery = 2;
        }
    }else if (alertView.tag == 3){
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"CRIME!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            crime = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_crime = 1;
        } else if (buttonIndex == 3){
            traffic = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_crime = 2;
        }
    }else if (alertView.tag == 4){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SIDEWALK!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            sidewalk = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_sidewalk = 1;
        } else if (buttonIndex == 3){
            sidewalk = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_sidewalk = 2;
        }
        
    }else if (alertView.tag == 5){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"SLOPE!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            slope = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_slope = 1;
        } else if (buttonIndex == 3){
            traffic = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_slope = 2;
        }
        
    }else if (alertView.tag == 6){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"RESIDENTIAL DENSITY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            residential = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_residential = 1;
        } else if (buttonIndex == 3){
            residential = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_residential = 2;
        }
        
    }else if (alertView.tag == 7){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"BUSINESS DENSITY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            business = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_business = 1;
        } else if (buttonIndex == 3){
            business = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_business = 2;
        }
        
    } else if (alertView.tag == 8){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"ACCESSIBILITY!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            accessibility = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_accessibility = 1;
        } else if (buttonIndex == 3){
            accessibility = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_accessibility = 2;
        }
        
    } else if (alertView.tag == 9){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"INTERSECTIONS!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            intersections = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_intersections = 1;
        } else if (buttonIndex == 3){
            intersections = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_intersections = 2;
        }
        
    }else if (alertView.tag == 10){
        
        if (buttonIndex == 1){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"LAND VARIATIONS!" message:@"This parameter indicates the light environment along your walk. It may influence your walk in night" delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
            [alertView2 show];
            
        } else if (buttonIndex == 2){
            landvariations = 5;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com"]]];
            temp_landvariations = 1;
        } else if (buttonIndex == 3){
            landvariations = 3;
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com"]]];
            temp_landvariations = 2;
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
