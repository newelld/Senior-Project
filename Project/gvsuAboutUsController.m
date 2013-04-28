//
//  gvsuAboutUsController.m
//  Philanthropy
//
//  Created by Thomas Peterson on 4/28/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "gvsuAboutUsController.h"

@interface gvsuAboutUsController ()

@end

@implementation gvsuAboutUsController
@synthesize dismissViewButton;

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
    
    [self.view addSubview:dismissViewButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
