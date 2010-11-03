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
	[db setValue:@"0aa3a9f0acf8308151a50b8dd5d12e06a323ab12" forKey:FC_d_api_key];
	Famigo *f = [Famigo sharedInstance];
	f.skipInvites = NO;
	f.allFamigoPlayers = YES;
	f.game_name = @"Mad Minute";
	f.game_instructions = @"";
    
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

@end