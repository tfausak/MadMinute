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
    [arithmeticEquationGenerator release];
    [arithmeticEquation release];
    [timer release];
    [responseValue release];
    
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
        
        // Change the back button to a cancel button
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelGame)];
        [[self navigationItem] setLeftBarButtonItem:cancelButton animated:YES];
        [cancelButton release];
        
        // Get game settings from user defaults
        gameType = (GameType)[[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey];
        difficulty = (Difficulty)[[NSUserDefaults standardUserDefaults] integerForKey:kDifficultyKey];
        allowNegativeNumbers = [[NSUserDefaults standardUserDefaults] integerForKey:kAllowNegativeNumbersKey];
        
        // Figure out how many players are playing
        switch (gameType) {
            case PassAndPlay:
                numberOfPlayers = [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey];
                break;
            case PassAndPlayWithFamigo:
                numberOfPlayers = [(NSArray *)[[[Famigo sharedInstance] gameInstance] valueForKey:@"famigo_players"] count];
                break;
            default:
                numberOfPlayers = 1;
                break;
        }
        
        //
        currentPlayer = 1;
        arithmeticEquationGenerator = [[ArithmeticEquationGenerator alloc] initWithDifficulty:difficulty allowNegativeNumbers:allowNegativeNumbers];
        
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
        
        //
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
    //
    arithmeticEquation = [arithmeticEquationGenerator generateEquation];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerDidFire) userInfo:nil repeats:YES];
    timeLeft = kInitialTime;
    score = 0;
    responseValue = @"";
    responseIsPositive = YES;
    
    //
    [timeElapsedBar setHidden:NO];
    [timeElapsedLabel setHidden:NO];
    [signControl setHidden:NO];
    [numberPad setUserInteractionEnabled:YES];
    [self updateUI];
    
    // Store settings with Famigo
    if (gameType == PassAndPlayWithFamigo || gameType == MultiDeviceWithFamigo) {
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:difficulty], kDifficultyKey, [NSNumber numberWithInt:allowNegativeNumbers], kAllowNegativeNumbersKey, nil];
        Famigo *famigo = [Famigo sharedInstance];
        NSDictionary *gameData = [[famigo gameInstance] valueForKey:[famigo game_name]];
        NSDictionary *myDictionary = [gameData valueForKey:[famigo member_id]];
        [myDictionary setValue:settings forKey:kPlayerSettingsKey];
        [famigo updateGame];
    }
    
    //
    NSLog(@"%@", [[Famigo sharedInstance] gameInstance]);
}

- (void)stopGame {
    //
    arithmeticEquation = nil;
    [timer invalidate];
    timer = nil;
    timeLeft = 0;
    score = 0;
    responseValue = @"";
    responseIsPositive = YES;
    
    //
    [timeElapsedBar setHidden:YES];
    [timeElapsedLabel setHidden:YES];
    [signControl setHidden:YES];
    [numberPad setUserInteractionEnabled:NO];
    [self updateUI];
}

- (void)cancelGame {
    // TODO handle cancelling nicely (w/ famigo, etc.)
    [self stopGame];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)timerDidFire {
    timeLeft -= 1;
    if (timeLeft < 0) {
        [self stopGame];
        switch (gameType) {
            case SinglePlayer:
                [(NavigationController *)[self navigationController] didStopGame];
                break;
            case PassAndPlay:
                if (currentPlayer < numberOfPlayers) {
                    currentPlayer += 1;
                    UIAlertView *alertView = [[UIAlertView alloc] init];
                    [alertView addButtonWithTitle:@"OK"];
                    [alertView setDelegate:self];
                    [alertView setMessage:[NSString stringWithFormat:@"Pass the %@ to %@.", [self deviceName], [self nameForPlayerNumber:currentPlayer]]];
                    [alertView setTitle:@"Pass!"];
                    [alertView show];
                    [alertView release];
                }
                else {
                    [(NavigationController *)[self navigationController] didStopGame];
                }
                break;
            case PassAndPlayWithFamigo:
                if (currentPlayer < numberOfPlayers) {
                    currentPlayer += 1;
                    UIAlertView *alertView = [[UIAlertView alloc] init];
                    [alertView addButtonWithTitle:@"OK"];
                    [alertView setDelegate:self];
                    [alertView setMessage:[NSString stringWithFormat:@"Pass the %@ to %@.", [self deviceName], [self nameForPlayerNumber:currentPlayer]]];
                    [alertView setTitle:@"Pass!"];
                    [alertView show];
                    [alertView release];
                }
                else {
                    [(NavigationController *)[self navigationController] didStopGame];
                }
                break;
            case MultiDeviceWithFamigo:
                // TODO update famigo
                [(NavigationController *)[self navigationController] didStopGame];
                break;
            default:
                NSAssert(NO, @"unknown game type");
                break;
        }
    }
    [self updateUI];
}

