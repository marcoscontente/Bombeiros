//
//  AutoRes.h
//  AVCB
//
//  Created by Stefanini on 2711//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mapping.h"

@interface AutoRes : NSObject <Mapping>

@property (nonatomic, strong) NSString *numeroAVCB;
@property (nonatomic, strong) NSString *razaoSocial;
@property (nonatomic, strong) NSString *endereco;
@property (nonatomic, strong) NSString *complemento;
@property (nonatomic, strong) NSString *municipio;
@property (nonatomic, strong) NSString *ocupacao;
@property (nonatomic, strong) NSString *areaTotal;

@end
