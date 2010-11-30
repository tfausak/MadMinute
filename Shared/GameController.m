//
//  GameController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"

@implementation GameController

@synthesize parentViewController;
@synthesize arithmeticEquationGenerator;
@synthesize arithmeticEquation;
@synthesize gameClock;
@synthesize timeLeft;
@synthesize responseValue;
@synthesize responseIsPositive;
@synthesize score;
@synthesize numberRight;
@synthesize numberWrong;
@synthesize numberSkipped;
@synthesize navigationBar;
@synthesize scoreLabel;
@synthesize timeBar;
@synthesize timeElapsedBar;
@synthesize timeElapsedLabel;
@synthesize firstOperandLabel;
@synthesize operatorLabel;
@synthesize secondOperandLabel;
@synthesize responseBar;
@synthesize responseBackground;
@synthesize responseLabel;
@synthesize signControl;
@synthesize numberPad;

- (void)dealloc {
    [parentViewController release];
    [arithmeticEquationGenerator release];
    [arithmeticEquation release];
    [gameClock release];
    [responseValue release];
    [navigationBar release];
    [scoreLabel release];
    [timeBar release];
    [timeElapsedBar release];
    [timeElapsedLabel release];
    [firstOperandLabel release];
    [operatorLabel release];
    [secondOperandLabel release];
    [responseBar release];
    [responseBackground release];
    [responseLabel release];
    [signControl release];
    [numberPad release];
    
    [super dealloc];
}

#pragma mark -

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
}

