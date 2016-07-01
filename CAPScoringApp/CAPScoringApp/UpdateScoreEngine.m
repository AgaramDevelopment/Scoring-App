//
//  UpdateScoreEngine.m
//  CAPScoringApp
//
//  Created by mac on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "UpdateScoreEngine.h"
#import "DBManagerEndBall.h"

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




-(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSNumber*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT
{
  
    
    F_ISWICKET = 0;
    
    F_ISWICKETCOUNTABLE = 0;
    
    U_BOWLERMAIDENS = 0;
    
    
    
    
    getDataArray = [[NSMutableArray alloc]init];
    
    getDataArray = [DBManagerEndBall GetDataFromUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    if(getDataArray.count>0)
    {
        OLDISLEGALBALL=[getDataArray objectAtIndex:0];
        OLDBOWLERCODE=[getDataArray objectAtIndex:1];
        OLDSTRIKERCODE=[getDataArray objectAtIndex:2];
        OLDNONSTRIKERCODE=[getDataArray objectAtIndex:3];
        
        
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
        
       [DBManagerEndBall UpdateScoreBoard : BALLCODE :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : BOWLINGTEAMCODE : INNINGSNO : STRIKERCODE :ISFOUR : ISSIX : RUNS : OVERTHROW : ISWICKET : WICKETTYPE : WICKETPLAYER : BOWLERCODE : OVERNO : BALLNO : 0 : WIDE : NOBALL : BYES :LEGBYES : 0 : 0 : ISWICKETUNDO : F_ISWICKETCOUNTABLE : F_ISWICKET : F_WICKETTYPE];
    }
    
    if( STRIKERCODE != OLDSTRIKERCODE || NONSTRIKERCODE != OLDNONSTRIKERCODE)
    {
        [DBManagerEndBall UpdateBattingOrderUpdateScoreEngine : MATCHCODE: TEAMCODE : INNINGSNO];
        
        
        
        [DBManagerEndBall UpdateBowlingOrderUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO];
        
        
        
        [DBManagerEndBall DeleteRemoveUnusedBatFBSUpdateScoreEngine : COMPETITIONCODE : MATCHCODE:BOWLERCODE : TEAMCODE : INNINGSNO];
        
        [DBManagerEndBall DeleteRemoveUnusedBowFBSUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :BOWLERCODE :INNINGSNO];
        
        
        
        if(AWARDEDTOTEAMCODE.length > 0)
        {
            if([DBManagerEndBall GetPenaltyBallCodeUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :BALLCODE])
                
                
            {
                [DBManagerEndBall UpdatePenaltyScoreEngine : MATCHCODE :TEAMCODE : BALLCODE];
                
            }
            else
            {

             MAXID = [DBManagerEndBall GetMaxidUpdateScoreEngine];
                
               //PENALTYCODE = 'PNT' + RIGHT(REPLICATE('0',7)+CAST(MAXID AS VARCHAR(7)),7);
                
                [DBManagerEndBall InsertPenaltyScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE];
                
            }
            
            
            if (BALLCODE == nil || BALLCODE == @"" ) {
                
                if ([DBManagerEndBall getInningNo:COMPETITIONCODE :MATCHCODE :INNINGSNO]) {
                    
                    [DBManagerEndBall UpdateInningsSummary:PENALTYRUNS :COMPETITIONCODE :MATCHCODE :INNINGSNO];
                    
                }

          
                
            }
            if(OLDISLEGALBALL == 1 && ISLEGALBALL == 0)
            {
                [DBManagerEndBall UpdateBallPlusoneScoreEngine:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :BALLCODE];
                
                
                
                [DBManagerEndBall UpdateBallMinusoneScoreEngine :COMPETITIONCODE :MATCHCODE:TEAMCODE:INNINGSNO:BALLCODE];
                
                
            }
            else if(OLDISLEGALBALL == 0 && ISLEGALBALL == 1)
            {
                
            [DBManagerEndBall LegalBallByOverNoUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO];
                
            }
      
            
            LASTBALLCODE = [DBManagerEndBall LastBallCodeUPSE: MATCHCODE : INNINGSNO];
            if(BALLCODE = LASTBALLCODE)
            {
             
            OVERSTATUS =  [DBManagerEndBall OverStatusUPSE:COMPETITIONCODE : MATCHCODE :INNINGSNO :OVERNO];
                
                CURRENTSTRIKERCODE = STRIKERCODE;
                CURRENTNONSTRIKERCODE = NONSTRIKERCODE;
                CURRENTBOWLERCODE = BOWLERCODE;
                
                int totalRuns = (TOTALRUNS.intValue + (WIDE.intValue > 0 ? WIDE.intValue-1 : WIDE.intValue) + (NOBALL.intValue > 0 ? NOBALL.intValue-1 : NOBALL.intValue) + LEGBYES.intValue + BYES.intValue + ((BYES.intValue > 0 || LEGBYES.intValue > 0) ? OVERTHROW.intValue : 0));
                
              //  T_TOTALRUNS =
                
                
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
                
                [DBManagerEndBall  InningEveUpdateScoreEngine : COMPETITIONCODE : MATCHCODE];
                
            }
            if([DBManagerEndBall BallCodeUPSE :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:OLDBOWLERCODE])
                
            {
                [DBManagerEndBall DeleteOverDetailsUPSE:COMPETITIONCODE : MATCHCODE :INNINGSNO :OVERNO :OLDBOWLERCODE];
                NSString* OTHERBOWLEROVERBALLCNT = [[NSString alloc] init];
                [DBManagerEndBall OtherOverBallcntUPSE:  COMPETITIONCODE : MATCHCODE: INNINGSNO:OVERNO];
                
                NSString* OTHERBOWLER = [[NSString alloc] init];
                [DBManagerEndBall OtherOverBallcntUPSE :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO];
                
                
                
                if (OTHERBOWLEROVERBALLCNT > 0)
                {
        
                    [DBManagerEndBall IsMaidenOverUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                    
                    [DBManagerEndBall IsOverCompleteUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                }
                
              
                
                
                if(ISMAIDENOVER == @"1" && ISOVERCOMPLETE == 1)
                {
                    [DBManagerEndBall BowMadienSummUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                    U_BOWLERMAIDENS = @1;
                }
                if(ISOVERCOMPLETE == 1)
                {
                    [DBManagerEndBall BowSummaryOverplusoneUPSE  : COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO:OTHERBOWLER];
                    
                }
                else
                {
                    [DBManagerEndBall BowSummaryUPSE: COMPETITIONCODE :MATCHCODE :BOWLINGTEAMCODE :INNINGSNO : OTHERBOWLER];
                    
                }
                [DBManagerEndBall BowSummaryUPSE: COMPETITIONCODE :MATCHCODE :BOWLINGTEAMCODE :INNINGSNO : OTHERBOWLER];
            }		
        }
    }
}









@end
