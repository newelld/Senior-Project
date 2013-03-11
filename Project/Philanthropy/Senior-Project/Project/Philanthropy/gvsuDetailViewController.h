//
//  gvsuDetailViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 1/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gvsuDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
 