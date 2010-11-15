//
//  SettingsController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

@synthesize parentViewController;
@synthesize difficulty;
@synthesize navigationBar;
@synthesize settingsTableView;
@synthesize allowNegativeNumbersSwitch;

- (void)dealloc {
    [parentViewController release];
    [difficulty release];
    [navigationBar release];
    [settingsTableView release];
    [allowNegativeNumbersSwitch release];
    
    [super dealloc];
}

#pragma mark -

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    [view release];
}

- (void)viewDidLoad {
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    
    difficulty = [NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"] inSection:0];
    
    navigationBar = [[UINavigationBar alloc] init]; {
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [navigationItem setTitle:@"Settings"]; 
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Famigo"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:parentViewController
                                                                      action:@selector(pressedFamigoButton:)];
        [navigationItem setLeftBarButtonItem:leftButton];
        [leftButton release];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:parentViewController
                                                                       action:@selector(pressedNewGameButton:)];
        [navigationItem setRightBarButtonItem:rightButton];
        [rightButton release];
        
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem release];
    } [[self view] addSubview:navigationBar];
    
    settingsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped]; {
        [settingsTableView setDataSource:self];
        [settingsTableView setDelegate:self];
    } [[self view] addSubview:settingsTableView];
    
    allowNegativeNumbersSwitch = [[UISwitch alloc] init]; {
        [allowNegativeNumbersSwitch addTarget:self action:@selector(toggledSwitch:) forControlEvents:UIControlEventValueChanged];
        [allowNegativeNumbersSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"allowNegativeNumbers"]];
    } [[settingsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setAccessoryView:allowNegativeNumbersSwitch];
    
    [self drawUI];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] init];
    if ([indexPath compare:difficulty] == NSOrderedSame) {
        [tableViewCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    NSString *title;
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    title = @"Very easy";
                    break;
                case 1:
                    title = @"Easy";
                    break;
                case 2:
                    title = @"Medium";
                    break;
                case 3:
                    title = @"Hard";
                    break;
                case 4:
                    title = @"Very hard";
                    break;
                default:
                    NSAssert(NO, @"Unknown index");
                    break;
            }
            break;
        case 1:
            switch ([indexPath row]) {
                case 0:
                    title = @"Negative numbers";
                    [tableViewCell addSubview:allowNegativeNumbersSwitch];
                    break;
                default:
                    NSAssert(NO, @"Unknown index");
                    break;
            }
            break;
        default:
            NSAssert(NO, @"Unknown index");
            break;
    }
    
    [[tableViewCell textLabel] setText:title];
    
    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 1;
    }
    
    NSAssert(NO, @"Unknown section");
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Difficulty";
        case 1:
            return @"Options";
    }
    
    NSAssert(NO, @"Unknown section");
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            if ([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryNone) {
                return indexPath;
            }
            return nil;
        case 1:
            return nil;
    }
    
    NSAssert(NO, @"Unknown index");
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:difficulty] != NSOrderedSame) {
        [[tableView cellForRowAtIndexPath:difficulty] setAccessoryType:UITableViewCellAccessoryNone];
        difficulty = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[indexPath row] forKey:@"difficulty"];
    [defaults synchronize];
}

#pragma mark -

- (void)toggledSwitch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[allowNegativeNumbersSwitch isOn] forKey:@"allowNegativeNumbers"];
    [defaults synchronize];        
}

- (void)drawUI {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPad landscape
            [[self view] setFrame:CGRectMake(0, 0, 1024, 768)];
        }
        else {
            // iPad portrait
            [[self view] setFrame:CGRectMake(0, 0, 768, 1024)];
        }
        
        [allowNegativeNumbersSwitch setFrame:CGRectMake([[self view] frame].size.width - 150, 9, 94, 27)];
    }
    else {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPhone landscape
            [[self view] setFrame:CGRectMake(0, 0, 480, 320)];
        }
        else {
            // iPhone portrait
            [[self view] setFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        [allowNegativeNumbersSwitch setFrame:CGRectMake([[self view] frame].size.width - 115, 9, 94, 27)];
    }
    
    [navigationBar setFrame:CGRectMake(0, 0, [[self view] frame].size.width, 44)];
    [settingsTableView setFrame:CGRectMake(0, 44, [[self view] frame].size.width, [[self view] frame].size.height - 64)];
        
    [self updateUI];
}

- (void)updateUI {
}

@end