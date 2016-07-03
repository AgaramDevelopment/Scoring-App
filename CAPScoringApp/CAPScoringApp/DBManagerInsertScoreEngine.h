//
//  DBManagerInsertScoreEngine.h
//  CAPScoringApp
//
//  Created by Stephen on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetPlayerDetail.h"
#import "InsertSEScoreEngineRecord.h"

@interface DBManagerInsertScoreEngine : NSObject

+(NSString*) GetBallCodeForInsertScoreEngine:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL)  UpdateMatchStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE;

+(NSNumber*) GetBallCountForInsertScoreEngine:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSNumber*) INNINGSNO : (NSNumber*) OVERNO:(NSNumber*) BALLNO;

+(NSString*) GetBallCodesForInsertScoreEngine:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSNumber*) INNINGSNO : (NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT;

+(NSString*) GetMaxIdForInsertScoreEngine:(NSString*) MATCHCODE;

+(NSMutableArray*) GetInsertTypeGreaterthanZeroDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BALLCODE ;

+(BOOL)  UpdateBallEventtableForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO;

+(BOOL)  UpdateBallEventtablesForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO:(NSNumber*) T_BALLCOUNT;

+(BOOL)  UpdateBallEventtablesInAddBallNoForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO:(NSNumber*) T_BALLCOUNT;

+(BOOL)  InsertBallEventForInsertScoreEngine:(NSNumber*) BALLCODENO: (NSNumber*) N_BALLNO: (NSNumber*) N_BALLCOUNT: (NSNumber*) BALLSPEED: (NSNumber*) UNCOMFORTCLASSIFCATION:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) BALLCODE;


+(BOOL)  UpdateOverBallCountInBallEventtForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) T_OVERNO;

+(BOOL)  UpdateBEForInsertScoreEngine:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO : (NSNumber*) T_OVERNO;

+(NSString*) GetmaxPenaltyIdForInsertScoreEngine;

+(BOOL)  InsertPenaltyDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO : (NSNumber*) BALLCODENO : (NSNumber*) PENALTYCODE: (NSNumber*) AWARDEDTOTEAMCODE: (NSNumber*) PENALTYRUNS: (NSNumber*) PENALTYTYPECODE: (NSNumber*) PENALTYREASONCODE;

+(NSString*) GetPrevoiusBallCodeForInsertScoreEngine : (NSNumber*) OVERNO: (NSNumber*) BALLNO:(NSNumber*) BALLCOUNT : (NSString*) MATCHCODE : (NSString*) INNINGSNO;

+(NSNumber*) GetBallcodeInBallEventForInsertScoreEngine : (NSString*) PREVIOUSBALLCODE: (NSString*) BOWLERCODE;

+(NSString*) GetPrevoiusBowlerCodeForInsertScoreEngine : (NSString*) PREVIOUSBALLCODE;

+(BOOL)  UpdateBolwerOverDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSString*) INNINGSNO : (NSNumber*) OVERNO : (NSString*) PREVIOUSBOWLERCODE;

+(BOOL)  UpdateBolwlingSummaryForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) INNINGSNO : (NSString*) PREVIOUSBOWLERCODE;


+(BOOL)  InsertBowlerOverDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO: (NSNumber*) OVERNO: (NSString*) BOWLERCODE;

+(NSNumber*) GetBallCodeForUpdateBowlerOverDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) OVERNO;

+(BOOL)  UpdateBowlerDetailsForInsertScoreEngine:(NSString*) BOWLERCODE:  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO: (NSNumber*) OVERNO;

+(NSNumber*) GetOverBallCountForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO:  (NSNumber*) OVERNO;


