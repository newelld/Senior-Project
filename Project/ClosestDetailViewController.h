//
//  ClosestDetailViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosestDetailViewController : UIViewController{
    NSString *building;
    NSString *campus;
    NSString *description1, *description2;
    NSString *donorName1, *donorName2;
    NSString *donorPic1, * donorPic2;
    
    IBOutlet UILabel *donorsName;
    IBOutlet UIImageView *donorsPic;
    IBOutlet UITextView *donorsDescription;
}

@property (nonatomic, retain)NSString *building, *campus, *description1, *description2,
          *donorPic1, *donorPic2, *donorName1, *donorName2;
@end
