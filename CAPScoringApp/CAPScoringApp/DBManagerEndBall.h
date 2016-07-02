//
//  DBManagerEndBall.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerEndBall : NSObject
{
    NSNumber* F_BOWLEROVERS ;
    NSNumber* F_BOWLERBALLS ;
    NSNumber* F_BOWLERRUNS ;
    NSNumber* F_BOWLERMAIDENS ;
    NSNumber* F_BOWLERWICKETS ;
    NSNumber* F_BOWLERNOBALLS ;
    NSNumber* F_BOWLERWIDES ;
    NSNumber* F_BOWLERDOTBALLS ;
    NSNumber* F_BOWLERFOURS ;
    NSNumber* F_BOWLERSIXES ;
    
    
    NSNumber* U_BOWLEROVERS;
    NSNumber* U_BOWLERBALLS ;
    NSNumber* U_BOWLERPARTIALOVERBALLS ;
    NSNumber* F_BOWLERPARTIALOVERBALLS;
    NSNumber* U_BOWLERRUNS ;
    NSNumber* U_BOWLERMAIDENS ;
    NSNumber* U_BOWLERWICKETS ;
    NSNumber* U_BOWLERNOBALLS ;
    NSNumber* U_BOWLERWIDES ;
    NSNumber* U_BOWLERDOTBALLS ;
    NSNumber* U_BOWLERFOURS ;
    NSNumber* U_BOWLERSIXES ;
    NSNumber* BOWLERCOUNT ;
    NSNumber* ISOVERCOMPLETE ;
    

    
    
    NSString* SCRIPT_DATA ;
    
    NSString* F_STRIKERCODE ;
    NSString* F_BOWLERCODE ;
    NSNumber* F_ISLEGALBALL ;
    NSNumber* F_OVERS ;
    NSNumber* F_BALLS ;
    NSNumber* F_RUNS ;
    NSNumber* F_OVERTHROW ;
    NSNumber* F_ISFOUR ;
    NSNumber* F_ISSIX ;
    NSNumber* F_WIDE ;
    NSNumber* F_NOBALL ;
    NSNumber* F_BYES ;
    NSNumber* F_LEGBYES ;
    NSNumber* F_PENALTY ;
    NSNumber* F_WICKETNO ;
    NSString* F_WICKETPLAYER ;
    NSString* F_FIELDINGPLAYER ;
    
    
    
    NSString* O_RUNS;
    NSString* N_RUNS ;
    
    NSString * TEAMCODE;
    NSString *F_OVERNO;
    NSString *OVERS;
    NSString *O_WICKETNO;
    NSString * U_BOWLERCODE;
}



@property(strong,nonatomic)NSString *BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE;
@property(strong,nonatomic)NSString *BATTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BOWLTEAMSHORTNAME;
@property(strong,nonatomic)NSString *BATTEAMNAME;
@property(strong,nonatomic)NSString* BOWLTEAMNAME;
@property(strong,nonatomic)NSNumber* MATCHOVERS;
@property(strong,nonatomic)NSString* BATTEAMLOGO;
@property(strong,nonatomic)NSString* BOWLTEAMLOGO;
@property(strong,nonatomic)NSString* MATCHTYPE;
@property(strong,nonatomic)NSNumber* OLDISLEGALBALL;
@property(strong,nonatomic)NSString* OLDBOWLERCODE;
@property(strong,nonatomic)NSString* OLDSTRIKERCODE;
@property(strong,nonatomic)NSString* OLDNONSTRIKERCODE;


