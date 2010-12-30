//
//  ResultsViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "NavigationController.h"

@implementation ResultsViewController

@synthesize famigo;
@synthesize defaults;

@synthesize gameType;
@synthesize gameData;

- (void)dealloc {
    [famigo release];
    [defaults release];
    
    [gameData release];
    
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Results"];
        
        // Load the game type
        defaults = [NSUserDefaults standardUserDefaults];
        gameType = [defaults integerForKey:kGameTypeKey];
        
        // Load the game data
        if (gameType == SinglePlayer || gameType == PassAndPlay) {
            gameData = [defaults objectForKey:kGameDataKey];
        }
        else {
            famigo = [Famigo sharedInstance];
            gameData = [[famigo gameInstance] objectForKey:[famigo game_name]];
        }
        [gameData retain];
        
        NSLog(@"%@", gameData);
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end