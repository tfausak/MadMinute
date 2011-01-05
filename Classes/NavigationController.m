//
//  NavigationController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NavigationController.h"
#import "AppDelegate.h"
#import "LogoAnimationController.h"
#import "GameTypeSelectorViewController.h"
#import "Settings.h"
#import "MadMinuteViewController.h"
#import "ResultsViewController.h"

@implementation NavigationController

@synthesize logoAnimationController;
@synthesize gameTypeSelectorViewController;
@synthesize famigoController;
@synthesize settings;
@synthesize madMinuteViewController;
@synthesize resultsViewController;
@synthesize waitAlertView;

- (void)dealloc {
    [logoAnimationController release];
    [gameTypeSelectorViewController release];
    [famigoController release];
    [settings release];
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

- (void)didSelectGameType:(GameType)gameType {
    [Settings setGameType:gameType];
    
    if (gameType == SinglePlayer || gameType == PassAndPlay) {
        settings = [[Settings alloc] init];
        [self pushViewController:settings animated:YES];
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
    if ([Settings gameType] == SinglePlayer || [Settings gameType] == PassAndPlay) {
        [self popToRootViewControllerAnimated:NO];
        resultsViewController = [[ResultsViewController alloc] init];
        [self pushViewController:resultsViewController animated:YES];
    }
}

#pragma mark -
#pragma mark FamigoControllerDelegate

- (void)famigoReady {
    // This is all handled by didReceiveFamigoNotification
}

- (void)didReceiveFamigoNotification:(NSNotification *)notification {
    Famigo *famigo = [Famigo sharedInstance];
    
    if ([[notification name] isEqualToString:FamigoMessageGameCreated] || [[notification name] isEqualToString:FamigoMessageGameRead] || [[notification name] isEqualToString:FamigoMessageGameJoined]) {
        // Push the settings control onto the stack if we just came from Famigo
        if ([[self topViewController] isKindOfClass:[FamigoController class]]) {
            settings = [[Settings alloc] init];
            [self pushViewController:settings animated:YES];
        }
        
        // If the game data has info on all the players, the game is finished
        NSInteger dataCount = [[[famigo gameInstance] objectForKey:[famigo game_name]] count];
        NSInteger playerCount = [[[famigo gameInstance] objectForKey:@"famigo_players"] count];
        if (dataCount == playerCount) {
            [[famigo gameInstance] setValue:@"finished" forKey:FC_d_game_active];
            [famigo updateGame];
        }
        
        // Show a "Waiting for players to finish" alert view
        if ([Settings gameType] == MultiDeviceWithFamigo && waitAlertView == nil && [[self topViewController] isKindOfClass:[MadMinuteViewController class]] && [madMinuteViewController timer] == nil) {
            waitAlertView = [UIAlertView alloc];
            [waitAlertView initWithTitle:@"Waiting for players"
                                 message:@"This will go away automatically when everyone finishes."
                                delegate:self
                       cancelButtonTitle:@"Cancel game"
                       otherButtonTitles:nil];
            [waitAlertView show];
        }
        
        // Show a "Waiting for players to join" alert view
        NSInteger inviteCount = [[[famigo gameInstance] objectForKey:FC_d_game_invites] count];
        if ([Settings gameType] == MultiDeviceWithFamigo && waitAlertView == nil && [[self topViewController] isKindOfClass:[Settings class]] && inviteCount != 0) {
            waitAlertView = [UIAlertView alloc];
            [waitAlertView initWithTitle:@"Waiting for players"
                                 message:@"This will go away automatically when everyone joins."
                                delegate:self
                       cancelButtonTitle:@"Cancel game"
                       otherButtonTitles:nil];
            [waitAlertView show];
        }
        else if ([Settings gameType] == MultiDeviceWithFamigo && waitAlertView != nil && [[self topViewController] isKindOfClass:[Settings class]] && inviteCount == 0) {
            [waitAlertView dismissWithClickedButtonIndex:1
                                                animated:YES];
            [waitAlertView release];
            waitAlertView = nil;
        }
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameCanceled]) {
        [self popToRootViewControllerAnimated:NO];
        [famigo setWatchGame:NO];
        
        // Clear any active alert views
        if (waitAlertView != nil) {
            [waitAlertView dismissWithClickedButtonIndex:1
                                                animated:YES];
            [waitAlertView release];
            waitAlertView = nil;
        }
        
        // Let the players know the game was canceled
        UIAlertView *alertView = [UIAlertView alloc];
        [alertView initWithTitle:@"Game canceled"
                         message:@"Someone canceled the game!"
                        delegate:nil
               cancelButtonTitle:@"OK"
               otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameFinished]) {
        // Dismiss the "Waiting for players to finish" alert view
        if (waitAlertView != nil) {
            [waitAlertView dismissWithClickedButtonIndex:1
                                                animated:YES];
            [waitAlertView release];
            waitAlertView = nil;
        }
        
        // Show the results
        [self popToRootViewControllerAnimated:NO];
        resultsViewController = [[ResultsViewController alloc] init];
        [self pushViewController:resultsViewController animated:YES];
    }
    else if ([[notification name] isEqualToString:FamigoMessageGameUpdateFailed]) {
        // TODO handle failed updates
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

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[Famigo sharedInstance] cancelGame];
        [[Famigo sharedInstance] setWatchGame:NO];
        [self popToRootViewControllerAnimated:NO];
    }
}

@end