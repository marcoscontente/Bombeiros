//
//  AutoRes.m
//  AVCB
//
//  Created by Stefanini on 2711//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import "AutoRes.h"

@implementation AutoRes

-(void) responseMap:(RKObjectMapping*)mapping
{
    [mapping addAttributeMappingsFromDictionary:
     @{@"numeroAVCB"    : @"numeroAVCB",
       @"razaoSocial"   : @"razaoSocial",
       @"endereco"      : @"endereco",
       @"complemento"   : @"complemento",
       @"municipio"     : @"municipio",
       @"ocupacao"      : @"ocupacao",
       @"areaTotal"     : @"areaTotal"}
     ];
}

@end
