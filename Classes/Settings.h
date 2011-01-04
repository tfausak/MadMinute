//
//  Settings.h
//  Mad Minute
//
//  Created by Taylor Fausak on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Settings : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
}

@property (nonatomic, retain, readonly) UITableView *tableView;

// Class methods
// Getters
+ (GameType)gameType;
+ (Difficulty)difficulty;
+ (BOOL)allowNegativeNumbers;
+ (NSInteger)numberOfPlayers;
+ (NSDictionary *)all;

// String getters
+ (NSString *)gameTypeAsString:(GameType)gameType;
+ (NSString *)gameTypeAsString;
+ (NSString *)difficultyAsString:(Difficulty)difficulty;
+ (NSString *)difficultyAsString;
+ (NSString *)allowNegativeNumbersAsString;
+ (NSString *)numberOfPlayersAsString:(NSInteger)numberOfPlayers;
+ (NSString *)numberOfPlayersAsString;
+ (NSString *)allAsString;

// Setters
+ (void)setGameType:(GameType)gameType;
+ (void)setDifficulty:(Difficulty)difficulty;
+ (void)setAllowNegativeNumbers:(BOOL)allowNegativeNumbers;
+ (void)setNumberOfPlayers:(NSInteger)numberOfPlayers;
+ (void)setAll:(NSDictionary *)all;

// Instance methods
- (void)switchValueDidChange:(id)sender;

@end