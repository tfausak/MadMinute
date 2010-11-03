//
//  MadMinuteController.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MadMinuteController.h"

@implementation MadMinuteController

static const int kNumberPadButtons = 12;

@synthesize famigoController;
@synthesize logoAnimationController;
@synthesize arithmeticEquationGenerator;

@synthesize interfaceIsBuilt;
@synthesize time;
@synthesize score;
@synthesize result;
@synthesize response;

@synthesize navigationBar;
@synthesize statusView;
@synthesize timeProgress;
@synthesize scoreLabel;
@synthesize problemView;
@synthesize firstOperandLabel;
@synthesize operationLabel;
@synthesize secondOperandLabel;
@synthesize blackBar;
@synthesize responseLabel;
@synthesize skipButton;
@synthesize doneButton;
@synthesize numberPad;
@synthesize numberPadButtons;

- (void)dealloc {
    [famigoController release];
    [logoAnimationController release];
    [arithmeticEquationGenerator release];
    
    [navigationBar release];
    [statusView release];
    [timeProgress release];
    [scoreLabel release];
    [problemView release];
    [firstOperandLabel release];
    [operationLabel release];
    [secondOperandLabel release];
    [blackBar release];
    [responseLabel release];
    [skipButton release];
    [doneButton release];
    [numberPad release];
    [numberPadButtons release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Managing the View

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    [view release];
}

- (void)viewDidLoad {
    [self buildInterface];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self buildInterface:duration];
}

#pragma mark -

- (void)famigoReady {
    NSLog(@"famigoReady");
}

- (void)logoAnimationDidFinish:(NSNotification *)notification {
    [[logoAnimationController view] removeFromSuperview];
    [logoAnimationController release];
}

#pragma mark -

- (void)buildInterface {
    [self buildInterface:0.0];
}

- (void)buildInterface:(NSTimeInterval)duration {
    // Only create the interface elements once
    // Every other call will just move things around
    if (!interfaceIsBuilt) {
        interfaceIsBuilt = YES;
        
        navigationBar = [[UINavigationBar alloc] init]; {
            UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Mad Minute"];
            [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Famigo" style:UIBarButtonItemStylePlain target:self action:@selector(pressedFamigoButton:)]];
            [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(pressedSettingsButton:)]];
            [navigationBar pushNavigationItem:navigationItem animated:NO];
            [navigationItem release];
        } [[self view] addSubview:navigationBar];
        
        statusView = [[UIView alloc] init];
        [[self view] addSubview:statusView];
        
        timeProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [statusView addSubview:timeProgress];
        
        scoreLabel = [[UILabel alloc] init];
        [statusView addSubview:scoreLabel];
        
        problemView = [[UIView alloc] init];
        [[self view] addSubview:problemView];
        
        firstOperandLabel = [[UILabel alloc] init];
        [problemView addSubview:firstOperandLabel];
        
        operationLabel = [[UILabel alloc] init];
        [problemView addSubview:operationLabel];
        
        secondOperandLabel = [[UILabel alloc] init];
        [problemView addSubview:secondOperandLabel];
        
        blackBar = [[UIView alloc] init];
        [problemView addSubview:blackBar];
        
        responseLabel = [[UILabel alloc] init];
        [problemView addSubview:responseLabel];
        
        skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(pressedSkipButton:) forControlEvents:UIControlEventTouchUpInside];
        [[self view] addSubview:skipButton];
        
        doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(pressedDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [[self view] addSubview:doneButton];
        
        numberPad = [[UIView alloc] init];
        [[self view] addSubview:numberPad];
        
        numberPadButtons = [[NSMutableArray alloc] init];
        for (int index = 0; index < kNumberPadButtons; index += 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
            [numberPadButtons insertObject:button atIndex:index];
            [numberPad addSubview:[numberPadButtons objectAtIndex:index]];
        }
    }
    
    // Build the right interface for the current device and orientation
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
            [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            [self buildInterfaceIPadLandscape:duration];
        }
        else {
            [self buildInterfaceIPadPortrait:duration];
        }
    }
    else {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
            [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            [self buildInterfaceIPhoneLandscape:duration];
        }
        else {
            [self buildInterfaceIPhonePortrait:duration];
        }
    }
}

