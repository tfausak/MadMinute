//
//  MadMinuteController.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamigoHeaders.h"

@interface MadMinuteController : UIViewController <FamigoControllerDelegate> {
    FamigoController *famigoController;
    LogoAnimationController *logoAnimationController;
    
    // Interface elements
    UINavigationBar *navigationBar;
    UIView *prompt;
    UILabel *firstOperandLabel;
    UILabel *operationLabel;
    UILabel *secondOperandLabel;
    UIView *response;
    int responseValue;
    UILabel *responseLabel;
    UIView *numberPad;
    NSMutableArray *numberPadButtons;
}

@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) LogoAnimationController *logoAnimationController;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIView *prompt;
@property (nonatomic, retain) UILabel *firstOperandLabel;
@property (nonatomic, retain) UILabel *operationLabel;
@property (nonatomic, retain) UILabel *secondOperandLabel;
@property (nonatomic, retain) UIView *response;
@property (nonatomic, assign) int responseValue;
@property (nonatomic, retain) UILabel *responseLabel;
@property (nonatomic, retain) UIView *numberPad;
@property (nonatomic, retain) NSMutableArray *numberPadButtons;

- (void)famigoReady;
- (void)buildInterface;
- (void)buildInterface:(NSTimeInterval)duration;

@end