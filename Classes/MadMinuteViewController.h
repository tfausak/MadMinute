//
//  MadMinuteViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ArithmeticEquationGenerator.h"

@interface MadMinuteViewController : UIViewController <UIAlertViewDelegate> {
    // Game settings
    GameType gameType;
    Difficulty difficulty;
    int numberOfPlayers;
    BOOL allowNegativeNumbers;
    
    // Game state
    int currentPlayer;
    ArithmeticEquationGenerator *arithmeticEquationGenerator;
    ArithmeticEquation *arithmeticEquation;
    NSTimer *timer;
    int timeLeft;
    int score;
    NSString *responseValue;
    BOOL responseIsPositive;
    
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

@property (nonatomic, assign, readonly) GameType gameType;
@property (nonatomic, assign, readonly) Difficulty difficulty;
@property (nonatomic, assign, readonly) int numberOfPlayers;
@property (nonatomic, assign, readonly) BOOL allowNegativeNumbers;

@property (nonatomic, assign, readonly) int currentPlayer;
@property (nonatomic, retain, readonly) ArithmeticEquationGenerator *arithmeticEquationGenerator;
@property (nonatomic, retain, readonly) ArithmeticEquation *arithmeticEquation;
@property (nonatomic, retain, readonly) NSTimer *timer;
@property (nonatomic, assign, readonly) int timeLeft;
@property (nonatomic, assign, readonly) int score;
@property (nonatomic, retain, readonly) NSString *responseValue;
@property (nonatomic, assign, readonly) BOOL responseIsPositive;

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

- (void)startGame;
- (void)stopGame;
- (void)cancelGame;
- (void)timerDidFire;
- (NSString *)deviceName;
- (NSString *)nameForPlayerNumber:(int)number;
- (void)signControlValueDidChange;
- (void)pressedNumberPadButton:(id)sender;
- (void)drawUI;
- (void)updateUI;

@end