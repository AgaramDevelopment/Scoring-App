//
//  UpdateScoreEngine.m
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "UpdateScoreEngine.h"
#import "DBManagerEndBall.h"
#import "UpdateScoreEngineRecord.h"

@implementation UpdateScoreEngine
@synthesize BALLCODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;

@synthesize OVERNO;
@synthesize BALLNO;
@synthesize BALLCOUNT;
@synthesize SESSIONNO;

@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize BOWLERCODE;
@synthesize WICKETKEEPERCODE;
@synthesize UMPIRE1CODE;
@synthesize UMPIRE2CODE;
@synthesize ATWOROTW;
@synthesize BOWLINGEND;
@synthesize BOWLTYPE;
@synthesize SHOTTYPE;
@synthesize SHOTTYPECATEGORY;
@synthesize ISLEGALBALL;
@synthesize ISFOUR;
@synthesize ISSIX;

@synthesize RUNS;
@synthesize OVERTHROW;
@synthesize TOTALRUNS;
@synthesize WIDE;
@synthesize NOBALL;
@synthesize BYES;
@synthesize LEGBYES;
@synthesize PENALTY;
@synthesize TOTALEXTRAS;
@synthesize GRANDTOTAL;
@synthesize RBW;

@synthesize PMLINECODE;
@synthesize PMLENGTHCODE;
@synthesize PMSTRIKEPOINT;
@synthesize PMSTRIKEPOINTLINECODE;

@synthesize PMX1;
@synthesize PMY1;
@synthesize PMX2;
@synthesize PMY2;
@synthesize PMX3;
@synthesize PMY3;

@synthesize WWREGION;

@synthesize WWX1;
@synthesize WWY1;
@synthesize WWX2;
@synthesize WWY2;
@synthesize BALLDURATION;

@synthesize ISAPPEAL;
@synthesize ISBEATEN;
@synthesize ISUNCOMFORT;
@synthesize ISWTB;
@synthesize ISRELEASESHOT;
@synthesize MARKEDFOREDIT;

@synthesize REMARKS;

@synthesize ISWICKET;

@synthesize WICKETTYPE;
@synthesize WICKETPLAYER;
@synthesize FIELDINGPLAYER	;

@synthesize ISWICKETUNDO;

@synthesize AWARDEDTOTEAMCODE;

@synthesize PENALTYRUNS;

@synthesize PENALTYTYPECODE;
@synthesize PENALTYREASONCODE;
@synthesize BALLSPEED;
@synthesize UNCOMFORTCLASSIFCATION;
@synthesize WICKETEVENT;



@synthesize BATTINGTEAMCODE;
@synthesize BOWLINGTEAMCODE;

@synthesize BATTEAMSHORTNAME;
@synthesize BOWLTEAMSHORTNAME;
@synthesize BATTEAMNAME;
@synthesize BOWLTEAMNAME;

@synthesize MATCHOVERS;

@synthesize BATTEAMLOGO;
@synthesize BOWLTEAMLOGO;
@synthesize MATCHTYPE;

@synthesize OLDISLEGALBALL;
@synthesize OLDBOWLERCODE;
@synthesize OLDSTRIKERCODE;
@synthesize OLDNONSTRIKERCODE;


@synthesize F_ISWICKET;
@synthesize F_ISWICKETCOUNTABLE;
@synthesize F_WICKETTYPE;
@synthesize WICKETNO;
@synthesize MAXID;
@synthesize PENALTYCODE;
@synthesize LASTBALLCODE;
@synthesize T_STRIKERCODE;
@synthesize T_NONSTRIKERCODE;
@synthesize T_TOTALRUNS;

@synthesize OTHERBOWLEROVERBALLCNT;
@synthesize OTHERBOWLER;
@synthesize U_BOWLERMAIDENS;
@synthesize ISMAIDENOVER;

@synthesize ISOVERCOMPLETE;

@synthesize OVERSTATUS;

@synthesize CURRENTSTRIKERCODE;
@synthesize CURRENTNONSTRIKERCODE;
@synthesize CURRENTBOWLERCODE;
@synthesize getDataArray;


