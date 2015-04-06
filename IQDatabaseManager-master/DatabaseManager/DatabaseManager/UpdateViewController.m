//
//  UpdateViewController.m
//  DatabaseManager

#import "UpdateViewController.h"
#import "MyDatabaseManager.h"

@interface UpdateViewController ()
{
    __weak IBOutlet UITextField *textFieldName;
    __weak IBOutlet UITextField *textFieldEmail;
    __weak IBOutlet UITextField *textFieldPhoneNumber;
    __weak IBOutlet UITextView *textViewComment;
}


@end

@implementation UpdateViewController
@synthesize record;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textFieldName.text = self.record.name;
    textFieldEmail.text = self.record.email;
    textFieldPhoneNumber.text = self.record.phoneNumber;
    textViewComment.text = self.record.comment;

    
	// Do any additional setup after loading the view.
}

- (IBAction)updateClicked:(UIButton *)sender
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          textFieldName.text,kName,
                          textFieldEmail.text,kEmail,
                          textFieldPhoneNumber.text,kPhoneNumber,
                          textViewComment.text,kComment,
                          nil];

    [[MyDatabaseManager sharedManager] updateRecord:self.record inRecordTable:dict];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
