//
//  ViewController.m
//  DJAlertViewSample
//
//  Created by jiang deng on 2018/7/3.
//  Copyright © 2018年 DJ. All rights reserved.
//

#import "ViewController.h"
#import "DJAlertView.h"
#import "DJAlertViewHelp.h"

@interface ViewController ()

- (IBAction)showSimpleAlertView:(id)sender;
- (IBAction)showSimpleCustomizedAlertView:(id)sender;

- (IBAction)showLargeAlertView:(id)sender;

- (IBAction)showTwoButtonAlertView:(id)sender;
- (IBAction)showTwoStackedButtonAlertView:(id)sender;

- (IBAction)showMultiButtonAlertView:(id)sender;

- (IBAction)showAlertViewWithContentView:(id)sender;

- (IBAction)show5StackedAlertViews:(id)sender;
- (IBAction)showOver5StackedAlertViews:(id)sender;

- (IBAction)showNoTapToDismiss:(id)sender;

- (IBAction)dismissWithNoAnimationAfter1Second:(id)sender;

- (IBAction)showAlertInsideAlertCompletion:(id)sender;

- (IBAction)testDismissWithNoAnimationAfter1Second:(id)sender;

- (IBAction)cannotDismiss:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}

- (IBAction)showSimpleAlertView:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"Hello World"
                                                     message:@"Oh my this looks like a nice message."
                                                 cancelTitle:@"Ok"
                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                      if (cancelled)
                                                      {
                                                          NSLog(@"Simple Alert View cancelled");
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"Simple Alert View dismissed, but not cancelled");
                                                      }
                                                  }];
    alertView.alertMarkBgEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    alertView.alertMarkBgColor = [UIColor colorWithHex:0x0000FF alpha:0.1];
    //[alertView showAlertView];
}

- (IBAction)showSimpleCustomizedAlertView:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"Hello World"
                                                     message:@"Oh my this looks like a nice message."
                                                 cancelTitle:@"Ok"
                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                      if (cancelled)
                                                      {
                                                          NSLog(@"Simple Customised Alert View cancelled");
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"Simple Customised Alert View dismissed, but not cancelled");
                                                      }
                                                  }];
    alertView.alertMarkBgColor = [UIColor colorWithRed:94 / 255.0 green:196 / 255.0 blue:221 / 255.0 alpha:0.25];
    alertView.alertBgColor = [UIColor colorWithRed:255 / 255.0 green:206 / 255.0 blue:13 / 255.0 alpha:1.0];
    
    alertView.alertTitleFont = [UIFont fontWithName:@"Zapfino" size:15.0f];
    alertView.alertTitleColor = [UIColor blueColor];
    
    alertView.cancleBtnBgColor = [UIColor colorWithHex:0xEE45E3];
    alertView.buttonHeight = 50;
    
    //[alertView showAlertView];
}

- (IBAction)showLargeAlertView:(id)sender
{
    [DJAlertView showAlertWithTitle:@"Why this is a larger title! Even larger than the largest large thing that ever was large in a very large way."
                            message:@"Oh my this looks like a nice message. Yes it does, and it can span multiple lines... all the way down.\n\nBut what's this? Even more lines? Why yes, now we can have even more content to show the world. Why? Because now you don't have to worry about the text overflowing off the screen. If text becomes too long to fit on the users display, it'll simply overflow and allow for the user to scroll. So now you're free to write however much you wish to write in an alert. A novel? An epic? Doesn't matter, because it can all now fit*. \n\n\n*Disclaimer: Within hardware and technical limitations, of course.\n\n To demonstrate, watch here:\nHere is a line.\nAnd here is another.\nAnd another.\nAnd another.\nAaaaaaand another.\nOh lookie here, AND another.\nAnd here's one more.\nFor good measure.\nAnd hello, newline.\n\n\nFeel free to expand your textual minds."
                        cancelTitle:@"Ok thanks, that's grand"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled)
                             {
                                 NSLog(@"Larger Alert View cancelled");
                             }
                             else
                             {
                                 NSLog(@"Larger Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showTwoButtonAlertView:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"The Matrix"
                                                     message:@"Pick the Red pill, or the blue pill"
                                                 cancelTitle:@"Blue"
                                                  otherTitle:@"Red"
                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                      if (cancelled)
                                                      {
                                                          if (buttonIndex == 0)
                                                          {
                                                              NSLog(@"Cancel (Blue) button pressed");
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"Cancel taped outside");
                                                          }
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"Other (Red) button pressed");
                                                      }
                                                  }];
    
    alertView.cancleBtnBgColor = [UIColor blueColor];
    alertView.otherBtnBgColor = [UIColor redColor];
    alertView.cancleBtnTextColor = [UIColor whiteColor];
    alertView.otherBtnTextColor = [UIColor whiteColor];
    
    alertView.alertGapLineColor = [UIColor yellowColor];
    
    //[alertView showAlertView];
}

