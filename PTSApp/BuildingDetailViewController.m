//
//  BuildingDetailViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/17/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "BuildingDetailViewController.h"
#import "SuiteDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface BuildingDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *buildingPicsImageView;
@property (strong, nonatomic) IBOutlet UILabel *numOfFloorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *squarefootageLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UIButton *phoneButton;

@end

@implementation BuildingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.addressLabel.text = self.building[@"address"];
    [self.building fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFile *logoFile = object[@"logo"];
        [logoFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (data) {
                self.logoImageView.image = [UIImage imageWithData:data];
            }
        }];

        PFFile *imageFile = object[@"buildingImage"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (data) {
                self.buildingPicsImageView.image = [UIImage imageWithData:data];
            }
        }];
        self.numOfFloorsLabel.text = self.building[@"numberOfFloors"];
        self.squarefootageLabel.text = self.building[@"squarefootage"];
        self.contactName.text = self.building[@"contactName"];
        [self.phoneButton setTitle:self.building[@"contactEmail"] forState:UIControlStateNormal];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"View Avaliable Suites"]) {
        SuiteDetailViewController *vc = segue.destinationViewController;
        vc.buildingID = self.building.objectId;
    }
}

- (IBAction)onPhoneNumberPressed:(id)sender
{
    NSString *emailTitle = self.building[@"address"];
    NSString *messageBody = [NSString stringWithFormat: @"I found your building while perusing the PlanTheSpace.com app and would like to get some more information. \n \n Thanks, %@ %@  \n %@", [PFUser currentUser][@"firstName"], [PFUser currentUser][@"lastName"], [PFUser currentUser][@"phone"]];
    NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", self.building[@"contactEmail"]]];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc setDelegate:self];
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [self presentViewController:mc animated:YES completion:NULL];
}

@end
