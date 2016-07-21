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
#import "AddBreakVC.h"

@interface DBManager : NSObject
//tournament
+(NSMutableArray *)RetrieveEventData: (NSString *) userCode;
//login
+(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password;
+(BOOL)checkExpiryDate: (NSString *) userId;
+(BOOL)checkSecurityExpiryDate: (NSString *) USERCODE;
//toss details
+(NSMutableArray *)checkTossDetailsWonby: (NSString *) MATCHCODE;
+(NSMutableArray *)Electedto;
+(NSMutableArray *)StrikerNonstriker: (NSString *) MATCHCODE :(NSString *) TeamCODE;
+(NSMutableArray *)Bowler: (NSString *) MATCHCODE :(NSString *) TeamCODE;
+(NSMutableArray *)RetrieveFixturesData:(NSString*)competitionCode :(NSString*)userCode;

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

+ (NSString *) getballcodemethod :(NSString *)matchcode;
//+ (NSMutableArray *) getballcodemethod;
+ (NSMutableArray *) getTeamCodemethod;
+ (NSMutableArray *) getInningsNomethod;
+ (NSMutableArray *) getDayNomethod;


+(NSMutableArray *)AppealRetrieveEventData;
+(NSMutableArray *)getOtwRtw;

+(NSMutableArray *)GetBallDetails : (NSString *) MatchCode : (NSString *) CompetitionCode;


//toss proceed Save
+(NSString *) TossSaveDetails:(NSString *) MATCHCODE:(NSString *) COMPETITIONCODE;
+ (BOOL) insertMatchEvent :(NSString *) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) selectTeamcode :(NSString *) electedcode:(NSString*) teamCode:(NSString*)teambCode;

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
+(NSMutableArray *)RetrieveFieldingPlayerData : (NSString *) MATCHCODE : (NSString *) TEAMCODE ;


// playerOrderlevel
+(BOOL)updatePlayerorder:(NSString *) matchCode :(NSString *) teamcode PlayerCode:(NSString *)playerCode PlayerOrder:(NSString *)playerorder ;

+(NSMutableArray *)getTeamCaptainandTeamwicketkeeper:(NSString*) competitioncode :(NSString*) matchcode;

+(BOOL)updateCapitainWicketkeeper:(NSString *) compatitioncode :(NSString *) matchCode capitainAteam:(NSString *)capitainAteam capitainBteam:(NSString *)capitainBteam wicketkeeperAteam:(NSString *)wicketkeeperAteam  wicketkeeperBteam:(NSString *)wicketkeeperBteam;

//Wicket type
+(NSMutableArray *)RetrieveWicketType;
//+(NSMutableArray *)RetrievePlayerData;
+(NSMutableArray *)RetrievePlayerData: (NSString *) MATCHCODE :(NSString *) TeamCODE;




//Fetch SE on Page Load

+(NSString *)getComletedInnings:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE;
+(NSString *)getTotalBatTeamRuns:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE;
+(NSString *)getTOTALBOWLTEAMRUNS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BOWLINGTEAMCODE:(NSString *)BOWLINGTEAMCODE;
+(NSString *)getTEMPBOWLPENALTY:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BOWLINGTEAMCODE:(NSString *)BOWLINGTEAMCODE;
+(NSString *)getTEMPBATPENALTY:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO;
+(NSNumber *)getTARGETRUNS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO;

+(NSMutableArray *)getT_BOWLINGEND:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE LASTBALLCODE:(NSString *)LASTBALLCODE:(NSString*)BATTEAMOVERS;

+(NSNumber *)getNOBALL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO BATTEAMOVERS:(NSString *)BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:(NSString *)BATTEAMOVRWITHEXTRASBALLS;

+(NSMutableArray *)getBATSMANDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                          INNINGSNO:(NSString *)INNINGSNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE T_BOWLINGEND:(NSString *)T_BOWLINGEND;
+(NSNumber *)getBallEventCount:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO;
+(NSMutableArray *)getTotalRuns:(NSString *)LASTBALLCODE ;

