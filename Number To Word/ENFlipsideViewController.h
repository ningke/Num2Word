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
- (NSString *)getUnitStringFromSliderValue:(float)sliderValue LongScale:(BOOL)longScale;
- (void)initializeSlider:(UISlider *)slider Label:(UILabel *)label;
- (BOOL)useLongScale;
@end

@interface ENFlipsideViewController : UIViewController

@property (weak, nonatomic) id <ENFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *useLongScale;
@property (weak, nonatomic) IBOutlet UISlider *unitSlider;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
- (IBAction)unitChanged:(UISlider *)sender;

@end
