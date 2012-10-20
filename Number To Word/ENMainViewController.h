//
//  ENMainViewController.h
//  Number To Word
//
//  Created by Ning Ke on 10/20/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import "ENFlipsideViewController.h"

@interface ENMainViewController : UIViewController <ENFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
