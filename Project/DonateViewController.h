//
//  DonateViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end