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
+(NSMutableArray *)RetrieveOfficalMasterData;


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

+ (NSMutableArray *) getballcodemethod;
+ (NSMutableArray *) getTeamCodemethod;
+ (NSMutableArray *) getInningsNomethod;
+ (NSMutableArray *) getDayNomethod;


+(NSMutableArray *)AppealRetrieveEventData;
+(NSMutableArray *)getOtwRtw;


//fielding factor
+(NSMutableArray *)RetrieveFieldingFactorData;

//Bowl type - Spin
+(NSMutableArray *)getBowlType;

//bowl type - fast
+(NSMutableArray *)getBowlFastType;

@end
