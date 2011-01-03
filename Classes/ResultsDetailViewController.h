//
//  ResultsDetailViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Famigo.h"
#import "ArithmeticEquation.h"

@interface ResultsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSUserDefaults *defaults;
    Famigo *famigo;
    NSArray *questions;
    UITableView *tableView;
}

@property (nonatomic, retain, readonly) NSUserDefaults *defaults;
@property (nonatomic, retain, readonly) Famigo *famigo;
@property (nonatomic, retain, readonly) NSArray *questions;
@property (nonatomic, retain, readonly) UITableView *tableView;

- (id)initWithPlayer:(NSString *)aPlayer;

@end