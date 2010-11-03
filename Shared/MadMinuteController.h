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
}

@property (nonatomic, retain) FamigoController *famigoController;
@property (nonatomic, retain) LogoAnimationController *logoAnimationController;

- (void)famigoReady;

@end