//
//  GameTypeController.m
//  MadMinute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameTypeController.h"

@implementation GameTypeController

- (void)dealloc {
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [[self view] setBackgroundColor:[UIColor colorWithHue:(150 / 359.0) saturation:1.0 brightness:0.5 alpha:1.0]];
        
        UILabel *label;
        UIButton *button;
        
        label = [[UILabel alloc] init];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"Georgia-Bold" size:40]];
        [label setFrame:CGRectMake(20, 20, [[self view] bounds].size.width - 40, 40)];
        [label setText:@"mad"];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [[self view] addSubview:label];
        [label release];
        
        label = [[UILabel alloc] init];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"Georgia-Bold" size:40]];
        [label setFrame:CGRectMake(20, 60, [[self view] bounds].size.width - 40, 40)];
        [label setText:@"minute"];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [[self view] addSubview:label];
        [label release];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:nil action:@selector(pressedGameTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [button setFrame:CGRectMake(20, [[self view] bounds].size.height - 120, [[self view] bounds].size.width - 40, 40)];
        [button setTag:NO];
        [button setTitle:@"Multi device" forState:UIControlStateNormal];
        [[self view] addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:nil action:@selector(pressedGameTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [button setFrame:CGRectMake(20, [[self view] bounds].size.height - 60, [[self view] bounds].size.width - 40, 40)];
        [button setTag:YES];
        [button setTitle:@"Pass and play" forState:UIControlStateNormal];
        [[self view] addSubview:button];
    }
    
    return self;
}

@end