- (NSString *)deviceName {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound) {
        return @"iPhone";
    }
    
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound) {
        return @"iPad";
    }
    
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPod"].location != NSNotFound) {
        return @"iPod";
    }
    
    return @"device";
}

- (NSString *)nameForPlayerNumber:(int)number {
    switch (gameType) {
        case PassAndPlay:
            return [NSString stringWithFormat:@"player %d", number];
        case PassAndPlayWithFamigo:
            return (NSString *)[(NSDictionary *)[(NSArray *)[[[Famigo sharedInstance] gameInstance] valueForKey:@"famigo_players"] objectAtIndex:number - 1] objectForKey:@"member_name"];
        default:
            return nil;
    }
}

- (void)signControlValueDidChange {
    switch ([signControl selectedSegmentIndex]) {
        case 0:
            responseIsPositive = YES;
            break;
        case 1:
            responseIsPositive = NO;
            break;
        default:
            NSAssert(NO, @"Unknown sign control state");
            break;
    }
    [self updateUI];
}

- (void)pressedNumberPadButton:(id)sender {
    switch ([sender tag]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9: // a number
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
        case 10: // delete
            if ([responseValue length] > 0) {
                responseValue = [responseValue substringToIndex:([responseValue length] - 1)];
            }
            break;
        case 11: // done/skip
            if (!responseIsPositive && ![responseValue isEqualToString:@"0"]) {
                responseValue = [@"-" stringByAppendingString:responseValue];
            }
            
            if ([responseValue isEqualToString:[arithmeticEquation resultAsString]]) {
                [[self view] setBackgroundColor:[UIColor greenColor]];
                score += 1 + [arithmeticEquationGenerator difficulty] + [arithmeticEquationGenerator allowNegativeNumbers];
            }
            else {
                if ([responseValue isEqualToString:@""]) {
                    [[self view] setBackgroundColor:[UIColor whiteColor]];
                }
                else {
                    [[self view] setBackgroundColor:[UIColor redColor]];
                }
            }
            
            // Log the question
            if (gameType == PassAndPlayWithFamigo || gameType == MultiDeviceWithFamigo) {
                NSDictionary *question = [NSDictionary dictionaryWithObjectsAndKeys:[arithmeticEquation serialize], kPlayerEquationKey, responseValue, kPlayerResponseKey, nil];
                Famigo *famigo = [Famigo sharedInstance];
                NSDictionary *gameData = [[famigo gameInstance] valueForKey:[famigo game_name]];
                NSDictionary *myDictionary = [gameData valueForKey:[famigo member_id]];
                NSMutableArray *myQuestions = [myDictionary valueForKey:kPlayerQuestionsKey];
                [myQuestions addObject:question];
                [famigo updateGame];
                NSLog(@"\n%@\n%@", gameData, myQuestions);
            }
            
            [UIView beginAnimations:nil context:nil]; {
                [[self view] setBackgroundColor:[UIColor clearColor]];
            } [UIView commitAnimations];
            
            arithmeticEquation = [arithmeticEquationGenerator generateEquation];
            responseValue = @"";
            responseIsPositive = YES;
            break;
        default:
            NSAssert(NO, @"unknown tag");
            break;
    }
    [self updateUI];
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