//
//  ClosestViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gvsuCLController.h"



@interface ClosestViewController : UIViewController

<UITableViewDataSource, UITableViewDelegate, gvsuCLControllerDelegate>{
    IBOutlet UILabel *locationLabel;
    IBOutlet UIImageView *locationPic;
    
    gvsuCLController *clController;
    NSArray *data;
    NSMutableArray *filteredData;
    NSDictionary *building;
}

- (void)locationDisplay:(CLLocation *) location;
- (void)locationError:(NSError *) error;
- (void)closestBuilding;

@end
