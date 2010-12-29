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
    switch (gameType) {
        case SinglePlayer:
            break;
        case PassAndPlay:
            break;
        case PassAndPlayWithFamigo:
            [[Famigo sharedInstance] setForceGameToStartSynchronously:NO];
            [[Famigo sharedInstance] setIsPassAndPlaySession:YES];
            break;
        case MultiDeviceWithFamigo:
            [[Famigo sharedInstance] setForceGameToStartSynchronously:YES];
            [[Famigo sharedInstance] setIsPassAndPlaySession:NO];
            break;
        default:
            NSAssert(NO, @"unknown game type");
            break;
    }
    
    // Store the selected game type
    [[NSUserDefaults standardUserDefaults] setInteger:gameType forKey:kGameTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (gameType == PassAndPlayWithFamigo || gameType == MultiDeviceWithFamigo) {
        famigoController = [FamigoController sharedInstanceWithDelegate:self];
        [self pushViewController:famigoController animated:YES];
        
        // Make sure we have connectivity
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"kNetworkReachabilityChangedNotification" object:NULL]];
    }
    else {
        settingsViewController = [[SettingsViewController alloc] init];
        [self pushViewController:settingsViewController animated:YES];
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
    // TODO bring up the *right* view controller
    settingsViewController = [[SettingsViewController alloc] init];
    [self pushViewController:settingsViewController animated:YES];
}

- (void)didReceiveFamigoNotification:(NSNotification *)notification {
    Famigo *famigo = [Famigo sharedInstance];
    
    if ([[notification name] isEqualToString:FamigoMessageGameCreated]) {
        // Get a list of player names
        NSArray *playerDictionaries = [[famigo gameInstance] valueForKey:FC_d_game_invites];
        NSMutableArray *playerMemberIds = [NSMutableArray array];
        [playerMemberIds addObject:[famigo member_id]];
        for (NSDictionary *playerDictionary in playerDictionaries) {
            [playerMemberIds addObject:[playerDictionary valueForKey:FC_d_member_id]];
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
        waitAlertView = [[UIAlertView alloc] init];
        [waitAlertView setMessage:@"Waiting for all of the other players to join the game. Come on already!"];
        [waitAlertView setTitle:@"Waiting for players"];
        [waitAlertView show];
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameUpdated]) {
        if (waitAlertView != nil) {
            [waitAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [waitAlertView release];
            waitAlertView = nil;
        }
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameCanceled]) {
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