//
//  Util.m
//  AVCB
//
//  Created by Stefanini on 2711//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import "Util.h"

@implementation Util

+(void) removeLoginTimeout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timeout"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"timeout"];
}

+ (Util*) shared
{
    static Util *shared;
    if(shared == nil)
    {
        shared = [[super allocWithZone:nil] init];
    }
    return shared;
}

+(BOOL) isLoginTimeout
{
#ifdef DEBUG
    NSDate *d = [[NSUserDefaults standardUserDefaults] valueForKey:@"timeout"];
    if(d != nil)
        NSLog(@"interval for timeout: %f", [d timeIntervalSinceNow]);
#endif
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] valueForKey:@"timeout"];
    if(date == nil ||
       [date timeIntervalSinceNow] < -600) // dez minutos
    {
        return YES;
        
    }
    return NO;
}

+(void) resetLoginTimeout
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"timeout"];
}

+(NSString*) currentUser
{
    NSString *user = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    return user;
}

+(NSString*) buildAuthToken
{
    NSString *user = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:@"pass"];
    NSString *token = [NSString stringWithFormat:@"WRAP wrap_username=%@, wrap_password=%@", user, pass];
    return token;
}

+(NSDictionary*) buildAuthForUser
{
    NSString *pathAppSettings = [[NSBundle mainBundle] pathForResource:@"AVCB-Configuracoes" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:pathAppSettings];
    
    return dict;
}

+(void) authenticationForUser:(NSString*)user pass:(NSString*)pass andDate:(NSDate*)date
{
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:@"pass"];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"timeout"];
}

- (RKResponseDescriptor*) responseWithObject:(id) obj
{
    RKResponseDescriptor *descriptor = nil;
    if([obj conformsToProtocol:@protocol(Mapping)])
    {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass: [obj class]];
        [obj responseMap:mapping];
        descriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        return descriptor;
    }
    else
    {
        NSLog(@"Object %@ do not implements Mapping", obj);
        NSAssert(NO, @"Object %@ do not implements Mapping", obj);
    }
    
    return descriptor;
}

- (RKRequestDescriptor*) requestWithObject:(id) obj
{
    RKRequestDescriptor *descriptor = nil;
    if([obj conformsToProtocol:@protocol(Mapping)])
    {
        RKObjectMapping *mapping = [RKObjectMapping requestMapping];
        [obj responseMap:mapping];
        descriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping objectClass:[obj class] rootKeyPath:nil method:RKRequestMethodAny];
        return descriptor;
    }
    else
    {
        NSLog(@"Object %@ do not implements Mapping", obj);
        NSAssert(NO, @"Object %@ do not implements Mapping", obj);
    }
    
    return descriptor ;
}

@end
