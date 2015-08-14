//
//  WebViewController.m
//  AVCB
//
//  Created by Vinicius on 8/13/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewParam {
    [act stopAnimating];
    [UIView animateWithDuration:.5 animations:^{
        webView.alpha = 1.0;
    }];
}

@end
