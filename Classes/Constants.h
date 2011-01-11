//
//  Constants.h
//  Mad Minute
//
//  Created by Taylor Fausak on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define kAPIKey @"88bc1871153b792e827d116603f0400db906236c"
#define kFamigoIPAddress @"174.143.213.31"
#define kGameName @"Mad Minute"
#define kGameInstructions @"\nIt's like math, but faster!\n\n"
#define kPromptOnAppLaunchCount 3
#define kAppStoreReviewUrl @"http://www.famigogames.com/"
#define kInitialTime 60

// NSUserDefaults keys
#define kAppLaunchCountKey @"appLaunchCount"
#define kGameTypeKey @"gameType"
#define kDifficultyKey @"difficulty"
#define kNumberOfPlayersKey @"numberOfPlayers"
#define kAllowNegativeNumbersKey @"allowNegativeNumbers"
#define kGameDataKey @"gameData"

#define kPlayerKeyKey @"key"
#define kPlayerNameKey @"name"
#define kPlayerScoreKey @"score"
#define kPlayerSettingsKey @"settings"
#define kPlayerQuestionsKey @"questions"

typedef enum {
    SinglePlayer,
    PassAndPlay,
    PassAndPlayWithFamigo,
    MultiDeviceWithFamigo
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
