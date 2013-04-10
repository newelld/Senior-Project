//
//  ClosestDetailViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "ClosestDetailViewController.h"

@implementation ClosestDetailViewController
@synthesize building, campus, donorName1, donorName2, donorPic1, donorPic2, description1,
            description2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = building;
    donorsName.text = donorName1;
    donorsName.adjustsFontSizeToFitWidth=YES;
    
    UIImageView *dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic1]];
    UITextView *dDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, dPic.frame.size.height, 320, 50)];
    dDescription.editable = NO;
    dDescription.backgroundColor = [UIColor clearColor];
    [dDescription setFont:[UIFont fontWithName:@"Georgia" size:14]];
    
    dDescription.text = description1;
    
    [scrollview addSubview:dPic];
    [scrollview addSubview:dDescription];
    
    
    dDescription.frame = CGRectMake(dDescription.frame.origin.x, dDescription.frame.origin.y, dDescription.frame.size.width, dDescription.contentSize.height);
    scrollview.contentSize = CGSizeMake(320, dPic.frame.size.height +dDescription.frame.size.height);
    
    UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"];
    UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
    [self.view setBackgroundColor: backgroundPattern];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
