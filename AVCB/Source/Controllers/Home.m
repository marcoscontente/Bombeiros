//
//  Home.m
//  AVCB
//
//  Created by Stefanini on 2212//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
// teste

#import "Home.h"
#import "AppDelegate.h"
#import "Util.h"
#import "Reachability.h"
#import "Informacao.h"
#import "AVCB-Swift.h"

@import CoreLocation;

@interface Home ()

@property (nonatomic, strong) ZBarReaderViewController *reader;
@end

@implementation Home
{
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
    NSString *responseData;
    Reachability* internetReachable;
    IBOutlet UIButton *qrButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    firstTimeUpdateLocation = YES;
    self.reader = [[ZBarReaderViewController alloc] init];
    self.reader.readerDelegate = self;
    self.reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    self.reader.view.tintColor = [UIColor whiteColor];
    [self.reader setTracksSymbols:YES];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
  
    [qrButton setBackgroundImage:[qrButton.currentBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
  
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if ([[segue identifier] isEqualToString:@"segueWebView"]) {
        WebViewController *webViewController = [segue destinationViewController];
        webViewController.url = (NSString *)sender;
    } else if ([segue.identifier isEqualToString:@"segueInformacao"]) {
      Informacao *informacao = (Informacao *)segue.destinationViewController;
      if ([sender isKindOfClass:[NSString class]]) {
        informacao.fileName = (NSString *)sender;
      }
    } else if ([segue.identifier isEqualToString:@"SegueLicencaDetail"]) {
      LicencaDetailViewController *licencaDetailViewController = (LicencaDetailViewController *)segue.destinationViewController;
      licencaDetailViewController.licenca = (Licenca *)sender;
    }
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
    [NSThread detachNewThreadSelector:@selector(showActivityViewer) toTarget:[[UIApplication sharedApplication] delegate] withObject:nil];
    
    // acessando os nossos resources
    NSString *pathAppSettings = [[NSBundle mainBundle] pathForResource:@"AVCB-Configuracoes" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:pathAppSettings];
    
    // obtendo usuario e senha
    NSString *user = (NSString*)[dict objectForKey:@"User"];
    NSString *password = (NSString*)[dict objectForKey:@"Password"];
    
    // obtendo nossa url base
    NSString *ApiUrlBase = (NSString*)[dict objectForKey:@"Url_Producao"];

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
                               initWithTitle:@"Erro de conexão"
                               message:@"Ocorreu um erro ao processar a requisição, tente novamente."
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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideActivityViewer];
    
    if (error.code == -1009)
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Erro de conexão"
                               message:@"Não obtivemos sucesso em sua consulta. Para verificar a validade ou autenticidade da Licença, acesso o Portal do Via Fácil Bombeiros na internet: www.corpodebombeiros.sp.gov.br"
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
    else
    {
        NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
        if (internetStatus == NotReachable)
        {
            UIAlertView *alerta = [[UIAlertView alloc]
                                   initWithTitle:@"Erro de conexão"
                                   message:@"Não obtivemos sucesso em sua consulta. Para verificar a validade ou autenticidade da Licença, acesso o Portal do Via Fácil Bombeiros na internet: [www.corpodebombeiros.sp.gov.br]www.corpodebombeiros.sp.gov.br"
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc]
                                   initWithTitle:@"Erro de conexão"
                                   message:@"Não obtivemos sucesso em sua consulta. Tente novamente."
                                   delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
            [alerta show];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    if (stCodAuto == 200)
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            jsonLocation = [[CLLocation alloc] initWithLatitude:jsonLatitude longitude:jsonLongitude];
            atualLocation = locationManager.location;
          
            NSDictionary *codigoJson = [self formatterToDictionary: responseData];
          
          NSString *logradouro = codigoJson[@"DadosLogradouro"];
          if (logradouro && logradouro.length > 0) {
            [[CLGeocoder new] geocodeAddressString:codigoJson[@"DadosLogradouro"] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
              CLPlacemark *placemark = placemarks.firstObject;
              jsonLatitude = placemark.location.coordinate.latitude;
              jsonLongitude = placemark.location.coordinate.longitude;
              jsonLocation = placemark.location;
              double distance;
              if (jsonLatitude == 0 && jsonLongitude == 0) {
                distance = -1;
              } else {
                distance = [atualLocation distanceFromLocation:jsonLocation];
              }
              [[Util shared] setDistance:distance];
              [[Util shared] setRespostaChamada:codigoJson];
              [[Util shared] setLocalizacaoHabilitado:YES];
              Licenca *licenca = [[Licenca alloc] init:codigoJson];
              
              
              dispatch_async(dispatch_get_main_queue(), ^{
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideActivityViewer];
              });
              
              [self performSegueWithIdentifier:@"SegueLicencaDetail" sender:licenca];
            }];
            
            return;
          } else {
              double distance;
              if (jsonLatitude == 0 && jsonLongitude == 0) {
                distance = -1;
              } else {
                distance = [atualLocation distanceFromLocation:jsonLocation];
              }
              [[Util shared] setDistance:distance];
              [[Util shared] setRespostaChamada:codigoJson];
              [[Util shared] setLocalizacaoHabilitado:YES];
              Licenca *licenca = [[Licenca alloc] init:codigoJson];
              
              [self performSegueWithIdentifier:@"SegueLicencaDetail" sender:licenca];
            
          }

          
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc]
                                   initWithTitle:@"Aviso"
                                   message:@"Habilite seu GPS para verificar se a sua localização é próxima ao logradouro da licença"
                                   delegate:self
                                   cancelButtonTitle:@"Cancelar"
                                   otherButtonTitles:@"Configurações", nil];
            [alerta show];
        }
    }
    else if (stCodAuto == 400)
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Aviso"
                               message:responseData
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
    else
    {
        UIAlertView *alerta = [[UIAlertView alloc]
                               initWithTitle:@"Erro de conexão"
                               message:@"Nào obtivemos sucesso em sua consulta, tente novamente."
                               delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alerta show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideActivityViewer];
    });
}

