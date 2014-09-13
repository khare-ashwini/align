//
//  WTWHelpViewController.m
//  WalkThisWay
//
//  Created by GIS on 3/26/14.
//  Copyright (c) 2014 GATech-CGIS. All rights reserved.
//

#import "WTWHelpViewController.h"

@interface WTWHelpViewController ()
{
    NSMutableArray *imgArray;
    int currentImgIndex;
}
@end

@implementation WTWHelpViewController

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
    
    imgArray = [[NSMutableArray alloc] init];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg01-tip01.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg01-tip02.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg01-tip03.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg01-tip04.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg02-tip01.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg02-tip02.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg02-tip03.png"])]];
    [imgArray addObject:[UIImage imageNamed:([NSString stringWithFormat:@"help-pg02-tip04.png"])]];
    currentImgIndex = 0;
    
    self.prevPageBtn.enabled = false;
    self.prevTipBtn.enabled = false;
    self.nextTipBtn.enabled = true;
    self.nextPageBtn.enabled = true;
    
    [self.scrollView setContentSize:(CGSizeMake(320, 416))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previousPage:(id)sender {
    currentImgIndex = 0;
    self.imgView.image= [imgArray objectAtIndex:currentImgIndex];
    [self updateNaviButtons];
}

- (IBAction)nextTip:(id)sender {
    currentImgIndex++;
    self.imgView.image= [imgArray objectAtIndex:currentImgIndex];
    [self updateNaviButtons];
}

- (IBAction)nextPage:(id)sender {
    currentImgIndex = 4;
    self.imgView.image= [imgArray objectAtIndex:currentImgIndex];
    [self updateNaviButtons];
}

- (IBAction)previousTip:(id)sender {
    currentImgIndex--;
    self.imgView.image= [imgArray objectAtIndex:currentImgIndex];
    [self updateNaviButtons];
}

- (void) updateNaviButtons {
    if((currentImgIndex + 1) == imgArray.count){
        self.nextTipBtn.enabled = false;
    } else {
        self.nextTipBtn.enabled = true;
    }
    
    if((currentImgIndex - 1) == -1) {
        self.prevTipBtn.enabled = false;
    } else {
        self.prevTipBtn.enabled = true;
    }
    
    if(currentImgIndex > 3) {
        self.nextPageBtn.enabled = false;
    } else {
        self.nextPageBtn.enabled = true;
    }
    
    if(currentImgIndex <= 3) {
        self.prevPageBtn.enabled = false;
    } else {
        self.prevPageBtn.enabled = true;
    }
}
@end
