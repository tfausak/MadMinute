//
//  SettingsController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

@synthesize parentViewController;
@synthesize navigationBar;
@synthesize difficultySlider;
@synthesize allowNegativeNumbersSwitch;

- (void)dealloc {
    [parentViewController release];
    [navigationBar release];
    [difficultySlider release];
    [allowNegativeNumbersSwitch release];
    
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
    
    navigationBar = [[UINavigationBar alloc] init]; {
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [navigationItem setTitle:@"Settings"]; 
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Famigo"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:parentViewController
                                                                      action:@selector(pressedFamigoButton:)];
        [navigationItem setLeftBarButtonItem:leftButton];
        [leftButton release];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:parentViewController
                                                                       action:@selector(pressedNewGameButton:)];
        [navigationItem setRightBarButtonItem:rightButton];
        [rightButton release];
        
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem release];
    } [[self view] addSubview:navigationBar];
    
    difficultySlider = [[UISlider alloc] init]; {
        [difficultySlider addTarget:self action:@selector(movedSlider:) forControlEvents:UIControlEventValueChanged];
        
        int difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"];
        [difficultySlider setValue:difficulty animated:YES];
    } [[self view] addSubview:difficultySlider];
    
    allowNegativeNumbersSwitch = [[UISwitch alloc] init]; {
        [allowNegativeNumbersSwitch addTarget:self action:@selector(toggledSwitch:) forControlEvents:UIControlEventValueChanged];
        
        BOOL allowNegativeNumbers = [[NSUserDefaults standardUserDefaults] boolForKey:@"allowNegativeNumbers"];
        [allowNegativeNumbersSwitch setOn:allowNegativeNumbers];
    } [[self view] addSubview:allowNegativeNumbersSwitch];
    
    [self updateUI];
}

#pragma mark -

- (void)movedSlider:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:([difficultySlider value] * 4) forKey:@"difficulty"];
    [defaults synchronize];
}

- (void)toggledSwitch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[allowNegativeNumbersSwitch isOn] forKey:@"allowNegativeNumbers"];
    [defaults synchronize];    
}

#pragma mark -

- (void)updateUI {
    [UIView beginAnimations:nil context:nil];
    
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
            
            [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
            
            [difficultySlider setFrame:CGRectMake(20, 64, 280, 22)];
            
            [allowNegativeNumbersSwitch setFrame:CGRectMake(113, 106, 94, 27)];
        }
    }
    
    [UIView commitAnimations];
}

@end