+(BOOL) InsertBallEventsForInsertScoreEngine : (NSNumber*) BALLCODENO :  (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) DAYNO : (NSNumber*) OVERNO :  (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT : (NSNumber*) OVERBALLCOUNT : (NSString*) SESSIONNO : (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE :  (NSString*) BOWLERCODE : (NSString*) WICKETKEEPERCODE : (NSString*) UMPIRE1CODE : (NSString*) UMPIRE2CODE : (NSString*) ATWOROTW:(NSString*) BOWLINGEND :  (NSString*) BOWLTYPE : (NSString*) SHOTTYPE : (NSString*) SHOTTYPECATEGORY : (NSNumber*) ISLEGALBALL : (NSNumber*) ISFOUR : (NSNumber*) ISSIX :  (NSNumber*) RUNS : (NSNumber*) OVERTHROW :  (NSNumber*) TOTALRUNS : (NSNumber*) WIDE: (NSNumber*) NOBALL : (NSString*) BYES:  (NSString*) LEGBYES: (NSNumber*) PENALTY: (NSNumber*) TOTALEXTRAS : (NSNumber*) GRANDTOTAL: (NSNumber*) RBW:(NSString*) PMLINECODE:  (NSString*) PMLENGTHCODE: (NSNumber*) PMSTRIKEPOINT: (NSString*) PMSTRIKEPOINTLINECODE : (NSNumber*) PMX1: (NSNumber*) PMY1:(NSNumber*) PMX2:  (NSNumber*) PMY2: (NSNumber*) PMX3: (NSNumber*) PMY3 : (NSNumber*) WWREGION: (NSNumber*) WWX1:(NSNumber*) WWY1:  (NSNumber*) WWX2: (NSNumber*) WWY2: (NSString*) BALLDURATION : (NSString*) ISAPPEAL: (NSString*) ISBEATEN:(NSString*) ISUNCOMFORT:  (NSString*) ISWTB: (NSString*) ISRELEASESHOT: (NSString*) MARKEDFOREDIT : (NSString*) REMARKS: (NSString*) VIDEOFILENAME: (NSString*) BALLSPEED:  (NSString*) UNCOMFORTCLASSIFCATION;


+(BOOL)  UpdateInningsEventEventsForInsertScoreEngine:(NSString*) T_STRIKERCODE:(NSString*) T_NONSTRIKERCODE: (NSString*) BOWLERCODE:   (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO;

+(BOOL)  InsertWicketEventsForInsertScoreEngine:(NSNumber*) BALLCODENO: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO:(NSString*) ISWICKET :(NSString*) WICKETTYPE :(NSString*) WICKETPLAYER :(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT;


+(NSString*) GetmatchtypeForInsertScoreEngine : (NSString*) COMPETITIONCODE;

+(NSString*) GetInningsStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) INNINGSNO;


+(NSMutableArray*) GetBattingShortnameForInsertScoreEngine: (NSString*) BATTINGTEAMCODE;


+(NSMutableArray*) GetBowlingShortnameForInsertScoreEngine: (NSString*) BOWLINGTEAMCODE;

+(NSMutableArray*) GettargetDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE ;

+(NSMutableArray*) GetmatchDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE ;

+(NSMutableArray*) GetBowltypeDetailsForInsertScoreEngine;

+(NSMutableArray*) GetShotTypeDetailsForInsertScoreEngine;

+(NSMutableArray*) GetRowNumberForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO ;


+(NSMutableArray*) GetPlayerDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO ;


+(NSNumber*) GetIsFollowOnForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSNumber*) GetIsFollowOnInElseIfForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSString*) GetTeamTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE;

+(NSString*) GetTeamTeampenaltyInelseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE;


+(NSNumber * ) GetbatTeamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE;


+(NSNumber * ) GetbatTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE;

+(NSNumber * ) GetbatTeampenaltyInElseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE;

+(NSNumber * ) GetBowlingTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BOWLINGTEAMCODE;


+(NSNumber * ) GetBowlingTeampenaltyInElseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BOWLINGTEAMCODE;


+(NSNumber*) GetIsFollowOnDetailForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSNumber*) GetBattingTeampenaltysForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;


+(NSNumber*) GetBattingTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;


+(NSNumber*) GetBowlTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO :  (NSString*) BOWLINGTEAMCODE;


+(NSNumber*) GetBattingTeampenaltyInn4ForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE;


+(NSNumber * ) GetbatTeampenaltyInn4InElseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE;


+(NSNumber * ) GetBowlingTeampenaltyInn4ForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BOWLINGTEAMCODE;


+(NSNumber * ) GetBatTeamWicketForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO;


+(NSNumber * ) GetBatTeamOverForInsertScoreEngine: (NSNumber*) BALLCODENO;


+(NSNumber * ) GetBatTeamOverBallForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS;


+(NSNumber * ) GetBatTeamOverWithExtraBallForInsertScoreEngine:  (NSNumber*) BALLCODENO;

+(NSNumber * ) GetBatTeamOverWithExtraBallCountForInsertScoreEngine:  (NSNumber*) BALLCODENO;


+(NSNumber * ) GetIslegalBallCountForInsertScoreEngine:  (NSNumber*) LASTBALLCODE;


+(NSNumber * ) GetOverNoForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) BATTEAMOVERS;

+(NSNumber * ) GetOverNosForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) BATTEAMOVERS;


+(NSString * ) GetBowlerCodeForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) ISOVERCOMPLETE :(NSString*) BATTEAMOVERS;



+(NSMutableArray * ) GetBowlingTeamPlayersForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) ISOVERCOMPLETE :(NSString*) BATTEAMOVERS;


+(NSNumber * ) GetCompletedInningsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE;

+(NSNumber * ) GetTotalBatteamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE;

+(NSNumber * ) GetTotalBowlteamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BOWLINGTEAMCODE;

+(NSNumber * ) GetTempBowlPenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BOWLINGTEAMCODE;

+(NSNumber * ) GetTempBatTeamPenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE;

+(NSNumber * ) GetgrandtotalForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*)TEMPBATPENALTY;

+(NSMutableArray*) GetLastBallATWOROTWForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) ISOVERCOMPLETE:(NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*)LASTBALLCODE ;

+(NSNumber * ) GetNoBallForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) BATTEAMOVERS  :(NSString*)BATTEAMOVRWITHEXTRASBALLS;


+(NSMutableArray*) GetWicketPlayerAndTypeForInsertScoreEngine: (NSString*) LASTBALLCODE;


+(NSMutableArray*) GetStrickerNonStrickerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO;


+(NSString * ) GetWicketplayerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;

+(NSString * ) GetWicketplayerInNonStrickerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;


+(NSString * ) GetStrickerBallsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE  ;


+(NSString * ) GetStrickerCodeForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE  ;


+(NSMutableArray*) GetBallEventForInsertScoreEngine: (NSString*) STRIKERBALLS : (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE  ;


+(NSMutableArray*) GetPlayermasterForInsertScoreEngine: (NSString*) STRIKERCODE ;

+(NSString * ) GetNonStrickerCodeForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) NONSTRIKERCODE  ;


+(NSString * ) GetStrickerCodeforNonStrickerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) NONSTRIKERCODESTRIKERCODE  ;

+(NSMutableArray*) GetBallEventforNonstrickerForInsertScoreEngine: (NSString*) NONSTRIKERBALLS : (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) NONSTRIKERCODE  ;


+(NSMutableArray*) GetPlayermasterInNonStrickerForInsertScoreEngine: (NSString*) NONSTRIKERCODE ;


+(NSMutableArray*) GetpartneShiprunsandBallsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) STRIKERCODE   :(NSString*) NONSTRIKERCODE;


+(NSString * ) GetBowlerCodeforassignForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) BATTEAMOVERS: (NSString*) BATTEAMOVRWITHEXTRASBALLS: (NSString*) BATTEAMOVRWITHEXTRASBALLCOUNT  ;



+(NSString * ) GetWicketForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) BOWLERCODE;

+(NSNumber * ) GetLastBowlerOverNoForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) BOWLERCODE  ;

+(NSNumber * ) GetLastBowlerOverStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO  ;

+(NSNumber * ) GetLastBowlerOverBallNoStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE;
;
+(NSNumber * ) GetLASTBOWLEROVERBALLNOWITHEXTRASForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE;

+(NSNumber * ) GetLASTBOWLEROVERBALLCOUNTForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE :(NSNumber*) LASTBOWLEROVERBALLNOWITHEXTRAS;

+(NSNumber * ) GetATWOROTWForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE :(NSNumber*) LASTBOWLEROVERBALLNOWITHEXTRAS: (NSNumber*) LASTBOWLEROVERBALLCOUNT;


+(NSNumber * ) GetISPARTIALOVERForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSString*) BOWLERCODE:(NSString*) BATTEAMOVERS ;

+(NSNumber * ) GetISPARTIALOVERInBowlForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSString*) BOWLERCODE:(NSString*) BATTEAMOVERS ;

+(NSMutableArray*) GetTotalBallsBowlForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) STRIKERCODE   :(NSString*) NONSTRIKERCODE;


+(NSString*) GetBOWLERSPELLForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BOWLERCODE   :(NSString*) NONSTRIKERCODE;


+(NSMutableArray*) GetBowlerDetailsForInsertScoreEngine:(NSNumber*) ISPARTIALOVER :(NSNumber*)   LASTBOWLEROVERBALLNO : (NSNumber*)  BOWLERSPELL :(NSNumber*)  BOWLERRUNS :(NSNumber*)  S_ATWOROTW :(NSNumber*)  MAIDENS :(NSNumber*)  WICKETS :(NSNumber*) TOTALBALLSBOWL : (NSNumber*) LASTBOWLEROVERBALLNO:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BOWLERCODE;

+(NSNumber * ) GetOverNoInBowlForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSString*) BALLCODENO;

+(NSNumber * ) GetISINNINGSLASTOVERForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSNumber*) OVERNO;

+(NSMutableArray*) GetTeamDetailsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE;

+(NSMutableArray*) GetUmpireDetailsForInsertScoreEngine;

+(NSMutableArray*) GetFieldingEventDetailsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) BOWLINGTEAMCODE ;


+(BOOL)  UpdateBSForInsertScoreEngine:  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO;

+(NSMutableArray*) GetBallDetailsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSNumber*) CURRENTOVER;



@end
