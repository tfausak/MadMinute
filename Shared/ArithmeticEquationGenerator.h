//
//  ArithmeticEquationGenerator.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArithmeticEquation.h"

typedef enum {
    VeryEasy,
    Easy,
    Medium,
    Hard,
    VeryHard
} Difficulty;

@interface ArithmeticEquationGenerator : NSObject {
    Difficulty difficulty;
    int allowedOperations;
    BOOL allowNegativeNumbers;
    int additionMax;
    int subtractionMax;
    int multiplicationMax;
    int divisionMax;
}

@property (nonatomic, assign, readonly) Difficulty difficulty;
@property (nonatomic, assign, readonly) int allowedOperations;
@property (nonatomic, assign, readonly) BOOL allowNegativeNumbers;
@property (nonatomic, assign, readonly) int additionMax;
@property (nonatomic, assign, readonly) int subtractionMax;
@property (nonatomic, assign, readonly) int multiplicationMax;
@property (nonatomic, assign, readonly) int divisionMax;

- (id)initWithDifficulty:(Difficulty)theDifficulty allowNegativeNumbers:(BOOL)negativeNumbers;
- (ArithmeticEquation *)generateEquation;

@end