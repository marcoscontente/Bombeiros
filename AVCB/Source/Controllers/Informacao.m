//
//  Informacao.m
//  AVCB
//
//  Created by Vinicius on 9/15/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "Informacao.h"

@interface Informacao ()

@end

@implementation Informacao

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *html = @"<html><head></head><body style=\"text-align:justify;color:black;padding-left:10px;padding-right:10px;padding-top:10px;padding-bottom:10px;\">Este aplicativo permite ao cidadão consultar as Licenças emitidas pelo Corpo de Bombeiros (AVCB e CLCB). A Licença atesta que a edificação atendeu às exigências de segurança contra incêndio do Estado de São Paulo e, portanto, encontra-se regularizada perante o Corpo de Bombeiros. Verifique se a edificação que você frequenta possui segurança contra incêndio e se ela está sendo utilizada dentro das condições aprovadas. O documento de Licença do Corpo de Bombeiros deve estar afixado na entrada da edificação. Para consultar, basta apontar o leitor para o QRCode existente no documento. A consulta pelo número do documento ou pelo endereço da edificação pode ser efetuada no portal do Via Fácil Bombeiros na internet:<a href=\"http://www.corpodebombeiros.sp.gov.br\">www.corpodebombeiros.sp.gov.br</a></body></html>";
    webView.delegate = self;
    [webView loadHTMLString:html baseURL:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return  true;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
