//
//  FeedbackController.m
//  Pods
//
//  Created by Ashwini Khare on 9/18/15.
//
//

#import "FeedbackController.h"
#import <Firebase/Firebase.h>

@interface FeedbackController ()

@end

@implementation FeedbackController

@synthesize TextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    //Firebase Stuff
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://sweltering-torch-1850.firebaseio.com"];
    // Write data to Firebase
    NSString *text = [TextView text];
    NSDictionary *sampleEntry = @{
                                  @"feedback" : text
                                  };
    Firebase *postRef = [myRootRef childByAutoId];
    [postRef setValue:sampleEntry];
}
@end
