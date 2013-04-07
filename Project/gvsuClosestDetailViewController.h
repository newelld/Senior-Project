//
//  gvsuClosestDetailViewController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 4/7/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gvsuClosestDetailViewController : UIViewController
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end