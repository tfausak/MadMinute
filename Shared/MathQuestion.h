//
//  MathQuestion.h
//  Aardvark
//
//  Created by Cody Powell on 10/29/10.
//  Copyright 2010 Famigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathQuestion : NSObject {
	NSString *question;
	int answer;
}

@property (retain, nonatomic) NSString *question;
@property (assign, nonatomic) int answer;

- (id)initWithQuestion:(NSString *)initialQuestion answer:(int)initialAnswer;

@end