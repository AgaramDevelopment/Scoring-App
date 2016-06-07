//
//  DBManager.h
//  CAP
//
//  Created by Lexicon on 20/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BallEventRecord.h"
#import "BowlerEvent.h"
#import "FieldingFactorRecord.h"

@interface DBManager : NSObject
//tournament
+(NSMutableArray *)RetrieveEventData;
//login
+(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password;
+(BOOL)checkExpiryDate: (NSString *) userId;

//toss details
+(NSMutableArray *)checkTossDetailsWonby: (NSString *) MATCHCODE;
+(NSMutableArray *)Electedto;
+(NSMutableArray *)StrikerNonstriker: (NSString *) MATCHCODE :(NSString *) TeamCODE;
+(NSMutableArray *)Bowler: (NSString *) MATCHCODE :(NSString *) TeamCODE;
+(NSMutableArray *)RetrieveFixturesData:(NSString*)competitionCode;


//fixtures&official


+(NSMutableArray *)RetrieveFixturesData;
+(BOOL)updateFixtureInfo:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode;
//+(NSMutableArray *)RetrieveOfficalMasterData;
+(NSMutableArray *)RetrieveOfficalMasterData:(NSString*) matchCode competitionCode:(NSString*)competitionCode;


//select player
+(NSMutableArray *)getSelectingPlayerArray: (NSString *) teamCode matchCode:(NSString *) matchCode;
+(BOOL)updateSelectedPlayersResultCode:(NSString*)playerCode matchCode:(NSString*) matchCode recordStatus:(NSString*)recordStatus;


//match setup

+(NSMutableArray *)SelectTeamPlayers:(NSString*) matchCode teamCode:(NSString*)teamCode;
+(BOOL)updateOverInfo:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode;

// StartBall Record
+ (BOOL) saveBallEventData:(BallEventRecord *) ballEventData;

+ (BOOL) insertBallCodeAppealEvent:(BallEventRecord *) ballcode;
+ (BOOL) insertBallCodeFieldEvent :(BallEventRecord *) ballcode;
+ (BOOL) insertBallCodeWicketEvent :(BallEventRecord *) ballcode;
+ (BOOL) insertBallCodeFieldEvent :(BallEventRecord *) ballEvent bowlerEvent:(BowlerEvent *)bowlerEvent fieldingFactor:(FieldingFactorRecord *) fieldingFactor nrs:(NSString *) nrs;

+ (NSMutableArray *) getballcodemethod;
+ (NSMutableArray *) getTeamCodemethod;
+ (NSMutableArray *) getInningsNomethod;
+ (NSMutableArray *) getDayNomethod;


+(NSMutableArray *)AppealRetrieveEventData;
+(NSMutableArray *)getOtwRtw;

+(NSMutableArray *)GetBallDetails : (NSString *) MatchCode : (NSString *) CompetitionCode;


//toss proceed Save
+(NSString *) TossSaveDetails:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE;
+ (BOOL) insertMatchEvent :(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)selectTeamcode :(NSString*)electedcode:(NSString*)teamCode:(NSString*)teambCode;

+(NSString *) getMaxInningsNumber:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE;
+ (BOOL) inserMaxInningsEvent :(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE :(NSString*)maxInnNo:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)CURRENTSTRIKERCODE:(NSString*)CURRENTNONSTRIKERCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSSTATUS:(NSString*)BOWLINGEND;

+ (BOOL) inserMaxInningsEvent :(NSString*) CompetitionCode:(NSString*)MATCHCODE:(NSString*)teamaCode :(NSString*)maxInnNo:(NSString*)StrikerCode:(NSString*)NonStrikerCode:(NSString*)selectBowlerCode:(NSString*)StrikerCode:(NSString*)NonStrikerCode:(NSString*)selectBowlerCode:(NSString*)teamaCode:(NSString*)inningsStatus:(NSString*)BowlingEnd;

+(BOOL)updateProcced:(NSString*)CompetitionCode:(NSString*)MATCHCODE;

//Appeal
+(NSMutableArray *)AppealSystemRetrieveEventData;
+(NSMutableArray *)AppealComponentRetrieveEventData;
+(NSMutableArray *) AppealUmpireRetrieveEventData:(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE;


+(NSMutableArray *)getBowlType;
+(NSMutableArray *)getBowlFastType;
+(NSMutableArray *)getAggressiveShotType;
+(NSMutableArray *)getDefenceShotType;
+(NSMutableArray *)RetrieveFieldingFactorData;
+(NSMutableArray *)RetrieveFieldingPlayerData;


// playerOrderlevel
+(BOOL)updatePlayerorder:(NSString *) matchCode :(NSString *) teamcode PlayerCode:(NSString *)playerCode PlayerOrder:(NSString *)playerorder ;

+(NSMutableArray *)getTeamCaptainandTeamwicketkeeper:(NSString*) competitioncode :(NSString*) matchcode;

+(BOOL)updateCapitainWicketkeeper:(NSString *) compatitioncode :(NSString *) matchCode capitainAteam:(NSString *)capitainAteam capitainBteam:(NSString *)capitainBteam wicketkeeperAteam:(NSString *)wicketkeeperAteam  wicketkeeperBteam:(NSString *)wicketkeeperBteam;
@end
