//
//  GameTypeSelectorViewController.m
//  Mad Minute
//
//  Created by Taylor Fausak on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameTypeSelectorViewController.h"
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
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:NULL action:NULL];
        [[self navigationItem] setBackBarButtonItem:backButton];
        [backButton release];
        
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
            return 4;
        default:
            NSAssert(NO, @"unknown section");
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    UITableViewCell *tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    [tableViewCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case SinglePlayer:
                    [[tableViewCell textLabel] setText:@"Single player"];
                    [[tableViewCell detailTextLabel] setText:@""];
                    break;
                case PassAndPlay:
                    [[tableViewCell textLabel] setText:@"Pass and play"];
                    [[tableViewCell detailTextLabel] setText:@""];
                    break;
                case PassAndPlayWithFamigo:
                    [[tableViewCell textLabel] setText:@"Pass and play"];
                    [[tableViewCell detailTextLabel] setText:@"With Famigo"];
                    break;
                case MultiDeviceWithFamigo:
                    [[tableViewCell textLabel] setText:@"Multi device"];
                    [[tableViewCell detailTextLabel] setText:@"With Famigo"];
                    break;
                default:
                    NSAssert(NO, @"unknown row");
                    return nil;
            }
            break;
        default:
            NSAssert(NO, @"unknown section");
            return nil;
    }
    
    return tableViewCell;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch (section) {
        case 0:
            return @"Game type";
        default:
            NSAssert(NO, @"unknown section");
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)aTableView titleForFooterInSection:(NSInteger)section {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch (section) {
        case 0:
            return @"Famigo requires internet access";
        default:
            NSAssert(NO, @"unknown section");
            return nil;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case SinglePlayer:
                case PassAndPlay:
                case PassAndPlayWithFamigo:
                case MultiDeviceWithFamigo:
                    return 54;
                default:
                    NSAssert(NO, @"unknown row");
                    return 0;
            }
        default:
            NSAssert(NO, @"unknown section");
            return 0;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(aTableView == tableView, @"invalid table view");
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case SinglePlayer:
                case PassAndPlay:
                case PassAndPlayWithFamigo:
                case MultiDeviceWithFamigo:
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [(NavigationController *)[self navigationController] didSelectGameType:[indexPath row]];
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