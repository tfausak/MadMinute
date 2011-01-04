//
//  MadMinuteViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MadMinuteViewController.h"
#import "NavigationController.h"

@implementation MadMinuteViewController

@synthesize f;
@synthesize defaults;

@synthesize gameType;
@synthesize difficulty;
@synthesize numberOfPlayers;
@synthesize allowNegativeNumbers;

@synthesize currentPlayer;
@synthesize arithmeticEquationGenerator;
@synthesize arithmeticEquation;
@synthesize timer;
@synthesize timeLeft;
@synthesize score;
@synthesize responseValue;
@synthesize responseIsPositive;
@synthesize gameData;

@synthesize timeBar;
@synthesize timeElapsedBar;
@synthesize timeElapsedLabel;
@synthesize firstOperandLabel;
@synthesize operatorLabel;
@synthesize secondOperandLabel;
@synthesize responseBackground;
@synthesize responseLabel;
@synthesize signControl;
@synthesize numberPad;

- (void)dealloc {
    [f release];
    [defaults release];
    
    [arithmeticEquationGenerator release];
    [arithmeticEquation release];
    [timer release];
    [responseValue release];
    [gameData release];
    
    [timeBar release];
    [timeElapsedBar release];
    [timeElapsedLabel release];
    [firstOperandLabel release];
    [operatorLabel release];
    [secondOperandLabel release];
    [responseBackground release];
    [responseLabel release];
    [signControl release];
    [numberPad release];
    
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Mad Minute"];
        
        // Ditch the back button in favor of a cancel button
        UIBarButtonItem *cancelButton = [UIBarButtonItem alloc];
        [cancelButton initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancelGame)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        [cancelButton release];
        
        // Get game settings
        defaults = [NSUserDefaults standardUserDefaults];
        gameType = [defaults integerForKey:kGameTypeKey];
        difficulty = [defaults integerForKey:kDifficultyKey];
        allowNegativeNumbers = [defaults integerForKey:kAllowNegativeNumbersKey];
        
        // Initialize the arithmetic equation generator
        arithmeticEquationGenerator = [ArithmeticEquationGenerator alloc];
        [arithmeticEquationGenerator initWithDifficulty:difficulty
                                   allowNegativeNumbers:allowNegativeNumbers];
        
        // Set up a Famigo shorthand
        if (gameType == PassAndPlayWithFamigo || gameType == MultiDeviceWithFamigo) {
            f = [Famigo sharedInstance];
        }
        
        // Figure out how many people are playing
        numberOfPlayers = 1;
        if (gameType == PassAndPlay) {
            numberOfPlayers = [defaults integerForKey:kNumberOfPlayersKey];
        }
        else if (f != nil) {
            numberOfPlayers = [[[f gameInstance] objectForKey:@"famigo_players"] count];
        }
        
        // Figure out who the current player is
        currentPlayer = 1;
        if (gameType == MultiDeviceWithFamigo) {
            NSArray *players = [[f gameInstance] objectForKey:@"famigo_players"];
            for (int index = 0; index < numberOfPlayers; index += 1) {
                NSString *playerID = [[players objectAtIndex:index] objectForKey:@"member_id"];
                if ([[f member_id] isEqualToString:playerID]) {
                    currentPlayer = index + 1;
                    break;
                }
            }
        }
        
        // Wrap up the settings in a dictionary
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        [settings setValue:[NSNumber numberWithInt:gameType] forKey:kGameTypeKey];
        [settings setValue:[NSNumber numberWithInt:difficulty] forKey:kDifficultyKey];
        [settings setValue:[NSNumber numberWithInt:allowNegativeNumbers] forKey:kAllowNegativeNumbersKey];
        [settings setValue:[NSNumber numberWithInt:numberOfPlayers] forKey:kNumberOfPlayersKey];
        
        // Store the game data
        if (f == nil) {
            gameData = [NSMutableDictionary dictionary];
            
            // Initialize each player's data
            for (int player = 1; player <= numberOfPlayers; player += 1) {
                NSMutableDictionary *playerData = [NSMutableDictionary dictionary];
                [playerData setValue:settings forKey:kPlayerSettingsKey];
                [playerData setValue:[NSMutableArray array] forKey:kPlayerQuestionsKey];
                [playerData setValue:[NSString stringWithFormat:@"Player %d", player] forKey:kPlayerNameKey];
                NSString *playerName = [NSString stringWithFormat:@"player-%d", player];
                [gameData setValue:playerData forKey:playerName];
            }
        }
        else {
            gameData = [[f gameInstance] objectForKey:[f game_name]];
            [[gameData objectForKey:[f member_id]] setValue:settings forKey:kPlayerSettingsKey];
            [[gameData objectForKey:[f member_id]] setValue:[f member_name] forKey:kPlayerNameKey];
            
            // Initialize other players
            for (NSDictionary *player in [[f gameInstance] objectForKey:@"famigo_players"]) {
                if ([gameData objectForKey:[player objectForKey:@"member_id"]] == nil) {
                    NSMutableDictionary *playerData = [NSMutableDictionary dictionary];
                    [playerData setValue:settings forKey:kPlayerSettingsKey];
                    [playerData setValue:[NSMutableArray array] forKey:kPlayerQuestionsKey];
                    [playerData setValue:[player objectForKey:@"member_name"] forKey:kPlayerNameKey];
                    [gameData setValue:playerData forKey:[player objectForKey:@"member_id"]];
                }
            }
            [f updateGame];
        }
        [gameData retain];
        
        // Set up the UI and zero everything out
        [self initUI];
        [self stopGame];
        [self drawUI];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopGame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self drawUI];
}

