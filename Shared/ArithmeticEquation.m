//
//  ArithmeticEquation.m
//  MadMinute
//
//  Created by Taylor Fausak on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ArithmeticEquation.h"

@implementation ArithmeticEquation

@synthesize firstOperand;
@synthesize operation;
@synthesize secondOperand;
@synthesize result;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFirstOperand:(int)_firstOperand operation:(Operation)_operation secondOperand:(int)_secondOperand {
    if (self = [super init]) {
        firstOperand = _firstOperand;
        operation = _operation;
        secondOperand = _secondOperand;
        
        switch (operation) {
            case Addition:
                result = firstOperand + secondOperand;
                break;
            case Subtraction:
                result = firstOperand - secondOperand;
                break;
            case Multiplication:
                result = firstOperand * secondOperand;
                break;
            case Division:
                result = firstOperand / secondOperand;
                break;
            default:
                NSAssert(NO, @"Unknown operation");
                break;
        }
    }
    
    return self;
}

- (NSString *)firstOperandAsString {
    return [NSString stringWithFormat:@"%d", firstOperand];
}

- (NSString *)operationAsString {
    switch (operation) {
        case Addition:
            return @"+";
        case Subtraction:
            return @"-";
        case Multiplication:
            return @"×";
        case Division:
            return @"÷";
    }
    
    NSAssert(NO, @"Unknown operation");
    return @"";
}

- (NSString *)secondOperandAsString {
    return [NSString stringWithFormat:@"%d", secondOperand];
}

- (NSString *)resultAsString {
    return [NSString stringWithFormat:@"%d", result];
}

@end