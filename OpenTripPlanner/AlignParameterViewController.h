//
//  AlignParameterViewController.h
//  Chandra_Align
//
//  Created by Chandra Khatri on 9/28/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AlignParameterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *allParameterView;
@property (weak, nonatomic) IBOutlet UIView *myParameterView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)parameterSegment:(id)sender;

@end
