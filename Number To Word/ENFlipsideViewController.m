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

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

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

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
