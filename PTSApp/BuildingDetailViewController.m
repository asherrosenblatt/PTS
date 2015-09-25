//
//  BuildingDetailViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/17/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "BuildingDetailViewController.h"

@interface BuildingDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UITextView *buildingDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *buildingPicsImageView;

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
        self.buildingDescriptionTextView.text = self.building[@"description"];

    }];
}


@end
