//
//  ArithmeticEquation.h
//  Mad Minute
//
//  Created by Taylor Fausak on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

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

- (id)initWithFirstOperand:(int)theFirstOperand operation:(Operation)theOperation secondOperand:(int)theSecondOperand;
+ (ArithmeticEquation *)unserialize:(NSString *)serializedArithmeticEquation;
- (NSString *)serialize;
- (NSString *)firstOperandAsString;
- (NSString *)operationAsString;
- (NSString *)secondOperandAsString;
- (NSString *)resultAsString;

@end