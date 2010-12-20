//
//  AppDelegate.h
//  MadMinute
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MadMinuteController.h"
#import "FamigoHeaders.h"
#import "Reachability.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MadMinuteController *madMinuteController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MadMinuteController *madMinuteController;

- (void)evaluateTimeForReview;

@end