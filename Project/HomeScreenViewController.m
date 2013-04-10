//
//  HomeScreenViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController
@synthesize logoView, imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.tabBarItem.title = @"Home";
        self.tabBarItem.image = [UIImage imageNamed:@"house.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    [self.logoView setImage:[UIImage imageNamed:@"LakerLegacies.png"]];
    
    imageView.animationImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"Zumberge, James.jpg"],
                       [UIImage imageNamed:@"Weed, Ella.jpg"],
                       [UIImage imageNamed:@"Seidman, Bill.jpg"],
                       [UIImage imageNamed:@"Seidman, Bill and Sally.jpg"],
                       [UIImage imageNamed:@"Secchia, Peter.jpg"],
                       [UIImage imageNamed:@"Pew, Robert.jpg"],
                       [UIImage imageNamed:@"Padnos, Seymour.jpg"],
                       [UIImage imageNamed:@"Niemeyer, Glenn.jpg"],
                       [UIImage imageNamed:@"Murray, Mark.jpg"],
                       [UIImage imageNamed:@"Meijer, Fred.jpg"],
                       [UIImage imageNamed:@"Lubbers, Don.jpg"],
                       [UIImage imageNamed:@"Kirkhof, Russel.jpg"],
                       [UIImage imageNamed:@"Kennedy, John.jpg"],
                       [UIImage imageNamed:@"Keller, Fred.jpg"],
                       [UIImage imageNamed:@"Johnson, Paul.jpg"],
                       [UIImage imageNamed:@"Eberhard, LV.jpg"],
                       [UIImage imageNamed:@"DeVos, Rich.jpg"],
                       [UIImage imageNamed:@"Cook, Peter.jpg"],
                       [UIImage imageNamed:@"Cook, Peter & Pat.jpg"],
                       [UIImage imageNamed:@"Art Hills.jpg"],
                       nil];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.animationDuration = 40.0;
    imageView.animationRepeatCount = 0;

    [imageView startAnimating];
    [self.view addSubview:imageView];
    [self.view addSubview:logoView];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
