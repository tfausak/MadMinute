//
//  AardvarkController.m
//  Aardvark
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AardvarkController.h"
#import "QuestionGenerator.h"
#import "MathQuestion.h"

@interface AardvarkController()

@property (nonatomic, assign) BOOL interfaceIsBuilt;

- (void)buildInterfaceIPhonePortrait:(NSTimeInterval)duration;
- (void)buildInterfaceIPhoneLandscape:(NSTimeInterval)duration;
- (void)buildInterfaceIPadPortrait:(NSTimeInterval)duration;
- (void)buildInterfaceIPadLandscape:(NSTimeInterval)duration;
- (void)pressedNumberPadButton:(id)sender;

@end

@implementation AardvarkController

@synthesize famigoController;
@synthesize logoAnimationController;
@synthesize interfaceIsBuilt;
@synthesize numberPad;
@synthesize numberPadButtons;
@synthesize answer;
@synthesize questionText;
@synthesize questionGenerator;
@synthesize currentQuestion;

- (void)dealloc {
    [famigoController release];
    [logoAnimationController release];
    [numberPad release];
    [numberPadButtons release];
    [answer release];
    [questionGenerator release];
	[questionText release];
	
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
	
	self.questionText = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 150)];
	[self.view addSubview:questionText];
	
	self.questionGenerator = [[QuestionGenerator alloc] initWithDifficulty:2];
	self.currentQuestion = [self.questionGenerator generateQuestion];
	self.questionText.text = currentQuestion.questionText;
}

- (void)buildInterface:(NSTimeInterval)duration {
    // Only create the interface elements once
    // Every other call will just move things around
    if (!interfaceIsBuilt) {
        interfaceIsBuilt = YES;
        
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        // Create the number pad view
        numberPad = [[UIView alloc] init];
        [numberPad setBackgroundColor:[UIColor lightGrayColor]];
        [[self view] addSubview:numberPad];
        
        // Create all the buttons and put them in the number pad
        numberPadButtons = [[NSMutableArray alloc] initWithCapacity:14];
        for (int index = 0; index < 14; index += 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [numberPad addSubview:button];
            [button addTarget:self action:@selector(pressedNumberPadButton:) forControlEvents:UIControlEventTouchUpInside];
            [numberPadButtons insertObject:button atIndex:index];
        }
        
        // Set the buttons' titles
        [[numberPadButtons objectAtIndex:0]  setTitle:@"0" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:1]  setTitle:@"1" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:2]  setTitle:@"2" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:3]  setTitle:@"3" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:4]  setTitle:@"4" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:5]  setTitle:@"5" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:6]  setTitle:@"6" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:7]  setTitle:@"7" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:8]  setTitle:@"8" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:9]  setTitle:@"9" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:10] setTitle:@"." forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:11] setTitle:@"C" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:12] setTitle:@"±" forState:UIControlStateNormal];
        [[numberPadButtons objectAtIndex:13] setTitle:@"=" forState:UIControlStateNormal];
        
        // Create the answer text field
        answer = [[UITextField alloc] init];
        [answer setBorderStyle:UITextBorderStyleLine];
        [answer setText:@""];
        [[self view] addSubview:answer];
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
    assert(interfaceIsBuilt);
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
        
        [numberPad setFrame:CGRectMake(0, 236, 320, 224)];
        
        [[numberPadButtons objectAtIndex:0]  setFrame:CGRectMake( 20, 164, 136, 40)];
        [[numberPadButtons objectAtIndex:1]  setFrame:CGRectMake( 20, 116,  64, 40)];
        [[numberPadButtons objectAtIndex:2]  setFrame:CGRectMake( 92, 116,  64, 40)];
        [[numberPadButtons objectAtIndex:3]  setFrame:CGRectMake(164, 116,  64, 40)];
        [[numberPadButtons objectAtIndex:4]  setFrame:CGRectMake( 20,  68,  64, 40)];
        [[numberPadButtons objectAtIndex:5]  setFrame:CGRectMake( 92,  68,  64, 40)];
        [[numberPadButtons objectAtIndex:6]  setFrame:CGRectMake(164,  68,  64, 40)];
        [[numberPadButtons objectAtIndex:7]  setFrame:CGRectMake( 20,  20,  64, 40)];
        [[numberPadButtons objectAtIndex:8]  setFrame:CGRectMake( 92,  20,  64, 40)];
        [[numberPadButtons objectAtIndex:9]  setFrame:CGRectMake(164,  20,  64, 40)];
        [[numberPadButtons objectAtIndex:10] setFrame:CGRectMake(164, 164,  64, 40)];
        [[numberPadButtons objectAtIndex:11] setFrame:CGRectMake(236,  20,  64, 40)];
        [[numberPadButtons objectAtIndex:12] setFrame:CGRectMake(236,  68,  64, 40)];
        [[numberPadButtons objectAtIndex:13] setFrame:CGRectMake(236, 116,  64, 88)];
        
        [answer setFrame:CGRectMake(20, 183, 280, 40)];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPhoneLandscape:(NSTimeInterval)duration {
    assert(interfaceIsBuilt);
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPadPortrait:(NSTimeInterval)duration {
    assert(interfaceIsBuilt);
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

- (void)buildInterfaceIPadLandscape:(NSTimeInterval)duration {
    assert(interfaceIsBuilt);
    
    [UIView beginAnimations:nil context:nil]; {
        [UIView setAnimationDuration:duration];
    } [UIView commitAnimations];
}

#pragma mark -

- (void)pressedNumberPadButton:(id)sender {
    NSString *text = [[(UIButton *)sender titleLabel] text];
    assert([text length] == 1);
    unichar action = [text characterAtIndex:0];
    
    if (action >= 48 && action <= 57) { // a digit
        [answer setText:[[answer text] stringByAppendingString:text]];
    }
    else if (action == 46) { // "."
        NSRange range = [[answer text] rangeOfString:text];
        if (range.location == NSNotFound) {
            if ([[answer text] length] == 0) {
                [answer setText:[[answer text] stringByAppendingString:@"0"]];
            }
            [answer setText:[[answer text] stringByAppendingString:text]];
        }
    }
    else if (action == 177) { // "±"
        if ([[answer text] length] > 0 && [[answer text] characterAtIndex:0] == 45) { // "-"
            [answer setText:[[answer text] substringFromIndex:1]];
        }
        else {
            [answer setText:[@"-" stringByAppendingString:[answer text]]];
        }
    }
    else if (action == 67) { // "C" (clear)
        [answer setText:@""];
    }
    else if (action == 61) { // "="
    }
}

@end