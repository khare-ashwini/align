//
//  WTWHelpViewController.h
//  WalkThisWay
//
//  Created by GIS on 3/26/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTWHelpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIToolbar *footerToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevPageBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *prevTipBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextTipBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextPageBtn;

- (IBAction)previousPage:(id)sender;
- (IBAction)previousTip:(id)sender;
- (IBAction)nextTip:(id)sender;
- (IBAction)nextPage:(id)sender;

@end
