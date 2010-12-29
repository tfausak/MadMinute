//
//  SettingsViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "DifficultyViewController.h"
#import "NumberOfPlayersViewController.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
}

@property (nonatomic, retain) UITableView *tableView;

- (void)toggledSwitch:(id)sender;

@end