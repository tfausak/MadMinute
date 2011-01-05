//
//  NavigationController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FamigoController.h"

@class LogoAnimationController;
@class GameTypeSelectorViewController;
@class Settings;
@class MadMinuteViewController;
@class ResultsViewController;

@interface NavigationController : UINavigationController <FamigoControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    LogoAnimationController *logoAnimationController;
    GameTypeSelectorViewController *gameTypeSelectorViewController;
    FamigoController *famigoController;
    Settings *settings;
    MadMinuteViewController *madMinuteViewController;
    ResultsViewController *resultsViewController;
    UIAlertView *waitAlertView;
}

@property (nonatomic, retain) LogoAnimationController *logoAnimationController;
@property (nonatomic, retain) GameTypeSelectorViewController *gameTypeSelectorViewController;
@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) Settings *settings;
@property (nonatomic, retain) MadMinuteViewController *madMinuteViewController;
@property (nonatomic, retain) ResultsViewController *resultsViewController;
@property (nonatomic, retain) UIAlertView *waitAlertView;

- (void)logoAnimationDidFinish;
- (void)didSelectGameType:(GameType)gameType;
- (void)didStartGame;
- (void)didStopGame;
- (void)didReceiveFamigoNotification:(NSNotification *)notification;

@end