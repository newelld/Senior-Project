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
    [self.logoView setImage:[UIImage imageNamed:@"LakerLegacies.png"]];
    
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"Senior Project Data" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:mylist];
    
    NSMutableArray *animationImages = [[NSMutableArray alloc] init];
    NSString *temp;
    
    for (int i=0;  i < [data count]; i++) {
        temp = [[data objectAtIndex:i]objectForKey:@"Donor Image 1"];
        if(temp && ![temp isEqual: @"NULL"])
            [animationImages addObject: [UIImage imageNamed:temp]];
    }
    
    imageView.animationImages = animationImages;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.animationDuration = 100.0;
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