+(NSMutableArray *) getWICKETPLAYER:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO;
+(NSNumber *) getSTRIKERBALLS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE STRIKERCODE:(NSString *)STRIKERCODE;
+(BOOL) hasSTRIKERBALLS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE STRIKERCODE:(NSString *)STRIKERCODE;
+(NSMutableArray *) getStrickerCode:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE STRIKERCODE:(NSString *)STRIKERCODE STRIKERBALLS:(NSString *)STRIKERBALLS;
+(NSMutableArray *) getStrickerDetails:(NSString *)STRIKERCODE;
+(NSNumber *) getBALLCODECOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE NONSTRIKERCODE:(NSString *)NONSTRIKERCODE;
+(NSString *) getLASTBOWLEROVERSTATUS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO;
+(NSNumber *) getLASTBOWLEROVERNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE BOWLERCODE:(NSString *)BOWLERCODE;
+(NSNumber *) getWicket:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE BOWLERCODE:(NSString *)BOWLERCODE;
+(NSNumber *) getMAXINNINGS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE;
+(NSNumber *) getMAXOVERNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE MAXINNINGS:(NSString *)MAXINNINGS;
+(NSNumber *) getMAXBALL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE MAXINNINGS:(NSString *)MAXINNINGS MAXOVER:(NSString *)MAXOVER;
+(NSNumber *) getBALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE MAXINNINGS:(NSString *)MAXINNINGS MAXOVER:(NSString *)MAXOVER MAXBALL:(NSString *)MAXBALL;
+(NSString *) getMATCHRESULTSTATUS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE;
+(BOOL) getSPINSPEEDBALLS;
+(BOOL) getUNCOMFORT;
+(BOOL) getFASTSPEEDBALLS;
+(BOOL) getTeamDetails:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE;
+(BOOL) getUmpireDetails;
+(NSMutableArray *)GetBallGridDetails: (NSString*) COMPETITIONCODE MATCHCODE: (NSString*) MATCHCODE ISINNINGSLASTOVER: (NSString*) ISINNINGSLASTOVER  TEAMCODE: (NSString*) TEAMCODE INNINGSNO: (NSString*) INNINGSNO ISOVERCOMPLETE : (NSString*) ISOVERCOMPLETE BATTEAMOVERS : (NSString*) BATTEAMOVERS;

+(NSNumber *) getLASTBOWLEROVERBALLNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE;

+(NSNumber *) getLASTBOWLEROVERBALLNOWITHEXTRAS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE;

+(NSNumber *) getLASTBOWLEROVERBALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:(NSString *)LASTBOWLEROVERBALLNOWITHEXTRAS;

+(NSString *) getS_ATWOROTW:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:(NSString *)LASTBOWLEROVERBALLNOWITHEXTRAS LASTBOWLEROVERBALLCOUNT:(NSString *)LASTBOWLEROVERBALLCOUNT;

+(NSNumber *) getISPARTIALOVER:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS;

+(NSNumber *) getISPARTIALOVERWHEN0:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BOWLERCODE:(NSString *)BOWLERCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS;

+(NSMutableArray *)getTOTALBALLSBOWL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE BOWLERCODE:(NSString *)BOWLERCODE;

+(NSNumber *) getBOWLERSPELL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BOWLERCODE:(NSString *)BOWLERCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS V_SPELLNO:(NSString *)V_SPELLNO;

+(BOOL)GETBOLWERDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BOWLERCODE:(NSString *)BOWLERCODE;

+(NSMutableArray *)GETBOLWLINGDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO  BOWLERCODE:(NSString *)BOWLERCODE BOWLERSPELL:(NSString *)BOWLERSPELL BOWLERRUNS:(NSString *)BOWLERRUNS S_ATWOROTW:(NSString *)S_ATWOROTW TOTALBALLSBOWL:(NSString *)TOTALBALLSBOWL WICKETS:(NSString *)WICKETS MAIDENS:(NSString *)MAIDENS ISPARTIALOVER:(NSString *)ISPARTIALOVER LASTBOWLEROVERBALLNO:(NSString *)LASTBOWLEROVERBALLNO;

