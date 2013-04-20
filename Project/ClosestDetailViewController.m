//
//  ClosestDetailViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "ClosestDetailViewController.h"

@implementation ClosestDetailViewController
@synthesize building, campus, donorName1, donorName2, donorPic1, donorPic2, description1,
            description2, scrollView, pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem
    UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"];
    UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
    [self.view setBackgroundColor: backgroundPattern];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    //scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    self.navigationItem.title = donorName1;
    
    int numberOfViews = 1;
    if ([donorName2 isEqual: @"NULL"]) {
        CGFloat xOrigin = 0 * self.view.frame.size.width;
        UIView *donorView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, 335)];
        UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        innerScrollView.scrollEnabled = YES;
        
        UIImageView *dPic;
        dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic1]];

        
        UITextView *dDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, dPic.frame.size.height, 320, 50)];
        dDescription.editable = NO;
        dDescription.backgroundColor = [UIColor clearColor];
        [dDescription setFont:[UIFont fontWithName:@"Georgia" size:14]];
        dDescription.text = description1;
        
        [innerScrollView addSubview:dPic];
        [innerScrollView addSubview:dDescription];
        [donorView addSubview:innerScrollView];
        
        dDescription.frame = CGRectMake(dDescription.frame.origin.x, dDescription.frame.origin.y, dDescription.frame.size.width, dDescription.contentSize.height);
        innerScrollView.contentSize = CGSizeMake(320, dPic.frame.size.height +dDescription.frame.size.height);
       
        [scrollView addSubview:donorView];
    }else{
        numberOfViews = 2;
        for (int i = 0; i < 2; i++) {
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 15, self.view.frame.size.width, 20)];
            pageControl.numberOfPages = 2;
            pageControl.currentPage = i;
            pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
            CGFloat xOrigin = i * self.view.frame.size.width;
            UIView *donorView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, 325)];
            UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20)];
            
            UIImageView *dPic;
            if (i == 0)
                dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic1]];
            else
                dPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:donorPic2]];
            
            UITextView *dDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, dPic.frame.size.height, 300, 50)];
            dDescription.editable = NO;
            dDescription.backgroundColor = [UIColor clearColor];
            [dDescription setFont:[UIFont fontWithName:@"Georgia" size:14]];
            if (i == 0)
                dDescription.text = description1;
            else
                dDescription.text = description2;
            [innerScrollView addSubview:dPic];
            [innerScrollView addSubview:dDescription];
            [donorView addSubview:innerScrollView];
            
            dDescription.frame = CGRectMake(dDescription.frame.origin.x, dDescription.frame.origin.y, dDescription.frame.size.width, dDescription.contentSize.height);
            innerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, dPic.frame.size.height +dDescription.frame.size.height);
            
            UIImage *backgroundImage = [UIImage imageNamed:@"leather-background.png"]; //the background gets set twice for a
            UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];//reason
            [donorView setBackgroundColor: backgroundPattern];
            [donorView addSubview:pageControl];
            [scrollView addSubview:donorView];
        }
    }
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, self.view.frame.size.height);
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    if (page == 0)
        self.navigationItem.title = donorName1;
    else
        self.navigationItem.title = donorName2;
    
}

@end
