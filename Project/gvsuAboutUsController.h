//
//  gvsuAboutUsController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 4/28/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gvsuAboutUsController : UIViewController {
    IBOutlet UIButton *dismissViewButton;
}

- (IBAction)dismissView:(id)sender;

@property (nonatomic, retain) UIButton *dismissViewButton;

@end
