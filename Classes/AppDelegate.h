//
//  AppDelegate.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "Famigo.h"
#import "Reachability.h"
#import "NavigationController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    UIAlertView *reachabilityAlertView;
    UIWindow *window;
    NavigationController *navigationController;
}

@property (nonatomic, retain) UIAlertView *reachabilityAlertView;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) NavigationController *navigationController;

- (void)networkReachabilityDidChange;
- (BOOL)shouldPromptUserToReview;
- (void)promptUserToReview;

@end