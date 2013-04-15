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
    UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"];
    UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
    [self.view setBackgroundColor: backgroundPattern];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.pagingEnabled = YES;
    NSInteger numberOfViews = 2;
    if (numberOfViews == 2) {
        for (int i = 0; i < 2; i++) {
            CGFloat xOrigin = i * self.view.frame.size.width;
            UIView *donorView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, 335)];
            UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 335)];
            innerScrollView.scrollEnabled = YES;
            
            UIImageView *dPic;
            if (i == 0)
                dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic1]];
            else
                dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic2]];
            
            UITextView *dDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, dPic.frame.size.height, 320, 50)];
            dDescription.editable = NO;
            dDescription.backgroundColor = [UIColor clearColor];
            [dDescription setFont:[UIFont fontWithName:@"Georgia" size:14]];
            if (i == 0)
                dDescription.text = description1;
            else
                dDescription.text = description2;
            
            [innerScrollView addSubview:dPic];
            [innerScrollView addSubview:dDescription];
            [donorView addSubview:innerScrollView];
            UIImageView *plate = [[UIImageView alloc] initWithFrame:CGRectMake(0, 335, self.view.frame.size.width, 50)];
            [plate setImage:[UIImage imageNamed:@"plate.png"]];
            
            UILabel *donorsName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, plate.frame.size.width, plate.frame.size.height)];
            if (i == 0)
                donorsName.text = donorName1;
            else
                donorsName.text = donorName2;
            donorsName.adjustsFontSizeToFitWidth=YES;
            donorsName.backgroundColor = [UIColor clearColor];
            donorsName.textColor = [UIColor colorWithRed:255/255.0f green:242/255.0f blue:218/255.0f alpha:1.0f];
                     
            donorsName.textAlignment =  NSTextAlignmentCenter;
            [donorsName setFont:[UIFont fontWithName:@"Gil Sans" size:24]];
            [plate addSubview:donorsName];
            [donorView addSubview:plate];
            
            UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"]; //the background gets set twice for a
            UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];//reason
            [donorView setBackgroundColor: backgroundPattern];
            [scrollView addSubview:donorView];
        }
    }
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, self.view.frame.size.height);
    [self.view addSubview:scrollView];
    
//    self.navigationItem.title = building;
//    donorsName.text = donorName1;
//    donorsName.adjustsFontSizeToFitWidth=YES;
//    
//    UIImageView *dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic1]];
//    UITextView *dDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, dPic.frame.size.height, 320, 50)];
//    dDescription.editable = NO;
//    dDescription.backgroundColor = [UIColor clearColor];
//    [dDescription setFont:[UIFont fontWithName:@"Georgia" size:14]];
//    
//    dDescription.text = description1;
//    
//    [scrollview addSubview:dPic];
//    [scrollview addSubview:dDescription];
//    
//    
//    dDescription.frame = CGRectMake(dDescription.frame.origin.x, dDescription.frame.origin.y, dDescription.frame.size.width, dDescription.contentSize.height);
//    scrollview.contentSize = CGSizeMake(320, dPic.frame.size.height +dDescription.frame.size.height);
//    
//    UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"];
//    UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
//    [self.view setBackgroundColor: backgroundPattern];
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
