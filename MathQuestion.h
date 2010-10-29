//
//  MathQuestion.h
//  Aardvark
//
//  Created by Cody Powell on 10/29/10.
//  Copyright 2010 Famigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MathQuestion : NSObject {
	NSString *questionText;
	int answer;
}

@property (retain, nonatomic) NSString *questionText;
@property (assign, nonatomic) int answer;


-(id)initWithTextAndAnswer:(NSString*)myText :(int)myAnswer;

@end
