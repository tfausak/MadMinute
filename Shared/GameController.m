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

@synthesize parentViewController;
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
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    
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
        [responseLabel setAdjustsFontSizeToFitWidth:YES];
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
    } [[self view] addSubview:navigationBar];
    
    timeBar = [[UIView alloc] init]; {
        [timeBar setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    } [[self view] addSubview:timeBar];
    
    timeElapsedBar = [[UIView alloc] init]; {
        [timeElapsedBar setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    } [[self view] addSubview:timeElapsedBar];
    
    timeElapsedLabel = [[UILabel alloc] init]; {
        [timeElapsedLabel setBackgroundColor:[UIColor clearColor]];
        [timeElapsedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        [timeElapsedLabel setTextColor:[UIColor whiteColor]];
    } [[self view] addSubview:timeElapsedLabel];
    
    numberPad = [[UIView alloc] init]; {
        [numberPad setBackgroundColor:[UIColor blackColor]];
        
        for (int index = 0; index <= 9; index += 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; {
                [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundImage:[UIImage imageNamed:@"Button-Background"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"Button-Background-Inverse"] forState:UIControlStateHighlighted];
                [button setTag:index];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
            } [numberPad addSubview:button];
        }
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom]; {
            [deleteButton addTarget:self action:@selector(pressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"Button-Background-Inverse"] forState:UIControlStateNormal];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"Button-Background"] forState:UIControlStateHighlighted];
            [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [deleteButton setTitle:@"×" forState:UIControlStateNormal];
        } [numberPad addSubview:deleteButton];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom]; {
            [doneButton addTarget:self action:@selector(pressedDoneButton:) forControlEvents:UIControlEventTouchUpInside];
            [doneButton setBackgroundImage:[UIImage imageNamed:@"Button-Background-Inverse"] forState:UIControlStateNormal];
            [doneButton setBackgroundImage:[UIImage imageNamed:@"Button-Background"] forState:UIControlStateHighlighted];
            [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [doneButton setTitle:@"Skip" forState:UIControlStateNormal];
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
    gameClock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timeLeft = kInitialTime;
    score = 0;
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
    responseValue = @"";
    arithmeticEquation = nil;
    [numberPad setUserInteractionEnabled:NO];
    [signControl setUserInteractionEnabled:NO];
    
    [self updateUI];
}

- (void)gameClockExpired {
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
            
            float xScale = 1024.0 / 320.0;
            float yScale = 768.0 / 480.0;
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [firstOperandLabel setFrame:CGRectMake(120 * xScale, 88 * yScale, 140 * xScale, 52 * yScale)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [secondOperandLabel setFrame:CGRectMake(120 * xScale, 140 * yScale, 140 * xScale, 52 * yScale)];
            [secondOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [operatorLabel setFrame:CGRectMake(60 * xScale, 140 * yScale, 60 * xScale, 52 * yScale)];
            
            [responseBar setFrame:CGRectMake(0 * xScale, 191 * yScale, 320 * xScale, 1 * yScale)];
            
            [responseBackground setFrame:CGRectMake(0 * xScale, 192 * yScale, 320 * xScale, 52 * yScale)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [responseLabel setFrame:CGRectMake(90 * xScale, 192 * yScale, 170 * xScale, 52 * yScale)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(5 * xScale, 197 * yScale, 80 * xScale, 42 * yScale)];
            
            [navigationBar setFrame:CGRectMake(0 * xScale, 0 * yScale, 320 * xScale, 44 * yScale)];
            
            [timeBar setFrame:CGRectMake(0 * xScale, 44 * yScale, 320 * xScale, 44 * yScale)];
            
            [timeElapsedBar setFrame:CGRectMake(0 * xScale, 44 * yScale, 0 * xScale, 44 * yScale)];
            
            [timeElapsedLabel setFrame:CGRectMake(0 * xScale, 44 * yScale, 50 * xScale, 44 * yScale)];
            
            [numberPad setFrame:CGRectMake(0 * xScale, 244 * yScale, 320 * xScale, 216 * yScale)];
            
            for (int index = 0; index <= 9; index += 1) {
                [[(UIButton *)[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            }
            
            [(UIButton *)[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(106 * xScale, 163 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0 * xScale,   1 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(106 * xScale,   1 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(215 * xScale,   1 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0 * xScale,  55 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(106 * xScale,  55 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(215 * xScale,  55 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0 * xScale, 109 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(106 * xScale, 109 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(215 * xScale, 109 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(215 * xScale, 163 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(  0 * xScale, 163 * yScale, 105 * xScale,  53 * yScale)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        }
        else {
            // iPad portrait
            [[self view] setFrame:CGRectMake(0, 0, 768, 1024)];
            
            float xScale = 768.0 / 320.0;
            float yScale = 1024.0 / 480.0;
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [firstOperandLabel setFrame:CGRectMake(120 * xScale, 88 * yScale, 140 * xScale, 52 * yScale)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [secondOperandLabel setFrame:CGRectMake(120 * xScale, 140 * yScale, 140 * xScale, 52 * yScale)];
            [secondOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [operatorLabel setFrame:CGRectMake(60 * xScale, 140 * yScale, 60 * xScale, 52 * yScale)];
            
            [responseBar setFrame:CGRectMake(0 * xScale, 191 * yScale, 320 * xScale, 1 * yScale)];
            
            [responseBackground setFrame:CGRectMake(0 * xScale, 192 * yScale, 320 * xScale, 52 * yScale)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [responseLabel setFrame:CGRectMake(90 * xScale, 192 * yScale, 170 * xScale, 52 * yScale)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(5 * xScale, 197 * yScale, 80 * xScale, 42 * yScale)];
            
            [navigationBar setFrame:CGRectMake(0 * xScale, 0 * yScale, 320 * xScale, 44 * yScale)];
            
            [timeBar setFrame:CGRectMake(0 * xScale, 44 * yScale, 320 * xScale, 44 * yScale)];
            
            [timeElapsedBar setFrame:CGRectMake(0 * xScale, 44 * yScale, 0 * xScale, 44 * yScale)];
            
            [timeElapsedLabel setFrame:CGRectMake(0 * xScale, 44 * yScale, 50 * xScale, 44 * yScale)];
            
            [numberPad setFrame:CGRectMake(0 * xScale, 244 * yScale, 320 * xScale, 216 * yScale)];
            
            for (int index = 0; index <= 9; index += 1) {
                [[(UIButton *)[[numberPad subviews] objectAtIndex:index] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            }
            
            [(UIButton *)[[numberPad subviews] objectAtIndex:0]  setFrame:CGRectMake(106 * xScale, 163 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:1]  setFrame:CGRectMake(  0 * xScale,   1 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:2]  setFrame:CGRectMake(106 * xScale,   1 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:3]  setFrame:CGRectMake(215 * xScale,   1 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:4]  setFrame:CGRectMake(  0 * xScale,  55 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:5]  setFrame:CGRectMake(106 * xScale,  55 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:6]  setFrame:CGRectMake(215 * xScale,  55 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:7]  setFrame:CGRectMake(  0 * xScale, 109 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:8]  setFrame:CGRectMake(106 * xScale, 109 * yScale, 108 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:9]  setFrame:CGRectMake(215 * xScale, 109 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(215 * xScale, 163 * yScale, 105 * xScale,  53 * yScale)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(  0 * xScale, 163 * yScale, 105 * xScale,  53 * yScale)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        }
    }
    else {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPhone landscape
            [[self view] setFrame:CGRectMake(0, 0, 480, 320)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [firstOperandLabel setFrame:CGRectMake(20, 88, 80, 52)];
            [firstOperandLabel setTextAlignment:UITextAlignmentCenter];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [secondOperandLabel setFrame:CGRectMake(140, 88, 80, 52)];
            [secondOperandLabel setTextAlignment:UITextAlignmentCenter];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [operatorLabel setFrame:CGRectMake(100, 88, 40, 52)];
            
            [responseBar setFrame:CGRectMake(239, 88, 1, 52)];
            
            [responseBackground setFrame:CGRectMake(240, 88, 240, 52)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:36]];
            [responseLabel setFrame:CGRectMake(330, 88, 130, 52)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(245, 93, 80, 42)];
            
            [navigationBar setFrame:CGRectMake(0, 0, 480, 44)];
            
            [timeBar setFrame:CGRectMake(0, 44, 480, 44)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 0, 44)];
            
            [timeElapsedLabel setFrame:CGRectMake(0, 44, 50, 44)];
            
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
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(322, 123, 158,  39)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(  0, 123, 158,  39)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        }
        else {
            // iPhone portrait
            [[self view] setFrame:CGRectMake(0, 0, 320, 480)];
            
            [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [firstOperandLabel setFrame:CGRectMake(120, 88, 140, 52)];
            [firstOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [secondOperandLabel setFrame:CGRectMake(120, 140, 140, 52)];
            [secondOperandLabel setTextAlignment:UITextAlignmentRight];
            
            [operatorLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [operatorLabel setFrame:CGRectMake(60, 140, 60, 52)];
            
            [responseBar setFrame:CGRectMake(0, 191, 320, 1)];
            
            [responseBackground setFrame:CGRectMake(0, 192, 320, 52)];
            
            [responseLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:48]];
            [responseLabel setFrame:CGRectMake(90, 192, 170, 52)];
            [responseLabel setTextAlignment:UITextAlignmentRight];
            
            [signControl setFrame:CGRectMake(5, 197, 80, 42)];
            
            [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
            
            [timeBar setFrame:CGRectMake(0, 44, 320, 44)];
            
            [timeElapsedBar setFrame:CGRectMake(0, 44, 0, 44)];
            
            [timeElapsedLabel setFrame:CGRectMake(0, 44, 50, 44)];
            
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
            [(UIButton *)[[numberPad subviews] objectAtIndex:10] setFrame:CGRectMake(215, 163, 105,  53)];
            [(UIButton *)[[numberPad subviews] objectAtIndex:11] setFrame:CGRectMake(  0, 163, 105,  53)];
            
            [[(UIButton *)[[numberPad subviews] objectAtIndex:10] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            [[(UIButton *)[[numberPad subviews] objectAtIndex:11] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
        }
    }
    
    [self updateUI];
}

- (void)updateUI {
    [UIView beginAnimations:nil context:nil]; {
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
    
        CGRect frame = [timeElapsedBar frame];
        frame.size.width = [[self view] frame].size.width - (timeLeft / (double) kInitialTime) * [[self view] frame].size.width;
        [timeElapsedBar setFrame:frame];
        
        frame = [timeElapsedLabel frame];
        frame.origin.x = MIN([[self view] frame].size.width - 60, [timeElapsedBar frame].size.width + 10);
        [timeElapsedLabel setFrame:frame];
    } [UIView commitAnimations];
}

@end