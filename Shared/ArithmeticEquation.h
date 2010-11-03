//
//  ArithmeticEquation.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Addition,
    Subtraction,
    Multiplication,
    Division
} Operation;

@interface ArithmeticEquation : NSObject {
    int firstOperand;
    Operation operation;
    int secondOperand;
    int result;
}

@property (nonatomic, assign, readonly) int firstOperand;
@property (nonatomic, assign, readonly) Operation operation;
@property (nonatomic, assign, readonly) int secondOperand;
@property (nonatomic, assign, readonly) int result;

- (id)initWithFirstOperand:(int)anOperand operation:(Operation)theOperation secondOperand:(int)anotherOperand;
- (NSString *)firstOperandAsString;
- (NSString *)operationAsString;
- (NSString *)secondOperandAsString;
- (NSString *)resultAsString;

@end