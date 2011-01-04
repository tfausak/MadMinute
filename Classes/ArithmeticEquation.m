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

#pragma mark -

- (id)initWithFirstOperand:(int)theFirstOperand operation:(Operation)theOperation secondOperand:(int)theSecondOperand {
    if (self = [super init]) {
        firstOperand = theFirstOperand;
        operation = theOperation;
        secondOperand = theSecondOperand;
        
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

#pragma mark -

+ (ArithmeticEquation *)unserialize:(NSString *)serializedArithmeticEquation {
    // Break the string into tokens
    NSArray *tokens = [serializedArithmeticEquation componentsSeparatedByString:@" "];
    
    // Get each component
    int theFirstOperand = [(NSString *)[tokens objectAtIndex:0] intValue];
    int theOperation = (Operation)[(NSString *)[tokens objectAtIndex:1] intValue];
    int theSecondOperand = [(NSString *)[tokens objectAtIndex:2] intValue];
    
    return [[[ArithmeticEquation alloc] initWithFirstOperand:theFirstOperand operation:theOperation secondOperand:theSecondOperand] autorelease];
}

- (NSString *)serialize {
    return [NSString stringWithFormat:@"%d %d %d", firstOperand, operation, secondOperand];
}

#pragma mark -

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
            NSAssert(NO, @"Unknown operation");
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