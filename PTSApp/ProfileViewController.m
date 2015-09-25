//
//  ProfileViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/21/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.newSignUp == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile Incomplete" message:@"Please fill out the rest of the information on this page to complete your profile" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        self.firstNameField.text = [PFUser currentUser][@"firstName"];
        self.lastNameField.text = [PFUser currentUser][@"lastName"];
        self.companyField.text = [PFUser currentUser][@"companyName"];
        self.phoneField.text = [PFUser currentUser][@"phone"];
    }
}
- (IBAction)onSavePressed:(id)sender
{
    [PFUser currentUser][@"firstName"] = self.firstNameField.text;
    [PFUser currentUser][@"lastName"] = self.lastNameField.text;
    [PFUser currentUser][@"companyName"] = self.companyField.text;
    [PFUser currentUser][@"phone"] = self.phoneField.text;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Changes Saved" message:@"Your changes have been successfully saved." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unfortunately your changes could not be saved at this time. Please try again later." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (IBAction)onLogOutPressed:(id)sender
{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
@end
