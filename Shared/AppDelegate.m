//
//  AppDelegate.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

@interface AppDelegate()
-(void)evaluateTimeForReview;
@end

@implementation AppDelegate

@synthesize window;
@synthesize madMinuteController;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [window release];
    [madMinuteController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set up the Famigo API
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
	[db setValue:kAPIKey forKey:FC_d_api_key];
	Famigo *f = [Famigo sharedInstance];
	f.skipInvites = NO;
	f.allFamigoPlayers = YES;
	f.game_name = kGameName;
	f.game_instructions = kGameInstructions;
	f.forceGameToStartSynchronously = YES;
	f.game_name = @"Mad Minute";
	f.game_instructions = @"\nIt's like math, but faster!\n\n";
	
	[self evaluateTimeForReview];
	
	[[Reachability sharedReachability] setAddress:@"174.143.213.31"];
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	[[Reachability sharedReachability] remoteHostStatus];
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|
	 UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge];
    
    // Create a new frame below the status bar
    CGRect frame = [window frame];
    if (![UIApplication sharedApplication].statusBarHidden) {
        frame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    madMinuteController = [[MadMinuteController alloc] init];
    [[madMinuteController view] setFrame:frame];
    [window addSubview:[madMinuteController view]];
    
    [window makeKeyAndVisible];
    return YES;
}

#pragma mark Push Notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	Famigo *f = [Famigo sharedInstance];
	f.token_id = deviceToken;
}

//Check if this app has failed to receive an associated device token
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

#pragma mark App Store Review
// TODO: Need actual app store link for Mad Minute.
#define kAppLaunchCount @"app_launch_count"
#define kPromptForReviewOnLaunchCount 3
#define kAppStoreReviewUrl @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=394532988"

-(void)evaluateTimeForReview {
	NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
	NSNumber* appLaunchCount = [db valueForKey:kAppLaunchCount];
	if (!appLaunchCount) {
		appLaunchCount = [NSNumber numberWithInt:0];
	}
	int updatedAppLaunchCount = [appLaunchCount intValue] + 1;
	
	if (updatedAppLaunchCount == kPromptForReviewOnLaunchCount) {
		NSString *gameName = [Famigo sharedInstance].game_name;
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Help us by reviewing %@!", gameName]
													 message:[NSString stringWithFormat:@"We notice that you've played %@ a few times now.  Would you help new people find the game by reviewing it now?", gameName]
													delegate:self 
										   cancelButtonTitle:@"No thanks"
										   otherButtonTitles:@"Sure!",nil];
		[av show];
		[av release];
	}
	
	[db setValue:[NSNumber numberWithInt:updatedAppLaunchCount] forKey:kAppLaunchCount];
	[db synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		// Nothing to do here.
	} else {
		// Let's review!
		// This doesn't redirect in the simulator, as there's no app store in the simulator.
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreReviewUrl]];
	}
}

@end