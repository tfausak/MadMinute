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

@interface ResultsViewController : UIViewController {
    Famigo *famigo;
    NSUserDefaults *defaults;
    
    // Game information
    GameType gameType;
    NSDictionary *gameData;
}

@property (nonatomic, retain, readonly) Famigo *famigo;
@property (nonatomic, retain, readonly) NSUserDefaults *defaults;

@property (nonatomic, assign, readonly) GameType gameType;
@property (nonatomic, retain, readonly) NSDictionary *gameData;

@end