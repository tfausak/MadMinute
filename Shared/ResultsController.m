//
//  ResultsController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultsController.h"

@implementation ResultsController

@synthesize parentViewController;
@synthesize resultsTableView;
@synthesize gameData;

- (void)dealloc {
    [parentViewController release];
    [resultsTableView release];
    [gameData release];
    
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        NSMutableDictionary *scores = [NSMutableDictionary dictionary];
        int counter = 1;
        for (NSString *playerName in [NSArray arrayWithObjects:@"Player 1", @"Player 2", @"Player 3", nil]) {
            [scores setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:counter * 1], kNumberRightKey,
                               [NSNumber numberWithInt:counter * 2], kNumberWrongKey,
                               [NSNumber numberWithInt:counter * 3], kNumberSkippedKey,
                               [NSNumber numberWithInt:counter * 4], kScoreKey,
                               nil] forKey:playerName];
            counter += 1;
        }
        
        gameData = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:0], kSeedKey,
                    [NSNumber numberWithInt:0], kDifficultyKey,
                    [NSNumber numberWithBool:NO], kAllowNegativeNumbersKey,
                    scores, kScoresKey,
                    nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[gameData objectForKey:kScoresKey] allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [[[gameData objectForKey:kScoresKey] allKeys] objectAtIndex:section];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end