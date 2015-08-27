//
//  AVCBBanner.m
//  AVCB
//
//  Created by Vinicius on 8/27/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "AVCBBanner.h"

@implementation AVCBBanner 

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect {

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UITapGestureRecognizer *tapinha = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapinha:)];
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tapinha];
    }
    return self;
}

- (void)tapinha:(UIGestureRecognizer *)gesture {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:193"]];
}

@end