+(NSMutableArray *)GETPLAYERDETAIL:(NSString *)BOWLERCODE;

+(BOOL)GETBALLDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO LASTBALLCODE:(NSString *)LASTBALLCODE  TEAMCODE:(NSString *)TEAMCODE BALLCODE:(NSString *)BALLCODE;
+(BOOL)GETUMPIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE TEAMCODE:(NSString *)TEAMCODE INNINGSNO:(NSString *)INNINGSNO  UMPIRE1CODE:(NSString *)UMPIRE1CODE ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE  UMPIRE2CODE:(NSString *)UMPIRE2CODE  LASTBALLCODE:(NSString *)BALLCODE;
+(NSMutableArray *)GETUMPIREBYMATCHREGISTRATION:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE UMPIRE1CODE:(NSString *)UMPIRE1CODE UMPIRE2CODE:(NSString *)UMPIRE2CODE ;


+(NSNumber *) getU_OVERNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO;


+(NSNumber *) getU_BALLNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO;


+(NSNumber *) getU_BALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO BALLNO:(NSString *)BALLNO;

+(NSNumber *) GETU_BALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO BALLNO:(NSString *)BALLNO;

+(BOOL)GETUMPIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BALLNO:(NSString *)BALLNO INNINGSNO:(NSString *)INNINGSNO  BALLCOUNT:(NSString *)BALLCOUNT  OVERNO:(NSString *)OVERNO ;

+(NSMutableArray *)GETUMBIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE UMPIRE1CODE:(NSString *)UMPIRE1CODE UMPIRE2CODE:(NSString *)UMPIRE2CODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO BALLNO:(NSString *)BALLNO BALLCOUNT:(NSString *)BALLCOUNT;


+(NSMutableArray *)GETMATCHUMPIREDETAILS:(NSString *)UMPIRE1CODE UMPIRE2CODE:(NSString *)UMPIRE2CODE;


+(NSNumber *) getISINNINGSLASTOVER:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO  ISINNINGSLASTOVER:(NSString *)ISINNINGSLASTOVER TEAMCODE:(NSString *)TEAMCODE;
+(NSMutableArray *)GETUMPIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO  UMPIRE1CODE:(NSString *)UMPIRE1CODE ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE  UMPIRE2CODE:(NSString *)UMPIRE2CODE  LASTBALLCODE:(NSString *)LASTBALLCODE ;

+(NSMutableArray *)getTeamCodeAndMatchOver:(NSString*) competitioncode :(NSString*) matchcode;
+(NSMutableArray *)getMatchTypeAndIso:(NSString*) competitioncode;
+(NSMutableArray *)getCountOver:(NSString*) competitioncode :(NSString*) matchcode;
+(NSMutableArray *)getInningsNo:(NSString*) competitioncode :(NSString*) matchcode;
+(NSString *)getBattingTeamCode:(NSString*) competitioncode :(NSString*) matchcode;
+(NSMutableArray *)getMaxInningsNo:(NSString*) competitioncode :(NSString*) matchcode;

+(NSMutableArray *)getTeamCode:(NSString*) competitioncode :(NSString*) matchcode :(NSString*)inningsNo;

