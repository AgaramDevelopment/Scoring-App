//
//  DBManagerEndSession.h
//  CAPScoringApp
//
//  Created by deepak on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerEndSession : NSObject


+(NSString*)GetIsDayNightForFetchEndSession:(NSString*) MATCHCODE;
+(BOOL)GetDayNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSString*)GetDayNoStatusForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSString*)GetDayNoStatusIn0ForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSNumber*) GetInningsNosForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE;
+(NSNumber*)  GetSessionNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) DAYNO;
+(BOOL) GetOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO;
+(NSString*) GetStartOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO;
+(NSString*) GetNewStartOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO;

+(NSString*)  GetStartBallNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSString*) DAYNO:(NSNumber*) INNINGSNO: (NSString*) STARTOVERNO;
+(NSString*) GetEndOverNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSString*) DAYNO:(NSString*) INNINGSNO;
+(NSString*) GetEndBallNoForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSString*) DAYNO:(NSNumber*) INNINGSNO :(NSString*) ENDOVERNO;
+(NSString*) GetOverStatusForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*) ENDOVERNO;
+(NSString*) GetTeamNamesForFetchEndSession:(NSString*) BATTINGTEAMCODE;

+(NSString*)GetPenaltyRunsForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE;
+(NSString*) GetRunsScoredForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) SESSIONNO:(NSNumber*) INNINGSNO: (NSString*) DAYNO;

+(NSString*) GetWicketLoftForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO: (NSString*) SESSIONNO: (NSString*) DAYNO;
+(NSMutableArray*) GetBattingTeamForFetchEndSession:(NSString*) BATTINGTEAMCODE;
+(NSMutableArray*) GetSessionEventsForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSString*) GetStartDateForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSMutableArray*)GetDateDayWiseForFetchEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSMutableArray*)getSessionDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
+(NSMutableArray*) GetBattingTeamUsingBowlingCode:(NSString*) BOWLINGTEAMCODE;
+(NSMutableArray*) GetMetaSubCode;




//SP_INSERTENDSESSION----------------------------------------------------------------------


+(NSString*)  GetMatchTypeForInsertEndSession :(NSString*) COMPETITIONCODE;
+(NSString*)  GetWicketsForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSNumber*) INNINGSNO;

+(NSString*)  GetPenaltyRunsForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) TEAMCODE;

+(NSString*)  GetRunsForInsertEndSession:(NSString*) INNINGSNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE;

+(NSString*)  GetOverNoForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSNumber*) INNINGSNO;

+(NSString*)  GetBallNoForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) OVERNO:(NSNumber*) INNINGSNO;

+(NSString*) GetOverStatusForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSNumber*) INNINGSNO: (NSString*) OVERNO;

+(NSString*)  GetOversPlayedForInsertEndSession:(NSString*) INNINGSNO:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) TEAMCODE;

+(BOOL) GetSessionStartTimeForInsertEndSession:(NSString*) DAYNO:(NSString*) MATCHCODE: (NSString*) CHECKSTARTDATE;

+(BOOL) GetCompetitionCodeForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) TEAMCODE;

+(BOOL) GetDayNoInNotExistsForInsertEndSession:(NSString*) SESSIONSTARTTIME:(NSString*) SESSIONENDTIME :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO: (NSString*) DAYNO;

+(BOOL) GetSessionNoForInsertEndSession:(NSString*) SESSIONSTARTTIME:(NSString*) SESSIONENDTIME :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE ;

+(BOOL)  GetCompetitionCodeInNotExistsForInsertEndSession:COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO: (NSString*) SESSIONNO: (NSString*) DAYNO;

+(BOOL) InsertSessionEventForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) SESSIONNO:(NSString*) STARTTIME : (NSString*) ENDTIME:(NSString*) TEAMCODE: (NSString*) STARTOVER:(NSString*) ENDOVER :(NSString*) TOTALRUNS:(NSString*) TOTALWICKETS :(NSString*) DOMINANTTEAMCODE;

+(BOOL) GetDayNoForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO;


+(BOOL) InsertDayEventForInsertEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) TEAMCODE:(NSString*) RUNS : (NSString*) OVERBALLNO:(NSString*) WICKETS;

//SP_UPDATEENDSESSION-----------------------------------------------------------------------

+(BOOL)GetMatchCodeInNotExists:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE;
+(BOOL)updateEndSession:(NSString*) STARTTIME:(NSString*) ENDTIME : (NSString*) DOMINANTTEAMCODE:(NSString*) DAYNO :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) SESSIONNO;


//SP_DELETEENDSESSION-------------------------------------------------------------------------

+(BOOL) GetBallCodeForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) DAYNO: (NSString*) SESSIONNO;
+(BOOL) GetBallCodeWithAddDayNoForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) DAYNO;
+(BOOL) GetSessionNoForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) SESSIONNO;
+(BOOL)GetSessionNoWithAddDayNoForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) DAYNO;

+(BOOL)DeleteSessionEventsForDeleteEndSession:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO:(NSString*) DAYNO :(NSString*) SESSIONNO;

@end

