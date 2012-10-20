//
//  ENFlipsideViewController.h
//  Number To Word
//
//  Created by Ning Ke on 10/20/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ENFlipsideViewController;

@protocol ENFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ENFlipsideViewController *)controller;
@end

@interface ENFlipsideViewController : UIViewController

@property (weak, nonatomic) id <ENFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
