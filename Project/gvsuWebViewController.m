//
//  gvsuWebViewController.m
//  Philanthropy
//
//  Created by Thomas Peterson on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "gvsuWebViewController.h"

@interface gvsuWebViewController ()

@end

@implementation gvsuWebViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://gvsu.edu/jcp/donate-65.htm"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    webView.scalesPageToFit = YES;
    [webView loadRequest: request];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Optional UIWebViewDelegate delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end