+(NSMutableArray *)getDayNo:(NSString*) competitioncode :(NSString*) matchcode;
+(NSMutableArray *)getSessionNo:(NSString*) competitioncode :(NSString*) matchcode :(NSString*) dayNo;
+(NSMutableArray *)getInningsStatus:(NSString*) competitioncode :(NSString*) matchcode :(NSString*) inningsNo;
+(NSMutableArray *)getBowlteamCode:(NSString*) matchcode :(NSString*) competitioncode :(NSString *)teamAcode :(NSString *)teamBcode;
+(NSMutableArray *)getBattingTeamName:(NSString*)BATTINGTEAMCODE;
+(NSMutableArray *)getBowlingTeamName:(NSString*)BOWLINGTEAMCODE;
+(NSMutableArray *)getTargetRunsOvers:(NSString*)competitioncode:(NSString*)matchcode;
+(NSMutableArray *)getShotTypeCode;
+(NSMutableArray *)getBowlTypeCode;
+(NSString *) getFollowOn:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE:(NSString*)INNINGSNO;
+(NSString *) getPenalty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE;
+(NSString *) getPenaltyScore:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getGrandTotal:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO;
+(NSString *) getBatTeamPenalty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE;
+(NSString *) getPenaltyDetails:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getPenaltyDetailsBowling:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getPenaltyInnings:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getPenaltyInningsTwo:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getPenaltyInningsThree:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getBowlingPenaltyInnings:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE;
+(NSString *) getFollowOnFour:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;
+(NSString *) getBattingPenalty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE;
+(NSString *) getBowlPnty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO;
+(NSString *) getBattingWkt:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO;
+(NSString *) getTeamOver:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO;
+(NSString *) getTeamOverBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS;
+(NSString *) getTeamExtraBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS;
+(NSString *) getPrevOverBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS;
+(NSString *) getPrevOverExtBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS;
+(NSString *) getPrevOvrBallCnt:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)PREVOVRWITHEXTRASBALLS;
+(NSString *) getbatTeamOvrBallCnt:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)BATTEAMOVRWITHEXTRASBALLS;
+(NSString *) getOverNumber:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS;
+(NSString *) getOverNumberExits:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS;
+(NSString *) getLastBallCode:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)BATTEAMOVRWITHEXTRASBALLS:(NSString*)BATTEAMOVRBALLSCNT;

+(NSString *) getLastBallCodeMinus:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)PREVOVRWITHEXTRASBALLS:(NSString*)PREVOVRBALLSCNT;


+(BOOL)GETOVERNUMBERBYOVEREVENTS:(NSString *)COMPETITIONCODE :(NSString *)MATCHCODE :(NSString *)INNINGSNO  :(NSString *)BATTINGTEAMCODE :(NSString *)BATTEAMOVERS;

+(BOOL)GETOVERNUMBERBYOVERSTATUS0:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO  BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS;

+(NSString *) getPENULTIMATEBOWLERCODE:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE OVERNO:(NSString *)OVERNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE BATTEAMOVERS:(NSString *)BATTEAMOVERS;

+(NSMutableArray *)GETBOWLINGTEAMPLAYERS:(NSString *)PENULTIMATEBOWLERCODE MATCHCODE:(NSString *)MATCHCODE BOWLINGTEAMCODE:(NSString *)BOWLINGTEAMCODE COMPETITIONCODE:(NSString *)COMPETITIONCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE BATTEAMOVERS:(NSString *)BATTEAMOVERS;

+(NSString *) getLegalBall:(NSString*)LASTBALLCODE;



+(BOOL)getScoreingDetails:(NSString *)BATTEAMSHORTNAME BOWLTEAMSHORTNAME:(NSString *)BOWLTEAMSHORTNAME BATTEAMNAME:(NSString *)BATTEAMNAME BOWLTEAMNAME:(NSString *)BOWLTEAMNAME  BATTEAMLOGO:(NSString *)BATTEAMLOGO BOWLTEAMLOGO:(NSString *)BOWLTEAMLOGO BATTEAMRUNS:(NSString *)BATTEAMRUNS BATTEAMWICKETS:(NSString *)BATTEAMWICKETS ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE BATTEAMOVERS:(NSString *)BATTEAMOVERS BATTEAMOVRBALLS:(NSString *)BATTEAMOVRBALLS BATTEAMRUNRATE:(NSString *)BATTEAMRUNRATE TARGETRUNS:(NSString *)TARGETRUNS REQRUNRATE:(NSString *)REQRUNRATE  RUNSREQUIRED:(NSString *)RUNSREQUIRED REMBALLS:(NSString *)REMBALLS  ISPREVIOUSLEGALBALL:(NSString *)ISPREVIOUSLEGALBALL T_ATWOROTW:(NSString *)T_ATWOROTW T_BOWLINGEND:(NSString *)T_BOWLINGEND ISFREEHIT:(NSString *)ISFREEHIT ;


