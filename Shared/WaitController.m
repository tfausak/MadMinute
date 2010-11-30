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
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self setView:view];
    [view release];
}

- (void)viewDidLoad {
    [[self view] setBackgroundColor:[UIColor colorWithRed:0 green:0.5019607843 blue:0.2509803922 alpha:1]];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame:CGRectMake([[self view] frame].size.width / 2 - 18.5, [[self view] frame].size.height / 2 - 18.5, 37, 37)];
    [spinner setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [spinner startAnimating];
    [[self view] addSubview:spinner];
}

@end