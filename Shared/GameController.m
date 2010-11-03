//
//  GameController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"

int const kInitialTime = 60;

@implementation GameController

@synthesize arithmeticEquationGenerator;
@synthesize arithmeticEquation;
@synthesize gameClock;
@synthesize timeLeft;
@synthesize responseValue;
@synthesize responseIsPositive;
@synthesize score;
@synthesize navigationBar;
@synthesize scoreLabel;
@synthesize timeBar;
@synthesize timeElapsedBar;
@synthesize timeElapsedLabel;
@synthesize firstOperandLabel;
@synthesize secondOperandLabel;
@synthesize operatorLabel;
@synthesize responseBar;
@synthesize responseBackground;
@synthesize responseLabel;
@synthesize signControl;
@synthesize numberPad;

- (void)dealloc {
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
    [secondOperandLabel release];
    [operatorLabel release];
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
    [view release];
}

- (void)viewDidLoad {
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    
    firstOperandLabel = [[UILabel alloc] init]; {
        [firstOperandLabel setAdjustsFontSizeToFitWidth:YES];
        [firstOperandLabel setBackgroundColor:[UIColor clearColor]];
        [firstOperandLabel setTextAlignment:UITextAlignmentRight];
        [firstOperandLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:firstOperandLabel];
    
    secondOperandLabel = [[UILabel alloc] init]; {
        [secondOperandLabel setAdjustsFontSizeToFitWidth:YES];
        [secondOperandLabel setBackgroundColor:[UIColor clearColor]];
        [secondOperandLabel setTextAlignment:UITextAlignmentRight];
        [secondOperandLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:secondOperandLabel];
    
    operatorLabel = [[UILabel alloc] init]; {
        [operatorLabel setAdjustsFontSizeToFitWidth:YES];
        [operatorLabel setBackgroundColor:[UIColor clearColor]];
        [operatorLabel setTextAlignment:UITextAlignmentCenter];
        [operatorLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:operatorLabel];
    
    responseBar = [[UIView alloc] init]; {
        [responseBar setBackgroundColor:[UIColor blackColor]];
    } [[self view] addSubview:responseBar];
    
    responseBackground = [[UIView alloc] init]; {
        [responseBackground setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    } [[self view] addSubview:responseBackground];
    
    responseLabel = [[UITextField alloc] init]; {
        [responseLabel setAdjustsFontSizeToFitWidth:YES];
        [responseLabel setBackgroundColor:[UIColor clearColor]];
        [responseLabel setEnabled:NO];
        [responseLabel setTextAlignment:UITextAlignmentRight];
        [responseLabel setTextColor:[UIColor blackColor]];
    } [[self view] addSubview:responseLabel];
    
    signControl = [[UISegmentedControl alloc] init]; {
        [signControl addTarget:self action:@selector(pressedSignControl:) forControlEvents:UIControlEventValueChanged];
        [signControl insertSegmentWithTitle:@"+" atIndex:0 animated:NO];
        [signControl insertSegmentWithTitle:@"-" atIndex:1 animated:NO];
        [signControl setSelectedSegmentIndex:0];
    } [[self view] addSubview:signControl];
    
    navigationBar = [[UINavigationBar alloc] init]; {
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [navigationItem setTitle:@"Mad Minute"];
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(pressedSettingsButton:)];
        [navigationItem setLeftBarButtonItem:leftButton];
        [leftButton release];
        
        scoreLabel = [[UITextField alloc] init];
        [scoreLabel setBorderStyle:UITextBorderStyleRoundedRect];
        [scoreLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [scoreLabel setEnabled:NO];
        [scoreLabel setFrame:CGRectMake(0, 0, 60, 31)];
        [scoreLabel setTextAlignment:UITextAlignmentCenter];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:scoreLabel];
        [navigationItem setRightBarButtonItem:rightButton];
        [rightButton release];
        
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem release];
    } [[self view] addSubview:navigationBar];
    
    timeBar = [[UIView alloc] init]; {
        [timeBar setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    } [[self view] addSubview:timeBar];
    
    timeElapsedBar = [[UIView alloc] init]; {
        [timeElapsedBar setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    } [[self view] addSubview:timeElapsedBar];
    
    timeElapsedLabel = [[UILabel alloc] init]; {
        [timeElapsedLabel setBackgroundColor:[UIColor clearColor]];
        [timeElapsedLabel setTextColor:[UIColor whiteColor]];
    } [[self view] addSubview:timeElapsedLabel];
    
    numberPad = [[UIView alloc] init]; {
        [numberPad setBackgroundColor:[UIColor blackColor]];
        
        for (int index = 0; index <= 9; index += 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; {
                [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Button%d", index]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Button%d-Inverse", index]] forState:UIControlStateHighlighted];
                [button setTag:index];
            } [numberPad addSubview:button];
            [button release];
        }
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom]; {
            [deleteButton addTarget:self action:@selector(pressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setImage:[UIImage imageNamed:@"DeleteButton"] forState:UIControlStateNormal];
            [deleteButton setImage:[UIImage imageNamed:@"DeleteButton-Inverse"] forState:UIControlStateHighlighted];
        } [numberPad addSubview:deleteButton];
        [deleteButton release];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom]; {
            [doneButton addTarget:self action:@selector(pressedDoneButton:) forControlEvents:UIControlEventTouchUpInside];
            [doneButton setImage:[UIImage imageNamed:@"SkipButton"] forState:UIControlStateNormal];
            [doneButton setImage:[UIImage imageNamed:@"SkipButton-Inverse"] forState:UIControlStateHighlighted];
        } [numberPad addSubview:doneButton];
        [doneButton release];
    } [[self view] addSubview:numberPad];
    
    [self newGame];
}

#pragma mark -

- (void)newGame {
    Difficulty difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"];
    BOOL allowNegativeNumbers = [[NSUserDefaults standardUserDefaults] boolForKey:@"allowNegativeNumbers"];

    arithmeticEquationGenerator = [[ArithmeticEquationGenerator alloc] initWithDifficulty:difficulty allowNegativeNumbers:allowNegativeNumbers];
    arithmeticEquation = [arithmeticEquationGenerator generateEquation];
    gameClock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timeLeft = kInitialTime;
    score = 0;
    responseValue = @"";
    responseIsPositive = YES;
    [responseLabel setPlaceholder:@"?"];
    [signControl setEnabled:YES];
    
    for (int index = 0; index < [[numberPad subviews] count]; index += 1) {
        [(UIButton *)[[numberPad subviews] objectAtIndex:index] setEnabled:YES];
    }
    
    [self updateUI];
}

- (void)endGame {
    [gameClock invalidate];
    gameClock = nil;
    timeLeft = 0;
    score = 0;
    responseValue = @"";
    responseIsPositive = YES;
    arithmeticEquation = nil;
    [responseLabel setPlaceholder:@""];
    [signControl setEnabled:NO];
    
    for (int index = 0; index < [[numberPad subviews] count]; index += 1) {
        [(UIButton *)[[numberPad subviews] objectAtIndex:index] setEnabled:NO];
    }
    
    [self updateUI];
}

- (void)gameEnded {
    [gameClock invalidate];
    gameClock = nil;
    timeLeft = 0;
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Great Job!"];
    [alert setMessage:[NSString stringWithFormat:@"You scored %d point%@!", score, score == 1 ? @"" : @"s"]];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Go Back"];
    [alert addButtonWithTitle:@"Play Again"];
    [alert setCancelButtonIndex:0];
    [alert show];
    [alert release];
}

#pragma mark -

- (void)pressedSettingsButton:(id)sender {
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
    if (!responseIsPositive) {
        responseValue = [@"-" stringByAppendingString:responseValue];
    }
    
    if ([responseValue isEqualToString:[arithmeticEquation resultAsString]]) {
        score += [arithmeticEquationGenerator difficulty] + 1 + [arithmeticEquationGenerator allowNegativeNumbers];
        [[self view] setBackgroundColor:[UIColor greenColor]];
    }
    else {
        [[self view] setBackgroundColor:[UIColor redColor]];
    }
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:0.5];
        [[self view] setBackgroundColor:[UIColor lightGrayColor]];
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
        [self gameEnded];
    }
    
    [self updateUI];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self endGame];
            break;
        case 1:
            [self newGame];
            break;
        default:
            NSAssert(NO, @"Unknown button pressed");
            break;
    }
}