//SCOREBOARD
@synthesize F_STRIKERCODE;
@synthesize F_BOWLERCODE;
@synthesize F_ISLEGALBALL;
@synthesize F_OVERS;
@synthesize F_BALLS;
@synthesize F_RUNS;
@synthesize F_OVERTHROW;
@synthesize F_ISFOUR;
@synthesize F_ISSIX;
@synthesize F_WIDE;
@synthesize F_NOBALL;
@synthesize F_BYES;
@synthesize F_LEGBYES;
@synthesize F_PENALTY;
@synthesize F_WICKETNO;
@synthesize F_WICKETPLAYER;
@synthesize F_FIELDINGPLAYER;

@synthesize N_RUNS;
@synthesize O_RUNS;



-(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT
{
  
    
    F_ISWICKET = 0;
    
    F_ISWICKETCOUNTABLE = 0;
    
    U_BOWLERMAIDENS = 0;
    
    
    
    
    getDataArray = [[NSMutableArray alloc]init];
    
    getDataArray = [DBManagerEndBall GetDataFromUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    if(getDataArray.count>0)
    {
        
        UpdateScoreEngineRecord *updateScoreEngRec = [getDataArray objectAtIndex:0];
        
        
        OLDISLEGALBALL= updateScoreEngRec.OLDISLEGALBALL;
        OLDBOWLERCODE=updateScoreEngRec.OLDBOWLERCODE;
        OLDSTRIKERCODE=updateScoreEngRec.OLDSTRIKERCODE;
        OLDNONSTRIKERCODE=updateScoreEngRec.OLDNONSTRIKERCODE;
        
        
    }
    
    BATTINGTEAMCODE = TEAMCODE;
    
    F_ISWICKETCOUNTABLE = [ DBManagerEndBall GetWicCountUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    F_ISWICKET = [ DBManagerEndBall GetISWicCountUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    F_WICKETTYPE = [ DBManagerEndBall GetWicTypeUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    if(ISWICKET.intValue == 1)
    {
        
        if([DBManagerEndBall GetBallCodeExistsUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ])
        {
            [DBManagerEndBall UpdateWicEventsUpdateScoreEngine : WICKETTYPE :WICKETPLAYER:FIELDINGPLAYER:WICKETEVENT:COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
        }
        else
        {
            
            WICKETNO = [DBManagerEndBall GetWicketNoUpdateScoreEngine :COMPETITIONCODE :MATCHCODE : TEAMCODE : INNINGSNO : BALLCODE];
            
          [DBManagerEndBall InsertWicEventsUpdateScoreEngine : WICKETNO :BALLCODE :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :ISWICKET :WICKETTYPE :WICKETPLAYER :FIELDINGPLAYER :WICKETEVENT];
            
       }
        
        WICKETPLAYER =[ DBManagerEndBall GetWicPlayersUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO : BALLCODE ];
        
        if(ISWICKETUNDO.intValue == 1)
        {
            WICKETNO = [ DBManagerEndBall GetWicketNoUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO : BALLCODE];
            
            
            
           [DBManagerEndBall DeleteWicket : COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
            
            [DBManagerEndBall UpdateWicketEveUpdateScoreEngine:WICKETNO :MATCHCODE :COMPETITIONCODE :TEAMCODE :INNINGSNO];
            
            
        }
        
        //UPDATESCOREBOARD
       [DBManagerEndBall UpdateScoreBoard : BALLCODE :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : BOWLINGTEAMCODE : INNINGSNO : STRIKERCODE :ISFOUR : ISSIX : RUNS : OVERTHROW : ISWICKET : WICKETTYPE : WICKETPLAYER : BOWLERCODE : OVERNO : BALLNO : 0 : WIDE : NOBALL : BYES :LEGBYES : 0 : 0 : ISWICKETUNDO : F_ISWICKETCOUNTABLE : F_ISWICKET : F_WICKETTYPE];
    }
    
    if( ![STRIKERCODE isEqual: OLDSTRIKERCODE] || ![NONSTRIKERCODE isEqual: OLDNONSTRIKERCODE])
    {
        [DBManagerEndBall UpdateBattingOrderUpdateScoreEngine : MATCHCODE: TEAMCODE : INNINGSNO];
        
    }
    
    //Update Bowling Order sequence in Bowling Card when the bowler is changed or deleted.
        if (![BOWLERCODE isEqual: OLDBOWLERCODE]){
        [DBManagerEndBall UpdateBowlingOrderUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    }
    
    [DBManagerEndBall UPDATEBALLEVENT :  BALLCODE:COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO:BALLNO:BALLCOUNT:SESSIONNO:STRIKERCODE:NONSTRIKERCODE:BOWLERCODE:WICKETKEEPERCODE:UMPIRE1CODE:UMPIRE2CODE:ATWOROTW:BOWLINGEN:BOWLTYPE:SHOTTYPE:SHOTTYPECATEGORY:ISLEGALBALL:ISFOUR:ISSIX:RUNS:OVERTHROW:TOTALRUNS:WIDE:NOBALL:BYES:LEGBYES:PENALTY:TOTALEXTRAS:GRANDTOTAL:RBW:PMLINECODE:PMLENGTHCODE:PMSTRIKEPOINT:PMSTRIKEPOINTLINECODE:PMX1:PMY1:PMX2:PMY2:PMX3:PMY3:WWREGION:WWX1:WWY1:WWX2:WWY2:BALLDURATION:ISAPPEAL:ISBEATEN:ISUNCOMFORT:ISWTB:ISRELEASESHOT:MARKEDFOREDIT:REMARKS:ISWICKET:WICKETTYPE:WICKETPLAYER:FIELDINGPLAYER:ISWICKETUNDO:AWARDEDTOTEAMCODE:PENALTYRUNS:PENALTYTYPECODE:PENALTYREASONCODE:BALLSPEED:UNCOMFORTCLASSIFCATION:WICKETEVENT: BOWLINGEND];
    
    
    // Remove Unused Batsman from Batting Scorecard
    [DBManagerEndBall DeleteRemoveUnusedBatFBSUpdateScoreEngine : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    // Remove Unused Bowler from Bowling Scorecard
    [DBManagerEndBall DeleteRemoveUnusedBowFBSUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO : BOWLINGTEAMCODE];
    
        if(AWARDEDTOTEAMCODE.length > 0)
        {
            if([DBManagerEndBall GetPenaltyBallCodeUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE])
            {
                [DBManagerEndBall UpdatePenaltyScoreEngine:AWARDEDTOTEAMCODE :PENALTYRUNS :PENALTYTYPECODE :PENALTYREASONCODE :COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE ];

                
            }
            else
            {

             MAXID = [DBManagerEndBall GetMaxidUpdateScoreEngine];
                
               //PENALTYCODE = 'PNT' + RIGHT(REPLICATE('0',7)+CAST(MAXID AS VARCHAR(7)),7);
                
                [DBManagerEndBall InsertPenaltyScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE :PENALTYCODE :AWARDEDTOTEAMCODE :PENALTYRUNS :PENALTYTYPECODE :PENALTYREASONCODE];
                
                
                //ADDING PENALTY RUNS FOR INNINGSSUMMARY (SCOREBOARD)
                if (BALLCODE == nil || [BALLCODE isEqualToString: @""]) {
                    
                    if ([DBManagerEndBall getInningNo:COMPETITIONCODE :MATCHCODE :INNINGSNO]) {
                        
                        [DBManagerEndBall UpdateInningsSummary:PENALTYRUNS :COMPETITIONCODE :MATCHCODE :INNINGSNO];
                        
                    }
                    
                    
                    
                }

            }
            
        }
    
            
            if(OLDISLEGALBALL.intValue == 1 && ISLEGALBALL.intValue == 0)
            {
                [DBManagerEndBall UpdateBallPlusoneScoreEngine:BALLCOUNT :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :OVERNO :BALLCODE];
                
          
                [DBManagerEndBall UpdateBallMinusoneScoreEngine :COMPETITIONCODE :MATCHCODE:TEAMCODE:INNINGSNO:OVERNO:BALLNO];
                
          
                
                
            }
            else if(OLDISLEGALBALL.intValue == 0 && ISLEGALBALL.intValue == 1)
            {
                
                [DBManagerEndBall LegalBallByOverNoUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : OVERNO :BALLNO];
        
                [DBManagerEndBall LegalBallByOverNoUpdateScoreEngine :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : OVERNO :BALLNO: BALLCOUNT];
            }
      
            
            LASTBALLCODE = [DBManagerEndBall LastBallCodeUPSE: MATCHCODE : INNINGSNO];
            if([BALLCODE isEqual: LASTBALLCODE])
            {
             
            OVERSTATUS =  [DBManagerEndBall OverStatusUPSE:COMPETITIONCODE : MATCHCODE :INNINGSNO :OVERNO];
                
                CURRENTSTRIKERCODE = STRIKERCODE;
                CURRENTNONSTRIKERCODE = NONSTRIKERCODE;
                CURRENTBOWLERCODE = BOWLERCODE;
                
                int totalRuns = (TOTALRUNS.intValue + (WIDE.intValue > 0 ? WIDE.intValue-1 : WIDE.intValue) + (NOBALL.intValue > 0 ? NOBALL.intValue-1 : NOBALL.intValue) + LEGBYES.intValue + BYES.intValue + ((BYES.intValue > 0 || LEGBYES.intValue > 0) ? OVERTHROW.intValue : 0));
                
                T_TOTALRUNS = [NSNumber numberWithInt: totalRuns];
                
                
                if((T_TOTALRUNS.intValue % 2) == 0)
                {
                    T_STRIKERCODE = OVERSTATUS = 1 ? NONSTRIKERCODE : STRIKERCODE;
                    T_NONSTRIKERCODE = OVERSTATUS = 1 ? STRIKERCODE : NONSTRIKERCODE;
                }
                else
                {
                    T_STRIKERCODE =  OVERSTATUS = 1 ? STRIKERCODE : NONSTRIKERCODE;
                    T_NONSTRIKERCODE = OVERSTATUS = 1 ? NONSTRIKERCODE : STRIKERCODE;
                }
                
                [DBManagerEndBall  InningEveUpdateScoreEngine:T_STRIKERCODE :T_NONSTRIKERCODE :COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
                
                
            }
            if(![DBManagerEndBall BallCodeUPSE :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:OLDBOWLERCODE])
                
            {
                [DBManagerEndBall DeleteOverDetailsUPSE:COMPETITIONCODE : MATCHCODE :INNINGSNO :OVERNO :OLDBOWLERCODE];

               OTHERBOWLEROVERBALLCNT = [DBManagerEndBall OtherOverBallcntUPSE:  COMPETITIONCODE : MATCHCODE : INNINGSNO :OVERNO];
                

                [DBManagerEndBall OtherBowlerUPSE :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO :BOWLERCODE];
      
                
                
                
                if (OTHERBOWLEROVERBALLCNT.intValue > 0)
                {
        
                 ISMAIDENOVER =  [DBManagerEndBall IsMaidenOverUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                    
                   ISOVERCOMPLETE = [DBManagerEndBall IsOverCompleteUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                    
                    if(ISMAIDENOVER.intValue == 1 && ISOVERCOMPLETE.intValue == 1)
                    {
                        [DBManagerEndBall BowMadienSummUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                        
                        U_BOWLERMAIDENS = [NSNumber numberWithInt: 1];
                    }
                    
                    
                    if(ISOVERCOMPLETE.intValue == 1)
                    {
                        [DBManagerEndBall BowSummaryOverplusoneUPSE:OTHERBOWLEROVERBALLCNT :U_BOWLERMAIDENS :COMPETITIONCODE :MATCHCODE :BOWLINGTEAMCODE :INNINGSNO :OTHERBOWLER];
                        
                        
                    }
                    else
                    {
                        [DBManagerEndBall BowSummaryUPSE:OTHERBOWLEROVERBALLCNT :U_BOWLERMAIDENS :COMPETITIONCODE :MATCHCODE :BOWLINGTEAMCODE :INNINGSNO :OTHERBOWLER];
                        
                        
                        
                    }
                    
                }
                
              
                
                
                
                [DBManagerEndBall UPDATEWICKETOVERNOUPSE : COMPETITIONCODE :MATCHCODE : INNINGSNO];
                
                
            		
        }
    
}



//-(void) UpdateScoreBoard:(NSString *) BALLCODE:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSNumber*)INNINGSNO :(NSString *)BATSMANCODE:(NSNumber *) ISFOUR:(NSNumber*)ISSIX:(NSNumber*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)ISWICKET :(NSString *)WICKETTYPE:(NSString *)WICKETPLAYER:(NSString*)BOWLERCODE:(NSString*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)WICKETSCORE :(NSNumber *)WIDE:(NSNumber *)NOBALL:(NSNumber*)BYES	:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)ISDELETE :(NSNumber *)ISWICKETUNDO:(NSNumber *)F_ISWICKETCOUNTABLE:(NSNumber*)F_ISWICKET :(NSNumber*)F_WICKETTYPE
//{
//    
//    
//    [DBManagerEndBall SELECTALLUPSC : COMPETITIONCODE: MATCHCODE: BALLCODE ];
//    
//    [DBManagerEndBall UPDATEBATTINGSUMMARYUPSC : COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO :F_STRIKERCODE ];
//    
//    
//    
//   int O_RUNSvalue = F_RUNS.intValue + F_OVERTHROW.intValue + F_BYES.intValue + F_LEGBYES.intValue + F_NOBALL.intValue + F_WIDE.intValue + F_PENALTY.intValue;
//    
//  int N_RUNSvalue= RUNS.intValue + OVERTHROW.intValue + BYES.intValue + LEGBYES.intValue + NOBALL.intValue + WIDE.intValue + PENALTY.intValue;
//    
//   
//    O_RUNS = [NSString stringWithFormat:@"%d",O_RUNSvalue];
//    N_RUNS = [NSString stringWithFormat:@"%d",N_RUNSvalue];
//    
//    if(O_RUNS != N_RUNS)
//    {
//        [DBManagerEndBall UPDATEBATTINGSUMBYINNUPSC : O_RUNS:N_RUNS:COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
//    }
//    else
//    {
//        //[DBManagerEndBall UPDATEINNINGSSUMMARYUPSC : COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
//        
//        [DBManagerEndBall UPDATEBATTINGSUMMARYUPSC:O_RUNS :N_RUNS :COMPETITIONCODE :MATCHCODE :INNINGSNO];
//    }
//    
//    NSNumber* F_BOWLEROVERS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERBALLS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERRUNS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERMAIDENS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERWICKETS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERNOBALLS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERWIDES = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERDOTBALLS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERFOURS = [[NSNumber alloc] init];
//    NSNumber* F_BOWLERSIXES = [[NSNumber alloc] init];
//    
//    
//    [DBManagerEndBall SELECTINNBOWLEROVERSUPSC : COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO:F_BOWLERCODE ];
//    
//    
//    NSNumber* U_BOWLEROVERS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERBALLS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERPARTIALOVERBALLS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERRUNS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERMAIDENS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERWICKETS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERNOBALLS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERWIDES = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERDOTBALLS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERFOURS = [[NSNumber alloc] init];
//    NSNumber* U_BOWLERSIXES = [[NSNumber alloc] init];
//    NSNumber* BOWLERCOUNT = [[NSNumber alloc] init];
//    NSNumber* ISOVERCOMPLETE = [[NSNumber alloc] init];
//    
//    
//    NSString * TEAMCODE;
//    NSString *F_OVERNO;
//    NSString *OVERS;
//    NSString *O_WICKETNO;
//    NSString * U_BOWLERCODE;
//    ISOVERCOMPLETE = [DBManagerEndBall GETISOVERCOMPLETE : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:F_OVERS ];
//    BOWLERCOUNT  = [DBManagerEndBall GETBALLCOUNT : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO ];
//    
//    NSNumber* ISBALLEXISTS ;
//    ISBALLEXISTS = [DBManagerEndBall ISBALLEXISTS : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO];
//    NSNumber* ISBOWLERCHANGED;
//    ISBOWLERCHANGED = (BOWLERCODE != F_BOWLERCODE) ? @1 : @0;
//    
//    NSNumber*F_BOWLERPARTIALOVERBALLS;
//    
//    if([ISDELETE  isEqual: @1])
//    {
//        if(ISOVERCOMPLETE == 0 || BOWLERCOUNT > [NSNumber numberWithInt:1])
//        {
//            U_BOWLERBALLS = ((F_NOBALL == 0) && (F_WIDE == 0) && [BOWLERCOUNT  isEqual: @"1"]) ? [NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1 ]: F_BOWLERBALLS;
//            U_BOWLERPARTIALOVERBALLS = (F_NOBALL == 0  && F_WIDE == 0 && BOWLERCOUNT > 1) ? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) :[NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS]  ;
//        }
//        else
//        {
//            U_BOWLERBALLS = F_BOWLERBALLS;
//            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
//        }
//        
//        
//        U_BOWLEROVERS = ([ISBALLEXISTS  isEqual: @1]) ? F_BOWLEROVERS : ((F_BOWLEROVERS > 0 && [ISOVERCOMPLETE  isEqual: @1]) ? [NSNumber numberWithInt:F_BOWLEROVERS.intValue - 1] : F_BOWLEROVERS);
//    }
//    else
//    {
//        if(([ISBOWLERCHANGED  isEqual: @1]) || (([F_ISLEGALBALL  isEqual: @1]) && (NOBALL > 0 || WIDE > 0)))
//        {
//            U_BOWLERBALLS = ([F_NOBALL  isEqual: @0] && ([F_WIDE  isEqual: @0]) && [BOWLERCOUNT  isEqual: @1] && [ISOVERCOMPLETE  isEqual: @0]) ? ([NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1]): F_BOWLERBALLS;
//            U_BOWLERPARTIALOVERBALLS = ([F_NOBALL  isEqual:@0] && [F_WIDE  isEqual: @0] && BOWLERCOUNT.intValue > 1)? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) : F_BOWLERPARTIALOVERBALLS ;
//        }
//        else
//        {
//            U_BOWLERBALLS = F_BOWLERBALLS;
//            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
//        }
//        U_BOWLEROVERS = F_BOWLEROVERS;
//    }
//    
//    U_BOWLERRUNS = ((F_BYES == 0) && (F_LEGBYES == 0))?([NSNumber numberWithInt:F_BOWLERRUNS.intValue -F_RUNS.intValue + F_WIDE.intValue + F_NOBALL.intValue +F_WIDE.intValue > 0]? 0 : F_OVERTHROW ): (([NSNumber numberWithInt:F_BOWLERRUNS.intValue -F_WIDE.intValue +F_NOBALL.intValue]));
//    U_BOWLERWICKETS = (F_ISWICKETCOUNTABLE.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERWICKETS.intValue - 1]) : F_BOWLERWICKETS;
//    U_BOWLERNOBALLS = ( F_NOBALL.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERNOBALLS.intValue - 1]) : F_BOWLERNOBALLS ;
//    U_BOWLERWIDES = (F_WIDE.intValue > 0) ? [NSNumber numberWithInt:F_BOWLERWIDES.intValue - 1]: F_BOWLERWIDES ;
//    U_BOWLERDOTBALLS =((F_WIDE.intValue == 0) && (F_NOBALL.intValue == 0) && (F_RUNS.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERDOTBALLS.intValue - 1]) : F_BOWLERDOTBALLS;
//    U_BOWLERFOURS = ((F_ISFOUR.intValue == 1) && (F_WIDE.intValue == 0) && (F_BYES.intValue == 0) && (F_LEGBYES.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERFOURS.intValue - 1]):[NSNumber numberWithInt:F_BOWLERFOURS.intValue ] ;
//    U_BOWLERSIXES = (F_ISSIX.intValue == 1 && F_WIDE.intValue == 0 && F_BYES.intValue == 0 && F_LEGBYES.intValue == 0) ? [NSNumber numberWithInt:F_BOWLERSIXES.intValue - 1] : F_BOWLERSIXES;
//    
//    NSNumber* ISMAIDENOVER ;
//    NSString *SMAIDENOVER;
//    
//    if(ISMAIDENOVER.intValue > 5)
//    {
//        [DBManagerEndBall BALLCOUNTUPSC : COMPETITIONCODE:MATCHCODE:INNINGSNO:F_OVERNO];
//    }
//    {
//        SMAIDENOVER = [DBManagerEndBall SMAIDENOVER : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:@"%@",F_OVERS]:BALLCODE];
//        
//    }
//    ISMAIDENOVER = (RUNS.intValue + (BYES.intValue == 0)  && (LEGBYES.intValue == 0)) ? OVERTHROW : 0; + (WIDE.intValue + NOBALL.intValue) > 0 ? 0 : ISMAIDENOVER ;
//    ISMAIDENOVER = ( BOWLERCOUNT.intValue > 1 || ISBOWLERCHANGED.intValue == 1) ? 0 : ISMAIDENOVER ;
//    if([DBManagerEndBall GETOVERS : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:OVERS]] !=0)
//    {
//        if(ISMAIDENOVER == 0)
//        {
//            [DBManagerEndBall DELBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO];
//        }
//        // U_BOWLERMAIDENS = F_BOWLERMAIDENS - 1;
//        else
//        {
//            [DBManagerEndBall INSERTBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:BOWLERCODE:F_OVERNO];
//            U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue + 1];
//        }
//        U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue - 1];
//    }
//    
//    //+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS;
//    
//    // [DBManagerEndBall GETOVERS: U_BOWLEROVERS:U_BOWLERBALLS:U_BOWLERPARTIALOVERBALLS:U_BOWLERMAIDENS:U_BOWLERRUNS:U_BOWLERWICKETS:U_BOWLERNOBALLS:U_BOWLERWIDES:U_BOWLERDOTBALLS:U_BOWLERFOURS:U_BOWLERSIXES];
//    
//    [DBManagerEndBall GETOVERS:COMPETITIONCODE :MATCHCODE :INNINGSNO :OVERS];
//    
//    
//    
//    if(ISWICKETUNDO.intValue == 1)
//    {
//        NSNumber* O_WICKETNO;
//        [DBManagerEndBall WICKETNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
//    }
//    
//    [DBManagerEndBall UPDATEBATTINGSUMMARY : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
//    [DBManagerEndBall UPDATEBATTINGSUMMARYO_WICNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:O_WICKETNO];
//    
//    NSNumber* ISWKTDTLSUPDATE ;
//    //NSNumber* U_BOWLERCODE ;
//    NSNumber* BOWLEROVERBALLCNT ;
//    NSNumber * BOWLEROVERBALLCN;
//    
//    
//    ISWKTDTLSUPDATE = ((F_ISWICKET.intValue == 1) || (ISWICKET.intValue == 1)) ? @1 : @0;
//    U_BOWLERCODE  = (BOWLERCODE != F_BOWLERCODE )? BOWLERCODE : F_BOWLERCODE ;
//    BOWLEROVERBALLCNT = 0;
//    
//    BOWLEROVERBALLCNT = [DBManagerEndBall BOWLEROVERBALLCNT : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO:F_BOWLERCODE];
//    if(ISBOWLERCHANGED.intValue == 1)
//    {
//        if(![DBManagerEndBall GETBOWLERCODE :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE] )
//        {
//            //[DBManagerEndBall INSERTBOWLEROVERDETAILS :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE];
//            [DBManagerEndBall PARTIALUPDATEBOWLINGSUMMARY :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:BOWLERCODE];
//            
//        }
//        
//        if((ISDELETE == 0) || (ISBOWLERCHANGED.intValue == 1))
//        {
//            //[DBManagerEndBall SP_INSERTSCOREBOARD:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:BOWLINGTEAMCODE:INNINGSNO:BATSMANCODE:ISFOUR:ISSIX:RUNS:OVERTHROW:ISWICKET:WICKETTYPE:WICKETPLAYER:U_BOWLERCODE:OVERNO:BALLNO:WICKETSCORE:WIDE:NOBALL:BYES:LEGBYES:PENALTY:ISWKTDTLSUPDATE:ISBOWLERCHANGED:1:F_ISLEGALBALL];
//        }
//    }
//}







@end
