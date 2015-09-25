//
//  HomeScreenViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/21/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "HomeScreenViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ProfileViewController.h"

@interface HomeScreenViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property BOOL newSignUp;
@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.newSignUp = NO;
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
    if (![PFUser currentUser]) {
        if (![PFUser currentUser]) { // No user logged in
            // Create the log in view controller
            PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
            logInViewController.title = @"PlanTheSpace.com";
            [logInViewController setDelegate:self]; // Set ourselves as the delegate

            // Create the sign up view controller
            PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
            [signUpViewController setDelegate:self]; // Set ourselves as the delegate

            // Assign our sign up controller to be displayed from the login controller
            [logInViewController setSignUpController:signUpViewController];

            // Present the log in view controller
            [self presentViewController:logInViewController animated:YES completion:NULL];
        }
    }
}


- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];

}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }

    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
    self.newSignUp = YES;
    [self performSegueWithIdentifier:@"profileSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if ([sender isKindOfClass:[UIStoryboardSegue class]]) {
        if ([segue.identifier isEqualToString:@"profileSegue"]) {
            ProfileViewController *vc = segue.destinationViewController;
            vc.newSignUp = self.newSignUp;
            NSLog(@"");
        }
    }



@end
