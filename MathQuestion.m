//
//  MathQuestion.m
//  Aardvark
//
//  Created by Cody Powell on 10/29/10.
//  Copyright 2010 Famigo. All rights reserved.
//

#import "MathQuestion.h"

@implementation MathQuestion

@synthesize questionText, answer;

-(id)initWithTextAndAnswer:(NSString*)myText :(int)myAnswer {
	if ((self = [super init])) {
		self.questionText = myText;
		self.answer = myAnswer;
	}
	
	return self;
}

@end