- (void)viewDidLoad {
    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
    
    firstOperandLabel = [[UILabel alloc] init]; {
        [firstOperandLabel setAdjustsFontSizeToFitWidth:YES];
        [firstOperandLabel setBackgroundColor:[UIColor clearColor]];
        [firstOperandLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:firstOperandLabel];
    
    operatorLabel = [[UILabel alloc] init]; {
        [operatorLabel setAdjustsFontSizeToFitWidth:YES];
        [operatorLabel setBackgroundColor:[UIColor clearColor]];
        [operatorLabel setTextAlignment:UITextAlignmentCenter];
        [operatorLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:operatorLabel];
    
    secondOperandLabel = [[UILabel alloc] init]; {
        [secondOperandLabel setAdjustsFontSizeToFitWidth:YES];
        [secondOperandLabel setBackgroundColor:[UIColor clearColor]];
        [secondOperandLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:secondOperandLabel];
    
    responseBar = [[UIView alloc] init]; {
        [responseBar setBackgroundColor:[UIColor blackColor]];
    } [[self view] addSubview:responseBar];
    
    responseBackground = [[UIView alloc] init]; {
        [responseBackground setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    } [[self view] addSubview:responseBackground];
    
    responseLabel = [[UILabel alloc] init]; {
        [responseLabel setAdjustsFontSizeToFitWidth:NO];
        [responseLabel setBackgroundColor:[UIColor clearColor]];
        [responseLabel setTextAlignment:UITextAlignmentRight];
        [responseLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:responseLabel];
    
    signControl = [[UISegmentedControl alloc] init]; {
        [signControl addTarget:self action:@selector(pressedSignControl:) forControlEvents:UIControlEventValueChanged];
        [signControl insertSegmentWithTitle:@"+" atIndex:0 animated:NO];
        [signControl insertSegmentWithTitle:@"-" atIndex:1 animated:NO];
    } [[self view] addSubview:signControl];
    
    navigationBar = [[UINavigationBar alloc] init]; {
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [navigationItem setTitle:@"Mad Minute"];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:parentViewController
                                                                      action:@selector(pressedSettingsButton:)];
        [navigationItem setLeftBarButtonItem:leftButton];
        
        scoreLabel = [[UITextField alloc] init];
        [scoreLabel setBorderStyle:UITextBorderStyleRoundedRect];
        [scoreLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [scoreLabel setEnabled:NO];
        [scoreLabel setFrame:CGRectMake(0, 0, 60, 31)];
        [scoreLabel setTextAlignment:UITextAlignmentCenter];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:scoreLabel];
        [navigationItem setRightBarButtonItem:rightButton];
        
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        
        [navigationItem release];
        [leftButton release];
        [rightButton release];
    } [[self view] addSubview:navigationBar];
    
    timeBar = [[UIView alloc] init]; {
        [timeBar setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    } [[self view] addSubview:timeBar];
    
    timeElapsedBar = [[UIView alloc] init]; {
        [timeElapsedBar setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    } [[self view] addSubview:timeElapsedBar];
    
    timeElapsedLabel = [[UILabel alloc] init]; {
        [timeElapsedLabel setBackgroundColor:[UIColor clearColor]];
        [timeElapsedLabel setTextAlignment:UITextAlignmentCenter];
        [timeElapsedLabel setTextColor:[UIColor whiteColor]];
    } [[self view] addSubview:timeElapsedLabel];
    
    numberPad = [[UIView alloc] init]; {
        [numberPad setBackgroundColor:[UIColor blackColor]];
        
        for (int index = 0; index <= 9; index += 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; {
                [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
                [button setTag:index];
                [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            } [numberPad addSubview:button];
        }
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom]; {
            [deleteButton addTarget:self action:@selector(pressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setBackgroundColor:[UIColor colorWithWhite:0.25 alpha:1.0]];
            [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        } [numberPad addSubview:deleteButton];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom]; {
            [doneButton addTarget:self action:@selector(pressedDoneButton:) forControlEvents:UIControlEventTouchUpInside];
            [doneButton setBackgroundColor:[UIColor colorWithWhite:0.25 alpha:1.0]];
            [doneButton setTitle:@"Skip" forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        } [numberPad addSubview:doneButton];
    } [[self view] addSubview:numberPad];
    
    [self drawUI];
    [self endGame];
}

#pragma mark -

- (void)newGame {
    arithmeticEquationGenerator = [[ArithmeticEquationGenerator alloc] initWithDifficulty:[[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"]
                                                                     allowNegativeNumbers:[[NSUserDefaults standardUserDefaults] boolForKey:@"allowNegativeNumbers"]];
    arithmeticEquation = [arithmeticEquationGenerator generateEquation];
    gameClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timeLeft = kInitialTime;
    score = 0;
    numberRight = 0;
    numberWrong = 0;
    numberSkipped = 0;
    responseValue = @"";
    responseIsPositive = YES;
    [numberPad setUserInteractionEnabled:YES];
    [signControl setUserInteractionEnabled:YES];
    
    [self updateUI];
}

- (void)endGame {
    [gameClock invalidate];
    gameClock = nil;
    timeLeft = 0;
    score = 0;
    numberRight = 0;
    numberWrong = 0;
    numberSkipped = 0;
    responseValue = @"";
    arithmeticEquation = nil;
    [numberPad setUserInteractionEnabled:NO];
    [signControl setUserInteractionEnabled:NO];
    
    [self updateUI];
}

- (void)gameClockExpired {
    Famigo *f = [Famigo sharedInstance];
    
    // Update the player's information
    NSDictionary *playerDictionary = [[[f.gameInstance objectForKey:f.game_name] objectForKey:kScoresKey] objectForKey:f.member_id];
    [playerDictionary setValue:[NSNumber numberWithInt:1] forKey:kGameFinishedKey];
    [playerDictionary setValue:[NSNumber numberWithInt:numberRight] forKey:kNumberRightKey];
    [playerDictionary setValue:[NSNumber numberWithInt:numberWrong] forKey:kNumberWrongKey];
    [playerDictionary setValue:[NSNumber numberWithInt:numberSkipped] forKey:kNumberSkippedKey];
    [playerDictionary setValue:[NSNumber numberWithInt:score] forKey:kScoreKey];
    [[[f.gameInstance objectForKey:f.game_name] objectForKey:kScoresKey] setObject:playerDictionary forKey:f.member_id];
    
    // See if the game is actually done
    BOOL finished = YES;
    int winningScore = 0;
    NSString *winningMemberID = @"";
    for (NSString *memberID in [[f.gameInstance objectForKey:f.game_name] objectForKey:kScoresKey]) {
        NSDictionary *player = [[[f.gameInstance objectForKey:f.game_name] objectForKey:kScoresKey] objectForKey:memberID];
        finished &= (BOOL) [[player valueForKey:kGameFinishedKey] intValue];
        int playerScore = (int) [[player valueForKey:kScoreKey] intValue];
        if (playerScore > winningScore) { // TODO handle ties
            winningScore = playerScore;
            winningMemberID = memberID;
        }
    }
    if (finished) {
        [f.gameInstance setValue:@"finished" forKey:FC_d_game_active];
        for (NSDictionary *player in [f.gameInstance objectForKey:@"famigo_players"]) {
            if ([[player objectForKey:@"member_name"] isEqualToString:winningMemberID]) {
                // score isnt being set. if i print the dictionary, score is the only key not in quotes. what does it mean?
                [player setValue:[NSNumber numberWithInt:1] forKey:@"score"];
            }
        }
    }
    
    // Push updates to game state
    [f updateGame];
    
    UIAlertView *alert = [[UIAlertView alloc] init]; {
        [alert setTitle:@"Great Job!"];
        [alert setMessage:[NSString stringWithFormat:@"You scored %d point%@!", score, score == 1 ? @"" : @"s"]];
        [alert setMessage:[NSString stringWithFormat:@"%d %d %d %d", numberRight, numberWrong, numberSkipped, score]];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Go Back"];
        [alert addButtonWithTitle:@"Play Again"];
        [alert setCancelButtonIndex:0];
        [alert show];
    } [alert release];
    
    [self endGame];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self endGame];
            [[parentViewController view] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            break;
        case 1:
            [self newGame];
            break;
        default:
            NSAssert(NO, @"Unknown button pressed");
            break;
    }
}

- (void)pressedNumberPadButton:(id)sender {
    if ([responseValue length] >= 6) {
        return;
    }
    
    int tag = [(UIButton *)sender tag];
    if ([responseValue isEqualToString:@"0"]) {
        responseValue = [NSString stringWithFormat:@"%d", tag];
        [responseValue retain];
    }
    else {
        responseValue = [responseValue stringByAppendingString:[NSString stringWithFormat:@"%d", tag]];
    }
    
    [self updateUI];
}

- (void)pressedDeleteButton:(id)sender {
    if ([responseValue length] == 0) {
        return;
    }
    
    responseValue = [responseValue substringToIndex:([responseValue length] - 1)];
    
    [self updateUI];
}

- (void)pressedDoneButton:(id)sender {
    if (!responseIsPositive && ![responseValue isEqualToString:@"0"]) {
        responseValue = [@"-" stringByAppendingString:responseValue];
    }
    
    if ([responseValue isEqualToString:[arithmeticEquation resultAsString]]) {
        [[self view] setBackgroundColor:[UIColor greenColor]];
        score += 1 + [arithmeticEquationGenerator difficulty] + [arithmeticEquationGenerator allowNegativeNumbers];
        numberRight += 1;
    }
    else {
        if ([responseValue isEqualToString:@""]) {
            numberSkipped += 1;
        }
        else {
            [[self view] setBackgroundColor:[UIColor redColor]];
            numberWrong += 1;
        }
    }
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:0.5];
        [[self view] setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
    } [UIView commitAnimations];
    
    arithmeticEquation = [arithmeticEquationGenerator generateEquation];
    responseValue = @"";
    responseIsPositive = YES;
    
    [self updateUI];
}

- (void)pressedSignControl:(id)sender {
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
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

- (void)timerFireMethod:(NSTimer *)timer {
    timeLeft -= 1;
    
    if (timeLeft == -1) {
        [self gameClockExpired];
    }
    
    [self updateUI];
}

#pragma mark -

- (void)drawUI {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPad landscape
            [[self view] setFrame:CGRectMake(0, 0, 1024, 768)];
            
            [navigationBar setFrame:CGRectMake(0, 0, 1024, 44)];
            
            [timeBar setFrame:CGRectMake(0, 44, 1024, 56)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 0, 56)];
            
            [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [timeElapsedLabel setFrame:CGRectMake(0, 44, 100, 56)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:100]];
            [firstOperandLabel setFrame:CGRectMake(437, 100, 250, 100)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:100]];
            [operatorLabel setFrame:CGRectMake(337, 200, 100, 100)];
            [operatorLabel setTextAlignment:UITextAlignmentCenter];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:100]];
            [secondOperandLabel setFrame:CGRectMake(437, 200, 250, 100)];
            [secondOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [responseBar setFrame:CGRectMake(0, 300, 1024, 1)];
            
            [responseBackground setFrame:CGRectMake(0, 301, 1024, 95)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:100]];
            [responseLabel setFrame:CGRectMake(337, 301, 350, 95)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(100, 327, 200, 43)];
            
            [numberPad setFrame:CGRectMake(0, 396, 1024, 352)];
            
            for (int index = 0; index <= 9; index += 1) {
                [[(UIButton *)[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:64]];
            }
            
            [(UIButton *)[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(341, 265, 342,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(341,   1, 342,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(684,   1, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  89, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(341,  89, 342,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(684,  89, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0, 177, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(341, 177, 342,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(684, 177, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 265, 340,  87)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(684, 265, 340,  87)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
        }
        else {
            // iPad portrait
            [[self view] setFrame:CGRectMake(0, 0, 768, 1024)];
            
            [navigationBar setFrame:CGRectMake(0, 0, 768, 44)];
            
            [timeBar setFrame:CGRectMake(0, 44, 768, 56)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 0, 56)];
            
            [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [timeElapsedLabel setFrame:CGRectMake(0, 44, 100, 56)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:144]];
            [firstOperandLabel setFrame:CGRectMake(400, 100, 300, 200)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:144]];
            [operatorLabel setFrame:CGRectMake(200, 300, 200, 200)];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:144]];
            [secondOperandLabel setFrame:CGRectMake(400, 300, 300, 200)];
            [secondOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [responseBar setFrame:CGRectMake(0, 499, 768, 1)];
            
            [responseBackground setFrame:CGRectMake(0, 500, 768, 200)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:144]];
            [responseLabel setFrame:CGRectMake(200, 500, 500, 200)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(20, 578, 160, 43)];
            
            [numberPad setFrame:CGRectMake(0, 700, 768, 304)];
            
            for (int index = 0; index <= 9; index += 1) {
                [[(UIButton *)[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:64]];
            }
            
            [(UIButton *)[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(256, 229, 256,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(256,   1, 256,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(513,   1, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  77, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(256,  77, 256,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(513,  77, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0, 153, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(256, 153, 256,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(513, 153, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 229, 255,  75)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(513, 229, 255,  75)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
        }
    }
    else {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPhone landscape
            [[self view] setFrame:CGRectMake(0, 0, 480, 320)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [firstOperandLabel setFrame:CGRectMake(20, 88, 70, 52)];
            [firstOperandLabel setTextAlignment:UITextAlignmentCenter];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [operatorLabel setFrame:CGRectMake(90, 88, 40, 52)];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [secondOperandLabel setFrame:CGRectMake(130, 88, 70, 52)];
            [secondOperandLabel setTextAlignment:UITextAlignmentCenter];
            
            [responseBar setFrame:CGRectMake(219, 88, 1, 52)];
            
            [responseBackground setFrame:CGRectMake(220, 88, 260, 52)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [responseLabel setFrame:CGRectMake(320, 88, 140, 52)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(230, 93, 80, 42)];
            
            [navigationBar setFrame:CGRectMake(0, 0, 480, 44)];
            
            [timeBar setFrame:CGRectMake(0, 44, 480, 44)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 0, 44)];
            
            [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [timeElapsedLabel setFrame:CGRectMake(0, 44, 60, 44)];
            
            [numberPad setFrame:CGRectMake(0, 138, 480, 162)];
            
            for (int index = 0; index <= 9; index += 1) {
                [[(UIButton *)[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            }
            
            [(UIButton *)[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(159, 123, 162,  39)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 158,  40)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(159,   1, 162,  40)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(322,   1, 158,  40)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  42, 158,  39)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(159,  42, 162,  39)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(322,  42, 158,  39)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0,  82, 158,  40)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(159,  82, 162,  40)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(322,  82, 158,  40)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 123, 158,  39)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(322, 123, 158,  39)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        }
        else {
            // iPhone portrait
            [[self view] setFrame:CGRectMake(0, 0, 320, 480)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [firstOperandLabel setFrame:CGRectMake(180, 88, 100, 52)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [operatorLabel setFrame:CGRectMake(100, 140, 80, 52)];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [secondOperandLabel setFrame:CGRectMake(180, 140, 100, 52)];
            [secondOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [responseBar setFrame:CGRectMake(0, 191, 320, 1)];
            
            [responseBackground setFrame:CGRectMake(0, 192, 320, 52)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [responseLabel setFrame:CGRectMake(100, 192, 180, 52)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(10, 197, 80, 42)];
            
            [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
            
            [timeBar setFrame:CGRectMake(0, 44, 320, 44)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 0, 44)];
            
            [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [timeElapsedLabel setFrame:CGRectMake(0, 44, 60, 44)];
            
            [numberPad setFrame:CGRectMake(0, 244, 320, 216)];
            
            for (int index = 0; index <= 9; index += 1) {
                [[(UIButton *)[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            }
            
            [(UIButton *)[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(106, 163, 108,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0,   1, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(106,   1, 108,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(215,   1, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0,  55, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(106,  55, 108,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(215,  55, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0, 109, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(106, 109, 108,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(215, 109, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(  0, 163, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(215, 163, 105,  53)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        }
    }
    
    [self updateUI];
}

- (void)updateUI {
    [firstOperandLabel setText:[arithmeticEquation firstOperandAsString]];
    [secondOperandLabel setText:[arithmeticEquation secondOperandAsString]];
    [operatorLabel setText:[arithmeticEquation operationAsString]];
    [responseLabel setText:responseValue];
    [timeElapsedLabel setText:[NSString stringWithFormat:@"%d:%02d", timeLeft / 60, timeLeft % 60]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
    
    if ([arithmeticEquationGenerator allowNegativeNumbers]) {
        [signControl setEnabled:YES forSegmentAtIndex:1];
        [signControl setAlpha:1];
    }
    else {
        responseIsPositive = YES;
        [signControl setAlpha:0];
        [signControl setEnabled:NO forSegmentAtIndex:1];
    }
    [signControl setSelectedSegmentIndex:!responseIsPositive];
    
    if ([responseValue length] == 0) {
        [(UIButton *)[[numberPad subviews] objectAtIndex:11] setTitle:@"Skip" forState:UIControlStateNormal];
    }
    else {
        [(UIButton *)[[numberPad subviews] objectAtIndex:11] setTitle:@"Done" forState:UIControlStateNormal];
    }
    
    // Only animate the timeElapsedBar if it's moving forward
    int oldWidth = [timeElapsedBar frame].size.width;
    int newWidth = [[self view] frame].size.width - (timeLeft / (double) kInitialTime) * [[self view] frame].size.width;
    BOOL shouldAnimate = newWidth > oldWidth;
    
    if (shouldAnimate) {
        [UIView beginAnimations:nil context:nil];
    }
    
    CGRect frame = [timeElapsedBar frame];
    frame.size.width = [[self view] frame].size.width - (timeLeft / (double) kInitialTime) * [[self view] frame].size.width;
    [timeElapsedBar setFrame:frame];
    
    frame = [timeElapsedLabel frame];
    frame.origin.x = MIN([[self view] frame].size.width - [timeElapsedLabel frame].size.width, [timeElapsedBar frame].size.width);
    [timeElapsedLabel setFrame:frame];
    
    if (shouldAnimate) {
        [UIView commitAnimations];
    }
}

@end