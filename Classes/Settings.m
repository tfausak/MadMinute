//
//  Settings.m
//  Mad Minute
//
//  Created by Taylor Fausak on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "DifficultyViewController.h"
#import "NumberOfPlayersViewController.h"

@implementation Settings

@synthesize tableView;

- (void)dealloc {
    [tableView release];
    
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Settings"];
        
        // Add a bar button item to start the game
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Start game"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:[self navigationController]
                                                                  action:@selector(didStartGame)];
        [[self navigationItem] setRightBarButtonItem:button animated:YES];
        [button release];
        
        // Initialize the table view
        tableView = [UITableView alloc];
        [tableView initWithFrame:[[self view] bounds]
                           style:UITableViewStyleGrouped];
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
    
    // Update cell contents
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [[cell detailTextLabel] setText:[Settings difficultyAsString]];
    cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [[cell detailTextLabel] setText:[Settings numberOfPlayersAsString]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Class methods
#pragma mark Getters

+ (GameType)gameType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey];
}

+ (Difficulty)difficulty {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kDifficultyKey];
}

+ (BOOL)allowNegativeNumbers {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAllowNegativeNumbersKey];
}

+ (NSInteger)numberOfPlayers {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey];
}

+ (NSDictionary *)all {
    NSMutableDictionary *all = [[[NSMutableDictionary alloc] init] autorelease];
    [all setObject:[NSNumber numberWithInt:[Settings gameType]]
            forKey:kGameTypeKey];
    [all setObject:[NSNumber numberWithInt:[Settings difficulty]]
            forKey:kDifficultyKey];
    [all setObject:[NSNumber numberWithInt:[Settings allowNegativeNumbers]]
            forKey:kAllowNegativeNumbersKey];
    [all setObject:[NSNumber numberWithInt:[Settings numberOfPlayers]]
            forKey:kNumberOfPlayersKey];
    return all;
}

#pragma mark String getters

+ (NSString *)gameTypeAsString:(GameType)gameType {
    switch (gameType) {
        case SinglePlayer: return @"Single player";
        case PassAndPlay: return @"Pass and play";
        case PassAndPlayWithFamigo: return @"Pass and play (Famigo)";
        case MultiDeviceWithFamigo: return @"Multi device (Famigo)";
        default: return nil;
    }
}

+ (NSString *)gameTypeAsString {
    return [Settings gameTypeAsString:[Settings gameType]];
}

+ (NSString *)difficultyAsString:(Difficulty)difficulty {
    switch (difficulty) {
        case VeryEasy: return @"Very easy";
        case Easy: return @"Easy";
        case Medium: return @"Medium";
        case Hard: return @"Hard";
        case VeryHard: return @"Very hard";
        default: return nil;
    }
}

+ (NSString *)difficultyAsString {
    return [Settings difficultyAsString:[Settings difficulty]];
}

+ (NSString *)allowNegativeNumbersAsString {
    if ([Settings allowNegativeNumbers]) {
        return @"Yes";
    }
    else {
        return @"No";
    }
}

+ (NSString *)numberOfPlayersAsString:(NSInteger)numberOfPlayers {
    NSString *s = (numberOfPlayers == 1) ? @"" : @"s";
    return [NSString stringWithFormat:@"%d player%@", numberOfPlayers, s];
}

+ (NSString *)numberOfPlayersAsString {
    return [Settings numberOfPlayersAsString:[Settings numberOfPlayers]];
}

+ (NSString *)allAsString {
    return [NSString stringWithFormat:@"%@", [Settings all]];
}

#pragma mark Setters

+ (void)setGameType:(GameType)gameType {
    [[NSUserDefaults standardUserDefaults] setInteger:gameType forKey:kGameTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setDifficulty:(Difficulty)difficulty {
    [[NSUserDefaults standardUserDefaults] setInteger:difficulty forKey:kDifficultyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setAllowNegativeNumbers:(BOOL)allowNegativeNumbers {
    [[NSUserDefaults standardUserDefaults] setBool:allowNegativeNumbers forKey:kAllowNegativeNumbersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setNumberOfPlayers:(NSInteger)numberOfPlayers {
    [[NSUserDefaults standardUserDefaults] setInteger:numberOfPlayers forKey:kNumberOfPlayersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setAll:(NSDictionary *)all {
    [Settings setGameType:[[all objectForKey:kGameTypeKey] intValue]];
    [Settings setDifficulty:[[all objectForKey:kDifficultyKey] intValue]];
    [Settings setAllowNegativeNumbers:[[all objectForKey:kAllowNegativeNumbersKey] boolValue]];
    [Settings setNumberOfPlayers:[[all objectForKey:kNumberOfPlayersKey] intValue]];
}

#pragma mark -
#pragma mark Instance methods

- (void)switchValueDidChange:(id)sender {
    [Settings setAllowNegativeNumbers:[(UISwitch *)sender isOn]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 3 + ([Settings gameType] == PassAndPlay);
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@""];
    [cell autorelease];
    
    switch ([indexPath row]) {
        case 0:
            [[cell textLabel] setText:@"Game type"];
            [[cell detailTextLabel] setText:[Settings gameTypeAsString]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        case 1:
            [[cell textLabel] setText:@"Difficulty"];
            [[cell detailTextLabel] setText:[Settings difficultyAsString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case 2:
            [[cell textLabel] setText:@"Negative numbers"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UISwitch *toggleSwitch = [[UISwitch alloc] init];
            [toggleSwitch addTarget:self
                             action:@selector(switchValueDidChange:)
                   forControlEvents:UIControlEventValueChanged];
            [toggleSwitch setOn:[Settings allowNegativeNumbers]];
            [cell setAccessoryView:toggleSwitch];
            [toggleSwitch release];
            break;
        case 3:
            [[cell textLabel] setText:@"Number of players"];
            [[cell detailTextLabel] setText:[Settings numberOfPlayersAsString]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath row]) {
        case 1:
        case 3:
            return indexPath;
        default: return nil;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch ([indexPath row]) {
        case 1: {
            DifficultyViewController *viewController = [[DifficultyViewController alloc] init];
            [[self navigationController] pushViewController:viewController animated:YES];
            [viewController release];
            break; }
        case 3: {
            NumberOfPlayersViewController *viewController = [[NumberOfPlayersViewController alloc] init];
            [[self navigationController] pushViewController:viewController animated:YES];
            [viewController release];
            break; }
    }
}

@end