+(NSMutableArray *)FETCHSEALLINNINGSSCOREDETAILS:(NSString*)COMPETITIONCODE MATCHCODE:(NSString*)MATCHCODE;

+(NSMutableArray *)GETWICKETDETAILS:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE COMPETITIONCODE:(NSString *)COMPETITIONCODE INNINGSNO:(NSString *)INNINGSNO;

+(BOOL)GETFIELDINGEVENTSDETAILS:(NSString *)MATCHCODE TEAMCODE:(NSString *)TEAMCODE COMPETITIONCODE:(NSString *)COMPETITIONCODE;


+(BOOL)GETBOWLINGTEAMPLAYERS:(NSString *)MATCHCODE TEAMCODE:(NSString *)TEAMCODE;

+(BOOL)GETFIELDINGFACTORSDETAILS;

+(NSString *) batsManteamCode:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE;
+(NSString *) InningsNo:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE;


+(NSString *) inningsStatus:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE:(NSString*)INNINGSNO;
+(NSString *) sessionNo:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE:(NSString*)DAYNO;
+(NSString *) dayNO:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE;


//SP_INSERTBREAKS
+(BOOL) GetMatchCodeForInsertBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;


+(BOOL) GetCompetitionCodeForInsertBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) ISINCLUDEDURATION:(NSString*) BREAKNO:(NSString*) BREAKCOMMENTS;

+(BOOL) MatchCodeForInsertBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

+(BOOL) InsertInningsEvents:(NSString*) COMPETITIONCODE:(NSString*) INNINGSNO:(NSString*) MATCHCODE:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKCOMMENTS:(NSString*) BREAKNO:(NSString*) ISINCLUDEDURATION;

+(NSMutableArray *) GetBreakDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

+(NSString*) GetMaxBreakNoForInsertBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

//SP_UPDATEBREAKS



+(BOOL) GetMatchCodeForUpdateBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;

+(BOOL) GetCompetitionCodeForUpdateBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKCOMMENTS:(NSString*) ISINCLUDEDURATION:(NSString*) BREAKNO;

+(BOOL) GetBreakNoForUpdateBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKNO;

+(BOOL) UpdateInningsEvents:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKCOMMENTS:(NSString*) ISINCLUDEDURATION : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) INNINGSNO : (NSString*) BREAKNO;

+(NSMutableArray *) GetInningsBreakDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

+(NSString*) GetMaxBreakNoForUpdateBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

//SP_DELETEBREAKS
+(BOOL) GetCompetitionCodeForDeleteBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKNO;

+(BOOL) DeleteInningsEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO : (NSString*) BREAKNO;

+(NSMutableArray*) InningsBreakDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

+(NSString*) GetMaxBreakNoForDeleteBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

+(void ) InsertBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:
(NSString*)COMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO;

+(void) DeleteBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)COMMENTS:(NSString*)BREAKNO;





//-------------------------------------------------------------------------------------------------------

+(BOOL) updateBOWLERCODE:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
               INNINGSNO:(NSString *)INNINGSNO BOWLERCODE:(NSString *)BOWLERCODE;

+(BOOL) updateNONSTRIKERCODE:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                   INNINGSNO:(NSString *)INNINGSNO NONSTRIKERCODE:(NSString *)NONSTRIKERCODE;
+(BOOL) updateStricker:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             INNINGSNO:(NSString *)INNINGSNO STRIKERCODE:(NSString *)STRIKERCODE;
    
    +(BOOL) swapStrickerAndNonStricker:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
INNINGSNO:(NSString *)INNINGSNO STRIKERCODE:(NSString *)STRIKERCODE NONSTRIKERCODE:(NSString *)NONSTRIKERCODE;

