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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www2.policiamilitar.sp.gov.br/SGSCI/PUBLICO/PESQUISARAVCB.ASPX"]]];
}

@end
