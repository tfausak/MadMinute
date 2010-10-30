//
//  AardvarkController.m
//  Aardvark
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AardvarkController.h"
#import "ArithmeticEquationGenerator.h"

@interface AardvarkController()

@property (nonatomic, assign) BOOL interfaceIsBuilt;

- (void)buildInterfaceIPhonePortrait:(NSTimeInterval)duration;
- (void)buildInterfaceIPhoneLandscape:(NSTimeInterval)duration;
- (void)buildInterfaceIPadPortrait:(NSTimeInterval)duration;
- (void)buildInterfaceIPadLandscape:(NSTimeInterval)duration;
- (void)pressedNumberPadButton:(id)sender;

@end

@implementation AardvarkController

@synthesize interfaceIsBuilt;
@synthesize famigoController;
@synthesize logoAnimationController;
@synthesize navigationBar;
@synthesize prompt;
@synthesize firstOperandLabel;
@synthesize operationLabel;
@synthesize secondOperandLabel;
@synthesize response;
@synthesize responseValue;
@synthesize responseLabel;
@synthesize numberPad;
@synthesize numberPadButtons;

- (void)dealloc {
    [famigoController release];
    [logoAnimationController release];
    [navigationBar release];
    [prompt release];
    [firstOperandLabel release];
    [operationLabel release];
    [secondOperandLabel release];
    [response release];
    [responseLabel release];
    [numberPad release];
    [numberPadButtons release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Creating a View Controller Using Nib Files

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
    }
    return self;
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
    [self buildInterface];
    
    ArithmeticEquationGenerator *aeg = [[ArithmeticEquationGenerator alloc] initWithDifficulty:VeryHard allowNegativeNumbers:YES];
    ArithmeticEquation *ae = [aeg generateEquation];
    [firstOperandLabel setText:[ae firstOperandAsString]];
    [operationLabel setText:[ae operationAsString]];
    [secondOperandLabel setText:[ae secondOperandAsString]];
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
    [logoAnimationController registerForNotifications:self withSelector:@selector(logoAnimationDidFinish:)];*/
}

/*
- (void)viewDidUnload {
}
*/

/*
- (void)isViewLoaded {
}
*/

#pragma mark -
#pragma mark Responding to View Events

/*
- (void)viewWillAppear:(BOOL)animated {
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/

#pragma mark -
#pragma mark Configuring the View Rotation Settings

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/*
- (UIView *)rotatingHeaderView {
}
*/

/*
- (UIView *)rotatingFooterView {
}
*/

#pragma mark -
#pragma mark Responding to View Rotation Events

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self buildInterface:duration];
}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}
*/

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}
*/

/*
- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}
*/

/*
- (void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
}
*/

/*
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
}
*/

#pragma mark -
#pragma mark Handling Memory Warnings

/*
- (void)didReceiveMemoryWarning {
}
*/

#pragma mark -
#pragma mark Presenting Modal Views

/*
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
}
*/

/*
- (void)dismissModalViewControllerAnimated:(BOOL)animated {
}
*/

#pragma mark -
#pragma mark Configuring a Navigation Interface

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
}
*/

/*
- (UIBarButtonItem *)editButtonItem {
}
*/

#pragma mark -
#pragma mark Configuring the Navigation Controller’s Toolbar

/*
- (void)setToolbarItems:(NSArray *)toolbarItems animated:(BOOL)animated {
}
*/

#pragma mark -

