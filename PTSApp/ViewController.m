//
//  ViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/2/15.
//  Copyright (c) 2015 asher. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "BuildingDetailViewController.h"

@interface ViewController ()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *buildingsTableView;
@property (strong, nonatomic) IBOutlet MKMapView *buildingsMapView;
@property NSArray *buildingsArray;
@property PFObject *selectedBuilding;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self queryBuildings];
}

-(void)queryBuildings
{
    PFQuery *queryBuildings = [[PFQuery alloc] initWithClassName:@"Building"];
    [queryBuildings findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        self.buildingsArray = [NSArray new];
        self.buildingsArray = objects;
        [self.buildingsTableView reloadData];
        [self locateBuildings];
    }];
}

-(void)locateBuildings
{
    for (PFObject *building in self.buildingsArray) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *addressString = building[@"address"];
        [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
            MKPlacemark *building = [[MKPlacemark alloc] initWithPlacemark:[placemarks firstObject]];
            [self.buildingsMapView addAnnotation:building];
            [self.buildingsMapView setCenterCoordinate:building.coordinate animated:YES];
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.buildingsTableView dequeueReusableCellWithIdentifier:@"ID"];
    PFObject *building = [PFObject objectWithClassName:@"building"];
    building = [self.buildingsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = building[@"address"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.buildingsArray.count;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedBuilding = [self.buildingsArray objectAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"buildingDetailSegue"]) {
        BuildingDetailViewController *vc = segue.destinationViewController;
        vc.building = self.selectedBuilding;
    }
}

@end
