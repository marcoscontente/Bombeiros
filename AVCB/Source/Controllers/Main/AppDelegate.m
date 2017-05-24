//
//  AppDelegate.m
//  AVCB
//
//  Created by Stefanini on 2611//14.
//  Copyright (c) 2014 Prodesp. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(3);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ActivityView
-(void) showActivityViewer
{
    __weak UIWindow *window = self.window;
    self.activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
    self.activityView.backgroundColor = [UIColor blackColor];
    self.activityView.alpha = 0.5;
    
    /*
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((window.bounds.size.width-LABEL_WIDTH)/2+20, (window.bounds.size.height-LABEL_HEIGHT)/2, LABEL_WIDTH, LABEL_HEIGHT)];
     
     label.text = @"Aguarde";
     label.center = window.center;
     label.backgroundColor = [UIColor clearColor];
     label.textColor = [UIColor whiteColor];*/
    
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityWheel.frame = CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24);
    /*CGRectMake(label.frame.origin.x,// - LABEL_HEIGHT - 10,
     label.frame.origin.y,
     LABEL_HEIGHT,
     LABEL_HEIGHT);*/
    
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin  |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin   |
                                      UIViewAutoresizingFlexibleBottomMargin );
    activityWheel.color = [UIColor whiteColor];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.activityView addSubview:activityWheel];
    
    [window addSubview: self.activityView];
    
    [[[self.activityView subviews] objectAtIndex:0] startAnimating];
  });
}

-(void) hideActivityViewer
{
    if ([self.activityView subviews].count > 0) {
        [[[self.activityView subviews] objectAtIndex:0] stopAnimating];
    }
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

@end
