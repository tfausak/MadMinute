//
//  AppDelegate.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@class NavigationController;

@interface AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    NavigationController *navigationController;
    UIAlertView *reachabilityAlertView;
}

@property (nonatomic, retain, readonly) UIWindow *window;
@property (nonatomic, retain, readonly) NavigationController *navigationController;
@property (nonatomic, retain, readonly) UIAlertView *reachabilityAlertView;

- (void)networkReachabilityDidChange;
- (BOOL)shouldPromptUserToReview;
- (void)promptUserToReview;

@end