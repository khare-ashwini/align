//
//  OTPAboutViewController.m
//  OpenTripPlanner
//
//  Created by Jeff Maki on 10/26/12.
//  Copyright (c) 2012 OpenPlans. All rights reserved.
//

#import "OTPAboutViewController.h"
#import <QuartzCore/QuartzCore.h>

// IMPORTANT : File is not being Used
// See Webpage View / WTWWebpageViewController.m instead.

@interface OTPAboutViewController ()

@end

@implementation OTPAboutViewController

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
    NSLog(@"OTPAboutViewController");
    NSURL *myURL = [NSURL URLWithString:@"http://geo.gatech.edu/walkability/about.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:myURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
