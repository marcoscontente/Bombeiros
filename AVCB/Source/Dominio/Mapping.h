//
//  Mapping.h
//  AVCB
//
//  Created by Stefanini on 2711//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol Mapping <NSObject>

-(void) responseMap:(RKObjectMapping*)mapping;

@end

