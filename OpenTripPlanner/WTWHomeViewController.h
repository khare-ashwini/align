//
//  WTWHomeViewController.h
//  WalkThisWay
//
//  Created by GIS on 3/25/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTWHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)goToApp:(id)sender;
- (IBAction)goAboutUs:(id)sender;

@end
