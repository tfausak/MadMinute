//
//  SettingsController.h
//  MadMinute
//
//  Created by Taylor Fausak on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController {
    UIViewController *parentViewController;
    
    // UI elements
    UINavigationBar *navigationBar;
    UISlider *difficultySlider;
    UISwitch *allowNegativeNumbersSwitch;
}

@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UISlider *difficultySlider;
@property (nonatomic, retain) UISwitch *allowNegativeNumbersSwitch;

- (void)movedSlider:(id)sender;
- (void)toggledSwitch:(id)sender;
- (void)drawUI;
- (void)updateUI;

@end