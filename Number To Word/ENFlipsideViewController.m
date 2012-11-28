//
//  ENFlipsideViewController.m
//  Number To Word
//
//  Created by Ning Ke on 10/20/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import "ENFlipsideViewController.h"

@interface ENFlipsideViewController ()

@end

@implementation ENFlipsideViewController

@synthesize useLongScale;
@synthesize unitSlider;
@synthesize unitLabel;

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Set initial state of switch and scale according to relevant delegate values.
    [self.useLongScale setOn:[self.delegate useLongScale] animated:TRUE];
    [self.delegate initializeSlider:self.unitSlider Label:self.unitLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)unitChanged:(UISlider *)sender {
    NSString *unitstr = [self.delegate getUnitStringFromSliderValue:sender.value LongScale:self.useLongScale.on];
    [self.unitLabel setText:unitstr];
}
@end
