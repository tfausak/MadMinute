//
//  QuestionGenerator.h
//  Aardvark
//
//  Created by Cody Powell on 10/29/10.
//  Copyright 2010 Famigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MathQuestion;

typedef enum {
	Addition,
	Subtraction,
	Multiplication,
	Division
} Operation;

@interface QuestionGenerator : NSObject {
	NSMutableArray *allowedOperations;
	
	// Trivial operations are addition and subtraction.
	NSInteger trivialRangeMin;
	NSInteger trivialRangeMax;
	
	// Non-trivial operations are multiplication and division.
	NSInteger nontrivialRangeMin;
	NSInteger nontrivialRangeMax;
}

- (id)initWithDifficulty:(int)difficultyLevel;
- (MathQuestion *)generateQuestion;

@end