//
//  ResultsViewController.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Famigo.h"
#import "ResultsDetailViewController.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    Famigo *famigo;
    NSUserDefaults *defaults;
    UITableView *tableView;
    
    // Game information
    GameType gameType;
    NSDictionary *gameData;
}

@property (nonatomic, retain, readonly) Famigo *famigo;
@property (nonatomic, retain, readonly) NSUserDefaults *defaults;
@property (nonatomic, retain, readonly) UITableView *tableView;

@property (nonatomic, assign, readonly) GameType gameType;
@property (nonatomic, retain, readonly) NSDictionary *gameData;

- (NSInteger)scoreForPlayerNamed:(NSString *)playerName;
- (NSString *)responseToQuestion:(NSString *)question;
- (BOOL)isResponseCorrect:(NSString *)question;

@end