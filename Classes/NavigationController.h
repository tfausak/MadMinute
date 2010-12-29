//
//  NavigationController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Famigo.h"
#import "LogoAnimationController.h"
#import "GameTypeSelectorViewController.h"
#import "FamigoController.h"
#import "SettingsViewController.h"
#import "MadMinuteViewController.h"
#import "ResultsViewController.h"

@interface NavigationController : UINavigationController <FamigoControllerDelegate, UINavigationControllerDelegate> {
    LogoAnimationController *logoAnimationController;
    GameTypeSelectorViewController *gameTypeSelectorViewController;
    FamigoController *famigoController;
    SettingsViewController *settingsViewController;
    MadMinuteViewController *madMinuteViewController;
    ResultsViewController *resultsViewController;
    UIAlertView *waitAlertView;
}

@property (nonatomic, retain) LogoAnimationController *logoAnimationController;
@property (nonatomic, retain) GameTypeSelectorViewController *gameTypeSelectorViewController;
@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) SettingsViewController *settingsViewController;
@property (nonatomic, retain) MadMinuteViewController *madMinuteViewController;
@property (nonatomic, retain) ResultsViewController *resultsViewController;
@property (nonatomic, retain) UIAlertView *waitAlertView;

- (void)logoAnimationDidFinish;
- (void)didSelectGameType:(int)gameType;
- (void)didStartGame;
- (void)didStopGame;
- (void)didReceiveFamigoNotification:(NSNotification *)notification;

@end