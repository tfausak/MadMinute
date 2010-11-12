//
//  SettingsController.h
//  MadMinute
//
//  Created by Taylor Fausak on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamigoHeaders.h"
#import "FBConnect.h"

@interface SettingsController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    UIViewController *parentViewController;
    Facebook *facebook;
    BOOL loggedIntoFacebook;
    
    // UI elements
    UINavigationBar *navigationBar;
    UISlider *difficultySlider;
    UISwitch *allowNegativeNumbersSwitch;
    UIButton *facebookButton;
    UIButton *shareButton;
    UIButton *linkButton;
}

@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) BOOL loggedIntoFacebook;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UISlider *difficultySlider;
@property (nonatomic, retain) UISwitch *allowNegativeNumbersSwitch;
@property (nonatomic, retain) UIButton *facebookButton;
@property (nonatomic, retain) UIButton *shareButton;
@property (nonatomic, retain) UIButton *linkButton;

- (void)movedSlider:(id)sender;
- (void)toggledSwitch:(id)sender;
- (void)pressedFacebookButton:(id)sender;
- (void)pressedShareButton:(id)sender;
- (void)pressedLinkButton:(id)sender;
- (void)drawUI;
- (void)updateUI;

@end