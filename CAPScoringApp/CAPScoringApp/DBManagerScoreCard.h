//
//  DBManagerScoreCard.h
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerScoreCard : NSObject
-(NSMutableArray *) GetMatchRegistrationForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSMutableArray *) GetBattingSummaryForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSNumber*) GetInningsStatusForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSNumber*) GetMatchOverForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSNumber*) GetFinalInningsForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(NSString*) GetBattingteamCodeForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSString*) GetBowlingteamCodeForScoreBoard:(NSString*) BATTINGTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;


-(NSString*) GetIsFollowOnForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSString*) GetIsFollowOnInMinusForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

-(NSString*) GetTempBatTeamPenaltyForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE;

-(NSString*) TempBatTeamPenaltyForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO :(NSString*) BATTINGTEAMCODE;


-(NSMutableArray *) GetInningsSummaryForScoreBoard:(NSString*) TEMPBATTEAMPENALTY: (NSString*) MATCHOVERS: (NSString*) MATCHBALLS: (NSString*) FINALINNINGS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE : (NSString*) INNINGSNO;

-(NSMutableArray *) GetBatPlayerForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE : (NSString*) INNINGSNO;

-(NSString*) GetIsTimeShowForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(NSMutableArray *) GetBowlingSummaryForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO;

-(NSMutableArray *) GetBowlingSummaryInElseForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO;
-(NSMutableArray *) GetBattingSummaryForScoreBoardWkt:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO;

@end
