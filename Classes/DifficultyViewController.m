//
//  DifficultyViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DifficultyViewController.h"
#import "Settings.h"

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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@""];
    [cell autorelease];
    
    [[cell textLabel] setText:[Settings difficultyAsString:[indexPath row]]];
    if ([indexPath row] == [Settings difficulty]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath row] != [Settings difficulty]) {
        // Deselect the old difficulty
        [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[Settings difficulty] inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
        
        // Check the new difficulty
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [Settings setDifficulty:[indexPath row]];
    }
}

@end