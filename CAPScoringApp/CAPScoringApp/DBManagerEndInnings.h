//
//  DBManagerEndInnings.h
//  CAPScoringApp
//
//  Created by mac on 18/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerEndInnings : NSObject
//--------------------------------------------------------------------------------------------------------
//[SP_INSERTENDINNINGS]
-(NSString *) GetMatchTypeUsingCompetition:(NSString*) COMPETITIONCODE;

-(NSMutableArray *) GetInningsDetails:(NSString*) MATCHCODE;

-(NSString*) GetDayNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(NSString*) GetMaxDayNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(NSString*) GetSessionNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO;

-(NSNumber*) GetStartoverNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) SESSIONNO: (NSString*) OLDINNINGSNO: (NSString*) DAYNO;

-(NSNumber*) GetBallNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) SESSIONNO: (NSString*) OLDINNINGSNO: (NSString*) STARTOVERNO;

-(NSNumber*) GetStartOverBallNoForInsertEndInnings:(NSString*) STARTOVERNO:(NSString*) STARTBALLNO;

-(NSNumber*) GetRunScoredForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE:(NSString*) SESSIONNO: (NSString*) OLDINNINGSNO: (NSString*) DAYNO;

-(NSString*) GetWicketLostForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO:(NSString*) SESSIONNO;

-(BOOL) GetCompetitioncodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;

-(BOOL) UpdateInningsEventForMatchTypeBasedInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO;

-(NSString*) GetLastBallCodeForInsertEndInninges:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO;

-(NSString*) GetLastBallCodeForInsertEndInninges:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO;

-(NSMutableArray *) GetBallEventForInningsDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) LASTBALLCODE;

-(BOOL*) UpdateInningsEventForInsertEndInninges:(NSString*) INNINGSSTARTTIME : (NSString*) INNINGSENDTIME :(NSString*) OLDTEAMCODE :(NSString*) TOTALRUNS : (NSString*) ENDOVER :(NSString*) TOTALWICKETS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO;

-(BOOL) GetCompetitioncodeInAddOldInningsNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO;

-(NSString*) GetInningsCountForInsertEndInnings:(NSString*) MATCHCODE;

-(BOOL) UpdateMatchRegistrationForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(BOOL) GetMatchBasedSessionNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) SESSIONNO;



-(BOOL) InsertSessionEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) SESSIONNO: (NSString*) OLDTEAMCODE: (NSString*) STARTOVERBALLNO:(NSString*) ENDOVER:(NSString*) RUNSSCORED:(NSString*) TOTALWICKETS;


-(BOOL) GetDayNoInDayEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : OLDINNINGSNO: (NSString*) DAYNO;

-(BOOL) InsertDayEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) OLDTEAMCODE: (NSString*) TOTALRUNS:(NSString*) ENDOVER:(NSString*) TOTALWICKETS;

-(NSString*) GetCompetitioncodeInUpdateForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO;

-(BOOL) UpdateInningsEventInUpdateForInsertEndInninges:(NSString*) INNINGSSTARTTIME : (NSString*) INNINGSENDTIME :(NSString*) TOTALRUNS : (NSString*) ENDOVER :(NSString*) TOTALWICKETS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO;



-(NSString*) GetSecondTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

-(NSString*) GetThirdTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSString*) GetSecondTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSString*) GetFirstTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSNumber*) GetSecondTotalinSecondThirdTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSNumber*) GetFirstThirdTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

//-----------------------------------------------------------------------------------------------------
//SP_FETCHENDINNINGS
-(NSString*) GetTeamNameForFetchEndInnings:(NSString*) TEAMCODE;
-(NSNumber *) GetpenaltyRunsForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) TEAMCODE;
-(NSNumber*) GetTotalRunsForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO;
-(NSString*) GetOverNoForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO;
-(NSString*) GetBallNoForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString *)OVERNO:(NSString*) INNINGSNO;
-(NSString*) GetOverStatusForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSString*) OVERNO;
-(NSString*) GetWicketForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO;
-(NSMutableArray *) FetchEndInningsDetailsForFetchEndInnings:(NSString*) MATCHCODE;
-(NSString*)  GetMatchDateForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

//-----------------------------------------------------------------------------------------------------
//SP_MANAGESEOVERDETAILS


