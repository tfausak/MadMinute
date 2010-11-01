//
//  MadMinuteController.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamigoHeaders.h"
#import "ArithmeticEquationGenerator.h"

@interface MadMinuteController : UIViewController <FamigoControllerDelegate> {
    FamigoController *famigoController;
    LogoAnimationController *logoAnimationController;
    ArithmeticEquationGenerator *arithmeticEquationGenerator;
    
    BOOL interfaceIsBuilt;
    int time;
    int score;
    int result;
    int response;
    
    UINavigationBar *navigationBar;
    UIView *statusView;
    UIProgressView *timeProgress;
    UILabel *scoreLabel;
    UIView *problemView;
    UILabel *firstOperandLabel;
    UILabel *operationLabel;
    UILabel *secondOperandLabel;
    UIView *blackBar;
    UILabel *responseLabel;
    UIButton *skipButton;
    UIButton *doneButton;
    UIView *numberPad;
    NSMutableArray *numberPadButtons;
}

@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) LogoAnimationController *logoAnimationController;
@property (nonatomic, retain) ArithmeticEquationGenerator *arithmeticEquationGenerator;

@property (nonatomic, assign) BOOL interfaceIsBuilt;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int result;
@property (nonatomic, assign) int response;

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIView *statusView;
@property (nonatomic, retain) UIProgressView *timeProgress;
@property (nonatomic, retain) UILabel *scoreLabel;
@property (nonatomic, retain) UIView *problemView;
@property (nonatomic, retain) UILabel *firstOperandLabel;
@property (nonatomic, retain) UILabel *operationLabel;
@property (nonatomic, retain) UILabel *secondOperandLabel;
@property (nonatomic, retain) UIView *blackBar;
@property (nonatomic, retain) UILabel *responseLabel;
@property (nonatomic, retain) UIButton *skipButton;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIView *numberPad;
@property (nonatomic, retain) NSMutableArray *numberPadButtons;

- (void)famigoReady;
- (void)buildInterface;
- (void)buildInterface:(NSTimeInterval)duration;
- (void)buildInterfaceIPhonePortrait:(NSTimeInterval)duration;
- (void)buildInterfaceIPhoneLandscape:(NSTimeInterval)duration;
- (void)buildInterfaceIPadPortrait:(NSTimeInterval)duration;
- (void)buildInterfaceIPadLandscape:(NSTimeInterval)duration;
- (void)pressedFamigoButton:(id)sender;
- (void)pressedSettingsButton:(id)sender;
- (void)pressedNumberPadButton:(id)sender;
- (void)pressedSkipButton:(id)sender;
- (void)pressedDoneButton:(id)sender;
- (void)generateEquation;

@end