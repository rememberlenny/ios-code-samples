//
//  BMViewController.m
//  Tip Calculator BM
//
//  Created by Beau Matherne on 8/18/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import "BMViewController.h"

@interface BMViewController ()

@end

@implementation BMViewController

@synthesize tip, people, totalTip, totalBill, dividedAmount;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set background images for the left UIButtons
    UIImage *leftButtonImage = [UIImage imageNamed:@"leftButton.png"];
    UIImage *leftButtonImageHighlight = [UIImage imageNamed:@"leftButtonHighlight.png"];
    [oneButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [oneButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    [fourButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [fourButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    [sevenButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [sevenButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    [dotButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [dotButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    
    // Set background images for the center UIButtons
    UIImage *centerButtonImage = [UIImage imageNamed:@"centerButton.png"];
    UIImage *centerButtonImageHighlight = [UIImage imageNamed:@"centerButtonHighlight.png"];
    [twoButton setBackgroundImage:centerButtonImage forState:UIControlStateNormal];
    [twoButton setBackgroundImage:centerButtonImageHighlight forState:UIControlStateHighlighted];
    [fiveButton setBackgroundImage:centerButtonImage forState:UIControlStateNormal];
    [fiveButton setBackgroundImage:centerButtonImageHighlight forState:UIControlStateHighlighted];
    [eightButton setBackgroundImage:centerButtonImage forState:UIControlStateNormal];
    [eightButton setBackgroundImage:centerButtonImageHighlight forState:UIControlStateHighlighted];
    [zeroButton setBackgroundImage:centerButtonImage forState:UIControlStateNormal];
    [zeroButton setBackgroundImage:centerButtonImageHighlight forState:UIControlStateHighlighted];
    
    // The right UIButtons use the same background image as the left UIButtons
    [threeButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [threeButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    [sixButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [sixButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    [nineButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [nineButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    [backButton setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:leftButtonImageHighlight forState:UIControlStateHighlighted];
    
    // Set the minimum and maximum values of the UIStepper objects
    [tipStepper setMinimumValue:1];
    [tipStepper setMaximumValue:50];
    [peopleStepper setMinimumValue:1];
    [peopleStepper setMaximumValue:50];
    
    // Set the default billLabel text
    [billLabel setText:[NSString stringWithFormat:@""]];
    
    // Set default tip and people NSNumbers
    [self setTip:[NSNumber numberWithDouble:1]];
    [self setPeople:[NSNumber numberWithDouble:1]];
    
    // Set Borders for labels
    billLabel.layer.borderColor = [UIColor blackColor].CGColor;
    billLabel.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tipStepperChanged:(UIStepper *)sender {
    NSNumber *value = [NSNumber numberWithDouble:sender.value];
    [self setTip:value];
    [tipPercentLabel setText:[NSString stringWithFormat:@"%@%% tip", value]];
    
    NSNumberFormatter *currencyStyleFormatter = [[NSNumberFormatter alloc] init];
    [currencyStyleFormatter setMaximumFractionDigits:2];
    [currencyStyleFormatter setRoundingMode:NSNumberFormatterRoundUp];
    [currencyStyleFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSMutableString *currentValue = [NSMutableString stringWithFormat:@"%@", billLabel.text];
    
    NSNumber *num = [NSNumber numberWithDouble:[currentValue doubleValue] * ([tip doubleValue] / 100)];
    NSNumber *num2 = [NSNumber numberWithDouble:[currentValue doubleValue] + [num doubleValue]];
    NSNumber *num3 = [NSNumber numberWithDouble:[num2 doubleValue] / [people doubleValue]];
    NSString *string = [currencyStyleFormatter stringFromNumber:num];
    NSString *string2 = [currencyStyleFormatter stringFromNumber:num2];
    NSString *string3 = [currencyStyleFormatter stringFromNumber:num3];
    [totalTipLabel setText:string];
    [totalBillLabel setText:string2];
    [dividedAmountLabel setText:string3];
}

- (IBAction)peopleStepperChanged:(UIStepper *)sender {
    NSNumber *value = [NSNumber numberWithDouble:sender.value];
    [self setPeople:value];
    if ([value doubleValue] == 1)
    {
        [peopleLabel setText:[NSString stringWithFormat:@"%@ person", value]];
    }
    else
    {
        [peopleLabel setText:[NSString stringWithFormat:@"%@ people", value]];
    }
    
    NSNumberFormatter *currencyStyleFormatter = [[NSNumberFormatter alloc] init];
    [currencyStyleFormatter setMaximumFractionDigits:2];
    [currencyStyleFormatter setRoundingMode:NSNumberFormatterRoundUp];
    [currencyStyleFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSMutableString *currentValue = [NSMutableString stringWithFormat:@"%@", billLabel.text];
    
    NSNumber *num = [NSNumber numberWithDouble:[currentValue doubleValue] * ([tip doubleValue] / 100)];
    NSNumber *num2 = [NSNumber numberWithDouble:[currentValue doubleValue] + [num doubleValue]];
    NSNumber *num3 = [NSNumber numberWithDouble:[num2 doubleValue] / [people doubleValue]];
    NSString *string = [currencyStyleFormatter stringFromNumber:num];
    NSString *string2 = [currencyStyleFormatter stringFromNumber:num2];
    NSString *string3 = [currencyStyleFormatter stringFromNumber:num3];
    [totalTipLabel setText:string];
    [totalBillLabel setText:string2];
    [dividedAmountLabel setText:string3];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    
    // We need a way to establish what button was pressed.
    // Create an NSString with the title of the button.
    NSString *button = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
    
    // Make a function call to labelAction and pass the button title as an argument.
    [self labelAction:button];
}

- (void)labelAction:(NSString *)sender {
    
    NSNumberFormatter *currencyStyleFormatter = [[NSNumberFormatter alloc] init];
    [currencyStyleFormatter setMaximumFractionDigits:2];
    [currencyStyleFormatter setRoundingMode:NSNumberFormatterRoundUp];
    [currencyStyleFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSMutableString *currentValue = [NSMutableString stringWithFormat:@"%@", billLabel.text];
    
    // Procedure for backButton
    if ([sender isEqualToString:@"<<"])
    {
        if ( [currentValue length] > 0)
        {
            [currentValue deleteCharactersInRange:NSMakeRange([currentValue length] - 1, 1)];
            [billLabel setText:currentValue];
            NSNumber *num = [NSNumber numberWithDouble:[currentValue doubleValue] * ([tip doubleValue] / 100)];
            NSNumber *num2 = [NSNumber numberWithDouble:[currentValue doubleValue] + [num doubleValue]];
            NSNumber *num3 = [NSNumber numberWithDouble:[num2 doubleValue] / [people doubleValue]];
            NSString *string = [currencyStyleFormatter stringFromNumber:num];
            NSString *string2 = [currencyStyleFormatter stringFromNumber:num2];
            NSString *string3 = [currencyStyleFormatter stringFromNumber:num3];
            [totalTipLabel setText:string];
            [totalBillLabel setText:string2];
            [dividedAmountLabel setText:string3];
            
        }
    } // End backButton procedure
    
    // Procedure for decimal point
    if ([sender isEqualToString:@"."])
    {
        // Check to make sure there aren't two decimal points.
        NSRange range = [currentValue rangeOfString:@"."];
        if (range.location == NSNotFound)
        {
            [currentValue appendString:sender];
            [billLabel setText:currentValue];
        }
        else
        {
            // Do nothing
        }
    } // End decimal point procedure
    
    // Procedure for values 0-9
    if (![sender isEqualToString:@"." ] && ![sender isEqualToString:@"<<"])
    {
        [currentValue appendString:sender];
        [billLabel setText:currentValue];
        NSNumber *num = [NSNumber numberWithDouble:[currentValue doubleValue] * ([tip doubleValue] / 100)];
        NSNumber *num2 = [NSNumber numberWithDouble:[currentValue doubleValue] + [num doubleValue]];
        NSNumber *num3 = [NSNumber numberWithDouble:[num2 doubleValue] / [people doubleValue]];
        NSString *string = [currencyStyleFormatter stringFromNumber:num];
        NSString *string2 = [currencyStyleFormatter stringFromNumber:num2];
        NSString *string3 = [currencyStyleFormatter stringFromNumber:num3];
        [totalTipLabel setText:string];
        [totalBillLabel setText:string2];
        [dividedAmountLabel setText:string3];
    }
    
}

@end
