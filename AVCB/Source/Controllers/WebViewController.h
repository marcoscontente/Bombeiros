//
//  WebViewController.h
//  AVCB
//
//  Created by Vinicius on 8/13/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *act;
}

@property (nonatomic)NSString *url;

@end
