//
//  MadMinuteController.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MadMinuteController.h"
#import "Reachability.h"

@implementation MadMinuteController

@synthesize settingsController;
@synthesize gameController;
@synthesize famigoController;
@synthesize logoAnimationController;

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
    [settingsController release];
    [famigoController release];
    [famigoController release];
    [logoAnimationController release];
	
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
    
    // Display the Famigo logo
    logoAnimationController = [[LogoAnimationController alloc] init];
    [[logoAnimationController view] setFrame:[[self view] frame]];
    [[logoAnimationController view] setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:[logoAnimationController view]];
    
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

#pragma mark - Famigo integration
- (void)famigoReady {
    NSLog(@"famigoReady");
}

- (void)famigoNote:(NSNotification*)note {
	NSString *noteName = [note name];
	NSLog(@"received note %@", noteName);
	Famigo *f = [Famigo sharedInstance];
	
	if ([noteName isEqualToString:FamigoMessageGameUpdated]) {
		// Game is ready to go.  All invites accepted.
	} else if ([noteName isEqualToString:FamigoMessageGameCreated]) {		
		// Populate initial data structures for multiplayer.
		
		/*
		// For each player, we track which member id the player ties back to.
		// We also track which points on our grid the player has claimed already.
		NSDictionary *xMember = [membersForGame objectAtIndex:kXIndex];
		NSString *xMemberId = [xMember objectForKey:FC_d_member_id];
		NSMutableArray *xMemberClaimedPoints = [[NSMutableArray alloc] init];
		NSDictionary *xData = [NSDictionary dictionaryWithObjectsAndKeys:xMemberId, FC_d_member_id,
							   xMemberClaimedPoints, FC_claimed_points, nil];
		
		NSDictionary *oMember = [[f.gameInstance valueForKey:FC_d_game_players] objectAtIndex:kOIndex];
		NSString *oMemberId = [oMember objectForKey:FC_d_member_id];
		NSMutableArray *oMemberClaimedPoints = [[NSMutableArray alloc] init];
		NSDictionary *oData = [NSDictionary dictionaryWithObjectsAndKeys:oMemberId, FC_d_member_id,
							   oMemberClaimedPoints, FC_claimed_points, nil];
		
		NSDictionary *gameData = [NSDictionary dictionaryWithObjectsAndKeys:xData, FC_x_data, oData, FC_o_data, nil];
		[f.gameInstance setValue:gameData forKey:f.game_name];
		[f.gameInstance setValue:f.member_id forKey:FC_d_game_current_turn];
		[f updateGame]; */
	} else if ([noteName isEqualToString:FamigoMessageGameCanceled]) {
		// Wah wah wahhhhh.  Back to Famigo.
	} else if ([noteName isEqualToString:FamigoMessageGameFinished]) {		
		// Show results.
	}
}

#pragma mark - Reachability
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
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops"
									message:@"This game requires network access to play. This message will dismiss when network access is restored." 
								   delegate:self 
						  cancelButtonTitle:nil
						  otherButtonTitles:nil];
	networkAlert = av;
	
	[av show];
	[av release];
}

- (void)thawGame {
	[networkAlert dismissWithClickedButtonIndex:networkAlert.cancelButtonIndex animated:YES];
	networkAlert = nil;
}
@end