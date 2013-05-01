//
//  HomeScreenViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenViewController : UIViewController {
       
    IBOutlet UIImageView *logoView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *aboutUs;
}

@property(nonatomic, strong) IBOutlet UIImageView *logoView, *imageView;
@property(nonatomic, strong) IBOutlet UIButton *aboutUs;

- (IBAction)showAboutUs:(id)sender;

@end
