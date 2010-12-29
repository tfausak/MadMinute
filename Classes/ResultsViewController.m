//
//  ResultsViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "NavigationController.h"

@implementation ResultsViewController

- (void)dealloc {
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Results"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [(NavigationController *)[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end