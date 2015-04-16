//
//  AlignUsabilityViewController.h
//  Chandra_Align
//
//  Created by Chandra Khatri on 10/22/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface AlignUsabilityViewController : UIViewController

- (IBAction)vibrationsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *vibrateButton;
- (IBAction)vibrationSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

/*
- (IBAction)dropdown:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *dropdownView;

*/

@end
