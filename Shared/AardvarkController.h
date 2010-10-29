//
//  AardvarkController.h
//  Aardvark
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamigoHeaders.h"

@class QuestionGenerator, MathQuestion;

@interface AardvarkController : UIViewController <FamigoControllerDelegate> {
    FamigoController *famigoController;
    LogoAnimationController *logoAnimationController;
    
    // Interface elements
    UIView *numberPad;
    NSMutableArray *numberPadButtons;
    UITextField *answer;
	UILabel *questionText;
	QuestionGenerator *questionGenerator;
	MathQuestion *currentQuestion;
}

@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) LogoAnimationController *logoAnimationController;
@property (nonatomic, retain) UIView *numberPad;
@property (nonatomic, retain) NSMutableArray *numberPadButtons;
@property (nonatomic, retain) UITextField *answer;
@property (nonatomic, retain) UILabel *questionText;
@property (nonatomic, retain) QuestionGenerator *questionGenerator;
@property (nonatomic, retain) MathQuestion *currentQuestion;

- (void)famigoReady;
- (void)buildInterface;
- (void)buildInterface:(NSTimeInterval)duration;

@end