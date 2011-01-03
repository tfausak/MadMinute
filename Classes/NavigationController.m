//
//  NavigationController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NavigationController.h"
#import "AppDelegate.h"

@implementation NavigationController

@synthesize logoAnimationController;
@synthesize gameTypeSelectorViewController;
@synthesize famigoController;
@synthesize settingsViewController;
@synthesize madMinuteViewController;
@synthesize resultsViewController;
@synthesize waitAlertView;

- (void)dealloc {
    [logoAnimationController release];
    [gameTypeSelectorViewController release];
    [famigoController release];
    [settingsViewController release];
    [madMinuteViewController release];
    [resultsViewController release];
    [waitAlertView release];
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setDelegate:self];
        [self setNavigationBarHidden:YES animated:NO];
        [[self navigationBar] setBarStyle:UIBarStyleBlack];
        
        // Set up the background
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [backgroundImageView setContentMode:UIViewContentModeCenter];
        [backgroundImageView setFrame:[[self view] bounds]];
        [backgroundImageView setImage:[UIImage imageNamed:@"background.png"]];
        [[self view] insertSubview:backgroundImageView atIndex:0];
        [backgroundImageView release];
        
        // Display the Famigo logo
        logoAnimationController = [[LogoAnimationController alloc] init];
        [logoAnimationController registerForNotifications:self withSelector:@selector(logoAnimationDidFinish)];
        [self pushViewController:logoAnimationController animated:NO];
    }
    
    return self;
}

#pragma mark -

- (void)logoAnimationDidFinish {
    if (logoAnimationController != nil) {
        // Set up the root view controller
        gameTypeSelectorViewController = [[GameTypeSelectorViewController alloc] init];
        [self setViewControllers:[NSArray arrayWithObjects:gameTypeSelectorViewController, nil] animated:YES];
        
        // Remove the logo animation
        [logoAnimationController release];
        logoAnimationController = nil;
    }
}

- (void)didSelectGameType:(int)gameType {
    // Store the selected game type
    [[NSUserDefaults standardUserDefaults] setInteger:gameType forKey:kGameTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (gameType == SinglePlayer || gameType == PassAndPlay) {
        settingsViewController = [[SettingsViewController alloc] init];
        [self pushViewController:settingsViewController animated:YES];
    }
    else {
        // Make sure we have connectivity
        if ([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            [alertView setTitle:@"Internet access required"];
            [alertView setMessage:@"Famigo requires internet access."];
            [alertView addButtonWithTitle:@"OK"];
            [alertView setCancelButtonIndex:0];
            [alertView show];
            [alertView release];
            return;
        }
        
        // Set up the Famigo instance
        [[Famigo sharedInstance] setSkipInvites:NO];
        [[Famigo sharedInstance] setAllFamigoPlayers:YES];
        [[Famigo sharedInstance] setForceGameToStartSynchronously:gameType == MultiDeviceWithFamigo];
        [[Famigo sharedInstance] setGame_name:kGameName];
        [[Famigo sharedInstance] setGame_instructions:kGameInstructions];
        [[Famigo sharedInstance] setIsPassAndPlaySession:gameType == PassAndPlayWithFamigo];
        [[Famigo sharedInstance] registerForNotifications:self withSelector:@selector(didReceiveFamigoNotification:)];
        
        famigoController = [FamigoController sharedInstanceWithDelegate:self];
        [self pushViewController:famigoController animated:YES];
    }
}

- (void)didStartGame {
    madMinuteViewController = [[MadMinuteViewController alloc] init];
    [self pushViewController:madMinuteViewController animated:YES];
    [madMinuteViewController startGame];
}

- (void)didStopGame {
    [self popToRootViewControllerAnimated:NO];
    [[Famigo sharedInstance] setWatchGame:NO];
    
    resultsViewController = [[ResultsViewController alloc] init];
    [self pushViewController:resultsViewController animated:YES];
}

#pragma mark -
#pragma mark FamigoControllerDelegate

- (void)famigoReady {
    if ([[Famigo sharedInstance] gameInProgress]) {
        settingsViewController = [[SettingsViewController alloc] init];
        [self pushViewController:settingsViewController animated:YES];
    }
    else {
        resultsViewController = [[ResultsViewController alloc] init];
        [self pushViewController:resultsViewController animated:YES];
    }
}

- (void)didReceiveFamigoNotification:(NSNotification *)notification {
    Famigo *famigo = [Famigo sharedInstance];
    
    if ([[notification name] isEqualToString:FamigoMessageGameCreated]) {
        // Get a list of player names
        NSArray *playerDictionaries = [[famigo gameInstance] objectForKey:FC_d_game_invites];
        NSMutableArray *playerMemberIds = [NSMutableArray array];
        [playerMemberIds addObject:[famigo member_id]];
        for (NSDictionary *playerDictionary in playerDictionaries) {
            [playerMemberIds addObject:[playerDictionary objectForKey:FC_d_member_id]];
        }
        
		// Our game data consists of a dictionary of member_id to a separate dictionary, which stores player settings and player questions.
		NSMutableDictionary *gameData = [NSMutableDictionary dictionary];
		for (NSString *memberId in playerMemberIds) {
			// Settings: our seed, our difficulty, our negative number settings.
			NSMutableDictionary *settingsPlaceholder = [NSMutableDictionary dictionary];
			// Questions: each question the user faced and their answer/skipped status.
			NSMutableArray *questionPlaceholder = [NSMutableArray array];
			
			NSDictionary *madMinutePlayerDictionary = [NSDictionary dictionaryWithObjectsAndKeys: settingsPlaceholder, kPlayerSettingsKey, questionPlaceholder, kPlayerQuestionsKey, nil];
			[gameData setValue:madMinutePlayerDictionary forKey:memberId];
		}
        
		[[famigo gameInstance] setValue:gameData forKey:[famigo game_name]];
		[[famigo gameInstance] setValue:[famigo member_id] forKey:FC_d_game_current_turn];
		[famigo updateGame];
        
        // Wait for the other players to join
        if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == MultiDeviceWithFamigo) {
            waitAlertView = [[UIAlertView alloc] init];
            [waitAlertView setMessage:@"Waiting for all of the other players to join the game. Come on already!"];
            [waitAlertView setTitle:@"Waiting for players"];
            [waitAlertView show];
        }
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameUpdated]) {
        if (waitAlertView != nil) {
            [waitAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [waitAlertView release];
            waitAlertView = nil;
        }
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameCanceled]) {
        if ([[self topViewController] isKindOfClass:[MadMinuteViewController class]]) {
            [self popToRootViewControllerAnimated:NO];
            [[Famigo sharedInstance] setWatchGame:NO];
            
            UIAlertView *alertView = [[UIAlertView alloc] init];
            [alertView setTitle:@"Game Canceled"];
            [alertView setMessage:@"Somebody canceled the game!"];
            [alertView addButtonWithTitle:@"OK"];
            [alertView setCancelButtonIndex:0];
            [alertView show];
            [alertView release];
        }
	}
    else if ([[notification name] isEqualToString:FamigoMessageGameFinished]) {
        NSLog(@"game finished");
	}
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[FamigoController class]]) {
        [(FamigoController *)viewController show];
        [[Famigo sharedInstance] setWatchGame:NO];
    }
}

@end