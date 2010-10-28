//
//  AardvarkController.m
//  Aardvark
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AardvarkController.h"

@interface AardvarkController()

- (void)buildInterfaceIPhonePortrait;
- (void)buildInterfaceIPhoneLandscape;
- (void)buildInterfaceIPadPortrait;
- (void)buildInterfaceIPadLandscape;

@end

@implementation AardvarkController

@synthesize famigoController;
@synthesize logoAnimationController;

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
    [self buildInterface];
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
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            switch ([[UIDevice currentDevice] orientation]) {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    return [self buildInterfaceIPhoneLandscape];
                default: return [self buildInterfaceIPhonePortrait];
            }
        case UIUserInterfaceIdiomPad:
            switch ([[UIDevice currentDevice] orientation]) {
                case UIInterfaceOrientationLandscapeLeft:
                case UIInterfaceOrientationLandscapeRight:
                    return [self buildInterfaceIPadLandscape];
                default: return [self buildInterfaceIPadPortrait];
            }
        default: return;
    }
}

- (void)buildInterfaceIPhonePortrait {
}

- (void)buildInterfaceIPhoneLandscape {
}

- (void)buildInterfaceIPadPortrait {
}

- (void)buildInterfaceIPadLandscape {
}

@end