#pragma mark -

- (void)startGame {
    // Initialize game state
    arithmeticEquation = [arithmeticEquationGenerator generateEquation];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerDidFire)
                                           userInfo:nil
                                            repeats:YES];
    timeLeft = kInitialTime;
    score = 0;
    responseValue = @"";
    responseIsPositive = YES;
    
    // Show the UI
    [timeElapsedBar setHidden:NO];
    [timeElapsedLabel setHidden:NO];
    [signControl setHidden:NO];
    [numberPad setUserInteractionEnabled:YES];
    [self updateUI];
}

- (void)stopGame {
    // Destroy game state
    arithmeticEquation = nil;
    [timer invalidate];
    timer = nil;
    timeLeft = 0;
    score = 0;
    responseValue = @"";
    responseIsPositive = YES;
    
    // Hide the UI
    [timeElapsedBar setHidden:YES];
    [timeElapsedLabel setHidden:YES];
    [signControl setHidden:YES];
    [numberPad setUserInteractionEnabled:NO];
    [self updateUI];
}

- (void)cancelGame {
    [self stopGame];
    
    // Cancel the game on Famigo
    if (f != nil) {
        [f cancelGame];
        [f setWatchGame:NO];
    }
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)timerDidFire {
    timeLeft -= 1;
    if (timeLeft < 0) {
        [self timerDidExpire];
    }
    [self updateUI];
}

- (void)timerDidExpire {
    [self stopGame];
    
    // Store the game data
    if (f == nil) {
        [defaults setValue:gameData forKey:kGameDataKey];
        [defaults synchronize];
    }
    else {
        [[f gameInstance] setValue:gameData forKey:[f game_name]];
        [f updateGame];
    }
    
    switch (gameType) {
        case SinglePlayer:
            [(NavigationController *)[self navigationController] didStopGame];
            break;
        case PassAndPlay:
        case PassAndPlayWithFamigo:
            if (currentPlayer < numberOfPlayers) {
                currentPlayer += 1;
                UIAlertView *alertView = [[UIAlertView alloc] init];
                [alertView addButtonWithTitle:@"OK"];
                [alertView setDelegate:self];
                [alertView setMessage:@"Pass to the next player."];
                [alertView setTitle:@"Pass!"];
                [alertView show];
                [alertView release];
            }
            else {
                [(NavigationController *)[self navigationController] didStopGame];
                [[f gameInstance] setValue:@"finished" forKey:@"famigo_active"];
                [f updateGame];
                [f setWatchGame:NO];
            }
            break;
        case MultiDeviceWithFamigo:
            [(NavigationController *)[self navigationController] didStopGame];
            [[f gameInstance] setValue:@"finished" forKey:@"famigo_active"];
            [f updateGame];
            [f setWatchGame:NO];
            break;
    }
}

- (void)signControlValueDidChange {
    responseIsPositive = ![signControl selectedSegmentIndex];
    [self updateUI];
}