-(BOOL) GetOverNoFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(BOOL) InsertOverEventFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OVERSTATUS;
-(BOOL) GetBallCodeFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(NSString*) GetBowlingTeamCodeFormanageOverDetails:(NSString*) TEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSString*) GetBatTeanRunsFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO;
-(NSNumber*)GetMaxidFormanageOverDetails:(NSString*) MATCHCODE;
-(BOOL) InsertBallEventsFormanageOverDetails:(NSString*) BALLCODENO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) DAYNO:(NSString*) OVERNO : (NSString*) BALLNO:(NSString*) SESSIONNO  :(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE :(NSString*) BOWLERCODE:(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW:(NSString*) BOWLINGEND ;

-(BOOL) UpdateOverEventFormanageOverDetails:(NSString*) OVERSTATUS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;

-(BOOL)  UpdateBowlerOverDetailsFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(NSNumber*) GetBattingteamOverwithExtraBallFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;

-(NSNumber*) GetBattingteamOverBallCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO : (NSString*) BATTEAMOVRWITHEXTRASBALLS;

-(NSString *) GetLastBallCodeFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO : (NSNumber*) BATTEAMOVRWITHEXTRASBALLS : (NSNumber*) BATTEAMOVRBALLSCNT;

-(NSString *)GetBallEventCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

-(NSMutableArray*) GetStrickerNonStrickerRunFormanageOverDetails:(NSString*) LASTBALLCODE;

-(BOOL)  UpdateInningsEventFormanageOverDetails:(NSString*) T_STRIKERCODE:(NSString*) T_NONSTRIKERCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO ;

-(BOOL)  GetBallNoFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(NSString *)  GetIsMaidenOverFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(BOOL)  GetBowlerCodeFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(NSString *)   GetCurrentBowlerCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;
-(BOOL)  UpdateBowlingSummaryFormanageOverDetails:(NSString*) BOWLERCOUNT:(NSString*) ISMAIDENOVER :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) CURRENTBOWLER;

-(BOOL)UpdateBowlingSummaryFormanageOver:(NSString*) BOWLERCOUNT:(NSString*) ISMAIDENOVER :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) CURRENTBOWLER :(NSString*)OVERNO;
-(BOOL) InsertBowlingMaidenSummaryInElseFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO:(NSString*) BOWLERCODE:(NSString*) OVERNO;
-(BOOL) InsertBowlerOverDetailsFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE;


//------------------------------------------------------------------------------------------------
//SP_INSERTSCOREBOARD



-(BOOL) GetBatsmanCodeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATSMANCODE;

-(NSMutableArray*) GetO_AssignValueForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATSMANCODE;

-(NSNumber*) GetOBattingPositionNoForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO;
-(BOOL) InsertbattingSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) N_BATTINGPOSITIONNO :(NSString*) BATSMANCODE:(NSNumber*) N_RUNS: (NSNumber*) N_BALLS:(NSNumber*) N_ONES:(NSNumber*) N_TWOS :(NSNumber*) N_THREES: (NSNumber*) N_FOURS:(NSNumber*) N_SIXES:(NSNumber*) N_DOTBALLS;

-(BOOL) UpdatebattingSummaryForInsertScoreBoard:(NSString*) N_BATTINGPOSITIONNO:(NSNumber*) N_RUNS: (NSNumber*)N_BALLS:(NSNumber*) N_ONES:(NSNumber*) N_TWOS :(NSNumber*) N_THREES:(NSNumber*) N_FOURS:(NSNumber*)N_SIXES:(NSNumber*) N_DOTBALLS:(NSNumber*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) BATSMANCODE;

-(BOOL) GetWicKetTypeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER;

-(NSMutableArray*)  GetWicKetAssignVarForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER;

//-(BOOL) UpdatebattingSummaryInWiCketForInsertScoreBoard:(NSString*) N_WICKETNO:(NSString*) N_WICKETTYPE: (NSString*) N_FIELDERCODE:(NSString*) N_BOWLERCODE:(NSString*) WICKETOVERNO :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER;
-(BOOL) UpdatebattingSummaryInWiCketForInsertScoreBoard:(NSString*) N_WICKETNO:(NSString*) N_WICKETTYPE: (NSString*) N_FIELDERCODE:(NSString*) N_BOWLERCODE:(NSString*) WICKETOVERNO :(NSString*)WICKETBALLNO:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER;

-(BOOL) GetBateamCodeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO;

//-(NSMutableArray*) GetInningsSummaryAssignForInsertScoreBoard: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO : (NSString*) WICKETPLAYER;

- (NSMutableArray*) GetInningsSummaryAssignForInsertScoreBoard: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO;

