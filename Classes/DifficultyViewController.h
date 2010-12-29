//
//  DifficultyViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DifficultyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
}

@property (nonatomic, retain) UITableView *tableView;

+ (Difficulty)currentDifficulty;
+ (NSString *)currentDifficultyAsString;
+ (NSString *)difficultyAsString:(Difficulty)difficulty;

@end