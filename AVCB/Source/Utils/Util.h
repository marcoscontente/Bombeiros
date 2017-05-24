//
//  Util.h
//  AVCB
//
//  Created by Stefanini on 2711//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Mapping.h"
#import "AutoRes.h"

@interface Util : NSObject

+(void) removeLoginTimeout;
+(BOOL) isLoginTimeout;
+(void) resetLoginTimeout;

+ (Util*) shared;
@property (nonatomic) double distance;
@property (nonatomic) BOOL localizacaoHabilitado;
@property (strong) AutoRes *resAuto;
@property (strong) NSDictionary *respostaChamada;

+(NSString*) currentUser;
+(NSString*) buildAuthToken;
+(NSDictionary*) buildAuthForUser;

+(void) authenticationForUser:(NSString*)user pass:(NSString*)pass andDate:(NSDate*)date;
- (RKResponseDescriptor*) responseWithObject:(id)obj;
- (RKRequestDescriptor*) requestWithObject:(id)obj;
@end