+(NSString*) getLastBowlerCode:(NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO BALLNO: (NSString*) BALLNO BALLCOUNT: (NSString*) BALLCOUNT;
    
    +(NSString*) getBallCount:(NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO BALLNO: (NSString*) BALLNO;
        
        +(NSString*) getBallNO:(NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO;




//---------------------------------------------------------------------------------------------------------------------------------------
//SP_INITIALIZEINNINGSSCOREBOARD

// Delete Batting Summary
+(BOOL) deleteBattingSummary: (NSString *) COMPETITIONCODE  MATCHCODE :(NSString *) MATCHCODE
                            INNINGSNO : (NSNumber *) INNINGSNO;

+(BOOL) deleteInningsSummary:(NSString *) COMPETITIONCODE MATCHCODE:(NSString *) MATCHCODE
                   INNINGSNO:(NSNumber *) INNINGSNO;

+(BOOL) deleteBowlingSummary: (NSString *) COMPETITIONCODE MATCHCODE:(NSString *) MATCHCODE
                   INNINGSNO: (NSNumber *) INNINGSNO;
+(BOOL) insertBattingSummary:(NSString *) COMPETITIONCODE MATCHCODE:(NSString *) MATCHCODE
             BATTINGTEAMCODE:(NSString *) BATTINGTEAMCODE
                   INNINGSNO:(NSNumber *) INNINGSNO
                 STRIKERCODE:(NSString *) STRIKERCODE;

+(BOOL) insertBattingSummaryNonStricker:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                        BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                              INNINGSNO:(NSNumber *)INNINGSNO
                         NONSTRIKERCODE:(NSString *)NONSTRIKERCODE;

+(BOOL) insertInningsSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                   INNINGSNO:(NSNumber *)INNINGSNO;

+(BOOL) insertBowlingSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                   INNINGSNO:(NSNumber *)INNINGSNO
                  BOWLERCODE:(NSString *)BOWLERCODE;


//--------------------------------------------------------------------------------------------------------------------------------------
//SP_SBUPDATEPLAYERS

+(BOOL)  GetBallCodeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO;

+(BOOL)  GetWicketTypeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO;

+(BOOL) DeleteBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO;

+(BOOL)  DeleteBowlingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BOWLINGTEAMCODE :(NSString*) INNINGSNO;

+(BOOL) GetStrikerDetailBallCodeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO : (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE;


+(NSString*) GetStrikerDetailsBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO;

+(BOOL)  InsertBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO :(NSString*) STRIKERPOSITIONNO : (NSString*) STRIKERCODE;


+(BOOL)  GetBatsmanCodeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE;



+(BOOL ) UpdateBattingSummaryInStrickerDetailsForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE;


+(BOOL )  GetBatsmanCodeInUpdateBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE;

+(BOOL) UpdateBattingSummaryAndWicketEventInStrickerDetailsForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*)
                                                                  MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE;

+(BOOL) UpdateInningsEventsForPlayers:(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO;

+(BOOL) InsertBowlingSummaryForPlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) BOWLERPOSITIONNO:(NSString*) BOWLERCODE;


+(NSString *) GetBowlerDetailsForBowlingSummary:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO;

+(BOOL) GetBowlerDetailsForBallCode:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) BOWLERCODE;

+(BOOL) InsertBattingSummaryForPlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) NONSTRIKERPOSITIONNO:(NSString*) NONSTRIKERCODE;

+(NSString*) GetNonStrikerDetailsForBattingSummary:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO;


+(BOOL) GetNonStrikerDetailsForBallCode:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) NONSTRIKERCODE;

+(NSMutableArray *)GetBolwerDetailsonEdit:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) INNINGSNO;






//Revised overs
+(NSMutableArray *) RetrieveRevisedOverData:(NSString*)matchcode competitionCode:(NSString*) competitionCode recordstatus:(NSString*) recordstatus;
+(BOOL)updateRevisedOvers:(NSString*)overs comments:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode ;


//Revised Target
+(BOOL)updateRevisedTarget:(NSString*)overs runs:(NSString*)runs comments:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode;

