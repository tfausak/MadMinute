//
//  MadMinuteController.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MadMinuteController.h"

@implementation MadMinuteController

@synthesize settingsController;
@synthesize gameController;
@synthesize famigoController;
@synthesize logoAnimationController;

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
    [[self view] addSubview:[gameController view]];
    
    // Display the settings controller
    settingsController = [[SettingsController alloc] init];
    [settingsController setParentViewController:self];
    [[self view] addSubview:[settingsController view]];
    /*
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
    */
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
}

- (void)pressedNewGameButton:(id)sender {
    [gameController newGame];
    
    [UIView beginAnimations:nil context:nil]; {
        [[settingsController view] removeFromSuperview];
    } [UIView commitAnimations];
}

- (void)famigoReady {
    NSLog(@"famigoReady");
}

@end