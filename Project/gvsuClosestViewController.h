//
//  gvsuClosestViewController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 3/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gvsuCLController.h"

@interface gvsuClosestViewController : UIViewController <gvsuCLControllerDelegate>{
    IBOutlet UILabel *locationLabel;
    IBOutlet UIImageView *locationPic;
    
    gvsuCLController *clController;
    NSArray *data;
    NSDictionary *building;
}

- (void)locationDisplay:(CLLocation *) location;
- (void)locationError:(NSError *) error;
- (void)closestBuilding;

@end

