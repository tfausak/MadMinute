//
//  MadMinuteViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Famigo;
@class ArithmeticEquationGenerator;
@class ArithmeticEquation;

@interface MadMinuteViewController : UIViewController <UIAlertViewDelegate> {
    Famigo *famigo;
    
    // Game state
    NSInteger currentPlayer;
    ArithmeticEquationGenerator *arithmeticEquationGenerator;
    ArithmeticEquation *arithmeticEquation;
    NSTimer *timer;
    NSInteger timeLeft;
    NSString *responseValue;
    BOOL responseIsPositive;
    NSMutableArray *questions;
    
    // User interface
    UIView *timeBar;
    UIView *timeElapsedBar;
    UILabel *timeElapsedLabel;
    UILabel *firstOperandLabel;
    UILabel *operatorLabel;
    UILabel *secondOperandLabel;
    UIView *responseBackground;
    UILabel *responseLabel;
    UISegmentedControl *signControl;
    UIView *numberPad;
}

@property (nonatomic, retain, readonly) Famigo *famigo;
@property (nonatomic, assign, readonly) NSInteger currentPlayer;
@property (nonatomic, retain, readonly) ArithmeticEquationGenerator *arithmeticEquationGenerator;
@property (nonatomic, retain, readonly) ArithmeticEquation *arithmeticEquation;
@property (nonatomic, retain, readonly) NSTimer *timer;
@property (nonatomic, assign, readonly) NSInteger timeLeft;
@property (nonatomic, retain, readonly) NSString *responseValue;
@property (nonatomic, assign, readonly) BOOL responseIsPositive;
@property (nonatomic, retain, readonly) NSMutableArray *questions;
@property (nonatomic, retain, readonly) UIView *timeBar;
@property (nonatomic, retain, readonly) UIView *timeElapsedBar;
@property (nonatomic, retain, readonly) UILabel *timeElapsedLabel;
@property (nonatomic, retain, readonly) UILabel *firstOperandLabel;
@property (nonatomic, retain, readonly) UILabel *operatorLabel;
@property (nonatomic, retain, readonly) UILabel *secondOperandLabel;
@property (nonatomic, retain, readonly) UIView *responseBackground;
@property (nonatomic, retain, readonly) UILabel *responseLabel;
@property (nonatomic, retain, readonly) UISegmentedControl *signControl;
@property (nonatomic, retain, readonly) UIView *numberPad;

// Misc utilities
- (NSString *)playerKeyFor:(NSInteger)playerNumber;
- (NSString *)playerNameFor:(NSInteger)playerNumber;

// Game control
- (void)startGame;
- (void)stopGame;
- (void)cancelGame;

// Timer
- (void)timerDidFire;
- (void)timerDidExpire;

// Buttons
- (void)signControlValueDidChange;
- (void)pressedNumberPadButton:(id)sender;

// UI
- (void)initUI;
- (void)drawUI;
- (void)updateUI;

@end