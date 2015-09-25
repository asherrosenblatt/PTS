//
//  SuiteCodeViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/21/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "SuiteCodeViewController.h"
#import "SearchSuiteCodeViewController.h"

@interface SuiteCodeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *suiteCodeTextField;

@end

@implementation SuiteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.suiteCodeTextField resignFirstResponder];
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchSuiteCodeViewController *vc = segue.destinationViewController;
    vc.suiteCode = [NSString stringWithFormat:@"%@", self.suiteCodeTextField.text];
}

- (IBAction)onEnterSuitePressed:(id)sender
{
    if ([self.suiteCodeTextField.text isEqualToString:@""]) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Please Enter a Suite Code" message:@"I think you forgot to enter a suite code!" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles: nil];
    }
}


@end
