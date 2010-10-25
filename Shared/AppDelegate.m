//
//  AppDelegate.m
//  Aardvark
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize aardvarkController;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [[self window] release];
    [[self aardvarkController] release];
    
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
	f.game_name = @"Aardvark";
	f.game_instructions = @"\nIf you're an ant, it's going to eat you up.\n";
    
    // Load the main view
    [self setAardvarkController:[[AardvarkController alloc] init]];
    [[[self aardvarkController] view] setFrame:[[self window] frame]];
    [[self window] addSubview:[[self aardvarkController] view]];
    
    [[self window] makeKeyAndVisible];
    return YES;
}

@end