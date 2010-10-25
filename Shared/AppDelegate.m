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

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [[self window] release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[self window] makeKeyAndVisible];
    return YES;
}

@end