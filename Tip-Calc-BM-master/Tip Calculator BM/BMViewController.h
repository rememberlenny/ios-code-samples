//
//  BMViewController.h
//  Tip Calculator BM
//
//  Created by Beau Matherne on 8/18/13.
//  Copyright (c) 2013 Beau Matherne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BMViewController : UIViewController {
    IBOutlet UIButton *oneButton;
    IBOutlet UIButton *twoButton;
    IBOutlet UIButton *threeButton;
    IBOutlet UIButton *fourButton;
    IBOutlet UIButton *fiveButton;
    IBOutlet UIButton *sixButton;
    IBOutlet UIButton *sevenButton;
    IBOutlet UIButton *eightButton;
    IBOutlet UIButton *nineButton;
    IBOutlet UIButton *zeroButton;
    IBOutlet UIButton *dotButton;
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *billLabel;
    IBOutlet UILabel *tipPercentLabel;
    IBOutlet UILabel *peopleLabel;
    IBOutlet UILabel *totalBillLabel;
    IBOutlet UILabel *totalTipLabel;
    IBOutlet UILabel *dividedAmountLabel;
    IBOutlet UIStepper *tipStepper;
    IBOutlet UIStepper *peopleStepper;
}

@property (nonatomic, strong) NSNumber *tip, *people, *totalTip, *totalBill, *dividedAmount;

- (IBAction)tipStepperChanged:(UIStepper *)sender;
- (IBAction)peopleStepperChanged:(UIStepper *)sender;
- (IBAction)buttonPressed:(UIButton *)sender;
- (void)labelAction:(NSString *)sender;


@end
