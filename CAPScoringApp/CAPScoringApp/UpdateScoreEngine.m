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
#import "EndInnings.h"
#import "InsertSEScoreEngine.h"

@implementation UpdateScoreEngine
@synthesize BALLCODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
//@synthesize TEAMCODE;
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

@synthesize BATSMANCODE;
@synthesize ISDELETE;


@synthesize F_BOWLEROVERS;
@synthesize F_BOWLERBALLS;
@synthesize F_BOWLERRUNS;
@synthesize F_BOWLERPARTIALOVERBALLS;
@synthesize F_BOWLERMAIDENS;
@synthesize F_BOWLERWICKETS;
@synthesize F_BOWLERNOBALLS;
@synthesize F_BOWLERWIDES;
@synthesize F_BOWLERDOTBALLS;
@synthesize F_BOWLERFOURS;
@synthesize F_BOWLERSIXES;

@synthesize OVERS;
@synthesize BALLS;
@synthesize PARTIALOVERBALLS;
@synthesize WICKETS;
@synthesize MAIDENS;
@synthesize NOBALLS;
@synthesize WIDES;
@synthesize DOTBALLS;
@synthesize FOURS;
@synthesize SIXES;

@synthesize U_BOWLEROVERS;
@synthesize U_BOWLERBALLS;
@synthesize U_BOWLERPARTIALOVERBALLS;
@synthesize U_BOWLERRUNS;
@synthesize U_BOWLERWICKETS;
@synthesize U_BOWLERNOBALLS;
@synthesize U_BOWLERWIDES;
@synthesize U_BOWLERDOTBALLS;
@synthesize U_BOWLERFOURS;
@synthesize U_BOWLERSIXES;
@synthesize BOWLERCOUNT;

@synthesize ISBALLEXISTS ;

@synthesize ISBOWLERCHANGED;

@synthesize SMAIDENOVER;
@synthesize ISWKTDTLSUPDATE ;

@synthesize BOWLEROVERBALLCNT;
@synthesize BOWLEROVERBALLCN;


@synthesize F_OVERNO;
@synthesize O_WICKETNO;
@synthesize U_BOWLERCODE;

@synthesize getPlayerArray;
@synthesize getOverArray;
@synthesize getBowlingArray;

EndInnings *insertScoreBoard;

