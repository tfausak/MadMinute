//
//  NumberOfPlayersViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NumberOfPlayersViewController.h"
#import "Settings.h"

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell alloc];
    [cell initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:@""];
    [cell autorelease];
    
    [[cell textLabel] setText:[Settings numberOfPlayersAsString:[indexPath row] + 2]];
    if ([indexPath row] == [Settings numberOfPlayers] - 2) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath row] != [Settings numberOfPlayers] - 2) {
        // Deselect the old difficulty
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[Settings numberOfPlayers] - 2 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
        
        // Check the new difficulty
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [Settings setNumberOfPlayers:[indexPath row] + 2];
    }
}

@end