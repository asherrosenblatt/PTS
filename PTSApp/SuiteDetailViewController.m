//
//  SuiteDetailViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 9/25/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "SuiteDetailViewController.h"
#import <LazyPDFKit/LazyPDFKit.h>

@interface SuiteDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *suitesTableView;
@property (strong, nonatomic) IBOutlet UIImageView *suiteImageView;
@property (strong, nonatomic) IBOutlet UILabel *left1Label;
@property (strong, nonatomic) IBOutlet UILabel *left2Label;
@property (strong, nonatomic) IBOutlet UILabel *right1Label;
@property (strong, nonatomic) IBOutlet UILabel *right2Label;
@property (strong, nonatomic) IBOutlet UILabel *bottomLongLabel;
@property NSArray *suites;
@property PFObject *selectedSuite;

@end

@implementation SuiteDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadSuites];
}

-(void)loadSuites
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Suite"];
    if (self.suiteCode)
    {
        [query whereKey:@"suiteCode" equalTo:self.suiteCode];
    }
    else
    {
        [query whereKey:@"buildingID" equalTo:self.buildingID];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.suites = objects;
            [self displaySuite:self.suites.firstObject];
            self.selectedSuite = self.suites.firstObject;
            [self.suitesTableView reloadData];
        }
    }];
}

-(void)displaySuite :(PFObject *)suite
{
    [suite fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.left1Label.text = object[@"left1Label"];
        self.left2Label.text = object[@"left2Label"];
        self.right1Label.text = object[@"right1Label"];
        self.right2Label.text = object[@"right2Label"];
        self.bottomLongLabel.text = object[@"bottomLongLabel"];
        PFFile *imageData = object[@"suiteImage"];
        [imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (data) {
                self.suiteImageView.image = [UIImage imageWithData:data];
            }
        }];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.suitesTableView dequeueReusableCellWithIdentifier:@"ID"];
    PFObject *suite = [self.suites objectAtIndex:indexPath.row];
    cell.textLabel.text = suite[@"suiteNumber"];
    cell.detailTextLabel.text = suite[@"left2Label"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suites.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *suite = [self.suites objectAtIndex:indexPath.row];
    [self displaySuite:suite];
    self.selectedSuite = suite;
}


-(void)downloadPDF
{
    PFFile *pdfFile = self.selectedSuite[@"pdf"];
    [pdfFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if ( data )
        {
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];

            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"suitePDF.pdf"];
            [data writeToFile:filePath atomically:NO];
            [self openLazyPDF];
        }
    }];
}

- (IBAction)open:(id)sender
{
    [self downloadPDF];
}
- (void)openLazyPDF
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)

    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString  *documentsDirectory = [paths objectAtIndex:0];

    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"suitePDF.pdf"]; // Path to first PDF file

    LazyPDFDocument *document = [LazyPDFDocument withDocumentFilePath:filePath password:phrase];

    if (document != nil) // Must have a valid LazyPDFDocument object in order to proceed with things
    {
        LazyPDFViewController *lazyPDFViewController = [[LazyPDFViewController alloc] initWithLazyPDFDocument:document];

        lazyPDFViewController.delegate = self; // Set the LazyPDFViewController delegate to self

#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)

        [self.navigationController pushViewController:lazyPDFViewController animated:YES];

#else // present in a modal view controller

        lazyPDFViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        lazyPDFViewController.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:lazyPDFViewController animated:YES completion:NULL];

#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [LazyPDFDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}




#pragma mark - LazyPDFViewControllerDelegate methods

- (void)dismissLazyPDFViewController:(LazyPDFViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        NSString  *documentsDirectory = [paths objectAtIndex:0];

        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"suitePDF.pdf"];

        PFFile *file = [PFFile fileWithData:[NSData dataWithContentsOfFile:filePath]];

        self.selectedSuite[@"pdf"] = file;

        [self.selectedSuite saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"saved");
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];

            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"suitePDF.pdf"];
            NSData *blankData = [NSData new];
            [blankData writeToFile:filePath atomically:YES];
        }];
    }];
}


@end
