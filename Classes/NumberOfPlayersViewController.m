//
//  NumberOfPlayersViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NumberOfPlayersViewController.h"
#import "NavigationController.h"

@implementation NumberOfPlayersViewController

@synthesize tableView;

- (void)dealloc {
    [tableView release];
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Number of players"];
        
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch (section) {
        case 0:
            return 5;
        default:
            NSAssert(NO, @"unknown section");
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    UITableViewCell *tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                    [[tableViewCell textLabel] setText:[NSString stringWithFormat:@"%d players", [indexPath row] + 2]];
                    if ([indexPath row] == [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey] - 2) {
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
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch ([indexPath section]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
            if ([indexPath row] != [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey] - 2) {
                [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfPlayersKey] - 2 inSection:[indexPath section]]] setAccessoryType:UITableViewCellAccessoryNone];
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            
            [[NSUserDefaults standardUserDefaults] setInteger:[indexPath row] + 2 forKey:kNumberOfPlayersKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            NSAssert(NO, @"unknown section");
            break;
    }
}

@end