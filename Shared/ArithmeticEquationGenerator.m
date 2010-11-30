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
    [allowedOperations release];
    
    [super dealloc];
}

- (id)initWithDifficulty:(Difficulty)_difficulty allowNegativeNumbers:(BOOL)_allowNegativeNumbers {
    if (self = [super init]) {
        difficulty = _difficulty;
        allowNegativeNumbers = _allowNegativeNumbers;
        allowedOperations = [[NSMutableArray alloc] initWithObjects:
                             [NSNumber numberWithInt:Addition],
                             [NSNumber numberWithInt:Subtraction],
                             [NSNumber numberWithInt:Multiplication],
                             [NSNumber numberWithInt:Division],
                             nil];
        additionMax = subtractionMax = 51;
        multiplicationMax = divisionMax = 14;
        
        switch (difficulty) {
            case VeryEasy:
                [allowedOperations removeObjectAtIndex:3];
                [allowedOperations removeObjectAtIndex:2];
                [allowedOperations removeObjectAtIndex:1];
                additionMax = 6;
                break;
            case Easy:
                [allowedOperations removeObjectAtIndex:3];
                [allowedOperations removeObjectAtIndex:2];
                additionMax = 14;
                subtractionMax = 6;
                break;
            case Medium:
                [allowedOperations removeObjectAtIndex:3];
                additionMax = 21;
                subtractionMax = 14;
                multiplicationMax = 6;
                break;
            case Hard:
                subtractionMax = 21;
                divisionMax = 6;
                break;
            case VeryHard:
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
    operation = [(NSNumber *)[allowedOperations objectAtIndex:(arc4random() % [allowedOperations count])] intValue];
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
    
    // Randomly flip signs if negative numbers are allowed
    if (allowNegativeNumbers) {
        if (arc4random() & 1) {
            firstOperand *= -1;
        }
        if (arc4random() & 1) {
            secondOperand *= -1;
        }
    }
    
    return [[ArithmeticEquation alloc] initWithFirstOperand:firstOperand operation:operation secondOperand:secondOperand];
}

@end