//
//  GameController.h
//  MadMinute
//
//  Created by Taylor Fausak on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Famigo.h"
#import "ArithmeticEquationGenerator.h"

@interface GameController : UIViewController {
    UIViewController *parentViewController;
    
    // Game state
    ArithmeticEquationGenerator *arithmeticEquationGenerator;
    ArithmeticEquation *arithmeticEquation;
    NSTimer *gameClock;
    int timeLeft;
    NSString *responseValue;
    BOOL responseIsPositive;
    int score;
    int numberRight;
    int numberWrong;
    int numberSkipped;
    
    // UI elements
    UINavigationBar *navigationBar;
    UITextField *scoreLabel;
    UIView *timeBar;
    UIView *timeElapsedBar;
    UILabel *timeElapsedLabel;
    UILabel *firstOperandLabel;
    UILabel *operatorLabel;
    UILabel *secondOperandLabel;
    UIView *responseBar;
    UIView *responseBackground;
    UILabel *responseLabel;
    UISegmentedControl *signControl;
    UIView *numberPad;
}

@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, retain) ArithmeticEquationGenerator *arithmeticEquationGenerator;
@property (nonatomic, retain) ArithmeticEquation *arithmeticEquation;
@property (nonatomic, retain) NSTimer *gameClock;
@property (nonatomic, assign) int timeLeft;
@property (nonatomic, retain) NSString *responseValue;
@property (nonatomic, assign) BOOL responseIsPositive;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int numberRight;
@property (nonatomic, assign) int numberWrong;
@property (nonatomic, assign) int numberSkipped;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITextField *scoreLabel;
@property (nonatomic, retain) UIView *timeBar;
@property (nonatomic, retain) UIView *timeElapsedBar;
@property (nonatomic, retain) UILabel *timeElapsedLabel;
@property (nonatomic, retain) UILabel *firstOperandLabel;
@property (nonatomic, retain) UILabel *operatorLabel;
@property (nonatomic, retain) UILabel *secondOperandLabel;
@property (nonatomic, retain) UIView *responseBar;
@property (nonatomic, retain) UIView *responseBackground;
@property (nonatomic, retain) UILabel *responseLabel;
@property (nonatomic, retain) UISegmentedControl *signControl;
@property (nonatomic, retain) UIView *numberPad;

- (void)newGame;
- (void)endGame;
- (void)gameClockExpired;
- (void)pressedNumberPadButton:(id)sender;
- (void)pressedDeleteButton:(id)sender;
- (void)pressedDoneButton:(id)sender;
- (void)pressedSignControl:(id)sender;
- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)drawUI;
- (void)updateUI;

@end