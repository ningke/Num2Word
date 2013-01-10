//
//  ENMainViewController.h
//  Num2Word
//
//  Created by Ning Ke on 10/20/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import "ENFlipsideViewController.h"

@interface ENMainViewController : UIViewController <ENFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UILabel *formattedNumber;
@property (weak, nonatomic) IBOutlet UITextView *englishWord;
@property (copy, nonatomic) NSString *arabicNumber;
@property BOOL useLongScale;
@property NSString *largestUnit;

- (IBAction)toEnglish:(id)sender;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
