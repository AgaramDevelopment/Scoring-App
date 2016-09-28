//
//  DBManagerChangeToss.h
//  CAPScoringApp
//
//  Created by APPLE on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerChangeToss : NSObject


-(NSMutableArray *) GetBattingTeamPlayers:(NSString *) TEAMCODE:(NSString *) MATCHCODE;
-(NSMutableArray *) GetBowlingTeamPlayers:(NSString *) TEAMCODE:(NSString *) MATCHCODE;
-(NSMutableArray *) BattingTeamPlayersForToss:(NSString*) TEAMCODE:(NSString*) MATCHCODE;
-(NSMutableArray *) BowlingTeamPlayersForToss:(NSString*) TEAMCODE:(NSString*) MATCHCODE;
-(NSString *) GetBowlingTeamCodeForInningsEvents:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSNumber *) MAXINNINGSNO;
-(NSString*) GetBattingTeamCodeForInningsEvents:(NSString *) BOWLINGTEAMCODE:(NSString *) MATCHCODE:(NSString*) COMPETITIONCODE;
-(NSMutableArray *) GetUmpireDetailsForToss:(NSString*) MATCHCODE;
-(NSMutableArray *) GetTossDetails;
-(NSMutableArray *) GetTeamDetailsForToss:(NSString*) MATCHCODE;
-(NSMutableArray *)StrikerNonstriker: (NSString *) MATCHCODE :(NSString *) TeamCODE;
-(BOOL) SetMatchEventsForToss:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TOSSWONTEAMCODE:(NSString*) ELECTEDTO:(NSString*) BATTINGTEAMCODE:(NSString*) BOWLINGTEAMCODE;
-(NSString*) GetMaxInningsNoForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(BOOL) SetInningsEventsForToss:(NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE : (NSNumber*) Inningsno : (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE : (NSString*) BOWLERCODE : (NSString*) BOWLINGEND;
-(BOOL) UpdateMatchStatusForToss:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSMutableArray *) GetTossDetailsForBattingTeam:(NSString*) TOSSWONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSMutableArray *) GetTossDetailsForTeam:(NSString*) TOSSWONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSString*) GetMatchEventsForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSMutableArray *) GetTossDetailsForBowlingTeam:(NSString*) TOSSWONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSMutableArray *) GetTossDetailsForTeam:(NSString*) TOSSWONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSString*) GetMatchEventsForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(BOOL) SetMatchEventsForToss:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TOSSWONTEAMCODE:(NSString*) ELECTEDTO:(NSString*) BATTINGTEAMCODE:(NSString*) BOWLINGTEAMCODE;
-(NSString*) GetMaxInningsNoForTossDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(BOOL) UpdateMatchStatusForToss:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(NSString *) InsertTossDetails:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TOSSWONTEAMCODE:(NSString*)ELECTEDTO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)BOWLINGEND;
-(NSMutableDictionary *) FetchTossDetailsForInnings: (NSString*)MATCHCODE : (NSString*)COMPETITIONCODE;
@end
