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
    IBOutlet UILabel *buildingLabel;
    IBOutlet UILabel *campusLabel;
}
@property (nonatomic, retain)NSString *building, *campus;
@property (nonatomic, retain)IBOutlet UILabel *buildingLabel, *campusLabel;
@end
