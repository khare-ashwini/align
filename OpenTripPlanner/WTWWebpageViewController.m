//
//  WTWWebpageViewController.m
//  WalkThisWay
//
//  Created by GIS on 3/31/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "WTWWebpageViewController.h"

@interface WTWWebpageViewController ()

@end

@implementation WTWWebpageViewController

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
   
    NSURL *myURL = [NSURL URLWithString:@"http://geo.gatech.edu/walkability/about.html"];
    [self.webViewAbout loadRequest:[NSURLRequest requestWithURL:myURL]];
    NSLog(@"Webview Debug --- %@", self.webViewAbout);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
