//
//  AppDelegate.h
//  Aardvark
//
//  Created by Taylor Fausak on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AardvarkController.h"
#import "FamigoHeaders.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AardvarkController *aardvarkController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) AardvarkController *aardvarkController;

@end