- (void)famigoReady {
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
        
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Aardvark"];
        [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Famigo" style:UIBarButtonItemStylePlain target:nil action:nil]];
        [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:nil action:nil]];
        
        navigationBar = [[UINavigationBar alloc] init];
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [[self view] addSubview:navigationBar];
        
        prompt = [[UIView alloc] init];
        [[self view] addSubview:prompt];
        
        firstOperandLabel = [[UILabel alloc] init];
        [prompt addSubview:firstOperandLabel];
        
        operationLabel = [[UILabel alloc] init];
        [prompt addSubview:operationLabel];
        
        secondOperandLabel = [[UILabel alloc] init];
        [prompt addSubview:secondOperandLabel];
                
        response = [[UIView alloc] init];
        [[self view] addSubview:response];
        
        responseLabel = [[UILabel alloc] init];
        [responseLabel setText:[NSString stringWithFormat:@"%d", responseValue]];
        [response addSubview:responseLabel];
        
        numberPad = [[UIView alloc] init];
        [[self view] addSubview:numberPad];
        
        numberPadButtons = [[NSMutableArray alloc] initWithCapacity:12];
        for (int index = 0; index < 12; index += 1) {
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
        
        [prompt setFrame:CGRectMake(0, 44, 320, 136)];
        [prompt setBackgroundColor:[UIColor clearColor]];
        
        [firstOperandLabel setBackgroundColor:[UIColor clearColor]];
        [firstOperandLabel setFrame:CGRectMake(20, 20, 280, 40)];
        [firstOperandLabel setTextAlignment:UITextAlignmentRight];
        
        [operationLabel setBackgroundColor:[UIColor clearColor]];
        [operationLabel setFrame:CGRectMake(20, 60, 280, 40)];
        
        [secondOperandLabel setBackgroundColor:[UIColor clearColor]];
        [secondOperandLabel setFrame:CGRectMake(20, 60, 280, 40)];
        [secondOperandLabel setTextAlignment:UITextAlignmentRight];
        
        [response setFrame:CGRectMake(0, 178, 320, 60)];
        [response setBackgroundColor:[UIColor clearColor]];
        
        [responseLabel setFrame:CGRectMake(20, 0, 280, 60)];
        [responseLabel setBackgroundColor:[UIColor clearColor]];
        [responseLabel setTextAlignment:UITextAlignmentCenter];
        
        [numberPad setFrame:CGRectMake(0, 280, 320, 180)];
        [numberPad setBackgroundColor:[UIColor clearColor]];
        
        [[numberPadButtons objectAtIndex:0]  setFrame:CGRectMake(107, 135, 107, 45)];
        [[numberPadButtons objectAtIndex:1]  setFrame:CGRectMake(  0,   0, 107, 45)];
        [[numberPadButtons objectAtIndex:2]  setFrame:CGRectMake(107,   0, 107, 45)];
        [[numberPadButtons objectAtIndex:3]  setFrame:CGRectMake(214,   0, 107, 45)];
        [[numberPadButtons objectAtIndex:4]  setFrame:CGRectMake(  0,  45, 107, 45)];
        [[numberPadButtons objectAtIndex:5]  setFrame:CGRectMake(107,  45, 107, 45)];
        [[numberPadButtons objectAtIndex:6]  setFrame:CGRectMake(214,  45, 107, 45)];
        [[numberPadButtons objectAtIndex:7]  setFrame:CGRectMake(  0,  90, 107, 45)];
        [[numberPadButtons objectAtIndex:8]  setFrame:CGRectMake(107,  90, 107, 45)];
        [[numberPadButtons objectAtIndex:9]  setFrame:CGRectMake(214,  90, 107, 45)];
        [[numberPadButtons objectAtIndex:10] setFrame:CGRectMake(  0, 135, 107, 45)];
        [[numberPadButtons objectAtIndex:11] setFrame:CGRectMake(214, 135, 107, 45)];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPhoneLandscape:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    // TODO
    return [self buildInterfaceIPhonePortrait:duration];
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPadPortrait:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    // TODO
    return [self buildInterfaceIPhonePortrait:duration];
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPadLandscape:(NSTimeInterval)duration {
    NSAssert(interfaceIsBuilt, @"Interface not built before resizing");
    
    // TODO
    return [self buildInterfaceIPhonePortrait:duration];
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

#pragma mark -

- (void)pressedNumberPadButton:(id)sender {
    int index = [[[(UIButton *)sender titleLabel] text] intValue];
    switch (index) {
        case 10:
            responseValue *= -1;
            break;
        case 11:
            responseValue /= 10;
            break;
        default:
            responseValue *= 10;
            responseValue += index;
            break;
    }
    
    [responseLabel setText:[NSString stringWithFormat:@"%d", responseValue]];
}

@end