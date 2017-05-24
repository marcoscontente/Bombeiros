//
//  Informacao.m
//  AVCB
//
//  Created by Vinicius on 9/15/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "Informacao.h"
@import SafariServices;

@interface Informacao () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation Informacao

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSString *path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
  
    if ([self.fileName isEqualToString:@"Information"]) {
        self.navigationItem.title = @"Consulta Licenças";
    } else {
        self.navigationItem.title = @"O que é QRCode";
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        if ([SFSafariViewController class] != nil) {
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:request.URL];
            [self presentViewController:safariViewController animated:true completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:request.URL];
        }
      
        return NO;
    }
    return  true;
}

@end
