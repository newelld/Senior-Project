//
//  DetailViewController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 4/7/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController{
    NSString *building;
    NSString *campus;
    NSString *description;
    NSString *donor;
    IBOutlet UILabel *buildingLabel;
    IBOutlet UILabel *campusLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *donorLabel;
}
@property (nonatomic, retain)NSString *building, *campus, *description, *donor;
@property (nonatomic, retain)IBOutlet UILabel *buildingLabel, *campusLabel, *descriptionLabel, *donorLabel;
@end
