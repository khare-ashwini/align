//
//  AlignParameterViewController.m
//  Chandra_Align
//
//  Created by Chandra Khatri on 9/28/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "AlignParameterViewController.h"



@interface AlignParameterViewController ()

@end

@implementation AlignParameterViewController
@synthesize allParameterView, myParameterView;


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
@end
