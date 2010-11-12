//
//  SettingsController.m
//  MadMinute
//
//  Created by Taylor Fausak on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

@synthesize parentViewController;
@synthesize facebook;
@synthesize loggedIntoFacebook;
@synthesize navigationBar;
@synthesize difficultySlider;
@synthesize allowNegativeNumbersSwitch;
@synthesize facebookButton;
@synthesize shareButton;

- (void)dealloc {
    [parentViewController release];
    [facebook release];
    [navigationBar release];
    [difficultySlider release];
    [allowNegativeNumbersSwitch release];
    [facebookButton release];
    [shareButton release];
    
    [super dealloc];
}

#pragma mark -

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    [view release];
}

- (void)viewDidLoad {
    [[self view] setBackgroundColor:[UIColor lightGrayColor]];
    facebook = [[Facebook alloc] init];
    
    navigationBar = [[UINavigationBar alloc] init]; {
        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
        [navigationItem setTitle:@"Settings"]; 
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Famigo"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:parentViewController
                                                                      action:@selector(pressedFamigoButton:)];
        [navigationItem setLeftBarButtonItem:leftButton];
        [leftButton release];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New Game"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:parentViewController
                                                                       action:@selector(pressedNewGameButton:)];
        [navigationItem setRightBarButtonItem:rightButton];
        [rightButton release];
        
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem release];
    } [[self view] addSubview:navigationBar];
    
    difficultySlider = [[UISlider alloc] init]; {
        [difficultySlider addTarget:self action:@selector(movedSlider:) forControlEvents:UIControlEventTouchUpInside];
        
        int difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:@"difficulty"];
        [difficultySlider setValue:difficulty animated:YES];
    } [[self view] addSubview:difficultySlider];
    
    allowNegativeNumbersSwitch = [[UISwitch alloc] init]; {
        [allowNegativeNumbersSwitch addTarget:self action:@selector(toggledSwitch:) forControlEvents:UIControlEventValueChanged];
        
        BOOL allowNegativeNumbers = [[NSUserDefaults standardUserDefaults] boolForKey:@"allowNegativeNumbers"];
        [allowNegativeNumbersSwitch setOn:allowNegativeNumbers];
    } [[self view] addSubview:allowNegativeNumbersSwitch];
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; {
        [facebookButton addTarget:self action:@selector(pressedFacebookButton:) forControlEvents:UIControlEventTouchUpInside];
    } [[self view] addSubview:facebookButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; {
        [shareButton addTarget:self action:@selector(pressedShareButton:) forControlEvents:UIControlEventTouchUpInside];
    } [[self view] addSubview:shareButton];
    
    [self drawUI];
}

#pragma mark -

- (void)movedSlider:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:([difficultySlider value] * 4) forKey:@"difficulty"];
    [defaults synchronize];
}

- (void)toggledSwitch:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[allowNegativeNumbersSwitch isOn] forKey:@"allowNegativeNumbers"];
    [defaults synchronize];    
}

- (void)pressedFacebookButton:(id)sender {
    if (loggedIntoFacebook) {
        [facebook logout:self];
    }
    else {
        NSArray *permissions = [[NSArray arrayWithObjects:nil] retain];
        [facebook authorize:FamigoFacebookApplicationID permissions:permissions delegate:self];
    }
}

- (void)pressedShareButton:(id)sender {
    NSDictionary *actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"Famigo", @"text",
                                                           @"http://www.famigogames.com/", @"href",
                                                           nil], nil];
    NSDictionary *media = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"image", @"type",
                                                     @"http://famigogames.com/imgs/violet_bg.png", @"src",
                                                     @"http://www.famigogames.com/#image", @"href",
                                                     nil], nil];
    NSDictionary *attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Rad Ribs", @"name",
                                @"I finished a Rab Rib called 'The Puppy Park'!", @"caption",
                                @"One summer, my gramps and I took a frumpy trip to couch. It took us seventeen hours to get there! Along the way, we stopped to see the freezing gazelle. When I tried to take a picture of it, it started to wince and think. After that, we stopped in bedroom. That place is really sexy - I think I want to move there! When we finally got to our destination, I just couldn't help myself - I ran out of the car and snogged. It was so tiny, and at the gift shop, I bought myself two bra. What a great trip!", @"description",
                                @"http://www.famigogames.com/#attachment", @"href",
                                media, @"media",
                                nil];
    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   FamigoFacebookApplicationID, @"api_key",
                                   @"Share on Facebook",  @"user_message_prompt",
                                   [jsonWriter stringWithObject:actionLinks], @"action_links",
                                   [jsonWriter stringWithObject:attachment], @"attachment",
                                   nil];

    [facebook dialog:@"stream.publish" andParams:params andDelegate:self];
}

#pragma mark -

- (void)drawUI {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPad landscape
            [[self view] setFrame:CGRectMake(0, 0, 1024, 768)];
        }
        else {
            // iPad portrait
            [[self view] setFrame:CGRectMake(0, 0, 768, 1024)];
        }
    }
    else {
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
            // iPhone landscape
            [[self view] setFrame:CGRectMake(0, 0, 480, 320)];
        }
        else {
            // iPhone portrait
            [[self view] setFrame:CGRectMake(0, 0, 320, 480)];
        }
    }
    
    [navigationBar setFrame:CGRectMake(0, 0, [[self view] frame].size.width, 44)];
    
    [difficultySlider setFrame:CGRectMake(20, 64, [[self view] frame].size.width - 40, 22)];
    
    [allowNegativeNumbersSwitch setFrame:CGRectMake(([[self view] frame].size.width / 2) - 47, 106, 94, 27)];
    
    [facebookButton setFrame:CGRectMake(([[self view] frame].size.width / 2) - 36, 153, 72, 37)];
    
    [shareButton setFrame:CGRectMake(([[self view] frame].size.width / 2) - 36, 210, 72, 37)];
    
    [self updateUI];
}

- (void)updateUI {
    if (loggedIntoFacebook) {
        [facebookButton setTitle:@"logout" forState:UIControlStateNormal];
        [shareButton setTitle:@"share" forState:UIControlStateNormal];
    }
    else {
        [facebookButton setTitle:@"login" forState:UIControlStateNormal];
        [shareButton setTitle:@"-" forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark Facebook

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)request:(FBRequest *)request didLoad:(id)result {
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
}

- (void)dialogDidComplete:(FBDialog *)dialog {
}

- (void)fbDidLogin {
    loggedIntoFacebook = YES;
    [self updateUI];
}

- (void)fbDidLogout {
    loggedIntoFacebook = NO;
    [self updateUI];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
}

@end