+(NSString*) SELECTALLUPSC :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BALLCODE;
+(BOOL)   UPDATEBATTINGSUMMARYUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_STRIKERCODE;
+(BOOL)   UPDATEBATTINGSUMBYINNUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO;
+(BOOL)  UPDATEINNINGSSUMMARYUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO;
+(NSString*) SELECTINNBOWLEROVERSUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BOWLINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  F_BOWLERCODE ;
+(NSString*) GETISOVERCOMPLETE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  F_OVERS;
+(NSString*) GETBALLCOUNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS;
+(NSString*)  ISBALLEXISTS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS;
+(NSString*) BALLCOUNTUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO :(NSString*)  F_OVERS;
+(NSString*) SMAIDENOVER : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO :(NSString*)  F_OVERS :(NSString*) BALLCODE;
+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS;
+(BOOL)   DELBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS;
+(BOOL)   INSERTBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSString*) BOWLERCODE:(NSString*)  F_OVERS;
+(BOOL)   UPDATEBOWLINGSUMMARY : (NSString*) U_BOWLEROVERS :(NSString*) U_BOWLERBALLS : (NSString*) U_BOWLERPARTIALOVERBALLS :(NSString*) U_BOWLERMAIDENS :(NSString*) U_BOWLERRUNS :(NSString*) U_BOWLERWICKETS :(NSString*) U_BOWLERNOBALLS :(NSString*) U_BOWLERWIDES :(NSString*) U_BOWLERDOTBALLS :(NSString*) U_BOWLERFOURS :(NSString*) U_BOWLERSIXES :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSString*) BOWLINGTEAMCODE:(NSNumber*)  F_BOWLERCODE;
+(NSString*) WICKETNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*)  WICKETPLAYER;
+(BOOL)   UPDATEBATTINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER;
+(BOOL)   UPDATEBATTINGSUMMARYO_WICNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO : (NSString*) O_WICKETNO;
+(NSString*) BOWLEROVERBALLCNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSNumber*)  OVERNO:(NSString*) F_BOWLERCODE;
+(NSString*) GETBOWLERCODE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:  (NSString*) BATTINGTEAMCODE:(NSString*) TEAMCODE :(NSNumber*)  INNINGSNO :(NSNumber*)  OVERNO:(NSString*) BOWLERCODE;
//+(BOOL)   INSERTBOWLEROVERDETAILS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO : (NSNumber*) OVERNO :(NSString*) BOWLERCODE;
+(BOOL)   PARTIALUPDATEBOWLINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO :(NSString*) BOWLERCODE;


+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS;
+(BOOL)INSERTBOWLEROVERDETAILS : (NSString*)COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSNumber*) OVERNO :(NSString*) BOWLERCODE;







//2 sp_update

