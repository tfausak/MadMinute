//
//  NumberOfPlayersViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NumberOfPlayersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
}

@property (nonatomic, retain, readonly) UITableView *tableView;

@end