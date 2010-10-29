//
//  MathQuestion.m
//  Aardvark
//
//  Created by Cody Powell on 10/29/10.
//  Copyright 2010 Famigo. All rights reserved.
//

#import "MathQuestion.h"

@implementation MathQuestion

@synthesize question;
@synthesize answer;


- (id)initWithQuestion:(NSString *)initialQuestion answer:(int)initialAnswer {
    if (self = [super init]) {
        question = initialQuestion;
        answer = initialAnswer;
    }
    return self;
}

@end