- (void)pressedNumberPadButton:(id)sender {
    switch ([sender tag]) {
        case 10: // delete
            // Only delete if there is something to delete
            if ([responseValue length] > 0) {
                responseValue = [responseValue substringToIndex:([responseValue length] - 1)];
            }
            break;
        case 11: // done/skip
            // Prepend a minus sign if necessary
            if (!responseIsPositive && ![responseValue isEqualToString:@"0"]) {
                responseValue = [@"-" stringByAppendingString:responseValue];
            }
            
            // Check for right/wrong/skipped answers
            if ([responseValue isEqualToString:[arithmeticEquation resultAsString]]) {
                [[self view] setBackgroundColor:[UIColor greenColor]];
                score += 1 + [arithmeticEquationGenerator difficulty] + [arithmeticEquationGenerator allowNegativeNumbers];
            }
            else if ([responseValue isEqualToString:@""]) {
                [[self view] setBackgroundColor:[UIColor whiteColor]];
            }
            else {
                [[self view] setBackgroundColor:[UIColor redColor]];
            }
            
            // Update the game data
            NSString *playerName;
            NSString *question = [NSString stringWithFormat:@"%@ %@", [arithmeticEquation serialize], responseValue];
            if (f == nil) {
                playerName = [NSString stringWithFormat:@"player-%d", currentPlayer];
            }
            else {
                playerName = [[[[f gameInstance] objectForKey:@"famigo_players"] objectAtIndex:currentPlayer - 1] objectForKey:@"member_id"];
            }
            NSDictionary *playerData = [gameData objectForKey:playerName];
            NSMutableArray *playerQuestions = [playerData objectForKey:kPlayerQuestionsKey];
            [playerQuestions addObject:question];
            
            // Keep Famigo in sync
            if (f != nil) {
                [[f gameInstance] setValue:gameData forKey:[f game_name]];
                [f updateGame];
            }
            
            // Fade back to transparent
            [UIView beginAnimations:nil context:nil]; {
                [[self view] setBackgroundColor:[UIColor clearColor]];
            } [UIView commitAnimations];
            
            // Make the next question
            arithmeticEquation = [arithmeticEquationGenerator generateEquation];
            responseValue = @"";
            responseIsPositive = YES;
            break;
        default: // a number
            if ([responseValue length] < 6) {
                if ([responseValue isEqualToString:@"0"]) {
                    responseValue = [NSString stringWithFormat:@"%d", [sender tag]];
                    [responseValue retain];
                }
                else {
                    responseValue = [responseValue stringByAppendingString:[NSString stringWithFormat:@"%d", [sender tag]]];
                }
            }
            break;
    }
    [self updateUI];
}

#pragma mark -