+(NSMutableArray *) RetrieveRevisedTargetData:(NSString*)matchcode competitionCode:(NSString*) competitionCode;
+(NSNumber *) SetMatchRegistrationTarget:(NSString*)matchcode competitionCode:(NSString*) competitionCode;

+ (NSMutableArray *)getBowlerOversorder :(NSString *) Competitioncode :(NSString *) Matchcode :(NSString *) inningsno;

//penality
+(NSMutableArray *) GetPenaltyReasonForPenalty:(NSString*)metadatatypecode;
+(BOOL) SetPenaltyDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BALLCODE:(NSString*) PENALTYCODE:(NSString*) AWARDEDTOTEAMCODE:(NSString*) PENALTYRUNS:(NSString*) PENALTYTYPECODE:(NSString*) PENALTYREASONCODE;
+(NSMutableArray *) GetPenaltyDetailsForPageLoadPenalty:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;
+(NSMutableArray *) SetPenaltyDetailsForInsert:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;
+(NSMutableArray *) GetPenaltyDetailsForUpdate:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PENALTYCODE;
+(BOOL) GetUpdatePenaltyDetails:(NSString*) AWARDEDTOTEAMCODE:(NSNumber*) PENALTYRUNS:(NSString*) PENALTYTYPECODE :(NSString*) PENALTYREASONCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) PENALTYCODE;

+(NSString *) getMAXIDPENALTY;


//powerplay
+(BOOL) SetPowerPlayDetails:(NSString*) POWERPLAYCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) STARTOVER:(NSString*) ENDOVER:(NSString*) POWERPLAYTYPE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;

+(NSMutableArray *)fetchpowerplaytype;
+(NSMutableArray *) SetPowerPlayDetailsForInsert:(NSString*) MATCHCODE:(NSString*) INNINGSNO;

+(BOOL) UpdatePowerPlay:(NSString*) INNINGSNO:(NSString*) STARTOVER:(NSString*) ENDOVER:(NSString*) MATCHDATE:(NSString*)POWERPLAYTYPE:(NSString*) RECORDSTATUS:(NSString*) MODIFIEDBY:(NSString*) POWERPLAYCODE:(NSString*) MATCHCODE;
+(NSNumber *) SetMatchRegistration:(NSString*) MATCHCODE;
+(NSString *) getMAXIDPOWERPLAY;
//NEW
+(BOOL)checkpowerplay: (NSString *) STARTOVER ENDOVER:(NSString*) ENDOVER MATCHCODE:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO;
+(BOOL)getpowerplaytype:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYTYPE:(NSString*) POWERPLAYTYPE;

//+(NSMutableArray *)getpowerplaytype: (NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYTYPE:(NSString*) POWERPLAYTYPE;

+(BOOL)checkpowerplayforupdate: (NSString *) STARTOVER ENDOVER:(NSString*) ENDOVER MATCHCODE:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYCODE:(NSString*) POWERPLAYCODE;

+(NSMutableArray *)getpowerplaytypeforupdate:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYTYPE:(NSString*) POWERPLAYTYPE POWERPLAYCODE:(NSString*) POWERPLAYCODE;


// END OVER STATUS

//get overStatus

+ (NSString *)GETOVERSTATUS :(NSString *) Competitioncode :(NSString *) MatchCode :(NSString *) Teamcode :(NSString *)Inningsno :(NSString *) Overno;

+(NSMutableArray *)GETUMPIRE :(NSString *)Competitioncode :(NSString *) MatchCode;

+(NSMutableArray *)getMatchType :(NSString*)competitioncode :(NSString*)matchcode;


+(NSMutableArray *) getPlayedPlayersForPlayerXI:(NSString*)MATCHCODE COMPETITIOMCODE:(NSString*) COMPETITIOMCODE  OVERNO:(NSString*) OVERNO BALLNO:(NSString*) BALLNO;

+(NSMutableArray *) ArchivesFixturesData:(NSString*)competitionCode;



@end