- (void)buildInterfaceIPhonePortrait:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
        
        [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
        
        [statusView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [statusView setFrame:CGRectMake(0, 44, 320, 44)];
        
        [timeProgress setFrame:CGRectMake(20, 8, 280, 9)];
        
        [scoreLabel setBackgroundColor:[UIColor clearColor]];
        [scoreLabel setFrame:CGRectMake(20, 20, 280, 20)];
        [scoreLabel setTextAlignment:UITextAlignmentCenter];
        [scoreLabel setTextColor:[UIColor whiteColor]];
        
        [problemView setBackgroundColor:[UIColor clearColor]];
        [problemView setFrame:CGRectMake(0, 88, 320, 122)];
        
        [firstOperandLabel setBackgroundColor:[UIColor clearColor]];
        [firstOperandLabel setFont:[UIFont fontWithName:@"Helvetica" size:36]];
        [firstOperandLabel setFrame:CGRectMake(80, 0, 160, 40)];
        [firstOperandLabel setTextAlignment:UITextAlignmentRight];
        
        [operationLabel setBackgroundColor:[UIColor clearColor]];
        [operationLabel setFont:[UIFont fontWithName:@"Helvetica" size:36]];
        [operationLabel setFrame:CGRectMake(80, 40, 160, 40)];
        
        [secondOperandLabel setBackgroundColor:[UIColor clearColor]];
        [secondOperandLabel setFont:[UIFont fontWithName:@"Helvetica" size:36]];
        [secondOperandLabel setFrame:CGRectMake(80, 40, 160, 40)];
        [secondOperandLabel setTextAlignment:UITextAlignmentRight];
        
        [blackBar setBackgroundColor:[UIColor blackColor]];
        [blackBar setFrame:CGRectMake(60, 80, 200, 2)];
        
        [responseLabel setBackgroundColor:[UIColor clearColor]];
        [responseLabel setFont:[UIFont fontWithName:@"Helvetica" size:36]];
        [responseLabel setFrame:CGRectMake(20, 82, 220, 40)];
        [responseLabel setTextAlignment:UITextAlignmentRight];
        
        [skipButton setFrame:CGRectMake(0, 210, 160, 50)];
        
        [doneButton setFrame:CGRectMake(160, 210, 160, 50)];
        
        [numberPad setBackgroundColor:[UIColor clearColor]];
        [numberPad setFrame:CGRectMake(0, 260, 320, 200)];
        
        [[numberPadButtons objectAtIndex:0]  setFrame:CGRectMake(107, 150, 106, 50)];
        [[numberPadButtons objectAtIndex:1]  setFrame:CGRectMake(  0,   0, 106, 50)];
        [[numberPadButtons objectAtIndex:2]  setFrame:CGRectMake(107,   0, 106, 50)];
        [[numberPadButtons objectAtIndex:3]  setFrame:CGRectMake(214,   0, 106, 50)];
        [[numberPadButtons objectAtIndex:4]  setFrame:CGRectMake(  0,  50, 106, 50)];
        [[numberPadButtons objectAtIndex:5]  setFrame:CGRectMake(107,  50, 106, 50)];
        [[numberPadButtons objectAtIndex:6]  setFrame:CGRectMake(214,  50, 106, 50)];
        [[numberPadButtons objectAtIndex:7]  setFrame:CGRectMake(  0, 100, 106, 50)];
        [[numberPadButtons objectAtIndex:8]  setFrame:CGRectMake(107, 100, 106, 50)];
        [[numberPadButtons objectAtIndex:9]  setFrame:CGRectMake(214, 100, 106, 50)];
        [[numberPadButtons objectAtIndex:10] setFrame:CGRectMake(  0, 150, 106, 50)];
        [[numberPadButtons objectAtIndex:11] setFrame:CGRectMake(214, 150, 106, 50)];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPhoneLandscape:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    // TODO
    [self buildInterfaceIPhonePortrait:duration];
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPadPortrait:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    // TODO
    [self buildInterfaceIPhonePortrait:duration];
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPadLandscape:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    // TODO
    [self buildInterfaceIPhonePortrait:duration];
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

#pragma mark -

- (void)pressedFamigoButton:(id)sender {
    NSLog(@"pressedFamigoButton");
}

- (void)pressedSettingsButton:(id)sender {
    NSLog(@"pressedSettingsButton");
}

- (void)pressedNumberPadButton:(id)sender {
    int index = [[[(UIButton *)sender titleLabel] text] intValue];
    switch (index) {
        case 10:
            response *= -1;
            break;
        case 11:
            response /= 10;
            break;
        default:
            // Don't let the response value overflow
            if (log10(abs(response)) < 8) {
                response *= 10;
                response += index;
            }
            break;
    }
    
    if (response == 0) {
        [responseLabel setText:@""];
    }
    else {
        [responseLabel setText:[NSString stringWithFormat:@"%d", response]];
    }
}

- (void)pressedSkipButton:(id)sender {
    [self generateEquation];
}

- (void)pressedDoneButton:(id)sender {
    if (response == result) {
        // great jorb!
    }
    else {
        // try again, sucka
    }
    [self generateEquation];
}

#pragma mark -

- (void)generateEquation {
    if (arithmeticEquationGenerator == nil) {
        arithmeticEquationGenerator = [[ArithmeticEquationGenerator alloc] initWithDifficulty:VeryHard allowNegativeNumbers:YES];
    }
    
    ArithmeticEquation *ae = [arithmeticEquationGenerator generateEquation];
    [firstOperandLabel setText:[ae firstOperandAsString]];
    [operationLabel setText:[ae operationAsString]];
    [secondOperandLabel setText:[ae secondOperandAsString]];
    result = [ae result];
    response = 0;
    [responseLabel setText:@""];
}

@end