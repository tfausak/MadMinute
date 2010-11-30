//
//  WaitController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WaitController.h"

@implementation WaitController

@synthesize spinner;

- (void)dealloc {
    [spinner release];
    
    [super dealloc];
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    
    [self setView:view];
    [view release];
}

- (void)viewDidLoad {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [spinner setFrame:CGRectMake([[self view] frame].size.width / 2 - 18.5, [[self view] frame].size.height / 2 - 18.5, 37, 37)];
    [spinner startAnimating];
    [[self view] addSubview:spinner];
}

@end