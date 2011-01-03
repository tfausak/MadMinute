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

@synthesize famigo;
@synthesize defaults;
@synthesize tableView;

@synthesize gameType;
@synthesize gameData;

- (void)dealloc {
    [famigo release];
    [defaults release];
    [tableView release];
    
    [gameData release];
    
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Results"];
        
        // Load the game type
        defaults = [NSUserDefaults standardUserDefaults];
        gameType = [defaults integerForKey:kGameTypeKey];
        
        // Load the game data
        if (gameType == SinglePlayer || gameType == PassAndPlay) {
            gameData = [defaults objectForKey:kGameDataKey];
        }
        else {
            famigo = [Famigo sharedInstance];
            gameData = [[famigo gameInstance] objectForKey:[famigo game_name]];
        }
        [gameData retain];
        
        // Set up the table view
        tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [[self view] addSubview:tableView];
        
        // Hide the table view's background
        [tableView setBackgroundColor:[UIColor clearColor]];
        if ([tableView respondsToSelector:@selector(setBackgroundView:)]) {
            [tableView setBackgroundView:nil];
        }
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

- (NSInteger)scoreForPlayerNamed:(NSString *)playerName {
    // Get the player's data
    NSDictionary *data = [gameData objectForKey:playerName];
    
    // Split the player data into its components
    NSDictionary *settings = [data objectForKey:kPlayerSettingsKey];
    NSArray *questions = [data objectForKey:kPlayerQuestionsKey];
    
    // Get settings relevant to calculating score
    Difficulty difficulty = [[settings objectForKey:kDifficultyKey] intValue];
    BOOL allowNegativeNumbers = [[settings objectForKey:kAllowNegativeNumbersKey] intValue];
    
    // Loop over the questions
    NSInteger score = 0;
    for (NSString *question in questions) {
        if ([self isResponseCorrect:question]) {
            score += 1 + difficulty + allowNegativeNumbers;
        }
    }
    
    return score;
}

- (NSString *)responseToQuestion:(NSString *)question {
    // Split the question into tokens
    NSArray *tokens = [question componentsSeparatedByString:@" "];
    
    // Return the empty string if the user didn't respond
    if ([tokens count] < 4) {
        return @"";
    }
    
    // Return the user response
    return [tokens objectAtIndex:3];
}

- (BOOL)isResponseCorrect:(NSString *)question {
    ArithmeticEquation *arithmeticEquation = [ArithmeticEquation unserialize:question];
    NSString *response = [self responseToQuestion:question];
    
    return [response isEqualToString:[arithmeticEquation resultAsString]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //
    NSString *playerKey = [[gameData allKeys] objectAtIndex:[indexPath row]];
    NSString *playerName = [[gameData objectForKey:playerKey] objectForKey:kPlayerNameKey];
    [[tableViewCell textLabel] setText:playerName];
    
    //
    NSInteger playerScore = [self scoreForPlayerNamed:playerKey];
    NSString *s = (playerScore == 1) ? @"" : @"s";
    [[tableViewCell detailTextLabel] setText:[NSString stringWithFormat:@"%d point%@", playerScore, s]];
    
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [gameData count];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ResultsDetailViewController *resultsDetailViewController = [ResultsDetailViewController alloc];
    [resultsDetailViewController initWithPlayer:[[gameData allKeys] objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:resultsDetailViewController animated:YES];
    [resultsDetailViewController release];
}

@end