#pragma mark -

- (void)updateUI {
    [UIView beginAnimations:nil context:nil];
    
    [firstOperandLabel setText:[arithmeticEquation firstOperandAsString]];
    [secondOperandLabel setText:[arithmeticEquation secondOperandAsString]];
    [operatorLabel setText:[arithmeticEquation operationAsString]];
    [responseLabel setText:responseValue];
    [timeElapsedLabel setText:[NSString stringWithFormat:@"%d:%02d", timeLeft / 60, timeLeft % 60]];
    
    if (responseIsPositive) {
        [signControl setSelectedSegmentIndex:0];
    }
    else {
        [signControl setSelectedSegmentIndex:1];
    }
        
    if ([responseValue length] == 0) {
        [(UIButton *)[[numberPad subviews] objectAtIndex:11] setImage:[UIImage imageNamed:@"SkipButton"] forState:UIControlStateNormal];
        [(UIButton *)[[numberPad subviews] objectAtIndex:11] setImage:[UIImage imageNamed:@"SkipButton-Inverse"] forState:UIControlStateHighlighted];
    }
    else {
        [(UIButton *)[[numberPad subviews] objectAtIndex:11] setImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
        [(UIButton *)[[numberPad subviews] objectAtIndex:11] setImage:[UIImage imageNamed:@"DoneButton-Inverse"] forState:UIControlStateHighlighted];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPad landscape
        }
        else {
            // iPad portrait
        }
    }
    else {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPhone landscape
        }
        else {
            // iPhone portrait
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48.0]];
            [firstOperandLabel setFrame:CGRectMake(120, 88, 140, 52)];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48.0]];
            [secondOperandLabel setFrame:CGRectMake(120, 140, 140, 52)];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48.0]];
            [operatorLabel setFrame:CGRectMake(60, 140, 60, 52)];
            
            [responseBar setFrame:CGRectMake(0, 191, 320, 1)];
            
            [responseBackground setFrame:CGRectMake(0, 192, 320, 52)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48.0]];
            [responseLabel setFrame:CGRectMake(60, 192, 200, 52)];
            
            if ([arithmeticEquationGenerator allowNegativeNumbers]) {
                [signControl setFrame:CGRectMake(5, 197, 75, 42)];
            }
            
            [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
            
            [scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
            
            [timeBar setFrame:CGRectMake(0, 44, 320, 44)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 320 - (timeLeft / (double) kInitialTime) * 320, 44)];
            
            [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24.0]];
            [timeElapsedLabel setFrame:CGRectMake(MIN(260, [timeElapsedBar frame].size.width + 10), 44, 50, 44)];
            
            [numberPad setFrame:CGRectMake(0, 244, 320, 216)];
            
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
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(215, 163, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(  0, 163, 105,  53)];
        }
    }
    
    [UIView commitAnimations];
}

@end