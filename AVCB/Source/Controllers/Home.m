//
//  Home.m
//  AVCB
//
//  Created by Stefanini on 2212//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import "Home.h"
#import "AppDelegate.h"
#import "Util.h"

@interface Home ()

@end

@implementation Home
{
    __strong ZBarReaderViewController *_reader;
    BOOL firstTimeUpdateLocation;
    BOOL internet;
    double jsonLatitude;
    double jsonLongitude;
    long stCodAuto;
    CLLocation *atualLocation;
    CLLocation *jsonLocation;
    CLLocationManager *locationManager;
    CLGeocoder *fgeo;
    NSMutableData *urlData;
    AppDelegate *delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    firstTimeUpdateLocation = YES;
    _reader = [ZBarReaderViewController new];
    _reader.readerDelegate = self;
    _reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    [_reader setTracksSymbols:YES];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = 500;
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (firstTimeUpdateLocation)
    {
        atualLocation = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        
        firstTimeUpdateLocation = NO;
    }
}

-(NSDictionary*)formatterToDictionary: (NSString *)codigoQR
{
    NSDictionary *jsonFormatter;
    NSData *data = [codigoQR dataUsingEncoding:NSUTF8StringEncoding];
    jsonFormatter = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonFormatter;
}

-(void)chamadaServico:(NSDictionary *)chave
{
    delegate = [[UIApplication sharedApplication] delegate];
    // exibe o activity indicator
    [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:[[UIApplication sharedApplication] delegate] withObject:nil];
    
    // acessando os nossos resources
    NSString *pathAppSettings = [[NSBundle mainBundle] pathForResource:@"AVCB-Configuracoes" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:pathAppSettings];
    
    // obtendo usuario e senha
    NSString *user = (NSString*)[dict objectForKey:@"User"];
    NSString *password = (NSString*)[dict objectForKey:@"Password"];
    
    // obtendo nossa url base
    NSString *ApiUrlBase = (NSString*)[dict objectForKey:@"Url_Desenvolvimento"];

    // iniciando a requisicao
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // obtendo usuario e senha da resquisicao
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", user, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    // encodando esse usuario e senha
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    // setando a url
    [request setURL:[NSURL URLWithString:ApiUrlBase]];
    // setando o metodo
    [request setHTTPMethod:@"POST"];
    // setando os headers
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // setando o body
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:chave options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSString *conteudoBody = jsonString;

    
    [request setHTTPBody:[conteudoBody dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection){
        urlData = [NSMutableData data];
    }
    else{
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Não foi possivel estabelecer conexão com o servidor"
                               message:@"Tente novamente"
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
}

#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    urlData = [[NSMutableData alloc] init];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    stCodAuto = [httpResponse statusCode];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [urlData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [delegate hideActivityViewer];
    
    if (error.code == -1009)
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Erro"
                               message:@"Você está sem conexão com a internet."
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
    else
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Erro"
                               message:error.localizedDescription
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    if (stCodAuto != 200)
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Erro"
                               message:responseData
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
    else
    {
        jsonLocation = [[CLLocation alloc] initWithLatitude:jsonLatitude longitude:jsonLongitude];
        double distance = [atualLocation distanceFromLocation:jsonLocation];

        NSDictionary *codigoJson = [self formatterToDictionary: responseData];
        [[Util shared] setDistance:distance];
        [[Util shared] setRespostaChamada:codigoJson];
        [self performSegueWithIdentifier:@"seguePesquisa" sender:nil];
           
    }
    [delegate hideActivityViewer];
}

#pragma mark - ZBarDelegate
-(void)readerView:(ZBarReaderView *)readerView didStopWithError:(NSError *)error
{
    
}

-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    
}

-(void)readerViewDidStart:(ZBarReaderView *)readerView
{
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
}

-(void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    ZBarSymbol *symbol = nil;
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    for(symbol in results)
        break;
    
    
    NSString* txtCodigo = symbol.data;
    NSDictionary *codigoJson;
    
    //verificar se o modelo de qrcode é antigo
    
    BOOL modeloAVCB = [txtCodigo rangeOfString:@"AVCB:"].location != NSNotFound;
    BOOL modeloCLCB = [txtCodigo rangeOfString:@"CLCB:"].location != NSNotFound;
    
    if (modeloAVCB)
    {
        // chamamos a url do bombeiro
        [self performSegueWithIdentifier:@"segueWebView" sender:@"http://www2.policiamilitar.sp.gov.br/SGSCI/PUBLICO/PESQUISARAVCB.ASPX"];
    }
    else if (modeloCLCB) {
        [self performSegueWithIdentifier:@"segueWebView" sender:@"http://www2.policiamilitar.sp.gov.br/SGSCI/PUBLICO/PESQUISARCLCB.ASPX"];
    }
    else
    {
        codigoJson = [self formatterToDictionary: txtCodigo];
        if (codigoJson == NULL)
        {
            [[[UIAlertView alloc] initWithTitle:@"Atenção"  message:@"QRCode Inválido!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        else
        {
            NSDictionary *qrcode = [codigoJson objectForKey:@"qrcode"];
            NSString *chave = [qrcode objectForKey:@"ID"];
            jsonLatitude = [[qrcode objectForKey:@"Latitude"] doubleValue];
            jsonLongitude = [[qrcode objectForKey:@"Longitude"] doubleValue];
            [self chamadaServico:@{@"chave":chave}];
        }
    }
    
    [_reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueWebView"]) {
        WebViewController *webViewController = [segue destinationViewController];
        webViewController.url = (NSString *)sender;
    }
}

#pragma mark - IBActions
- (IBAction)btnScannerQR:(id)sender
{
    [self presentViewController:_reader animated:YES completion:nil];
}

@end
