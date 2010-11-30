//
//  ResultsController.h
//  MadMinute
//
//  Created by Taylor Fausak on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ResultsController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIViewController *parentViewController;
    UITableView *resultsTableView;
    
    NSMutableDictionary *gameData;
}

@property (nonatomic, assign) UIViewController *parentViewController;
@property (nonatomic, retain) UITableView *resultsTableView;
@property (nonatomic, retain) NSMutableDictionary *gameData;

@end