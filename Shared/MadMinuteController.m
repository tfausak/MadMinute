//
//  MadMinuteController.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MadMinuteController.h"

@implementation MadMinuteController

@synthesize resultsController;
@synthesize settingsController;
@synthesize gameController;
@synthesize famigoController;
@synthesize logoAnimationController;
@synthesize waitController;
@synthesize gameTypeController;

-(id)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(reachabilityNote:)
													 name:@"kNetworkReachabilityChangedNotification" 
												   object:nil];
		[[Famigo sharedInstance] registerForNotifications:self withSelector:@selector(famigoNote:)];
	}
	
	return self;
}

- (void)dealloc {
    [resultsController release];
    [settingsController release];
    [famigoController release];
    [famigoController release];
    [logoAnimationController release];
    [waitController release];
    [gameTypeController release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Managing the View

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    [view release];
}

- (void)viewDidLoad {
    
    // Display the game controller
    gameController = [[GameController alloc] init];
    [gameController setParentViewController:self];
    [[self view] addSubview:[gameController view]];
    
    // Display the settings controller
    settingsController = [[SettingsController alloc] init];
    [settingsController setParentViewController:self];
    [[self view] addSubview:[settingsController view]];
    
    // Display the Famigo controller
    famigoController = [FamigoController sharedInstanceWithDelegate:self];
    [[famigoController view] setFrame:[[self view] frame]];
    [famigoController viewWillAppear:NO];
    [famigoController show];
    [[self view] addSubview:[famigoController view]];
    
    // Display the game type controller
    gameTypeController = [[GameTypeController alloc] init];
    [[gameTypeController view] setFrame:[[self view] frame]];
    [[self view] addSubview:[gameTypeController view]];
    /*
    // Display the Famigo logo
    logoAnimationController = [[LogoAnimationController alloc] init];
    [[logoAnimationController view] setFrame:[[self view] frame]];
    [[logoAnimationController view] setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:[logoAnimationController view]];
    */
    // Capture the notification at the end of the logo animation
    [logoAnimationController registerForNotifications:self withSelector:@selector(logoAnimationDidFinish:)];
    
}

- (void)logoAnimationDidFinish:(NSNotification *)notification {
    [[logoAnimationController view] removeFromSuperview];
    [logoAnimationController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [gameController drawUI];
    [settingsController drawUI];
}

#pragma mark -

- (void)pressedFamigoButton:(id)sender {
    [famigoController viewWillAppear:NO];
    [famigoController show];
    [[self view] addSubview:[famigoController view]];
}

- (void)pressedNewGameButton:(id)sender {
    [gameController newGame];
    [[self view] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

- (void)pressedSettingsButton:(id)sender {
    [gameController endGame];
    [[self view] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

#pragma mark -
#pragma mark Famigo integration

- (void)famigoReady {
    NSLog(@"famigoReady");
}

- (void)famigoNote:(NSNotification*)note {
	NSString *noteName = [note name];
	NSLog(@"received note %@", noteName);
	Famigo *f = [Famigo sharedInstance];
    
    if ([noteName isEqualToString:FamigoMessageGameCreated]) {
		// Populate initial data structures for multiplayer.
        
        // Throw the wait controller up on the screen
        waitController = [[WaitController alloc] init];
        [[self view] addSubview:[waitController view]];
        
        // Get a list of player names
        NSArray *playerDictionaries = [f.gameInstance valueForKey:FC_d_game_invites];
        NSMutableArray *playerNames = [NSMutableArray array];
        [playerNames addObject:f.member_id];
        for (NSDictionary *playerDictionary in playerDictionaries) {
            [playerNames addObject:[playerDictionary valueForKey:FC_d_member_id]];
        }
        
        // Create the default player dictionary
        NSDictionary *defaultPlayerDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [NSNumber numberWithInt:0], kGameFinishedKey,
                                                 [NSNumber numberWithInt:0], kNumberRightKey,
                                                 [NSNumber numberWithInt:0], kNumberWrongKey,
                                                 [NSNumber numberWithInt:0], kNumberSkippedKey,
                                                 [NSNumber numberWithInt:0], kScoreKey,
                                                 nil];
        NSMutableDictionary *scoresDictionary = [NSMutableDictionary dictionary];
        
        // Set every player's dictionary to the default one
        for (NSString *playerName in playerNames) {
            [scoresDictionary setObject:defaultPlayerDictionary forKey:playerName];
        }
        
        NSDictionary *gameData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:0], kSeedKey,
                                  [NSNumber numberWithInt:0], kDifficultyKey,
                                  [NSNumber numberWithInt:NO], kAllowNegativeNumbersKey, // don't even think about using numberWithBool
                                  scoresDictionary, kScoresKey,
                                  nil];
        [f.gameInstance setValue:gameData forKey:f.game_name];
		[f.gameInstance setValue:f.member_id forKey:FC_d_game_current_turn];
		[f updateGame];
    }
    else if ([noteName isEqualToString:FamigoMessageGameUpdated]) {
        [[waitController view] removeFromSuperview];
    }
    else if ([noteName isEqualToString:FamigoMessageGameCanceled]) {
		// Wah wah wahhhhh. Back to Famigo.
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        [alertView setTitle:@"Game Canceled"];
        [alertView setMessage:@"Somebody canceled the game!"];
        [alertView addButtonWithTitle:@"OK"];
        [alertView setCancelButtonIndex:0];
        [alertView show];
        [alertView release];
        
        [famigoController viewWillAppear:NO];
        [famigoController show];
        [[self view] addSubview:[famigoController view]];
	}
    else if ([noteName isEqualToString:FamigoMessageGameFinished]) {		
		// Show results.
        
        // Display the results controller
        resultsController = [[ResultsController alloc] init];
        [resultsController setParentViewController:self];
        [[self view] addSubview:[resultsController view]];
	}
}

#pragma mark -
#pragma mark Reachability

- (void)reachabilityNote:(NSNotification*)note {
	Reachability *netStatusOracle = [Reachability sharedReachability];
	
	switch ([netStatusOracle internetConnectionStatus]) {
		case NotReachable:
			[self freezeGameNoNetwork];
			break;
		default:
			// don't care if it's reachable via cell or wifi, just as long as it's reachable
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			[self performSelector:@selector(thawGame) withObject:nil afterDelay:1.];
			break;
	}
}

- (void)freezeGameNoNetwork {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"This game requires network access to play. This message will dismiss when network access is restored." 
                                                       delegate:self 
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
	networkAlert = alertView;
	[alertView show];
	[alertView release];
}

- (void)thawGame {
	[networkAlert dismissWithClickedButtonIndex:networkAlert.cancelButtonIndex animated:YES];
	networkAlert = nil;
}

#pragma mark -

- (void)pressedGameTypeButton:(id)sender {
    [[Famigo sharedInstance] setForceGameToStartSynchronously:![sender tag]];
    [[Famigo sharedInstance] setIsPassAndPlaySession:[sender tag]];
    [[gameTypeController view] removeFromSuperview];
    [gameTypeController release];
}

@end