-(BOOL) InsertInningsSummaryForInsertScoreBoard :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) N_BYES:(NSString*) N_LEGBYES: (NSString*) N_NOBALLS:(NSString*) N_WIDES:(NSString*) N_PENALTIES :(NSString*) N_INNINGSTOTAL : (NSString*) N_INNINGSTOTALWICKETS;

-(BOOL) UpdateInningsSummaryForInsertScoreBoard :(NSString*) N_BYES:(NSString*) N_LEGBYES: (NSString*) N_NOBALLS:(NSString*) N_WIDES:(NSString*) N_PENALTIES :(NSString*) N_INNINGSTOTAL : (NSString*) N_INNINGSTOTALWICKETS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO;

-(BOOL) UpdatebattingSummaryInWiCketScoreForInsertScoreBoard:(NSString*) N_INNINGSTOTAL :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETPLAYER;

-(NSNumber*)GetOverStatusForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO;

-(BOOL) GetBowlerForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO ;

-(NSNumber*) GetBowlerCountForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO;

-(BOOL) InsertBowlerOverDetailsForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*) WICKETOVERNO:(NSString*) BOWLERCODE;

-(BOOL) GetBowlerCodeForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) BOWLINGTEAMCODE:(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE;

-(NSMutableArray*) GetBowlingDetailsForassignvarForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE;

-(NSNumber*) GetBowlingPositionCountForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) BOWLINGTEAMCODE:(NSNumber*) INNINGSNO;

-(NSNumber*) GetBallCountForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO;

-(NSNumber*) GetMaiDenOverForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO;

-(BOOL) GetOversForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO;

-(BOOL) DeletebattingSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETOVERNO;


-(BOOL)  InsertBowlingMaidenSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE :(NSNumber*) WICKETOVERNO;

-(BOOL)  InsertBowlingSummaryForInsertScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSNumber*) N_BOWLINGPOSITIONNO:(NSNumber*) BOWLERCODE:(NSNumber*) N_BOWLEROVERS:(NSNumber*) N_BOWLERBALLS:(NSNumber*) N_BOWLERPARTIALOVERBALLS:(NSNumber*) N_BOWLERMAIDENS:(NSNumber*) N_BOWLERRUNS:(NSNumber*) N_BOWLERWICKETS:(NSNumber*) N_BOWLERNOBALLS:(NSNumber*) N_BOWLERWIDES:(NSNumber*) N_BOWLERDOTBALLS:(NSNumber*) N_BOWLERFOURS:(NSNumber*) N_BOWLERSIXES;


-(BOOL) UpdateBowlingSummaryForInsertScoreBoard:(NSString*) N_BOWLINGPOSITIONNO:(NSString*) N_BOWLEROVERS :(NSNumber*) N_BOWLERBALLS	:(NSString*) N_BOWLERPARTIALOVERBALLS :(NSNumber*) N_BOWLERMAIDENS:(NSNumber*) N_BOWLERRUNS:(NSNumber*) N_BOWLERWICKETS:(NSNumber*) N_BOWLERNOBALLS:(NSNumber*) N_BOWLERWIDES:(NSNumber*) N_BOWLERDOTBALLS:(NSNumber*) N_BOWLERFOURS:(NSNumber*) N_BOWLERSIXES:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BOWLERCODE;
//----------------------------------------------------------------------------------------------------------
//SP_DELETEENDINNINGS

-(NSString*) GetMatchTypeUsingCompetitionForDeleteEndInnings:(NSString*) COMPETITIONCODE;
-(BOOL) GetBallCodeForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO;
-(BOOL) GetInningsNoForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO;
-(BOOL) UpdateInningsEventForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO;
-(BOOL) DeleteInningsEventForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(BOOL) DeleteOverEventsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(BOOL) DeleteBowlerOverDetailsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(BOOL) DeleteSessionEventsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(NSString*) GetSessionNoForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO;
-(BOOL) DeleteSessionEventsInInningsEntryForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(BOOL) DeleteDayEventsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(NSString*) GetDayNoForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDINNINGSNO;
-(BOOL) DeleteDayEventsInInningsEntryForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(BOOL) DeletePenaltyDetailsForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO;
-(NSString*) GetInningsCountForDeleteEndInnings:(NSString*) MATCHCODE;
-(BOOL) UpdatematchRegistrationForDeleteEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
-(NSMutableArray *) GetInningsDetailsForDeleteEndInnings:(NSString*) MATCHCODE;

-(BOOL) GetSessionNoForDeleteEndInninges:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) OLDINNINGSNO;

-(NSNumber *) GetBowlerCountFormanageOverDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;

@end
