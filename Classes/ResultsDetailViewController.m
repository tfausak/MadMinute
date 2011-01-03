//
//  ResultsDetailViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsDetailViewController.h"

@implementation ResultsDetailViewController

@synthesize defaults;
@synthesize famigo;
@synthesize questions;
@synthesize tableView;

- (void)dealloc {
    //[defaults release]; // this caused a crash once. should i be doing this?
    [famigo release];
    [questions release];
    [tableView release];
    
    [super dealloc];
}

#pragma mark -

- (id)initWithPlayer:(NSString *)aPlayer {
    if (self = [super init]) {
        // Load the game type
        defaults = [NSUserDefaults standardUserDefaults];
        GameType gameType = [defaults integerForKey:kGameTypeKey];
        
        // Load the game data
        NSDictionary *gameData;
        if (gameType == SinglePlayer || gameType == PassAndPlay) {
            gameData = [defaults objectForKey:kGameDataKey];
        }
        else {
            famigo = [Famigo sharedInstance];
            gameData = [[famigo gameInstance] objectForKey:[famigo game_name]];
        }
        
        // Load the player data
        NSDictionary *playerData = [gameData objectForKey:aPlayer];
        [self setTitle:[playerData objectForKey:kPlayerNameKey]];
        NSMutableArray *playerQuestions = [[playerData objectForKey:kPlayerQuestionsKey] mutableCopy];
        
        // Re-format the questions
        for (int index = 0; index < [playerQuestions count]; index += 1) {
            NSString *question = [playerQuestions objectAtIndex:index];
            NSArray *tokens = [question componentsSeparatedByString:@" "];
            
            ArithmeticEquation *equation = [ArithmeticEquation unserialize:question];
            NSString *response = ([tokens count] < 4) ? @"" : [tokens objectAtIndex:3];
            NSNumber *correct = [NSNumber numberWithBool:[response isEqualToString:[equation resultAsString]]];
            
            NSDictionary *newQuestion = [NSDictionary dictionaryWithObjectsAndKeys:equation, @"equation", response, @"response", correct, @"correct", nil];
            [playerQuestions replaceObjectAtIndex:index withObject:newQuestion];
        }
        
        // Save the new list of questions
        questions = [[NSArray alloc] initWithArray:playerQuestions];
        
        // Set up the table view
        tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [tableView setBackgroundColor:[UIColor clearColor]];
        if ([tableView respondsToSelector:@selector(setBackgroundView:)]) {
            [tableView setBackgroundView:nil];
        }
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [[self view] addSubview:tableView];
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *question = [questions objectAtIndex:[indexPath row]];
    
    ArithmeticEquation *equation = [question objectForKey:@"equation"];
    NSString *response = [question objectForKey:@"response"];
    BOOL correct = [[question objectForKey:@"correct"] boolValue];
    
    [[tableViewCell textLabel] setText:[NSString stringWithFormat:@"%d %@ %d = %@", [equation firstOperand], [equation operationAsString], [equation secondOperand], response]];
    if (correct) {
        [tableViewCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [[tableViewCell textLabel] setTextColor:[UIColor redColor]];
        [[tableViewCell detailTextLabel] setText:[NSString stringWithFormat:@"Correct answer: %d", [equation result]]];
    }
    
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [questions count];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([questions count] > 0) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@ did not answer any questions.", [self title]];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end