#pragma mark - ZBarDelegate
-(void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    ZBarSymbol *symbol = nil;
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
  
    for(symbol in results)
      break;
  
    NSString* txtCodigo = symbol.data;
    NSDictionary *codigoJson = [self formatterToDictionary: txtCodigo];
  
  
  
  BOOL modeloAVCB = [txtCodigo rangeOfString:@"AVCB:"].location != NSNotFound;
  BOOL modeloCLCB = [txtCodigo rangeOfString:@"CLCB:"].location != NSNotFound;
  BOOL modeloSLCB = [txtCodigo rangeOfString:@"SLCB:"].location != NSNotFound;
  
  // acessando os nossos resources
  NSString *pathAppSettings = [[NSBundle mainBundle] pathForResource:@"AVCB-Configuracoes" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:pathAppSettings];
  
  if (modeloAVCB) {
    [self performSegueWithIdentifier:@"segueWebView" sender:[dict objectForKey:@"Url_AVCB"]] ;
  } else if (modeloCLCB || modeloSLCB) {
    [self performSegueWithIdentifier:@"segueWebView" sender:[dict objectForKey:@"Url_CLCB"]];
  } else {
    codigoJson = [self formatterToDictionary: txtCodigo];
    if (codigoJson == NULL) {
      [self performSegueWithIdentifier:@"segueWebView" sender:@"http://www.corpodebombeiros.sp.gov.br"];
    } else {
      NSDictionary *qrCode = [codigoJson objectForKey:@"qrcode"];
      if (qrCode && [qrCode objectForKey:@"Certidao"] != nil) {
        [self chamadaServico:codigoJson];
      } else if (qrCode && [qrCode objectForKey:@"ID"] != nil) {
        [self chamadaServico:@{@"chave": [qrCode objectForKey:@"ID"]}];
      } else {
        [self performSegueWithIdentifier:@"segueWebView" sender:@"http://www.corpodebombeiros.sp.gov.br"];
      }
    }
  }
  
  [self.reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions
- (IBAction)btnScannerQR:(id)sender
{
    [self presentViewController:self.reader animated:YES completion:nil];
}

- (IBAction)verInformacoes:(id)sender {
    [self performSegueWithIdentifier:@"segueInformacao" sender:@"Information"];
}

- (IBAction)qrCodeInfoTapped:(id)sender {
  [self performSegueWithIdentifier:@"segueInformacao" sender:@"QRCode"];
}

- (IBAction)call193:(id)sender {
  NSURL *call193Url = [NSURL URLWithString:@"tel://193"];
  [[UIApplication sharedApplication] openURL:call193Url];
}

#pragma mark - Alert Dekegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
    else
    {
        NSDictionary *codigoJson = [self formatterToDictionary: responseData];
        [[Util shared] setRespostaChamada:codigoJson];
        [[Util shared] setLocalizacaoHabilitado:NO];
        [self performSegueWithIdentifier:@"seguePesquisa" sender:nil];
    }

}

@end
