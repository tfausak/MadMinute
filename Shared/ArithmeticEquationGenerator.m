//
//  ArithmeticEquationGenerator.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArithmeticEquationGenerator.h"

@implementation ArithmeticEquationGenerator

@synthesize difficulty;
@synthesize allowedOperations;
@synthesize allowNegativeNumbers;
@synthesize additionMax;
@synthesize subtractionMax;
@synthesize multiplicationMax;
@synthesize divisionMax;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithDifficulty:(Difficulty)theDifficulty allowNegativeNumbers:(BOOL)negativeNumbers {
    if (self = [super init]) {
        difficulty = theDifficulty;
        allowNegativeNumbers = negativeNumbers;
        
        switch (difficulty) {
            case VeryEasy:
                allowedOperations = Addition;
                additionMax = 10;
                break;
            case Easy:
                allowedOperations = Addition | Subtraction;
                additionMax = 20;
                subtractionMax = 10;
                break;
            case Medium:
                allowedOperations = Addition | Subtraction | Multiplication;
                additionMax = 50;
                subtractionMax = 20;
                multiplicationMax = 6;
                break;
            case Hard:
                allowedOperations = Addition | Subtraction | Multiplication | Division;
                additionMax = 100;
                subtractionMax = 50;
                multiplicationMax = 13;
                divisionMax = 6;
                break;
            case VeryHard:
                additionMax = 100;
                subtractionMax = 100;
                multiplicationMax = 13;
                divisionMax = 13;
                break;
            default:
                NSAssert(NO, @"Unknown difficulty");
                break;
        }
    }
    return self;
}

- (ArithmeticEquation *)generateEquation {
    float firstOperand;
    Operation operation;
    float secondOperand;
    
    // Generate a random operation
    operation = pow(2, arc4random() % sizeof(Operation));
    switch (operation) {
        case Addition:
            firstOperand = arc4random() % additionMax;
            secondOperand = arc4random() % additionMax;
            break;
        case Subtraction:
            firstOperand = arc4random() % subtractionMax;
            secondOperand = arc4random() % subtractionMax;
            if (!allowNegativeNumbers && secondOperand > firstOperand) {
                float tmp = firstOperand;
                firstOperand = secondOperand;
                secondOperand = tmp;
            }
            break;
        case Multiplication:
            firstOperand = arc4random() % multiplicationMax;
            secondOperand = arc4random() % multiplicationMax;
            break;
        case Division:
            do {
                secondOperand = arc4random() % divisionMax;
            } while (secondOperand == 0);
            
            firstOperand = secondOperand * (arc4random() % divisionMax);
            break;
        default:
            NSAssert(NO, @"Unknown operation");
            break;
    }
    
    return [[ArithmeticEquation alloc] initWithFirstOperand:firstOperand operation:operation secondOperand:secondOperand];
}

@end