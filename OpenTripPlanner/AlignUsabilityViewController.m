//
//  AlignUsabilityViewController.m
//  Chandra_Align
//
//  Created by Chandra Khatri on 10/22/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "AlignUsabilityViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface AlignUsabilityViewController ()

@end


@implementation AlignUsabilityViewController
@synthesize vibrateButton;

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

/*
- (void)vibratePhone;
{
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
    {
        AudioServicesPlaySystemSound (1352); //works ALWAYS as of this post
    }
    else
    {
        // Not an iPhone, so doesn't have vibrate
        // play the less annoying tick noise or one of your own
        AudioServicesPlayAlertSound (1105);
    }
}
 */

- (void) vibrateButton:(id)sender{
    //[self vibrationSwitch:(id)sender];
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSDate *alertTime = [[NSDate date]
                         dateByAddingTimeInterval:10];
    UIApplication* app = [UIApplication sharedApplication];
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc]
                                        init];
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName = @"bell_tree.mp3";
        notifyAlarm.alertBody = @"Staff meeting in 30 minutes";
        [app scheduleLocalNotification:notifyAlarm];
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (IBAction)vibrationsButton:(id)sender {

    [self vibrationSwitch:(id)sender];
    
}

- (IBAction)vibrationSwitch:(id)sender {
}


/*
int count = 0;

- (IBAction)dropdown:(id)sender{
    
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
        _dropdownView.alpha =0.7;
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

*/

@end
