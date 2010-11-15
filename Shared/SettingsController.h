//
//  SettingsController.h
//  MadMinute
//
//  Created by Taylor Fausak on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamigoHeaders.h"

@interface SettingsController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIViewController *parentViewController;
    NSIndexPath *difficulty;
    
    // UI elements
    UINavigationBar *navigationBar;
    UITableView *settingsTableView;
    UISwitch *allowNegativeNumbersSwitch;
}

@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, retain) NSIndexPath *difficulty;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *settingsTableView;
@property (nonatomic, retain) UISwitch *allowNegativeNumbersSwitch;

- (void)toggledSwitch:(id)sender;
- (void)drawUI;
- (void)updateUI;

@end