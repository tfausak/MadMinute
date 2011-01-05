//
//  AppDelegate.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Famigo.h"
#import "Settings.h"
#import "NavigationController.h"
#import "Reachability.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize reachabilityAlertView;

- (void)dealloc {
    [window release];
    [navigationController release];
    [reachabilityAlertView release];
    [super dealloc];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] setValue:kAPIKey forKey:FC_d_api_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Set the default number of players
    if ([Settings numberOfPlayers] == 0) {
        [Settings setNumberOfPlayers:2];
    }
    
    // Bring up the main window
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window makeKeyAndVisible];
    
    // Bring up the main view controller
    navigationController = [[NavigationController alloc] init];
    [window addSubview:[navigationController view]];
	
    // Set up Reachability
	[[Reachability sharedReachability] setAddress:kFamigoIPAddress];
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	[[Reachability sharedReachability] remoteHostStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkReachabilityDidChange)
                                                 name:@"kNetworkReachabilityChangedNotification"
                                               object:nil];
	
    // Register for push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    
    // Ask the user to review the app
    if ([self shouldPromptUserToReview]) {
        [self promptUserToReview];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Reachability

- (void)networkReachabilityDidChange {
    if ([Settings gameType] == PassAndPlayWithFamigo || [Settings gameType] == MultiDeviceWithFamigo) {
        if ([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
            if (reachabilityAlertView == nil) {
                reachabilityAlertView = [UIAlertView alloc];
                [reachabilityAlertView initWithTitle:@"Internet access required"
                                             message:@"This application requires internet access. This message will automatically be dismissed when network access is restored."
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil];
                [reachabilityAlertView show];
            }
        }
        else if (reachabilityAlertView != nil) {
            [reachabilityAlertView dismissWithClickedButtonIndex:0
                                                        animated:YES];
            [reachabilityAlertView release];
            reachabilityAlertView = nil;
        }
    }
}

#pragma mark -
#pragma mark Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[Famigo sharedInstance] setToken_id:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

#pragma mark -
#pragma mark App Store Review

- (BOOL)shouldPromptUserToReview {
    int appLaunchCount = [[NSUserDefaults standardUserDefaults] integerForKey:kAppLaunchCountKey];
    
    // Don't bug 'em if they've already reviewed (or said they don't want to)
    if (appLaunchCount < 0) {
        return NO;
    }
    
    // Update the app launch count
    [[NSUserDefaults standardUserDefaults] setInteger:appLaunchCount + 1 forKey:kAppLaunchCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // No use trying to review if there's no network access
    if ([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
        return NO;
    }
    
    return appLaunchCount >= kPromptOnAppLaunchCount;
}

- (void)promptUserToReview {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    [alertView setTitle:[NSString stringWithFormat:@"Review %@?", kGameName]];
    [alertView setMessage:[NSString stringWithFormat:@"We notice that you've played %@ a few times now. Would you help new people find the game by reviewing it now?", kGameName]];
    [alertView setDelegate:self];
    [alertView addButtonWithTitle:@"Yes, review it now!"];
    [alertView addButtonWithTitle:@"Remind me later"];
    [alertView addButtonWithTitle:@"Don't ask me again"];
    [alertView setCancelButtonIndex:2];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Update the app launch count
    switch (buttonIndex) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kAppLaunchCountKey];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAppLaunchCountKey];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setInteger:-2 forKey:kAppLaunchCountKey];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Redirect to the review page if necessary
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreReviewUrl]];
    }
}

@end