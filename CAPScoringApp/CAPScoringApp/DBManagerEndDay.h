//
//  DBManagerEndDay.h
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManagerEndDay : NSObject

//SP_UPDATEENDDAY

+(NSString*) GetStartTimeForDayEvents:(NSString*) ENDTIMEFORMAT:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(BOOL) UpdateDayEventsForEndDay:(NSString*) STARTTIME:(NSString*) ENDTIME:(NSString*) COMMENTS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(NSMutableArray*) GetDayEventsForUpdateEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;


//SP_DELETEENDDAY

+(NSString*) GetBallCodeForDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) DAYNO;

+(BOOL) GetDayEventsForDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) DAYNO;

+(BOOL) DeleteDayEventsForDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(NSMutableArray*) GetDeleteEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;


//SP_FETCHENDDAYDETAILS

+(NSString*) GetIsDayNightForFetchEndDay:(NSString*) MATCHCODE;

+(NSString*) GetTeamNameForFetcHEndDay:(NSString*) TEAMCODE;

+(NSString*) GetDayNoForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSString*) GetMaxDayNoForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSString*) GetMaxDayNoForFetchEndDayDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSString*) GetPenaltyRunsForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) TEAMCODE;

+(NSString*) GetRunsForFetchEndDay:(NSNumber*) INNINGSNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) DAYNO;

+(NSString*) GetMinOverForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSNumber*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetMinBallNoForFetcHEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) MINOVERNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetMaxOverForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSNumber*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetMaxBallNoForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) OVERNO:(NSNumber*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetBallEventsForFetchEndDay:(NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSNumber*) INNINGSNO:(NSString*) MINOVERBALL:(NSString*) MAXOVERBALL;

+(NSString*) GetWicketsCountForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSNumber*) INNINGSNO:(NSString*) DAYNO;

+(NSMutableArray *) GetFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSMutableArray *) GetMatchDateForFetchEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;



//SP_INSERTENDDAY

+(NSString*) GetMatchTypeForInserTEndDay:(NSString*) COMPETITIONCODE;

+(NSString*) GetMaxSessionNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetMinOverNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetMinBallNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSNumber*) STARTOVERNO;

+(NSString*) GetMaxOverNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO;

+(NSString*) GetMaxBallNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSString*)ENDOVERNO;

+(NSString*) GetOverStatusForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) ENDOVERNO;

+(NSString*) GetRunsScoredForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) SESSIONNO:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetWicketLostForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) SESSIONNO;

+(NSString*) GetDayNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) DAYNO;

+(NSString*) GetStartTimeForInsertEndDay:(NSString*) STARTTIMEFORMAT:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE;

+(BOOL) SetDayEventsForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) STARTTIME:(NSString*) ENDTIME:(NSString*) DAYNO:(NSString*) BATTINGTEAMCODE:(NSString*) TOTALRUNS:(NSString*) TOTALOVERS:(NSString*) TOTALWICKETS:(NSString*) COMMENTS;

+(NSString*) GetSessionNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO:(NSString*) COUNT;

+(BOOL) SetSessionEventsForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO:(NSString*) SESSIONNO:(NSString*) BATTINGTEAMCODE:(NSString*) STARTOVERBALLNO:(NSString*) TOTALOVERS:(NSString*) RUNSSCORED:(NSString*) WICKETLOST;

+(NSMutableArray *) InsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(NSString*) GetMaxDayNoForInsertEndDay:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BATTINGTEAMCODE;



@end
