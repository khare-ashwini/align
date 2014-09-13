//
//  WTWHomeViewController.m
//  WalkThisWay
//
//  Created by GIS on 3/25/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "WTWHomeViewController.h"
#import "OTPDirectionsInputViewController.h"

@interface WTWHomeViewController ()

@end

@implementation WTWHomeViewController

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
	// Do any additional setup after loading the view.
    
    [self.scrollView setContentSize:(CGSizeMake(320, 460))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToApp:(id)sender {
    [self performSelector:@selector(doSegue:) withObject:@"goToApp" afterDelay:0.0];
}

- (IBAction)goAboutUs:(id)sender {
    // NSURL *myURL = [NSURL URLWithString:@"http://geo.gatech.edu/walkability/about.html"];
    NSURL *myURL = [NSURL URLWithString:@"http://geo.gatech.edu/walkability/HowItWorks.pdf"];
    [[UIApplication sharedApplication] openURL:myURL];
}

- (void)doSegue:(NSString *)segueId {
    // This indirect invocation of segue is required to show the highlight of the selected image before the segue transition
    [self performSegueWithIdentifier:segueId sender:self];
}
@end
