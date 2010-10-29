//
//  QuestionGenerator.m
//  Aardvark
//
//  Created by Cody Powell on 10/29/10.
//  Copyright 2010 Famigo. All rights reserved.
//

#import "QuestionGenerator.h"
#import "MathQuestion.h"

@interface QuestionGenerator()

@property (assign, nonatomic) NSInteger trivialRangeMin;
@property (assign, nonatomic) NSInteger trivialRangeMax;
@property (assign, nonatomic) NSInteger nontrivialRangeMin;
@property (assign, nonatomic) NSInteger nontrivialRangeMax;
@property (retain, nonatomic) NSArray *allowedOperations;

@end

@implementation QuestionGenerator

@synthesize allowedOperations;
@synthesize trivialRangeMin, trivialRangeMax, nontrivialRangeMin, nontrivialRangeMax;

-(id)initWithDifficulty:(int)difficultyLevel {
	if ((self = [super init])) {
		
		// Can't store ints in an array, instead we use NSNumbers.
		NSNumber *additionObj = [NSNumber numberWithInt:Addition];
		NSNumber *subtractionObj = [NSNumber numberWithInt:Subtraction];
		NSNumber *multiplicationObj = [NSNumber numberWithInt:Multiplication];
		NSNumber *divisionObj = [NSNumber numberWithInt:Division];
		
		switch (difficultyLevel) {
			case 1:
				self.allowedOperations = [NSArray arrayWithObjects:additionObj, nil];
				self.trivialRangeMin = 0;
				self.trivialRangeMax = 10;
				self.nontrivialRangeMin = 0;
				self.nontrivialRangeMax = 0;
				break;
			case 2:
				self.allowedOperations = [NSArray arrayWithObjects:additionObj, subtractionObj, nil];
				self.trivialRangeMin = 0;
				self.trivialRangeMax = 100;
				self.nontrivialRangeMin = 0;
				self.nontrivialRangeMax = 0;
				break;
			case 3:
				self.allowedOperations = [NSArray arrayWithObjects:additionObj, subtractionObj, multiplicationObj, nil];
				self.trivialRangeMin = 0;
				self.trivialRangeMax = 100;
				self.nontrivialRangeMin = 0;
				self.nontrivialRangeMax = 12;
				break;
			case 4:
				self.allowedOperations = [NSArray arrayWithObjects:additionObj, subtractionObj, multiplicationObj, divisionObj, nil];
				self.trivialRangeMin = 0;
				self.trivialRangeMax = 1000;
				self.nontrivialRangeMin = 0;
				self.nontrivialRangeMax = 20;
				break;
			case 5:
				self.allowedOperations = [NSArray arrayWithObjects:additionObj, subtractionObj, multiplicationObj, divisionObj, nil];
				self.trivialRangeMin = -5000;
				self.trivialRangeMax = 5000;
				self.nontrivialRangeMin = -20;
				self.nontrivialRangeMax = 20;
				break;
			default:
				NSAssert(0, @"Bad difficulty selected.");
		}
		
		// Seed our randomizer.
        srandomdev();
    }
    return self;
}

-(MathQuestion*)generateQuestion {
	NSString *questionText = @"";
	int leftOperand = 0;
	int rightOperand = 0;
	int answer = 0;
	
	// Allowed operations differ by difficulty level, so we select an operation randomly
	// based upon what we're specified are the allowed operations.
	int operationsCount = [self.allowedOperations count];
	Operation randomOperation = random() % operationsCount;
	
	switch (randomOperation) {
		case Addition:
			questionText = @"+";
			leftOperand = random() % self.trivialRangeMax;
			rightOperand = random() % self.trivialRangeMax;
			answer = leftOperand + rightOperand;
			break;
		case Subtraction:
			leftOperand = random() % self.trivialRangeMax;
			
			// Don't allow negative differences if the range doesn't specify to do so.
			if (trivialRangeMin >= 0)
				// If we mod by the left operand, the difference must be >= 0.
				rightOperand = random() % leftOperand;
			else {
				rightOperand = random() % self.trivialRangeMax;
			}
			
			answer = leftOperand - rightOperand;
			questionText = @"-";
			break;
		case Multiplication:
			leftOperand = random() % self.nontrivialRangeMax;
			rightOperand = random() % self.nontrivialRangeMax;
			
			// If we allow negative numbers, then we'll randomly force operands to
			// be negative.
			if (self.nontrivialRangeMin < 0 && random() % 2 == 0)
				leftOperand *= -1;
			if (self.nontrivialRangeMin < 0 && random() % 2 == 0)
				rightOperand *= -1;
			answer = leftOperand * rightOperand;
			questionText = @"X";
			break;
		case Division:
			leftOperand = random() % self.nontrivialRangeMax;
			rightOperand = random() % self.nontrivialRangeMax;
			
			// Right operand is the number we divide by.  Don't allow 0's then.
			while (rightOperand == 0) {
				rightOperand = random() % self.nontrivialRangeMax;
			}
			
			// Multiply two numbers within our range, then use the product as the number into which we
			// divide.  This prevents remainders.
			int numberToDivideBy = leftOperand * rightOperand;
			leftOperand = numberToDivideBy;
			
			// If we allow negative numbers, then we'll randomly force operands to
			// be negative.
			if (self.nontrivialRangeMin < 0 && random() % 2 == 0)
				leftOperand *= -1;
			if (self.nontrivialRangeMin < 0 && random() % 2 == 0)
				rightOperand *= -1;
			
			answer = leftOperand / rightOperand;
			questionText = @"/";
			
			break;
		default:
			NSAssert(0, @"Bad operation type selected.");
	}
	
	questionText = [NSString stringWithFormat:@"%d %@ %d", leftOperand, questionText, rightOperand];
	return [[MathQuestion alloc] initWithTextAndAnswer:questionText :answer];
}

@end
