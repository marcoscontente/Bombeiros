//
//  WebViewController.m
//  AVCB
//
//  Created by Vinicius on 8/13/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        self.webView.scalesPageToFit = YES;
        return YES;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewParam
{
    [act stopAnimating];
    [UIView animateWithDuration:.5 animations:^{
        self.webView.alpha = 1.0;
    }];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [act stopAnimating];
    [UIView animateWithDuration:.5 animations:^{
        self.webView.alpha = 1.0;
    }];
    
    if (error.code == -1009)
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Aviso"
                               message:@"Você está sem conexão com a internet."
                               delegate:self
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
    else
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Erro"
                               message:error.localizedDescription
                               delegate:self
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
