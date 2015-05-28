//
//  Home.h
//  AVCB
//
//  Created by Stefanini on 2212//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZBarSDK.h>
#import <ZBarReaderViewController.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Home : UITableViewController <ZBarReaderViewDelegate, ZBarReaderDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

- (IBAction)btnScannerQR:(id)sender;

@end