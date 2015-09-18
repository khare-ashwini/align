//
//  FeedbackController.h
//  Pods
//
//  Created by Ashwini Khare on 9/18/15.
//
//

#import <UIKit/UIKit.h>

@interface FeedbackController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *TextView;
- (IBAction)submitAction:(id)sender;

@end
