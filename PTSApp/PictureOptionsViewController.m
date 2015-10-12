//
//  PictureOptionsViewController.m
//  PTSApp
//
//  Created by Asher Rosenblatt on 10/5/15.
//  Copyright © 2015 asher. All rights reserved.
//

#import "PictureOptionsViewController.h"

@interface PictureOptionsViewController ()
@property NSArray *optionsArray;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property NSData *imageData;
@end

@implementation PictureOptionsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSMutableArray *optionsArray = [NSMutableArray new];
    for (int i = 0; i < 4; i++)
    {
        NSString *obj;
        if (i == 0)
        {
            obj= @"door";
        }
        else if (i == 1)
        {
            obj = @"window";
        }
        else if (i == 2)
        {
            obj = @"cubicle";
        }
        else if (i == 3)
        {
            obj = @"wall";
        }
        [optionsArray addObject:obj];
    }
    self.optionsArray = optionsArray;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    
    self.carousel.type = iCarouselTypeCoverFlow2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    //free up memory by releasing subviews
    self.carousel = nil;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.optionsArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;

    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:[self.optionsArray objectAtIndex:index]];
        view.contentMode = UIViewContentModeScaleAspectFit;

        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.textColor = [UIColor whiteColor];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }

    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [self.optionsArray objectAtIndex:index];

    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return 240;
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}


- (IBAction)onAddUpdatePressed:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{

    if (image)
    {

        [self dismissViewControllerAnimated:YES completion:^{
            self.imageData = UIImagePNGRepresentation(image);
            //[self.uploadButton setAlpha:1];
            //[self.uploadButton setEnabled:YES];
        }];

    }
    
    
}

@end
