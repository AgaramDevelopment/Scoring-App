//
//  DBManagerFollowOn.h
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerFollowOn : NSObject


//SP_FETCHFOLLOWON----------------------------------------------------------------

+(NSMutableArray *) GetteamDetailsForFetchFollowOn:(NSString*) MATCHCODE:(NSString*) TEAMCODE;
+(NSString*) GetFollowonForFetchFollowOn:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO;




//SP_FETCHTEAMNAMESELECTIONCHANGED-----------------------------------------------------------------

+(NSString*)GetOppositeTeamCodeForFetchTeamNameSelectionChanged: (NSString*) MATCHCODE:(NSString*)TEAMNAME;
+(NSMutableArray *)GetSelectionBattingTeamForFetchTeamNameSelectionChanged:(NSString*) MATCHCODE:(NSString*) TEAMCODE;
+(NSMutableArray *)GetOppositeBowlingTeamForFetchTeamNameSelectionChanged: (NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE;
+(NSMutableArray *)GetStrickerDetailForFetchTeamNameSelectionChanged: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME : (NSNumber*) INNINGSNO;


//SP_UPDATEFOLLOWON----------------------------------------------------------------------
+(NSString*)  GetBallCodeForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO;

+(NSString*) GetTeamNamesForUpdateFollowOn:(NSNumber*) TEAMNAME;

+(NSString*) GetTotalRunsForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO;

+(NSString*)  GetOverNoForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO;

+(NSString *) GetOverStatusForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO:(NSString*) OVERNO;

+(NSString *) GetBowlingTeamCodeForUpdateFollowOn:(NSString*) COMPETITIONCODE:(NSString*) TEAMNAME: (NSString*) MATCHCODE;

+(NSString*)  GetWicketForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO;

+(BOOL) UpdatInningsEventForInsertScoreBoard:(NSString*) TEAMNAME:(NSString*) TOTALRUN :(NSNumber*) OVERBALLNO	:(NSString*) WICKETS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSString*) TEAMNAME;

+(NSString*) GetTeamCodeForUpdateFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO;

+(BOOL) InsertInningsEventForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO :(NSString*) STRIKER:(NSString*) NONSTRIKER :(NSString*) BOWLER;

+(BOOL)UpdateInningsEventInStrickerForInsertScoreBoard:(NSString*) STRIKER:(NSString*) NONSTRIKER :(NSString*) BOWLERCODE:(NSString*) TEAMCODE: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO;

+(NSString *)  GetBallCodeForDeleteFollowOn:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMNAME :(NSNumber*) INNINGSNO ;

+(BOOL) UpdateInningsEventForDeleteFollowOn: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO;
+(BOOL) DeleteInningsEventForDeleteFollowOn: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO;

@end
