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

- (id)initWithDifficulty:(Difficulty)theDifficulty allowNegativeNumbers:(BOOL)negativeNumbers {
    if (self = [super init]) {
        difficulty = theDifficulty;
        allowNegativeNumbers = negativeNumbers;
        allowedOperations = [[NSMutableArray alloc] init];
        
        switch (difficulty) {
            case VeryEasy:
                [allowedOperations addObject:[NSNumber numberWithInt:Addition]];
                additionMax = 10;
                break;
            case Easy:
                [allowedOperations addObject:[NSNumber numberWithInt:Addition]];
                [allowedOperations addObject:[NSNumber numberWithInt:Subtraction]];
                additionMax = 21;
                subtractionMax = 10;
                break;
            case Medium:
                [allowedOperations addObject:[NSNumber numberWithInt:Addition]];
                [allowedOperations addObject:[NSNumber numberWithInt:Subtraction]];
                [allowedOperations addObject:[NSNumber numberWithInt:Multiplication]];
                additionMax = 51;
                subtractionMax = 21;
                multiplicationMax = 6;
                break;
            case Hard:
                [allowedOperations addObject:[NSNumber numberWithInt:Addition]];
                [allowedOperations addObject:[NSNumber numberWithInt:Subtraction]];
                [allowedOperations addObject:[NSNumber numberWithInt:Multiplication]];
                [allowedOperations addObject:[NSNumber numberWithInt:Division]];
                additionMax = 101;
                subtractionMax = 51;
                multiplicationMax = 14;
                divisionMax = 6;
                break;
            case VeryHard:
                [allowedOperations addObject:[NSNumber numberWithInt:Addition]];
                [allowedOperations addObject:[NSNumber numberWithInt:Subtraction]];
                [allowedOperations addObject:[NSNumber numberWithInt:Multiplication]];
                [allowedOperations addObject:[NSNumber numberWithInt:Division]];
                additionMax = 101;
                subtractionMax = 101;
                multiplicationMax = 14;
                divisionMax = 14;
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
    
    return [[[ArithmeticEquation alloc] initWithFirstOperand:firstOperand operation:operation secondOperand:secondOperand] autorelease];
}

@end