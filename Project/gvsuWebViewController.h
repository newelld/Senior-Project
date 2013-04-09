//
//  gvsuWebViewController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gvsuWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end