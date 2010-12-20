//
//  AppDelegate.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize madMinuteController;

- (void)dealloc {
    [window release];
    [madMinuteController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[NSUserDefaults standardUserDefaults] setValue:kAPIKey forKey:FC_d_api_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Set up the Famigo instance
    [[Famigo sharedInstance] setSkipInvites:NO];
    [[Famigo sharedInstance] setAllFamigoPlayers:YES];
    [[Famigo sharedInstance] setGame_name:kGameName];
    [[Famigo sharedInstance] setGame_instructions:kGameInstructions];
	
    // Set up Reachability
	[[Reachability sharedReachability] setAddress:kFamigoIPAddress];
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	[[Reachability sharedReachability] remoteHostStatus];
	
    // Register for notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    
    // Create a new frame below the status bar
    CGRect frame = [window frame];
    if (![UIApplication sharedApplication].statusBarHidden) {
        frame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    // Start the main view controller
    madMinuteController = [[MadMinuteController alloc] init];
    [[madMinuteController view] setFrame:frame];
    [window addSubview:[madMinuteController view]];
    [window makeKeyAndVisible];
	
    // After everything else, figure out if the user should be prompted to review
	[self evaluateTimeForReview];
    
    return YES;
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

-(void)evaluateTimeForReview {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSNumber *appLaunchCount = [userDefaults valueForKey:kAppLaunchCountKey];
    if (appLaunchCount == nil) {
		appLaunchCount = [NSNumber numberWithInt:0];
	}
    
    if ([appLaunchCount intValue] == kPromptForReviewOnLaunchCount) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Help us by reviewing %@!", kGameName]
													 message:[NSString stringWithFormat:@"We notice that you've played %@ a few times now. Would you help new people find the game by reviewing it now?", kGameName]
													delegate:self 
										   cancelButtonTitle:@"No thanks"
										   otherButtonTitles:@"Sure!",nil];
		[av show];
		[av release];
    }
	
	[userDefaults setValue:[NSNumber numberWithInt:([appLaunchCount intValue] + 1)] forKey:kAppLaunchCountKey];
	[userDefaults synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreReviewUrl]];
	}
}

@end