//
//  ArithmeticEquationGenerator.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
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
    NSMutableArray *allowedOperations;
    BOOL allowNegativeNumbers;
    int additionMax;
    int subtractionMax;
    int multiplicationMax;
    int divisionMax;
}

@property (nonatomic, assign, readonly) Difficulty difficulty;
@property (nonatomic, retain, readonly) NSMutableArray *allowedOperations;
@property (nonatomic, assign, readonly) BOOL allowNegativeNumbers;
@property (nonatomic, assign, readonly) int additionMax;
@property (nonatomic, assign, readonly) int subtractionMax;
@property (nonatomic, assign, readonly) int multiplicationMax;
@property (nonatomic, assign, readonly) int divisionMax;

- (id)initWithDifficulty:(Difficulty)_difficulty allowNegativeNumbers:(BOOL)_allowNegativeNumbers;
- (ArithmeticEquation *)generateEquation;

@end