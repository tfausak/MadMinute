//
//  ResultsViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    NSArray *data;
}

@property (nonatomic, retain, readonly) UITableView *tableView;
@property (nonatomic, retain, readonly) NSArray *data;

- (NSInteger)scoreForPlayerData:(NSDictionary *)playerData;

@end