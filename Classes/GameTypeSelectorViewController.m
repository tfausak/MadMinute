//
//  GameTypeSelectorViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameTypeSelectorViewController.h"
#import "Settings.h"
#import "NavigationController.h"

@implementation GameTypeSelectorViewController

@synthesize tableView;

- (void)dealloc {
    [tableView release];
    
    [super dealloc];
}

#pragma mark -

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Mad Minute"];
        
        // Create a generic back button (so that it won't say "Mad Minute")
        UIBarButtonItem *button = [UIBarButtonItem alloc];
        [button initWithTitle:@"Back"
                        style:UIBarButtonItemStyleBordered
                       target:NULL
                       action:NULL];
        [[self navigationItem] setBackBarButtonItem:button];
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
    [Settings setGameType:SinglePlayer];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell alloc];
    [cell initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:@""];
    [cell autorelease];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [[cell textLabel] setText:[Settings gameTypeAsString:[indexPath row]]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return @"Game type";
}

- (NSString *)tableView:(UITableView *)aTableView titleForFooterInSection:(NSInteger)section {
    return @"Famigo requires internet access";
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [(NavigationController *)[self navigationController] didSelectGameType:[indexPath row]];
}

@end