//
//  WaitController.h
//  MadMinute
//
//  Created by Taylor Fausak on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitController : UIViewController {
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) UIActivityIndicatorView *spinner;

@end