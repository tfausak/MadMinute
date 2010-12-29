//
//  Constants.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define kAPIKey @"0aa3a9f0acf8308151a50b8dd5d12e06a323ab12"
#define kFamigoIPAddress @"174.143.213.31"
#define kGameName @"Mad Minute"
#define kGameInstructions @"\nIt's like math, but faster!\n\n"
#define kPromptOnAppLaunchCount 3
#define kAppStoreReviewUrl @"http://www.apple.com/"
#define kInitialTime 60

// NSUserDefaults keys
#define kAppLaunchCountKey @"appLaunchCount"
#define kGameTypeKey @"gameType"
#define kDifficultyKey @"difficulty"
#define kNumberOfPlayersKey @"numberOfPlayers"
#define kAllowNegativeNumbersKey @"allowNegativeNumbers"
//#define kScoresKey @"scores"
//#define kGameFinishedKey @"gameFinished"
//#define kScoreKey @"score"

#define kPlayerSettingsKey @"settings"
#define kPlayerQuestionsKey @"questions"
#define kPlayerEquationKey @"equation"
#define kPlayerResponseKey @"response"

typedef enum {
    SinglePlayer = 0x01 << 0,
    PassAndPlay = 0x01 << 1,
    PassAndPlayWithFamigo = 0x01 << 2,
    MultiDeviceWithFamigo = 0x01 << 3
} GameType;

typedef enum {
    VeryEasy,
    Easy,
    Medium,
    Hard,
    VeryHard
} Difficulty;

typedef enum {
    Addition,
    Subtraction,
    Multiplication,
    Division
} Operation;