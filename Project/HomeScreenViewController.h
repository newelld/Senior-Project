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
    UIButton *aboutUs;
}

@property(nonatomic, retain) IBOutlet UIImageView *logoView, *imageView;
@property(nonatomic, retain) IBOutlet UIButton *aboutUs;

- (IBAction)showAboutUs:(id)sender;

@end
