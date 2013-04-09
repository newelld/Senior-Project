//
//  DetailViewController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 3/19/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    NSString *building;
    NSString *campus;
    NSString *description;
    NSString *donor;
    NSString *donorName;
    IBOutlet UILabel *buildingLabel;
    IBOutlet UILabel *campusLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *donorLabel;
}
@property (nonatomic, retain)NSString *building, *campus, *description, *donor, *donorName;
@property (nonatomic, retain)IBOutlet UILabel *buildingLabel, *campusLabel, *descriptionLabel, *donorLabel;

@end
