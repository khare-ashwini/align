//
//  ParametersViewController.m
//  OpenTripPlanner
//
//  Created by GIS on 12/5/13.
//  Copyright (c) 2013 OpenPlans. All rights reserved.
//

#import "ParametersViewController.h"
#import "WalkableParameter.h"
#import "CMPopTipView.h"

@interface ParametersViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) CMPopTipView *popTipView;
@property (nonatomic, strong) UIImageView *currTooltipTarget;

@end

@implementation ParametersViewController

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
    WalkableParameter *wp = [WalkableParameter params];
    
    [self initStepper:self.trafficStepper AndImg:self.trafficImg WithValue:wp.traffic];
    [self initStepper:self.greeneryStepper AndImg:self.greeneryImg WithValue:wp.greenery];
    [self initStepper:self.crimeStepper AndImg:self.crimeImg WithValue:wp.crime];
    [self initStepper:self.sidewalkStepper AndImg:self.sidewalkImg WithValue:wp.sidewalk];
    [self initStepper:self.resDensityStepper AndImg:self.resDensityImg WithValue:wp.resiDensity];
    [self initStepper:self.busDensityStepper AndImg:self.busDensityImg WithValue:wp.busiDensity];
    [self initStepper:self.accessibilityStepper AndImg:self.accessibilityImg WithValue:wp.accessibility];
    [self initStepper:self.intersectionsStepper AndImg:self.intersectionsImg WithValue:wp.intersection];
    [self initStepper:self.slopeStepper AndImg:self.slopeImg WithValue:wp.slope];
    [self initStepper:self.landVarStepper AndImg:self.landVarImg WithValue:wp.landVariation];
    
    [self.scrollView setScrollEnabled:YES];
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        //[self.containerView setFrame:CGRectMake(0, 0, 480, 416)];
    }
    [self.scrollView setContentSize:(CGSizeMake(320, 416))];
    // printf("%f,%f\n",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperChanged:(id)sender {
    UIStepper *stepper = (UIStepper *) sender;
    int val = (int) (roundf([stepper value]));
    UIImageView *targetImg = nil;
    NSString *tooltipMsg = nil;
    
    if(sender == self.trafficStepper) {
        targetImg = self.trafficImg;
        tooltipMsg = @"1 = More Traffic\n5 = Less Traffic";
    } else if(sender == self.greeneryStepper) {
        targetImg = self.greeneryImg;
        tooltipMsg = @"1 = Less Greenery\n5 = More Greenery";
    } else if(sender == self.crimeStepper) {
        targetImg = self.crimeImg;
        tooltipMsg = @"1 = More Crime\n5 = Less Crime";
    } else if(sender == self.sidewalkStepper) {
        targetImg = self.sidewalkImg;
        tooltipMsg = @"1 = Less Sidewalks\n5 = More Sidewalks";
    } else if(sender == self.resDensityStepper) {
        targetImg = self.resDensityImg;
        tooltipMsg = @"1 = Less\n5 = More";
    } else if(sender == self.busDensityStepper) {
        targetImg = self.busDensityImg;
        tooltipMsg = @"1 = Less\n5 = More";
    } else if(sender == self.accessibilityStepper) {
        targetImg = self.accessibilityImg;
        tooltipMsg = @"1 = Far from public transport\n5 = Near to public transport";
    } else if(sender == self.intersectionsStepper) {
        targetImg = self.intersectionsImg;
        tooltipMsg = @"1 = Less\n5 = More";
    } else if(sender == self.slopeStepper) {
        targetImg = self.slopeImg;
        tooltipMsg = @"1 = Steep\n5 = Flat";
    } else if(sender == self.landVarStepper) {
        targetImg = self.landVarImg;
        tooltipMsg = @"1 = Less\n5 = More";
    }
    
    if(targetImg != nil) {
        targetImg.image = [UIImage imageNamed:([NSString stringWithFormat:@"dots-%d_75.png", val])];
    }
    
    BOOL createTooltip = YES;
    if(nil != self.currTooltipTarget) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTooltip) object: nil];
        if(targetImg != self.currTooltipTarget) {
            [self hideTooltip];
        } else {
            createTooltip = NO;
        }
    }
    
    if(createTooltip) {
        self.currTooltipTarget = targetImg;
        self.popTipView = [[CMPopTipView alloc] initWithMessage:tooltipMsg];
        self.popTipView.has3DStyle = false;
        self.popTipView.textColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        self.popTipView.backgroundColor = [UIColor colorWithRed:175.0/255 green:212.0/255 blue:227.0/255 alpha:0.9];
        self.popTipView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        self.popTipView.preferredPointDirection = PointDirectionDown;
        [self.popTipView presentPointingAtView:targetImg inView:self.view animated:YES];
    }
    
    [self performSelector:@selector(hideTooltip) withObject:nil afterDelay:2.0];
}

- (void)hideTooltip {
    if(nil != self.popTipView) {
        [self.popTipView dismissAnimated:true];
        self.currTooltipTarget = nil;
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    WalkableParameter *wp = [WalkableParameter params];
    wp.traffic = (int) (roundf(self.trafficStepper.value));
    wp.greenery = (int) (roundf(self.greeneryStepper.value));
    wp.crime = (int) (roundf(self.crimeStepper.value));
    wp.sidewalk = (int) (roundf(self.sidewalkStepper.value));
    wp.resiDensity = (int) (roundf(self.resDensityStepper.value));
    wp.busiDensity = (int) (roundf(self.busDensityStepper.value));
    wp.accessibility = (int) (roundf(self.accessibilityStepper.value));
    wp.intersection = (int) (roundf(self.intersectionsStepper.value));
    wp.slope = (int) (roundf(self.slopeStepper.value));
    wp.landVariation = (int) (roundf(self.landVarStepper.value));

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        // printf("%f,%f\n",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        [self.containerView setFrame:CGRectMake(0, 0, self.containerView.frame.size.width, 416)];
        // printf("%f,%f\n",self.scrollView.frame.size.width,self.scrollView.frame.size.height);
    }
}

- (void)initStepper:(id)stepper AndImg:(id)img WithValue:(int)val {
    UIStepper *targetStepper = (UIStepper *) stepper;
    UIImageView *targetImg = (UIImageView *) img;
    
    [targetStepper setValue:val];
    targetImg.image = [UIImage imageNamed:([NSString stringWithFormat:@"dots-%d_75.png", val])];
}

@end
