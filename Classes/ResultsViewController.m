//
//  ResultsViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "NavigationController.h"
#import "Famigo.h"
#import "ResultsDetailViewController.h"
#import "Settings.h"

@implementation ResultsViewController

@synthesize tableView;
@synthesize data;

- (void)dealloc {
    [tableView release];
    [data release];
    
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Results"];
        
        // Load the game data
        NSDictionary *gameData;
        if ([Settings gameType] == SinglePlayer || [Settings gameType] == PassAndPlay) {
            gameData = [[NSUserDefaults standardUserDefaults] objectForKey:kGameDataKey];
        }
        else {
            gameData = [[[Famigo sharedInstance] gameInstance] objectForKey:[[Famigo sharedInstance] game_name]];
        }
        
        // Re-format game data
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSString *key in gameData) {
            NSDictionary *value = [gameData objectForKey:key];
            NSDictionary *playerData = [NSDictionary dictionaryWithObjectsAndKeys:
                                        key, kPlayerKeyKey,
                                        [value objectForKey:kPlayerNameKey], kPlayerNameKey,
                                        [NSNumber numberWithInt:[self scoreForPlayerData:value]], kPlayerScoreKey,
                                        [value objectForKey:kPlayerSettingsKey], kPlayerSettingsKey,
                                        [value objectForKey:kPlayerQuestionsKey], kPlayerQuestionsKey,
                                        nil];
            [players addObject:playerData];
        }
        
        // Sort game data
        if ([[[[NSSortDescriptor alloc] init] autorelease] respondsToSelector:@selector(sortDescriptorWithKey:ascending:)]) {
            [players sortUsingDescriptors:[NSArray arrayWithObjects:
                                           [NSSortDescriptor sortDescriptorWithKey:kPlayerScoreKey
                                                                         ascending:NO],
                                           [NSSortDescriptor sortDescriptorWithKey:kPlayerNameKey
                                                                         ascending:YES
                                                                          selector:@selector(caseInsensitiveCompare:)],
                                           nil]];
        }
        
        // Store the game data
        data = [[NSArray alloc] initWithArray:players];
        [players release];
        
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

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -

- (NSInteger)scoreForPlayerData:(NSDictionary *)playerData {
    NSInteger score = 0;
    Difficulty difficulty = [[[playerData objectForKey:@"settings"] objectForKey:@"difficulty"] intValue];
    BOOL allowNegativeNumbers = [[[playerData objectForKey:@"settings"] objectForKey:@"allowNegativeNumbers"] intValue];
    
    for (NSString *question in [playerData objectForKey:@"questions"]) {
        NSArray *tokens = [question componentsSeparatedByString:@" "];
        ArithmeticEquation *equation = [ArithmeticEquation unserialize:question];
        if ([tokens count] >= 4 && [[tokens objectAtIndex:3] isEqualToString:[equation resultAsString]]) {
            score += 1 + difficulty + allowNegativeNumbers;
        }
    }
    
    return score;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [[data objectAtIndex:[indexPath row]] objectForKey:kPlayerNameKey];
    NSInteger score = [[[data objectAtIndex:[indexPath row]] objectForKey:kPlayerScoreKey] intValue];
    NSString *s = (score == 1) ? @"" : @"s";
    
    //
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:@""];
    [tableViewCell autorelease];
    [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [[tableViewCell textLabel] setText:name];
    [[tableViewCell detailTextLabel] setText:[NSString stringWithFormat:@"%d point%@", score, s]];
    
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *playerKey = [[data objectAtIndex:[indexPath row]] objectForKey:kPlayerKeyKey];
    
    ResultsDetailViewController *viewController = [[ResultsDetailViewController alloc] initWithPlayer:playerKey];
    [[self navigationController] pushViewController:viewController animated:YES];
    [viewController release];
}

@end