-(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSString*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT:(NSString*)APPEALTYPECODE:
(NSString*)APPEALSYSTEMCODE:
(NSString*)APPEALCOMPONENTCODE:
(NSString*)APPEALUMPIRECODE:
(NSString*)APPEALBATSMANCODE:
(NSString*)APPEALISREFERRED:
(NSString*)APPEALDECISION:
(NSString*)APPEALCOMMENTS:
(NSString*)APPEALFIELDERCODE:
(NSString*)APPEALFLAG:
(NSString*)FIELDINGEVENTSFIELDERCODE:
(NSString*)FIELDINGEVENTSISSUBSTITUTE:
(NSString*)FIELDINGEVENTSFIELDINGFACTOR:
(NSString*)FIELDINGEVENTSNETRUNS:
(NSString*)FIELDINGEVENTSFLAG
{
  
    DBManagerEndBall *objDBManagerEndBall = [[DBManagerEndBall alloc]init];
    
   
    getDataArray = [[NSMutableArray alloc]init];
    
    
    getDataArray = [objDBManagerEndBall GetDataFromUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    if(getDataArray.count>0)
    {
        
        UpdateScoreEngineRecord *updateScoreEngRec = [getDataArray objectAtIndex:0];
        
        
        OLDISLEGALBALL= updateScoreEngRec.OLDISLEGALBALL;
        OLDBOWLERCODE=updateScoreEngRec.OLDBOWLERCODE;
        OLDSTRIKERCODE=updateScoreEngRec.OLDSTRIKERCODE;
        OLDNONSTRIKERCODE=updateScoreEngRec.OLDNONSTRIKERCODE;
        
        
    }
    
    BATTINGTEAMCODE = TEAMCODE;
    
    getBowlingArray = [[NSMutableArray alloc]init];
    getBowlingArray = [objDBManagerEndBall getBowlingTeamCode:COMPETITIONCODE :MATCHCODE :TEAMCODE];
    
    if (getBowlingArray.count>0) {
        
        UpdateScoreEngineRecord *bowlingCode = [getBowlingArray objectAtIndex:0];
        
        BOWLINGTEAMCODE = bowlingCode.BOWLINGTEAMCODE;
        
       // MATCHOVERS = bowlingCode.MATCHOVER;
    }

    
    F_ISWICKET = 0;
    F_ISWICKETCOUNTABLE = 0;
    F_WICKETTYPE = @"";
    
  
    
    
    F_ISWICKETCOUNTABLE = [ objDBManagerEndBall GetWicCountUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    F_ISWICKET = [ objDBManagerEndBall GetISWicCountUpdateScoreEngine :   MATCHCODE:COMPETITIONCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
    F_WICKETTYPE = [ objDBManagerEndBall GetWicTypeUpdateScoreEngine :  MATCHCODE:COMPETITIONCODE: TEAMCODE : INNINGSNO: BALLCODE ];
    
   
    if(ISWICKET.intValue == 1)
    {
        
        if([objDBManagerEndBall GetBallCodeExistsUpdateScoreEngine :  MATCHCODE: COMPETITIONCODE: TEAMCODE : INNINGSNO: BALLCODE ])
        {
           
                [objDBManagerEndBall UpdateWicEventsUpdateScoreEngine : WICKETTYPE :WICKETPLAYER:FIELDINGPLAYER:WICKETEVENT:  MATCHCODE:COMPETITIONCODE: TEAMCODE : INNINGSNO: BALLCODE ];
        }
        else
        {
            //: (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
            
                NSString *tempWickNo = [objDBManagerEndBall GetBallCodeExistsUpdateScoreEngine:  MATCHCODE: COMPETITIONCODE: TEAMCODE : INNINGSNO];

        [objDBManagerEndBall InsertWicEventsUpdateScoreEngine : tempWickNo:BALLCODE :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :ISWICKET :WICKETTYPE :WICKETPLAYER :FIELDINGPLAYER :WICKETEVENT];
            
        }
        
    }
        WICKETPLAYER =[ objDBManagerEndBall GetWicPlayersUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO : BALLCODE ];
        
       
        
        if(ISWICKETUNDO.intValue == 1)
        {
            WICKETNO = [ objDBManagerEndBall GetWicketNoUpdateScoreEngine : MATCHCODE: COMPETITIONCODE : TEAMCODE : INNINGSNO : BALLCODE];
            
            
            
            [objDBManagerEndBall DeleteWicket : COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
            
            [objDBManagerEndBall UpdateWicketEveUpdateScoreEngine:WICKETNO :MATCHCODE :COMPETITIONCODE :TEAMCODE :INNINGSNO];
            
            
        }

        //UPDATESCOREBOARD
        [self UpdateScoreBoard : BALLCODE :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : BOWLINGTEAMCODE : INNINGSNO : STRIKERCODE :ISFOUR : ISSIX : RUNS : OVERTHROW : ISWICKET : WICKETTYPE : WICKETPLAYER : BOWLERCODE : OVERNO : BALLNO : [NSNumber numberWithInt:0] : WIDE : NOBALL : BYES :LEGBYES : [NSNumber numberWithInt:0] : [NSNumber numberWithInt:0] : ISWICKETUNDO : F_ISWICKETCOUNTABLE : F_ISWICKET : F_WICKETTYPE];
    
    
     [objDBManagerEndBall UPDATEBALLEVENT :  BALLCODE:COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO:BALLNO:BALLCOUNT:SESSIONNO:STRIKERCODE:NONSTRIKERCODE:BOWLERCODE:WICKETKEEPERCODE:UMPIRE1CODE:UMPIRE2CODE:ATWOROTW:BOWLINGEN:BOWLTYPE:SHOTTYPE:SHOTTYPECATEGORY:ISLEGALBALL:ISFOUR:ISSIX:RUNS:OVERTHROW:TOTALRUNS:WIDE:NOBALL:BYES:LEGBYES:PENALTY:TOTALEXTRAS:GRANDTOTAL:RBW:PMLINECODE:PMLENGTHCODE:PMSTRIKEPOINT:PMSTRIKEPOINTLINECODE:PMX1:PMY1:PMX2:PMY2:PMX3:PMY3:WWREGION:WWX1:WWY1:WWX2:WWY2:BALLDURATION:ISAPPEAL:ISBEATEN:ISUNCOMFORT:ISWTB:ISRELEASESHOT:MARKEDFOREDIT:REMARKS:ISWICKET:WICKETTYPE:WICKETPLAYER:FIELDINGPLAYER:ISWICKETUNDO:AWARDEDTOTEAMCODE:PENALTYRUNS:PENALTYTYPECODE:PENALTYREASONCODE:BALLSPEED:UNCOMFORTCLASSIFCATION:WICKETEVENT: BOWLINGEND];
    InsertSEScoreEngine *objInsertSEScoreEngine = [[InsertSEScoreEngine alloc] init];
    if(![APPEALTYPECODE isEqualToString:@""] || [APPEALFLAG isEqualToString:@"D"])
        [objInsertSEScoreEngine InsertAppealEvents : BALLCODE : COMPETITIONCODE : MATCHCODE : TEAMCODE : [INNINGSNO integerValue] : APPEALTYPECODE : APPEALSYSTEMCODE : APPEALCOMPONENTCODE : APPEALUMPIRECODE : APPEALBATSMANCODE : APPEALISREFERRED : APPEALDECISION : APPEALCOMMENTS : APPEALFIELDERCODE : APPEALFLAG];
    if(![FIELDINGEVENTSFIELDINGFACTOR isEqualToString:@""] || [FIELDINGEVENTSFLAG isEqualToString:@"D"])
        [objInsertSEScoreEngine InsertFieldingEvents : COMPETITIONCODE : MATCHCODE : TEAMCODE : [INNINGSNO integerValue] : BALLCODE : FIELDINGEVENTSFIELDERCODE : FIELDINGEVENTSISSUBSTITUTE : FIELDINGEVENTSFIELDINGFACTOR : FIELDINGEVENTSNETRUNS : FIELDINGEVENTSFLAG];
    
    if( ![STRIKERCODE isEqual: OLDSTRIKERCODE] || ![NONSTRIKERCODE isEqual: OLDNONSTRIKERCODE])
    {
        [objDBManagerEndBall UpdateBattingOrderUpdateScoreEngine : MATCHCODE: TEAMCODE : INNINGSNO];
        
    }
    
    //Update Bowling Order sequence in Bowling Card when the bowler is changed or deleted.
    if (![BOWLERCODE isEqual: OLDBOWLERCODE]){
        [objDBManagerEndBall UpdateBowlingOrderUpdateScoreEngine: MATCHCODE :BOWLINGTEAMCODE : BATTINGTEAMCODE :INNINGSNO];
        
    }

   
    
    
    // Remove Unused Batsman from Batting Scorecard
    [objDBManagerEndBall DeleteRemoveUnusedBatFBSUpdateScoreEngine : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    // Remove Unused Bowler from Bowling Scorecard
    [objDBManagerEndBall DeleteRemoveUnusedBowFBSUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO : BOWLINGTEAMCODE];
    
    //PENALTY
    if(AWARDEDTOTEAMCODE.length > 0)
    {
        if([objDBManagerEndBall GetPenaltyBallCodeUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE])
        {
            [objDBManagerEndBall UpdatePenaltyScoreEngine:AWARDEDTOTEAMCODE :PENALTYRUNS :PENALTYTYPECODE :PENALTYREASONCODE :COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE ];
            
            
        }
        else
        {
            
            MAXID = [objDBManagerEndBall GetMaxidUpdateScoreEngine];
            
            //PENALTYCODE = 'PNT' + RIGHT(REPLICATE('0',7)+CAST(MAXID AS VARCHAR(7)),7);
            
            [objDBManagerEndBall InsertPenaltyScoreEngine:COMPETITIONCODE :MATCHCODE :INNINGSNO :BALLCODE :PENALTYCODE :AWARDEDTOTEAMCODE :PENALTYRUNS :PENALTYTYPECODE :PENALTYREASONCODE];
            
            
         
                
                //ADDING PENALTY RUNS FOR INNINGSSUMMARY (SCOREBOARD)
                if (BALLCODE == nil || [BALLCODE isEqualToString: @""]) {
                    
                    if ([objDBManagerEndBall getInningNo:COMPETITIONCODE :MATCHCODE :INNINGSNO]) {
                        
                        [objDBManagerEndBall UpdateInningsSummary:PENALTYRUNS :COMPETITIONCODE :MATCHCODE :INNINGSNO];
                        
                    }

                
            }
            
        }
        
    }
    
    
    if(OLDISLEGALBALL.intValue == 1 && ISLEGALBALL.intValue == 0)
    {
        [objDBManagerEndBall UpdateBallPlusoneScoreEngine:BALLCOUNT :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :OVERNO :BALLCODE];
        
        
        [objDBManagerEndBall UpdateBallMinusoneScoreEngine :COMPETITIONCODE :MATCHCODE:TEAMCODE:INNINGSNO:OVERNO:BALLNO];
        
        
        
        
    }
    else if(OLDISLEGALBALL.intValue == 0 && ISLEGALBALL.intValue == 1)
    {
        
        [objDBManagerEndBall LegalBallByOverNoUpdateScoreEngine:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : OVERNO :BALLNO];
        
        [objDBManagerEndBall LegalBallByOverNoUpdateScoreEngine :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO : OVERNO :BALLNO];
        
        
    }
    
    
    LASTBALLCODE = [objDBManagerEndBall LastBallCodeUPSE: MATCHCODE : INNINGSNO];
    if([BALLCODE isEqual: LASTBALLCODE])
    {
        
        OVERSTATUS =  [objDBManagerEndBall OverStatusUPSE:COMPETITIONCODE : MATCHCODE :INNINGSNO :OVERNO];
        
        CURRENTSTRIKERCODE = STRIKERCODE;
        CURRENTNONSTRIKERCODE = NONSTRIKERCODE;
        CURRENTBOWLERCODE = BOWLERCODE;
        
        int totalRuns = (TOTALRUNS.intValue + (WIDE.intValue > 0 ? WIDE.intValue-1 : WIDE.intValue) + (NOBALL.intValue > 0 ? NOBALL.intValue-1 : NOBALL.intValue) + LEGBYES.intValue + BYES.intValue + ((BYES.intValue > 0 || LEGBYES.intValue > 0) ? OVERTHROW.intValue : 0));
        
        T_TOTALRUNS = [NSNumber numberWithInt: totalRuns];
        
        
        if((T_TOTALRUNS.intValue % 2) == 0)
        {
            T_STRIKERCODE = (OVERSTATUS.intValue == 1) ? NONSTRIKERCODE : STRIKERCODE;
            T_NONSTRIKERCODE = (OVERSTATUS.intValue == 1) ? STRIKERCODE : NONSTRIKERCODE;
        }
        else
        {
            T_STRIKERCODE =  (OVERSTATUS.intValue == 1) ? STRIKERCODE : NONSTRIKERCODE;
            T_NONSTRIKERCODE = (OVERSTATUS.intValue == 1) ? NONSTRIKERCODE : STRIKERCODE;
        }
        
        [objDBManagerEndBall  InningEveUpdateScoreEngine:T_STRIKERCODE :T_NONSTRIKERCODE :COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
        
        
    }
    if(![objDBManagerEndBall BallCodeUPSE :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:OLDBOWLERCODE])
        
    {
        [objDBManagerEndBall DeleteOverDetailsUPSE:COMPETITIONCODE : MATCHCODE :INNINGSNO :OVERNO :OLDBOWLERCODE];
        
        OTHERBOWLEROVERBALLCNT = [objDBManagerEndBall OtherOverBallcntUPSE:  COMPETITIONCODE : MATCHCODE : INNINGSNO :OVERNO];
        
        
        [objDBManagerEndBall OtherBowlerUPSE :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO :BOWLERCODE];
        
        
        
        
        if (OTHERBOWLEROVERBALLCNT.intValue > 0)
        {
            
            
            ISMAIDENOVER =  [objDBManagerEndBall IsMaidenOverUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO];
            
            ISOVERCOMPLETE = [objDBManagerEndBall IsOverCompleteUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO];
            
            if(ISMAIDENOVER.intValue == 1 && ISOVERCOMPLETE.intValue == 1)
            {
                [objDBManagerEndBall BowMadienSummUPSE  :  COMPETITIONCODE :MATCHCODE:INNINGSNO:OVERNO:BOWLERCODE];
                
                U_BOWLERMAIDENS = [NSNumber numberWithInt: 1];
            }
            
            
            if(ISOVERCOMPLETE.intValue == 1)
            {
                [objDBManagerEndBall BowSummaryOverplusoneUPSE:OTHERBOWLEROVERBALLCNT :U_BOWLERMAIDENS :COMPETITIONCODE :MATCHCODE :BOWLINGTEAMCODE :INNINGSNO :OTHERBOWLER];
                
                
            }
            else
            {
                [objDBManagerEndBall BowSummaryUPSE:OTHERBOWLEROVERBALLCNT :U_BOWLERMAIDENS :COMPETITIONCODE :MATCHCODE :BOWLINGTEAMCODE :INNINGSNO :OTHERBOWLER];
                
                
                
            }
            
        }
        
        
    
        [objDBManagerEndBall UPDATEWICKETOVERNOUPSE : MATCHCODE :BATTINGTEAMCODE : INNINGSNO];
        
        
        
    }
    
}





// UPDATESCOREBOARD
-(void) UpdateScoreBoard:(NSString *) BALLCODE:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSNumber*)INNINGSNO :(NSString *)BATSMANCODE:(NSNumber *) ISFOUR:(NSNumber*)ISSIX:(NSNumber*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)ISWICKET :(NSString *)WICKETTYPE:(NSString *)WICKETPLAYER:(NSString*)BOWLERCODE:(NSString*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)WICKETSCORE :(NSNumber *)WIDE:(NSNumber *)NOBALL:(NSNumber*)BYES	:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)ISDELETE :(NSNumber *)ISWICKETUNDO:(NSNumber *)F_ISWICKETCOUNTABLE:(NSNumber*)F_ISWICKET :(NSNumber*)F_WICKETTYPE
{
    
    DBManagerEndBall *objDBManagerEndBall = [[DBManagerEndBall alloc]init];

    
    F_STRIKERCODE  = @"";
    F_BOWLERCODE  = @"";
    F_ISLEGALBALL  = [NSNumber numberWithInt:1];
    F_OVERS  = [NSNumber numberWithInt:0];
    F_BALLS = [NSNumber numberWithInt:0];
    F_RUNS  = [NSNumber numberWithInt:0];
    F_OVERTHROW  = [NSNumber numberWithInt:0];
    F_ISFOUR = [NSNumber numberWithInt:0];
    F_ISSIX  = [NSNumber numberWithInt:0];
    F_WIDE  = [NSNumber numberWithInt:0];
    F_NOBALL  = [NSNumber numberWithInt:0];
    F_BYES  = [NSNumber numberWithInt:0];
    F_LEGBYES  = [NSNumber numberWithInt:0];
    F_PENALTY  = [NSNumber numberWithInt:0];
    F_WICKETNO  = [NSNumber numberWithInt:0];
    F_WICKETPLAYER  = @"";
    F_FIELDINGPLAYER  = @"";
    
    
    
    
    getPlayerArray = [[NSMutableArray alloc]init];
    getPlayerArray = [objDBManagerEndBall SELECTALLUPSC : COMPETITIONCODE: MATCHCODE: BALLCODE ];
    
    if(getPlayerArray.count>0)
    {
        
        UpdateScoreEngine *updateScoreEngRec = [getPlayerArray objectAtIndex:0];
    
        F_STRIKERCODE = updateScoreEngRec.STRIKERCODE;
        F_BOWLERCODE = updateScoreEngRec.BOWLERCODE;
        F_ISLEGALBALL = updateScoreEngRec.ISLEGALBALL;
        F_OVERS = updateScoreEngRec.OVERNO;
        
        F_BALLS = updateScoreEngRec.BALLNO;
        F_RUNS  = updateScoreEngRec.RUNS;
        F_OVERTHROW = updateScoreEngRec.OVERTHROW;
        F_ISFOUR =  updateScoreEngRec.ISFOUR;
        F_ISSIX =  updateScoreEngRec.ISSIX;
        F_WIDE =   updateScoreEngRec.WIDE;
        F_NOBALL =   updateScoreEngRec.NOBALL;
        F_BYES =  updateScoreEngRec.BYES;
        F_LEGBYES  = updateScoreEngRec.LEGBYES;
        F_PENALTY = updateScoreEngRec.PENALTY;
        
    }
    
    
    
    [objDBManagerEndBall UPDATEBATTINGSUMMARYUPSC:F_WIDE :F_BYES :F_LEGBYES :F_RUNS :F_OVERTHROW :F_ISFOUR : F_ISSIX :COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :F_STRIKERCODE];
    

   int O_RUNSvalue = F_RUNS.intValue + F_OVERTHROW.intValue + F_BYES.intValue + F_LEGBYES.intValue + F_NOBALL.intValue + F_WIDE.intValue + F_PENALTY.intValue;
    
    int N_RUNSvalue= RUNS.intValue + OVERTHROW.intValue + BYES.intValue + LEGBYES.intValue + NOBALL.intValue + WIDE.intValue + PENALTY.intValue;
    
   
    O_RUNS = [NSString stringWithFormat:@"%d",O_RUNSvalue];
    N_RUNS = [NSString stringWithFormat:@"%d",N_RUNSvalue];
    
    if(![O_RUNS isEqual: N_RUNS])
    {
        [objDBManagerEndBall UPDATEBATTINGSUMBYINNUPSC:O_RUNS :N_RUNS :F_OVERS :F_BALLS :COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
    }
    
        [objDBManagerEndBall UPDATEINNINGSSUMMARYUPSC:F_NOBALL :F_BYES :F_NOBALL :F_LEGBYES :F_WIDE :F_PENALTY :F_RUNS :F_OVERTHROW :F_ISWICKET :F_WICKETTYPE :COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
        

    
    
    F_BOWLEROVERS = [NSNumber numberWithInt:0];
    F_BOWLERBALLS = [NSNumber numberWithInt:0];
    F_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt:0];
    F_BOWLERRUNS = [NSNumber numberWithInt:0];
    F_BOWLERMAIDENS = [NSNumber numberWithInt:0];
    F_BOWLERWICKETS = [NSNumber numberWithInt:0];
    F_BOWLERNOBALLS = [NSNumber numberWithInt:0];
    F_BOWLERWIDES = [NSNumber numberWithInt:0];
    F_BOWLERDOTBALLS = [NSNumber numberWithInt:0];
    F_BOWLERFOURS = [NSNumber numberWithInt:0];
    F_BOWLERSIXES = [NSNumber numberWithInt:0];
    
    
    
    
    getOverArray = [[NSMutableArray alloc]init];
    getOverArray = [objDBManagerEndBall SELECTINNBOWLEROVERSUPSC : COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO:BOWLERCODE ];
    if(getOverArray.count>0)
    {
        
        UpdateScoreEngine *updateScoreEngRec = [getOverArray objectAtIndex:0];
        
        F_BOWLEROVERS = updateScoreEngRec.OVERS;
        F_BOWLERBALLS = [NSNumber numberWithInt:updateScoreEngRec.BALLS.intValue];
        
        F_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt:updateScoreEngRec.PARTIALOVERBALLS.intValue];
        F_BOWLERRUNS = updateScoreEngRec.RUNS;
        
        F_BOWLERWICKETS = [NSNumber numberWithInt:updateScoreEngRec.WICKETS.intValue];
        F_BOWLERMAIDENS = [NSNumber numberWithInt:updateScoreEngRec.MAIDENS.intValue];
        F_BOWLERNOBALLS = [NSNumber numberWithInt:updateScoreEngRec.NOBALLS.intValue];
        F_BOWLERWIDES = [NSNumber numberWithInt:updateScoreEngRec.WIDES.intValue];
        
        F_BOWLERDOTBALLS = [NSNumber numberWithInt:updateScoreEngRec.DOTBALLS.intValue];
        F_BOWLERFOURS =  [NSNumber numberWithInt:updateScoreEngRec.FOURS.intValue];
        F_BOWLERSIXES = [NSNumber numberWithInt:updateScoreEngRec.SIXES.intValue];
        
    }
    
    
    
    U_BOWLEROVERS = [NSNumber numberWithInt:0];
    U_BOWLERBALLS = [NSNumber numberWithInt:0];
    U_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt:0];
    U_BOWLERRUNS = [NSNumber numberWithInt:0];
    U_BOWLERMAIDENS = F_BOWLERMAIDENS;
    U_BOWLERWICKETS = [NSNumber numberWithInt:0];
    U_BOWLERNOBALLS = [NSNumber numberWithInt:0];
    U_BOWLERWIDES = [NSNumber numberWithInt:0];
    U_BOWLERDOTBALLS = [NSNumber numberWithInt:0];
    U_BOWLERFOURS = [NSNumber numberWithInt:0];
    U_BOWLERSIXES = [NSNumber numberWithInt:0];
    
    BOWLERCOUNT = [NSNumber numberWithInt:0];
    
    //ISOVERCOMPLETE = [NSNumber numberWithInt:0];
    
    


    ISOVERCOMPLETE = [objDBManagerEndBall GETISOVERCOMPLETE : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:F_OVERS];
    
    
    BOWLERCOUNT  = [NSNumber numberWithInt:[objDBManagerEndBall GETBALLCOUNT : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO].intValue];
    
    ISBALLEXISTS = [NSNumber numberWithInt:0];
    
    ISBALLEXISTS = [objDBManagerEndBall ISBALLEXISTS : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO];
    
    
    
    ISBOWLERCHANGED = (![BOWLERCODE isEqualToString: F_BOWLERCODE]) ? @1 : @0;
    
    
    
    if([ISDELETE  isEqual: @1])
    {
        if(ISOVERCOMPLETE == 0 || BOWLERCOUNT.intValue > [NSNumber numberWithInt:1])
        {
            U_BOWLERBALLS = ((F_NOBALL == 0) && (F_WIDE == 0) && [BOWLERCOUNT  isEqual: @"1"]) ? [NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1 ]: F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = (F_NOBALL == 0  && F_WIDE == 0 && BOWLERCOUNT > 1) ? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) :[NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS]  ;
        }
        else
        {
            U_BOWLERBALLS = F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
        }
        
        
        U_BOWLEROVERS = ([ISBALLEXISTS  isEqual: @1]) ? F_BOWLEROVERS : ((F_BOWLEROVERS > 0 && [ISOVERCOMPLETE  isEqual: @1]) ? [NSNumber numberWithInt:F_BOWLEROVERS.intValue - 1] : F_BOWLEROVERS);
    }
    else
    {
        if(([ISBOWLERCHANGED  isEqual: @1]) || ((F_ISLEGALBALL.intValue == 1) && (NOBALL.intValue > 0 || WIDE.intValue > 0)))
        {
            U_BOWLERBALLS = (F_NOBALL.intValue  == 0 && (F_WIDE.intValue == 0) && [BOWLERCOUNT  isEqual: @1] && ISOVERCOMPLETE.intValue == 0) ? ([NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1]): F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = ([F_NOBALL  isEqual:@0] && [F_WIDE  isEqual: @0] && BOWLERCOUNT.intValue > 1)? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) : F_BOWLERPARTIALOVERBALLS ;
        }
        else
        {
            U_BOWLERBALLS = F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
        }
        U_BOWLEROVERS = F_BOWLEROVERS;
    }

    

    U_BOWLERRUNS = [NSNumber numberWithInt: ((F_BYES.intValue == 0) && (F_LEGBYES.intValue == 0))? (F_BOWLERRUNS.intValue - (F_RUNS.intValue + F_WIDE.intValue + F_NOBALL.intValue + (F_WIDE.intValue > 0 ? 0 : F_OVERTHROW.intValue ))): (F_BOWLERRUNS.intValue - (F_WIDE.intValue +F_NOBALL.intValue))];
                                                         
    
    
    U_BOWLERWICKETS = (F_ISWICKETCOUNTABLE.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERWICKETS.intValue - 1]) : F_BOWLERWICKETS;
    U_BOWLERNOBALLS = ( F_NOBALL.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERNOBALLS.intValue - 1]) : F_BOWLERNOBALLS ;
    U_BOWLERWIDES = (F_WIDE.intValue > 0) ? [NSNumber numberWithInt:F_BOWLERWIDES.intValue - 1]: F_BOWLERWIDES ;
    U_BOWLERDOTBALLS =((F_WIDE.intValue == 0) && (F_NOBALL.intValue == 0) && (F_RUNS.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERDOTBALLS.intValue - 1]) : F_BOWLERDOTBALLS;
    U_BOWLERFOURS = ((F_ISFOUR.intValue == 1) && (F_WIDE.intValue == 0) && (F_BYES.intValue == 0) && (F_LEGBYES.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERFOURS.intValue - 1]):[NSNumber numberWithInt:F_BOWLERFOURS.intValue ] ;
    U_BOWLERSIXES = (F_ISSIX.intValue == 1 && F_WIDE.intValue == 0 && F_BYES.intValue == 0 && F_LEGBYES.intValue == 0) ? [NSNumber numberWithInt:F_BOWLERSIXES.intValue - 1] : F_BOWLERSIXES;
    
 
   
    
    NSString *bCount = [objDBManagerEndBall BALLCOUNTUPSC : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:@"%@",F_OVERS]];
    
    NSNumber *ballCount = [NSNumber numberWithInt:bCount.intValue];
    
     ISMAIDENOVER = [NSNumber numberWithInt:0];
    
    if( ballCount.intValue  > 5)
    
    {
        
        ISMAIDENOVER = [objDBManagerEndBall SMAIDENOVER : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:@"%@",F_OVERS]:BALLCODE];
        
        ISMAIDENOVER = [NSNumber numberWithInt:(RUNS.intValue + (BYES.intValue == 0 && LEGBYES.intValue == 0 ? OVERTHROW.intValue : 0) + WIDE.intValue + NOBALL.intValue) > 0 ? 0 : ISMAIDENOVER.intValue];

        ISMAIDENOVER =  [NSNumber numberWithInt:BOWLERCOUNT.intValue > 1 || ISBOWLERCHANGED.intValue == 1 ? 0 : ISMAIDENOVER.intValue];
  
        
    }
    
    if([objDBManagerEndBall GETOVERS : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:@"%@",F_OVERS]])
    {
        if(ISMAIDENOVER.intValue == 0)
        {
            [objDBManagerEndBall DELBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:F_OVERS];
            U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue - 1];
        }
        
        
    }
        else
        {
            
            if (ISMAIDENOVER.intValue == 1 && ISOVERCOMPLETE.intValue == 1) {
                
                [objDBManagerEndBall INSERTBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:BOWLERCODE:F_OVERNO];
                U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue + 1];
            }
           
        }
    
    [objDBManagerEndBall UPDATEBOWLINGSUMMARY:U_BOWLEROVERS :U_BOWLERBALLS :U_BOWLERPARTIALOVERBALLS :U_BOWLERMAIDENS :U_BOWLERRUNS :U_BOWLERWICKETS :U_BOWLERNOBALLS :U_BOWLERWIDES :U_BOWLERDOTBALLS :U_BOWLERFOURS :U_BOWLERSIXES :COMPETITIONCODE :MATCHCODE :INNINGSNO :BOWLINGTEAMCODE :F_BOWLERCODE];
    
    
    
    
    if(ISWICKETUNDO.intValue == 1)
    {
        
        O_WICKETNO = [objDBManagerEndBall WICKETNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
    
    
    [objDBManagerEndBall UPDATEBATTINGSUMMARY : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
    [objDBManagerEndBall UPDATEBATTINGSUMMARYO_WICNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:O_WICKETNO];
        
    }
    
    
    ISWKTDTLSUPDATE = ((F_ISWICKET.intValue == 1) || (ISWICKET.intValue == 1)) ? @1 : @0;
    U_BOWLERCODE  = (BOWLERCODE != F_BOWLERCODE )? BOWLERCODE : F_BOWLERCODE ;
    
    BOWLEROVERBALLCNT = [NSNumber numberWithInt:0];
    
    BOWLEROVERBALLCNT = [objDBManagerEndBall BOWLEROVERBALLCNT : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO:F_BOWLERCODE];
    
    if(ISBOWLERCHANGED.intValue == 1)
    {
        if(![objDBManagerEndBall GETBOWLERCODE :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:OVERNO:BOWLERCODE] )
        {
           
            
            
            [objDBManagerEndBall INSERTBOWLEROVERDETAILS:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO :OVERNO :BOWLERCODE];
 
            [objDBManagerEndBall PARTIALUPDATEBOWLINGSUMMARY :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:BOWLERCODE];
            
        }
    }
        if((ISDELETE.intValue == 0) || (ISBOWLERCHANGED.intValue == 1))
        {
            
    
         
          insertScoreBoard = [[EndInnings alloc]init];
            
            insertScoreBoard.COMPETITIONCODE = COMPETITIONCODE;
            insertScoreBoard.MATCHCODE = MATCHCODE;
            insertScoreBoard.BATTINGTEAMCODE = BATTINGTEAMCODE;
            insertScoreBoard.INNINGSNO = INNINGSNO;
            insertScoreBoard.BATSMANCODE = BATSMANCODE;
            insertScoreBoard.ISFOUR = ISFOUR;
            insertScoreBoard.ISSIX = ISSIX;
            insertScoreBoard.RUNS = RUNS;
            insertScoreBoard.OVERTHROW = OVERTHROW;
            insertScoreBoard.ISWICKET = ISWICKET;
            insertScoreBoard.WICKETTYPE = WICKETTYPE;
            insertScoreBoard.WICKETPLAYER = WICKETPLAYER;
            insertScoreBoard.BOWLERCODE = U_BOWLERCODE;
            insertScoreBoard.OVERNO = OVERNO;
            insertScoreBoard.BALLNO = BALLNO;
            insertScoreBoard.WICKETSCORE = WICKETSCORE;
            insertScoreBoard.WIDE = WIDE;
            insertScoreBoard.NOBALL = NOBALL;
            insertScoreBoard.BYES = BYES;
            insertScoreBoard.LEGBYES = LEGBYES;
            insertScoreBoard.PENALTY = PENALTY;
            insertScoreBoard.ISWKTDTLSUPDATE = ISWKTDTLSUPDATE;
            insertScoreBoard.ISBOWLERCHANGED = ISBOWLERCHANGED;
            insertScoreBoard.ISUPDATE = [NSNumber numberWithInt:1];
            insertScoreBoard.O_ISLEGALBALL = F_ISLEGALBALL;
            insertScoreBoard.BOWLINGTEAMCODE = BOWLINGTEAMCODE;
            insertScoreBoard.WICKETOVERNO = OVERNO;
            insertScoreBoard.WICKETBALLNO = BALLNO;
           
         
          //  [insertScoreBoard insertScordBoard:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO];
            [insertScoreBoard insertScordBoard:COMPETITIONCODE :MATCHCODE :BATTINGTEAMCODE :INNINGSNO];
            
    
          
        
        }
    }








@end
