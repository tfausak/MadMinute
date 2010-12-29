//
//  DifficultyViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DifficultyViewController.h"

@implementation DifficultyViewController

@synthesize tableView;

- (void)dealloc {
    [tableView release];
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Difficulty"];
        
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

+ (Difficulty)currentDifficulty {
    return (Difficulty)[[NSUserDefaults standardUserDefaults] integerForKey:kDifficultyKey];
}

+ (NSString *)currentDifficultyAsString {
    return [[self class] difficultyAsString:[[self class] currentDifficulty]];
}

+ (NSString *)difficultyAsString:(Difficulty)difficulty {
    switch (difficulty) {
        case VeryEasy:
            return @"Very easy";
        case Easy:
            return @"Easy";
        case Medium:
            return @"Medium";
        case Hard:
            return @"Hard";
        case VeryHard:
            return @"Very hard";
        default:
            NSAssert(NO, @"unknown difficulty");
            return nil;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
        default:
            NSAssert(NO, @"unknown section");
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case VeryEasy:
                case Easy:
                case Medium:
                case Hard:
                case VeryHard:
                    [[tableViewCell textLabel] setText:[[self class] difficultyAsString:[indexPath row]]];
                    if ([indexPath row] == [[self class] currentDifficulty]) {
                        [tableViewCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    }
                    break;
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

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case VeryEasy:
                case Easy:
                case Medium:
                case Hard:
                case VeryHard:
                    if ([indexPath row] != [[self class] currentDifficulty]) {
                        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[self class] currentDifficulty] inSection:[indexPath section]]] setAccessoryType:UITableViewCellAccessoryNone];
                    }
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                    
                    [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] forKey:kDifficultyKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    break;
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