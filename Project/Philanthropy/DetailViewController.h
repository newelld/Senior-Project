//
//  DetailViewController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 3/19/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController{
    NSString *building;
    NSString *campus;
    NSString *description;
    IBOutlet UILabel *buildingLabel;
    IBOutlet UILabel *campusLabel;
    IBOutlet UILabel *descriptionLabel;
}
@property (nonatomic, retain)NSString *building, *campus, *description;
@property (nonatomic, retain)IBOutlet UILabel *buildingLabel, *campusLabel, *descriptionLabel;
@end