- (IBAction)showTwoStackedButtonAlertView:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"The Matrix"
                                                     message:@"Pick the Red pill, or the blue pill"
                                                 cancelTitle:@"Blue"
                                                  otherTitle:@"Red"
                                          buttonsShouldStack:YES
                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                      if (cancelled)
                                                      {
                                                          if (buttonIndex == 0)
                                                          {
                                                              NSLog(@"Cancel (Blue) button pressed");
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"Cancel taped outside");
                                                          }
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"Other (Red) button pressed");
                                                      }
                                                  }];
    
    alertView.cancleBtnBgColor = [UIColor blueColor];
    alertView.otherBtnBgColor = [UIColor redColor];
    alertView.cancleBtnTextColor = [UIColor whiteColor];
    alertView.otherBtnTextColor = [UIColor whiteColor];
    
    alertView.alertGapLineColor = [UIColor colorWithHex:0x22EE11];
    
    //[alertView showAlertView];
}

- (IBAction)showMultiButtonAlertView:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"Porridge"
                                                     message:@"How would you like it?"
                                                 cancelTitle:@"No thanks"
                                                 otherTitles:@[ @"Too Hot", @"Luke Warm", @"Quite nippy" ]
                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                      if (cancelled)
                                                      {
                                                          NSLog(@"Cancel button pressed");
                                                      }
                                                      else
                                                      {
                                                          NSLog(@"Button with index %li pressed", (long)buttonIndex);
                                                      }
                                                  }];
    
    alertView.cancleBtnBgColor = [UIColor greenColor];
    alertView.otherBtnBgColor = [UIColor greenColor];
    
    //[alertView showAlertView];
}

- (IBAction)showAlertViewWithContentView:(id)sender
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]];
    [view addSubview:imageView];
    imageView.frame = CGRectMake(55, 5, 90, 90);
    
    [DJAlertView showAlertWithTitle:@"A picture should appear below"
                            message:@"Yay, it works!"
                        contentView:view
                        cancelTitle:@"Ok"
                         otherTitle:nil
                         completion:^(BOOL cancelled, NSInteger buttonIndex){
                         }];
}

- (IBAction)show5StackedAlertViews:(id)sender
{
    for (int i = 1; i <= 5; i++)
    {
        DJAlertView *alertView = [[DJAlertView alloc] initWithIcon:nil
                                                             title:[NSString stringWithFormat:@"Hello %@", @(i)]
                                                           message:@"Oh my this looks like a nice message."
                                                       contentView:nil
                                                       cancelTitle:@"OK"
                                                       otherTitles:nil
                                                buttonsShouldStack:NO
                                                        completion:^(BOOL cancelled, NSInteger buttonIndex){
                                                        }];
        
        alertView.showAnimationType = arc4random() % (DJAlertViewShowAnimationSlideInFromRight + 1);
        alertView.hideAnimationType = arc4random() % (DJAlertViewHideAnimationSlideOutToRight + 1);
        
        [alertView showAlertView];
    }
}

- (IBAction)showOver5StackedAlertViews:(id)sender
{
    for (int i = 1; i <= 15; i++)
    {
        [DJAlertView showAlertWithTitle:[NSString stringWithFormat:@"Hello %@", @(i)]
                                message:@"Oh my this looks like a nice message."
                            cancelTitle:@"Ok"
                             completion:^(BOOL cancelled, NSInteger buttonIndex){
                             }];
    }
}

- (IBAction)showNoTapToDismiss:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"Tap"
                                                     message:@"Try tapping around the alert view to dismiss it. This should NOT work on this alert."];
    alertView.shouldDismissOnTapOutside = NO;
}

- (IBAction)dismissWithNoAnimationAfter1Second:(id)sender
{
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"No Animation" message:@"When dismissed"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
}

- (IBAction)showAlertInsideAlertCompletion:(id)sender
{
    [DJAlertView showAlertWithTitle:@"Alert Inception"
                            message:@"After pressing ok, another alert should appear"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             [DJAlertView showAlertWithTitle:@"Woohoo"];
                         }];
}

- (IBAction)testDismissWithNoAnimationAfter1Second:(id)sender
{
    // 无感关闭
    DJAlertView *alertView = [DJAlertView showAlertWithTitle:@"No Animation" message:@"When dismissed"];
    alertView.showAnimationType = DJAlertViewShowAnimationNone;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
    
    [DJAlertView showAlertWithTitle:[NSString stringWithFormat:@"Hello %@", @(1)]
                            message:@"Oh my this looks like a nice message."
                        cancelTitle:@"Ok"
                         completion:^(BOOL cancelled, NSInteger buttonIndex){
                         }];
}

- (IBAction)cannotDismiss:(id)sender
{
    DJAlertView *alertView = [[DJAlertView alloc] initWithIcon:@"ExampleImage"
                                                         title:@"Alert Alert!!"
                                                       message:@"After pressing ok, the alert cannot disappear"
                                                   contentView:nil
                                                   cancelTitle:@"OK"
                                                   otherTitles:nil
                                            buttonsShouldStack:NO
                                                    completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                        NSLog(@"Cannot dismiss");
                                                    }];
    alertView.notDismissOnCancel = YES;
    
    [alertView showAlertView];
}

@end
