//
//  AppDelegate.h
//  AVCB
//
//  Created by Stefanini on 2611//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// ActivityView
@property (strong, atomic)UIView* activityView;

-(void) showActivityViewer;
-(void) hideActivityViewer;


@end

