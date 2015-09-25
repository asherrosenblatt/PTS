//
//  SearchSuiteCodeViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/21/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "SearchSuiteCodeViewController.h"
#import <Parse/Parse.h>

@interface SearchSuiteCodeViewController ()

@end

@implementation SearchSuiteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"Suite"];
    [query whereKey:@"suiteCode" equalTo:self.suiteCode];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"%@", objects);
    }];
}

@end
