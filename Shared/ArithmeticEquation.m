//
//  ArithmeticEquation.m
//  Aardvark
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

- (id)initWithFirstOperand:(int)anOperand operation:(Operation)theOperation secondOperand:(int)anotherOperand {
    if (self = [super init]) {
        firstOperand = anOperand;
        operation = theOperation;
        secondOperand = anotherOperand;
        
        // Compute the result
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
        default:
            return @"";
    }
}

- (NSString *)secondOperandAsString {
    return [NSString stringWithFormat:@"%d", secondOperand];
}

- (NSString *)resultAsString {
    return [NSString stringWithFormat:@"%d", result];
}

@end