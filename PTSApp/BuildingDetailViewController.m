//
//  BuildingDetailViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/17/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "BuildingDetailViewController.h"

@interface BuildingDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;

@end

@implementation BuildingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.addressLabel.text = self.building[@"address"];
    [self.building fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.logoImageView.image = object[@"logo"];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
@end