+(NSMutableArray*) GetDataFromUpdateScoreEngine: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;
+(NSString*) GetBowlingTeamCodeUpdateScoreEngine : (NSNumber*) COMPETITIONCODE: (NSNumber*) MATCHCODE:(NSNumber*) BATTINGTEAMCODE:(NSNumber*) MATCHOVERS;
+(NSString*) GetWicCountUpdateScoreEngine :  (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;

+(NSString*) GetISWicCountUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;

+(NSString*) GetWicTypeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;

+(BOOL) GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;

+(BOOL)  UpdateWicEventsUpdateScoreEngine : (NSString*) WICKETTYPE:(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT:(NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;

+(NSString*) GetWicNoUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;


+(BOOL)   InsertWicEventsUpdateScoreEngine :  (NSString*) WICKETNO: (NSString*) BALLCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSNumber*) ISWICKET:(NSString*) WICKETTYPE :(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT;

+(NSString*) GetWicPlayersUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;


+(NSString*) GetWicketNoUpdateScoreEngine :  (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;

+(BOOL) DeleteWicketUpdateScoreEngine :  (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE :(NSNumber*) INNINGSNO;

+(NSString*) GetBallCodeUpdateScoreEngine :  (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;

+(BOOL)   UpdateWicketEveUpdateScoreEngine :  (NSNumber*) WICKETNO: (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;


//Update Batting  sequence in Batting Card when the batsman is changed or deleted.

+(BOOL) UpdateBattingOrderUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO;

//Update Bowling Order sequence in Bowling Card when the bowler is changed or deleted.
+(BOOL)  UpdateBowlingOrderUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE
:(NSString*) INNINGSNO;


//Remove Unused Batsman from Batting Scorecard
+(BOOL)  DeleteRemoveUnusedBatFBSUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO;

//Remove Unused Bowler from Bowling Scorecard
+(BOOL)  DeleteRemoveUnusedBowFBSUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)INNINGSNO : (NSString*) BOWLINGTEAMCODE;

//PENALTY
+(BOOL)  GetPenaltyBallCodeUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSString*) BALLCODE;

//UpdatePenalty
+(BOOL)  UpdatePenaltyScoreEngine : (NSString*)AWARDEDTOTEAMCODE : (NSString*)PENALTYRUNS: (NSString*)PENALTYTYPECODE: (NSString*) PENALTYREASONCODE : (NSString*)COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BALLCODE;


//MaxID
+(NSString*) GetMaxidUpdateScoreEngine;
//insertPENALTYDETAILS




+(BOOL)  InsertPenaltyScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE :(NSString*) PENALTYCODE : (NSString *) AWARDEDTOTEAMCODE : (NSString *) PENALTYRUNS : (NSString *) PENALTYTYPECODE : (NSString *) PENALTYREASONCODE;
//UpdateBallEvents
+(BOOL)  UpdateBallPlusoneScoreEngine :(NSString*) BALLCNT: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO:(NSString*)OVERNO:(NSString*) BALLCODE;

//UpdateBallMinusone
+(BOOL)  UpdateBallMinusoneScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO:(NSString*) OVERNO :(NSString*) BALLNO;

//(ILLEGAL BALL -> LEGAL BALL) = INCREMENT BALL NO FOR FURTHER DELIVERY OF THAT OVER
+(BOOL)  LegalBallByOverNoUpdateScoreEngine : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE :(NSString*) INNINGSNO : (NSString*)OVERNO : (NSString*)BALLNO;


//(ILLEGAL BALL -> LEGAL BALL) = INCREMENT BALL NO FOR FURTHER DELIVERY OF THAT OVER
+(BOOL)  LegalBallCountUpdateScoreEngine : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSString*) INNINGSNO;

//LastBallCode
+(NSString*) LastBallCodeUPSE :  (NSString*) MATCHCODE:(NSNumber*) INNINGSNO;

+(NSString*) OverStatusUPSE :  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO  :(NSString*) OVERNO;
//INNINGSEVENTS
+(BOOL)  InningEveUpdateScoreEngine : (NSString*) T_STRIKERCODE: (NSString*) T_NONSTRIKERCODE: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSString *) INNINGSNO;


+(BOOL)  BallCodeUPSE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE;





+(BOOL)  DeleteOverDetailsUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE ;

+(BOOL)DeleteWicket : (NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) TEAMCODE :(NSString*)INNINGSNO :(NSString*)BALLCODE;

+(NSString*) OtherOverBallcntUPSE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO;

+(NSString*) OtherBowlerUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE ;
+(NSString*) IsMaidenOverUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE ;
+(NSString*) IsOverCompleteUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE ;
+(BOOL)  BowMadienSummUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE :(NSString*) OVERNO ;

+(BOOL)  BowSummaryOverplusoneUPSE : (NSString*) OTHERBOWLEROVERBALLCNT : (NSString*) BOWLERMAIDEN : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER;

+(BOOL)  BowSummaryUPSE : (NSString*)OTHERBOWLEROVERBALLCNT: (NSString*)U_BOWLERMAIDENS:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER;

+(BOOL)  UPDATEWICKETOVERNOUPSE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO ;


+(void) UpdateScoreBoard:(NSString *) BALLCODE:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSNumber*)INNINGSNO :(NSString *)BATSMANCODE:(NSNumber *) ISFOUR:(NSNumber*)ISSIX:(NSNumber*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)ISWICKET :(NSString *)WICKETTYPE:(NSString *)WICKETPLAYER:(NSString*)BOWLERCODE:(NSString*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)WICKETSCORE :(NSNumber *)WIDE:(NSNumber *)NOBALL:(NSNumber*)BYES	:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)ISDELETE :(NSNumber *)ISWICKETUNDO:(NSNumber *)F_ISWICKETCOUNTABLE:(NSNumber*)F_ISWICKET :(NSNumber*)F_WICKETTYPE;


+(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSNumber*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString *)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEND:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT;

+(BOOL)  getInningNo : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO;
+(BOOL)  UpdateInningsSummary : (NSString*) PENALTYRUNS:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*)INNINGSNO;

@end
