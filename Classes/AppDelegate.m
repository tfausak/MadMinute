//
//  AppDelegate.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize reachabilityAlertView;
@synthesize window;
@synthesize navigationController;

- (void)dealloc {
    [reachabilityAlertView release];
    [window release];
    [navigationController release];
    [super dealloc];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set some defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FC_d_api_key] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:kAPIKey forKey:FC_d_api_key];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfPlayersKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:kNumberOfPlayersKey];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGameTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    [self networkReachabilityDidChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChange) name:@"kNetworkReachabilityChangedNotification" object:nil];
    
    // Set up the Famigo instance
    [[Famigo sharedInstance] setSkipInvites:NO];
    [[Famigo sharedInstance] setAllFamigoPlayers:YES];
    [[Famigo sharedInstance] setGame_name:kGameName];
    [[Famigo sharedInstance] setGame_instructions:kGameInstructions];
    [[Famigo sharedInstance] registerForNotifications:navigationController withSelector:@selector(didReceiveFamigoNotification:)];
	
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
    if ([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == PassAndPlayWithFamigo || [[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == MultiDeviceWithFamigo) {
            reachabilityAlertView = [[UIAlertView alloc] initWithTitle:@"Internet access required" message:@"This application requires internet access. This message will automatically be dismissed when network access is restored." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [reachabilityAlertView show];
        }
    }
    else if (reachabilityAlertView != nil) {
        [reachabilityAlertView dismissWithClickedButtonIndex:0 animated:YES];
        [reachabilityAlertView release];
        reachabilityAlertView = nil;
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
    
    // A negative launch count means they already reviewed or said they don't want to
    if (appLaunchCount < 0 || [[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
        return NO;
    }
    
    // Update the app launch count
    [[NSUserDefaults standardUserDefaults] setInteger:appLaunchCount + 1 forKey:kAppLaunchCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return appLaunchCount >= kPromptOnAppLaunchCount;
}

- (void)promptUserToReview {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Review %@?", kGameName] message:[NSString stringWithFormat:@"We notice that you've played %@ a few times now. Would you help new people find the game by reviewing it now?", kGameName] delegate:self cancelButtonTitle:@"Don't ask me again" otherButtonTitles:@"Yes, review it now!", @"Remind me later", nil];
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
            [[NSUserDefaults standardUserDefaults] setInteger:-2 forKey:kAppLaunchCountKey];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kAppLaunchCountKey];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Redirect to the review page if necessary
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreReviewUrl]];
    }
}

@end