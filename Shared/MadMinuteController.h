//
//  MadMinuteController.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SettingsController.h"
#import "GameController.h"
#import "FamigoHeaders.h"

@interface MadMinuteController : UIViewController <FamigoControllerDelegate> {
    SettingsController *settingsController;
    GameController *gameController;
    FamigoController *famigoController;
    LogoAnimationController *logoAnimationController;
	
	// Used for reachability.
	UIAlertView *networkAlert;
}

@property (nonatomic, retain) SettingsController *settingsController;
@property (nonatomic, retain) GameController *gameController;
@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) LogoAnimationController *logoAnimationController;

- (void)pressedFamigoButton:(id)sender;
- (void)pressedNewGameButton:(id)sender;
- (void)pressedSettingsButton:(id)sender;
- (void)famigoReady;
- (void)freezeGameNoNetwork;

@end