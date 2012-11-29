//
//  ENMainViewController.m
//  Num2Word
//
//  Created by Ning Ke on 10/20/12.
//  Copyright (c) 2012 Ning Ke. All rights reserved.
//

#import "ENMainViewController.h"
#import "ENConverter.h"

@interface ENMainViewController ()

@end

@implementation ENMainViewController

@synthesize numberField;
@synthesize arabicNumber;
@synthesize englishWord;
@synthesize useLongScale;
@synthesize largestUnit;

// Save preferences in NSUserDefaults
- (void)saveSettings
{
    NSUserDefaults *dflSettings = [NSUserDefaults standardUserDefaults];
    if ([dflSettings objectForKey:@"settings"] == nil) {
        [dflSettings setObject:@"Valid" forKey:@"settings"];
    }
    [dflSettings setBool:self.useLongScale forKey:@"LongScale"];
    [dflSettings setObject:self.largestUnit forKey:@"LargestUnit"];
}

// Load preferences from NSUserDefaults
- (void)loadSettings
{
    NSUserDefaults *dflSettings = [NSUserDefaults standardUserDefaults];
    if ([dflSettings objectForKey:@"settings"] == nil) {
        // Use ENConverter defaults
        self.useLongScale = [ENConverter defaultUseLongScale];
        self.largestUnit = @"billion";
        [self saveSettings];
        return;
    }
    self.useLongScale = [dflSettings boolForKey:@"LongScale"];
    self.largestUnit = [dflSettings objectForKey:@"LargestUnit"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toEnglish:) name:UITextFieldTextDidChangeNotification object:self.numberField];
    [self loadSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numberField resignFirstResponder];
}

- (IBAction)toEnglish:(id)sender {
    // Don't use NSNumberFormatter or NSDecimalNumber and such to convert into number.
    // Those methods don't work for very large numbers.
    // First make sure only numbers are in the text field
    self.arabicNumber = [self.numberField.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Get English from the number
    ENConverter *conv = [[ENConverter alloc] initWithString:self.arabicNumber Longscale:self.useLongScale LargestUnit:self.largestUnit];
    NSString *engstr = [conv englishRep];
    
    // Set Label text
    self.englishWord.text = engstr;
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(ENFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
    
    // Get settings
    self.useLongScale = controller.useLongScale.on;
    self.largestUnit = controller.unitLabel.text;
    // Save user preferences
    [self toEnglish:nil];
    [self saveSettings];
}

- (NSString *)getUnitStringFromSliderValue:(float)sliderValue LongScale:(BOOL)longScale
{
    return [ENConverter getUnitStringFromValue:sliderValue LongScale:longScale];
}

- (void)initializeSlider:(UISlider *)slider Label:(UILabel *)label
{
    float sliderValue;
    
    sliderValue = [ENConverter getOrderValue:self.largestUnit LongScale:self.useLongScale];
    [slider setValue:sliderValue];
    [label setText:self.largestUnit];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