- (void)initUI {
    // Time bar
    timeBar = [[UIView alloc] init];
    [timeBar setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [[self view] addSubview:timeBar];
    
    // Time elapsed bar
    timeElapsedBar = [[UIView alloc] init];
    [timeElapsedBar setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [[self view] addSubview:timeElapsedBar];
    
    // Time elapsed label
    timeElapsedLabel = [[UILabel alloc] init];
    [timeElapsedLabel setBackgroundColor:[UIColor clearColor]];
    [timeElapsedLabel setTextAlignment:UITextAlignmentCenter];
    [timeElapsedLabel setTextColor:[UIColor whiteColor]];
    [[self view] addSubview:timeElapsedLabel];
    
    // First operand label
    firstOperandLabel = [[UILabel alloc] init];
    [firstOperandLabel setAdjustsFontSizeToFitWidth:YES];
    [firstOperandLabel setBackgroundColor:[UIColor clearColor]];
    [firstOperandLabel setTextColor:[UIColor blackColor]];
    [[self view] addSubview:firstOperandLabel];
    
    // Operator label
    operatorLabel = [[UILabel alloc] init];
    [operatorLabel setAdjustsFontSizeToFitWidth:YES];
    [operatorLabel setBackgroundColor:[UIColor clearColor]];
    [operatorLabel setTextAlignment:UITextAlignmentCenter];
    [operatorLabel setTextColor:[UIColor blackColor]];
    [[self view] addSubview:operatorLabel];
    
    // Second operand label
    secondOperandLabel = [[UILabel alloc] init];
    [secondOperandLabel setAdjustsFontSizeToFitWidth:YES];
    [secondOperandLabel setBackgroundColor:[UIColor clearColor]];
    [secondOperandLabel setTextColor:[UIColor blackColor]];
    [[self view] addSubview:secondOperandLabel];
    
    // Response background
    responseBackground = [[UIView alloc] init];
    [responseBackground setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
    [[self view] addSubview:responseBackground];
    
    // Response label
    responseLabel = [[UILabel alloc] init];
    [responseLabel setAdjustsFontSizeToFitWidth:NO];
    [responseLabel setBackgroundColor:[UIColor clearColor]];
    [responseLabel setTextAlignment:UITextAlignmentRight];
    [responseLabel setTextColor:[UIColor blackColor]];
    [[self view] addSubview:responseLabel];
    
    // Sign control
    signControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"+", @"-", nil]];
    [signControl addTarget:self action:@selector(signControlValueDidChange) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:signControl];
    
    // Number pad
    numberPad = [[UIView alloc] init];
    [numberPad setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [[self view] addSubview:numberPad];
    
    // Number buttons
    UIButton *button;
    for (int index = 0; index <= 9; index += 1) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
        [button setTag:index];
        [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [numberPad addSubview:button];
    }
    
    // Delete button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [button setTag:10];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [numberPad addSubview:button];
    
    // Done/skip button
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [button setTag:11];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [numberPad addSubview:button];
}

- (void)drawUI {
    BOOL isIPad = NO;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
        isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    }
    BOOL isLandscape = [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight;
    
    if (isIPad) {
        if (isLandscape) { // iPad landscape
            [timeBar setFrame:CGRectMake(0, 0, 1024, 44)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:100]];
            [firstOperandLabel setFrame:CGRectMake(437, 56, 250, 100)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFrame:CGRectMake(337, 156, 100, 100)];
            
            [secondOperandLabel setFrame:CGRectMake(437, 156, 250, 100)];
            
            [responseBackground setFrame:CGRectMake(0, 257, 1024, 95)];
            
            [responseLabel setFrame:CGRectMake(337, 257, 350, 95)];
            
            [signControl setFrame:CGRectMake(100, 283, 200, 43)];
            
            [numberPad setFrame:CGRectMake(0, 352, 1024, 352)];
            
            [[[[numberPad subviews] objectAtIndex:0] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:64]];
            [[[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            
            [[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(341, 265, 342,  87)];
            [[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 340,  87)];
            [[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(341,   1, 342,  87)];
            [[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(684,   1, 340,  87)];
            [[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  89, 340,  87)];
            [[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(341,  89, 342,  87)];
            [[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(684,  89, 340,  87)];
            [[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0, 177, 340,  87)];
            [[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(341, 177, 342,  87)];
            [[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(684, 177, 340,  87)];
            [[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 265, 340,  87)];
            [[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(684, 265, 340,  87)];
        }
        else { // iPad portrait
            [timeBar setFrame:CGRectMake(0, 0, 768, 44)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:144]];
            [firstOperandLabel setFrame:CGRectMake(400, 56, 300, 200)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFrame:CGRectMake(200, 256, 200, 200)];
            
            [secondOperandLabel setFrame:CGRectMake(400, 256, 300, 200)];
            
            [responseBackground setFrame:CGRectMake(0, 456, 768, 200)];
            
            [responseLabel setFrame:CGRectMake(0, 456, 700, 200)];
            
            [signControl setFrame:CGRectMake(20, 534, 160, 43)];
            
            [numberPad setFrame:CGRectMake(0, 656, 768, 304)];
            
            [[[[numberPad subviews] objectAtIndex:0] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:64]];
            [[[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            
            [[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(256, 229, 256,  75)];
            [[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 255,  75)];
            [[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(256,   1, 256,  75)];
            [[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(513,   1, 255,  75)];
            [[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  77, 255,  75)];
            [[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(256,  77, 256,  75)];
            [[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(513,  77, 255,  75)];
            [[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0, 153, 255,  75)];
            [[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(256, 153, 256,  75)];
            [[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(513, 153, 255,  75)];
            [[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 229, 255,  75)];
            [[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(513, 229, 255,  75)];
        }
    }
    else {
        if (isLandscape) { // iPhone landscape
            [timeBar setFrame:CGRectMake(0, 0, 480, 44)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [firstOperandLabel setFrame:CGRectMake(20, 44, 70, 64)];
            [firstOperandLabel setTextAlignment:UITextAlignmentCenter];
            
            [operatorLabel setFrame:CGRectMake(90, 44, 40, 64)];
            
            [secondOperandLabel setFrame:CGRectMake(130, 44, 70, 64)];
            
            [responseBackground setFrame:CGRectMake(220, 44, 260, 62)];
            
            [responseLabel setFrame:CGRectMake(320, 44, 140, 62)];
            
            [signControl setFrame:CGRectMake(230, 53, 80, 42)];
            
            [numberPad setFrame:CGRectMake(0, 106, 480, 162)];
            
            [[[[numberPad subviews] objectAtIndex:0] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [[[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            
            [[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(159, 123, 162,  39)];
            [[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 158,  40)];
            [[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(159,   1, 162,  40)];
            [[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(322,   1, 158,  40)];
            [[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  42, 158,  39)];
            [[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(159,  42, 162,  39)];
            [[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(322,  42, 158,  39)];
            [[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0,  82, 158,  40)];
            [[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(159,  82, 162,  40)];
            [[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(322,  82, 158,  40)];
            [[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 123, 158,  39)];
            [[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(322, 123, 158,  39)];
        }
        else { // iPhone portrait
            [timeBar setFrame:CGRectMake(0, 0, 320, 44)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [firstOperandLabel setFrame:CGRectMake(180, 44, 100, 52)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFrame:CGRectMake(100, 96, 80, 52)];
            
            [secondOperandLabel setFrame:CGRectMake(180, 96, 100, 52)];
            
            [responseBackground setFrame:CGRectMake(0, 148, 320, 52)];
            
            [responseLabel setFrame:CGRectMake(100, 148, 180, 52)];
            
            [signControl setFrame:CGRectMake(10, 153, 80, 42)];
            
            [numberPad setFrame:CGRectMake(0, 200, 320, 216)];
            
            [[[[numberPad subviews] objectAtIndex:0] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [[[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            
            [[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(106, 163, 108,  53)];
            [[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 105,  53)];
            [[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(106,   1, 108,  53)];
            [[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(215,   1, 105,  53)];
            [[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  55, 105,  53)];
            [[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(106,  55, 108,  53)];
            [[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(215,  55, 105,  53)];
            [[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0, 109, 105,  53)];
            [[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(106, 109, 108,  53)];
            [[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(215, 109, 105,  53)];
            [[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 163, 105,  53)];
            [[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(215, 163, 105,  53)];
        }
    }
    
    [timeElapsedBar setFrame:CGRectMake(0, 0, 0, [timeBar bounds].size.height)];
    [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
    [timeElapsedLabel setFrame:CGRectMake(0, 0, 80, [timeBar bounds].size.height)];
    [operatorLabel setFont:[firstOperandLabel font]];
    [secondOperandLabel setFont:[firstOperandLabel font]];
    [secondOperandLabel setTextAlignment:[firstOperandLabel textAlignment]];
    [responseLabel setFont:[firstOperandLabel font]];
    
    for (int index = 0; index <= 9; index += 1) {
        [[[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[[[[numberPad subviews] objectAtIndex:0] titleLabel] font]];
    }
    [[[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[[[[numberPad subviews] objectAtIndex:10] titleLabel] font]];
    
    [self updateUI];
}

- (void)updateUI {
    [timeElapsedLabel setText:[NSString stringWithFormat:@"%d:%02d", timeLeft / 60, timeLeft % 60]];
    [firstOperandLabel setText:[arithmeticEquation firstOperandAsString]];
    [operatorLabel setText:[arithmeticEquation operationAsString]];
    [secondOperandLabel setText:[arithmeticEquation secondOperandAsString]];
    [responseLabel setText:responseValue];
    
    // Update the sign control
    if (allowNegativeNumbers) {
        [signControl setEnabled:YES forSegmentAtIndex:1];
        [signControl setAlpha:1];
    }
    else {
        responseIsPositive = YES;
        [signControl setAlpha:0];
        [signControl setEnabled:NO forSegmentAtIndex:1];
    }
    [signControl setSelectedSegmentIndex:!responseIsPositive];
    
    // Update the number pad buttons
    if ([responseValue length] == 0) {
        [[[numberPad subviews] objectAtIndex:10] setTitle:@"" forState:UIControlStateNormal];
        [[[numberPad subviews] objectAtIndex:11] setTitle:@"Skip" forState:UIControlStateNormal];
    }
    else {
        [[[numberPad subviews] objectAtIndex:10] setTitle:@"Delete" forState:UIControlStateNormal];
        [[[numberPad subviews] objectAtIndex:11] setTitle:@"Done" forState:UIControlStateNormal];
    }
    
    [UIView beginAnimations:nil context:nil]; {
        // Determine the new width of the bar
        CGRect frame = [timeElapsedBar bounds];
        frame.size.width = [timeBar bounds].size.width - (timeLeft / (double) kInitialTime) * [timeBar bounds].size.width;
        [timeElapsedBar setFrame:frame];
        
        // Place the label forward of the bar but not off screen
        frame = [timeElapsedLabel bounds];
        frame.origin.x = MIN([timeBar bounds].size.width - [timeElapsedLabel bounds].size.width, [timeElapsedBar bounds].size.width);
        [timeElapsedLabel setFrame:frame];
    } [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self startGame];
}

@end