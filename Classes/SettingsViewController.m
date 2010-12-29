//
//  SettingsViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationController.h"

@implementation SettingsViewController

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
        UIBarButtonItem *startGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Start game" style:UIBarButtonItemStyleDone target:[self navigationController] action:@selector(didStartGame)];
        [[self navigationItem] setRightBarButtonItem:startGameButton animated:YES];
        [startGameButton release];
        
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
    [(NavigationController *)[self navigationController] setNavigationBarHidden:NO animated:animated];
    
    // Set the difficulty
    [[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailTextLabel] setText:[DifficultyViewController currentDifficultyAsString]];
    
    // Set the number of players, if applicable
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == PassAndPlay) {
        [[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] detailTextLabel] setText:[NSString stringWithFormat:@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey]]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -

- (void)toggledSwitch:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:[(UISwitch *)sender isOn] forKey:kAllowNegativeNumbersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];        
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch (section) {
        case 0:
            if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == PassAndPlay) {
                return 3;
            }
            return 2;
        default:
            NSAssert(NO, @"unknown section");
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    UITableViewCell *tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    [[tableViewCell detailTextLabel] setText:@""];
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    [[tableViewCell textLabel] setText:@"Difficulty"];
                    [[tableViewCell detailTextLabel] setText:[DifficultyViewController currentDifficultyAsString]];
                    break;
                case 1:
                    [[tableViewCell textLabel] setText:@"Negative numbers"];
                    [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    UISwitch *toggle = [[UISwitch alloc] init];
                    [toggle addTarget:self action:@selector(toggledSwitch:) forControlEvents:UIControlEventValueChanged];
                    [toggle setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kAllowNegativeNumbersKey]];
                    [tableViewCell setAccessoryView:toggle];
                    [toggle release];
                    break;
                case 2:
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == PassAndPlay) {
                        [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                        [[tableViewCell textLabel] setText:@"Number of players"];
                        [[tableViewCell detailTextLabel] setText:[NSString stringWithFormat:@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey]]];
                        break;
                    }
                default:
                    NSAssert(NO, @"unknown row");
                    break;
            }
            break;
        default:
            NSAssert(NO, @"unknown section");
            return nil;
    }
    
    return tableViewCell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    return indexPath;
                case 1:
                    return nil;
                case 2:
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == PassAndPlay) {
                        return indexPath;
                    }
                default:
                    NSAssert(NO, @"unknown row");
                    return nil;
            }
        default:
            NSAssert(NO, @"unknown section");
            return nil;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0: {
                    DifficultyViewController *viewController = [[DifficultyViewController alloc] init];
                    [[self navigationController] pushViewController:viewController animated:YES];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    break; }
                case 1:
                    break;
                case 2:
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:kGameTypeKey] == PassAndPlay) {
                        // Believe it or not, this *is* the easiest way to do things
                        NumberOfPlayersViewController *viewController = [[NumberOfPlayersViewController alloc] init];
                        [(NavigationController *)[self navigationController] pushViewController:viewController animated:YES];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        break;
                    }
                default:
                    NSAssert(NO, @"unknown row");
                    break;
            }
            break;
        default:
            NSAssert(NO, @"unknown section");
            break;
    }
}

@end