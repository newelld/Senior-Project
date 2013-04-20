//
//  ClosestDetailViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosestDetailViewController : UIViewController <UIScrollViewDelegate>{
    NSString *building;
    NSString *campus;
    NSString *description1, *description2;
    NSString *donorName1, *donorName2;
    NSString *donorPic1, * donorPic2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL pageControlUsed;
    
    IBOutlet UITextView *donorsDescription;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain)NSString *building, *campus, *description1, *description2,
          *donorPic1, *donorPic2, *donorName1, *donorName2;
@end
