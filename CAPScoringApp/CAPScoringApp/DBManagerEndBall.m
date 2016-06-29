//
//  DBManagerEndBall.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerEndBall.h"
#import "UpdateScoreEngineRecord.h"

@implementation DBManagerEndBall
//SP_UPDATESCOREBOARD

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

//Copy database to application document
+ (void) copyDatabaseIfNotExist{
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
    
    //NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {//If file not exist
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


+(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}


+(void) UpdateScoreBoard:(NSString *) BALLCODE:(NSString *) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*)BOWLINGTEAMCODE:(NSNumber*)INNINGSNO :(NSString *)BATSMANCODE:(NSNumber *) ISFOUR:(NSNumber*)ISSIX:(NSNumber*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)ISWICKET :(NSString *)WICKETTYPE:(NSString *)WICKETPLAYER:(NSString*)BOWLERCODE:(NSString*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)WICKETSCORE :(NSNumber *)WIDE:(NSNumber *)NOBALL:(NSNumber*)BYES	:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)ISDELETE :(NSNumber *)ISWICKETUNDO:(NSNumber *)F_ISWICKETCOUNTABLE:(NSNumber*)F_ISWICKET :(NSNumber*)F_WICKETTYPE
{

    NSString* F_STRIKERCODE = [[NSString alloc] init];
    NSString* F_BOWLERCODE = [[NSString alloc] init];
    NSNumber* F_ISLEGALBALL = [[NSNumber alloc] init];
    NSNumber* F_OVERS = [[NSNumber alloc] init];
    NSNumber* F_BALLS = [[NSNumber alloc] init];
    NSNumber* F_RUNS = [[NSNumber alloc] init];
    NSNumber* F_OVERTHROW = [[NSNumber alloc] init];
    NSNumber* F_ISFOUR = [[NSNumber alloc] init];
    NSNumber* F_ISSIX = [[NSNumber alloc] init];
    NSNumber* F_WIDE = [[NSNumber alloc] init];
    NSNumber* F_NOBALL = [[NSNumber alloc] init];
    NSNumber* F_BYES = [[NSNumber alloc] init];
    NSNumber* F_LEGBYES = [[NSNumber alloc] init];
    NSNumber* F_PENALTY = [[NSNumber alloc] init];
    NSNumber* F_WICKETNO = [[NSNumber alloc] init];
    NSString* F_WICKETPLAYER = [[NSString alloc] init];
    NSString* F_FIELDINGPLAYER = [[NSString alloc] init];
    
    [DBManagerEndBall SELECTALLUPSC : COMPETITIONCODE: MATCHCODE: BALLCODE ];
    
    [DBManagerEndBall UPDATEBATTINGSUMMARYUPSC : COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO :F_STRIKERCODE ];
    
    int O_RUNSvalue,N_RUNSvalue;
    
    O_RUNSvalue=F_RUNS.intValue + F_OVERTHROW.intValue + F_BYES.intValue + F_LEGBYES.intValue + F_NOBALL.intValue + F_WIDE.intValue + F_PENALTY.intValue;
    
    N_RUNSvalue= RUNS.intValue + OVERTHROW.intValue + BYES.intValue + LEGBYES.intValue + NOBALL.intValue + WIDE.intValue + PENALTY.intValue;
    
    NSString* O_RUNS = [[NSNumber alloc] init];
    NSString* N_RUNS = [[NSNumber alloc] init];
    
    O_RUNS = [NSString stringWithFormat:@"%d",O_RUNSvalue]  ;
    N_RUNS = [NSString stringWithFormat:@"%d",N_RUNSvalue];  ;
    if(O_RUNS != N_RUNS)
    {
        [DBManagerEndBall UPDATEBATTINGSUMBYINNUPSC : O_RUNS:N_RUNS:COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
    }
    else
    {
        //[DBManagerEndBall UPDATEINNINGSSUMMARYUPSC : COMPETITIONCODE: MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
        
        [DBManagerEndBall UPDATEBATTINGSUMMARYUPSC:O_RUNS :N_RUNS :COMPETITIONCODE :MATCHCODE :INNINGSNO];
    }
    
    NSNumber* F_BOWLEROVERS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERBALLS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERRUNS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERMAIDENS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERWICKETS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERNOBALLS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERWIDES = [[NSNumber alloc] init];
    NSNumber* F_BOWLERDOTBALLS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERFOURS = [[NSNumber alloc] init];
    NSNumber* F_BOWLERSIXES = [[NSNumber alloc] init];
    
    
    [DBManagerEndBall SELECTINNBOWLEROVERSUPSC : COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO:F_BOWLERCODE ];
    
    
    NSNumber* U_BOWLEROVERS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERPARTIALOVERBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERRUNS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERMAIDENS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERWICKETS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERNOBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERWIDES = [[NSNumber alloc] init];
    NSNumber* U_BOWLERDOTBALLS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERFOURS = [[NSNumber alloc] init];
    NSNumber* U_BOWLERSIXES = [[NSNumber alloc] init];
    NSNumber* BOWLERCOUNT = [[NSNumber alloc] init];
    NSNumber* ISOVERCOMPLETE = [[NSNumber alloc] init];
    
    
    NSString * TEAMCODE;
    NSString *F_OVERNO;
    NSString *OVERS;
    NSString *O_WICKETNO;
    NSString * U_BOWLERCODE;
    ISOVERCOMPLETE = [DBManagerEndBall GETISOVERCOMPLETE : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:F_OVERS ];
    BOWLERCOUNT  = [DBManagerEndBall GETBALLCOUNT : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO ];
    
    NSNumber* ISBALLEXISTS ;
    ISBALLEXISTS = [DBManagerEndBall ISBALLEXISTS : COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:OVERNO];
    NSNumber* ISBOWLERCHANGED;
    ISBOWLERCHANGED = (BOWLERCODE != F_BOWLERCODE) ? @1 : @0;
    
    NSNumber*F_BOWLERPARTIALOVERBALLS;

    if([ISDELETE  isEqual: @1])
    {
        if(ISOVERCOMPLETE == 0 || BOWLERCOUNT > [NSNumber numberWithInt:1])
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
        if(([ISBOWLERCHANGED  isEqual: @1]) || (([F_ISLEGALBALL  isEqual: @1]) && (NOBALL > 0 || WIDE > 0)))
        {
            U_BOWLERBALLS = ([F_NOBALL  isEqual: @0] && ([F_WIDE  isEqual: @0]) && [BOWLERCOUNT  isEqual: @1] && [ISOVERCOMPLETE  isEqual: @0]) ? ([NSNumber numberWithInt:F_BOWLERBALLS.intValue - 1]): F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = ([F_NOBALL  isEqual:@0] && [F_WIDE  isEqual: @0] && BOWLERCOUNT.intValue > 1)? ([NSNumber numberWithInt:F_BOWLERPARTIALOVERBALLS.intValue - 1]) : F_BOWLERPARTIALOVERBALLS ;
        }
        else
        {
            U_BOWLERBALLS = F_BOWLERBALLS;
            U_BOWLERPARTIALOVERBALLS = F_BOWLERPARTIALOVERBALLS;
        }
        U_BOWLEROVERS = F_BOWLEROVERS;
    }
    
    U_BOWLERRUNS = ((F_BYES == 0) && (F_LEGBYES == 0))?([NSNumber numberWithInt:F_BOWLERRUNS.intValue -F_RUNS.intValue + F_WIDE.intValue + F_NOBALL.intValue +F_WIDE.intValue > 0]? 0 : F_OVERTHROW ): (([NSNumber numberWithInt:F_BOWLERRUNS.intValue -F_WIDE.intValue +F_NOBALL.intValue]));
    U_BOWLERWICKETS = (F_ISWICKETCOUNTABLE.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERWICKETS.intValue - 1]) : F_BOWLERWICKETS;
    U_BOWLERNOBALLS = ( F_NOBALL.intValue == 1) ? ([NSNumber numberWithInt:F_BOWLERNOBALLS.intValue - 1]) : F_BOWLERNOBALLS ;
    U_BOWLERWIDES = (F_WIDE.intValue > 0) ? [NSNumber numberWithInt:F_BOWLERWIDES.intValue - 1]: F_BOWLERWIDES ;
    U_BOWLERDOTBALLS =((F_WIDE.intValue == 0) && (F_NOBALL.intValue == 0) && (F_RUNS.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERDOTBALLS.intValue - 1]) : F_BOWLERDOTBALLS;
    U_BOWLERFOURS = ((F_ISFOUR.intValue == 1) && (F_WIDE.intValue == 0) && (F_BYES.intValue == 0) && (F_LEGBYES.intValue == 0)) ? ([NSNumber numberWithInt:F_BOWLERFOURS.intValue - 1]):[NSNumber numberWithInt:F_BOWLERFOURS.intValue ] ;
    U_BOWLERSIXES = (F_ISSIX.intValue == 1 && F_WIDE.intValue == 0 && F_BYES.intValue == 0 && F_LEGBYES.intValue == 0) ? [NSNumber numberWithInt:F_BOWLERSIXES.intValue - 1] : F_BOWLERSIXES;
    
    NSNumber* ISMAIDENOVER ;
    NSString *SMAIDENOVER;
    
    if(ISMAIDENOVER.intValue > 5)
    {
        [DBManagerEndBall BALLCOUNTUPSC : COMPETITIONCODE:MATCHCODE:INNINGSNO:F_OVERNO];
    }
    {
        SMAIDENOVER = [DBManagerEndBall SMAIDENOVER : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:@"%@",F_OVERS]:BALLCODE];
        
    }
    ISMAIDENOVER = (RUNS.intValue + (BYES.intValue == 0)  && (LEGBYES.intValue == 0)) ? OVERTHROW : 0; + (WIDE.intValue + NOBALL.intValue) > 0 ? 0 : ISMAIDENOVER ;
    ISMAIDENOVER = ( BOWLERCOUNT.intValue > 1 || ISBOWLERCHANGED.intValue == 1) ? 0 : ISMAIDENOVER ;
    if([DBManagerEndBall GETOVERS : COMPETITIONCODE:MATCHCODE:INNINGSNO:[NSString stringWithFormat:OVERS]] !=0)
    {
        if(ISMAIDENOVER == 0)
        {
            [DBManagerEndBall DELBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO];
        }
       // U_BOWLERMAIDENS = F_BOWLERMAIDENS - 1;
        else
        {
            [DBManagerEndBall INSERTBOWLINGMAIDENSUMMARY : COMPETITIONCODE:MATCHCODE:INNINGSNO:BOWLERCODE:F_OVERNO];
            U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue + 1];
        }
        U_BOWLERMAIDENS = [NSNumber numberWithInt:F_BOWLERMAIDENS.intValue - 1];
    }
    
    //+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS;
    
   // [DBManagerEndBall GETOVERS: U_BOWLEROVERS:U_BOWLERBALLS:U_BOWLERPARTIALOVERBALLS:U_BOWLERMAIDENS:U_BOWLERRUNS:U_BOWLERWICKETS:U_BOWLERNOBALLS:U_BOWLERWIDES:U_BOWLERDOTBALLS:U_BOWLERFOURS:U_BOWLERSIXES];
    
    [DBManagerEndBall GETOVERS:COMPETITIONCODE :MATCHCODE :INNINGSNO :OVERS];
    
    
    
    if(ISWICKETUNDO.intValue == 1)
    {
        NSNumber* O_WICKETNO;
        [DBManagerEndBall WICKETNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
    }
    
    [DBManagerEndBall UPDATEBATTINGSUMMARY : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
    [DBManagerEndBall UPDATEBATTINGSUMMARYO_WICNO : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:O_WICKETNO];
    
    NSNumber* ISWKTDTLSUPDATE ;
    //NSNumber* U_BOWLERCODE ;
    NSNumber* BOWLEROVERBALLCNT ;
    NSNumber * BOWLEROVERBALLCN;
   
    
    ISWKTDTLSUPDATE = ((F_ISWICKET.intValue == 1) || (ISWICKET.intValue == 1)) ? @1 : @0;
    U_BOWLERCODE  = (BOWLERCODE != F_BOWLERCODE )? BOWLERCODE : F_BOWLERCODE ;
    BOWLEROVERBALLCNT = 0;
    
    BOWLEROVERBALLCNT = [DBManagerEndBall BOWLEROVERBALLCNT : COMPETITIONCODE:MATCHCODE:INNINGSNO:OVERNO:F_BOWLERCODE];
    if(ISBOWLERCHANGED.intValue == 1)
    {
        if(![DBManagerEndBall GETBOWLERCODE :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE] )
        {
            //[DBManagerEndBall INSERTBOWLEROVERDETAILS :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE];
            [DBManagerEndBall PARTIALUPDATEBOWLINGSUMMARY :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:BOWLERCODE];
            
        }
        
        if((ISDELETE == 0) || (ISBOWLERCHANGED.intValue == 1))
        {
            //[DBManagerEndBall SP_INSERTSCOREBOARD:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:BOWLINGTEAMCODE:INNINGSNO:BATSMANCODE:ISFOUR:ISSIX:RUNS:OVERTHROW:ISWICKET:WICKETTYPE:WICKETPLAYER:U_BOWLERCODE:OVERNO:BALLNO:WICKETSCORE:WIDE:NOBALL:BYES:LEGBYES:PENALTY:ISWKTDTLSUPDATE:ISBOWLERCHANGED:1:F_ISLEGALBALL];
        }
    }
}


+(void) UpdateScoreEngine:(NSString *)BALLCODE:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSNumber*)OVERNO:(NSNumber*)BALLNO:(NSNumber*)BALLCOUNT:(NSNumber*)SESSIONNO:(NSNumber*)STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*)BOWLERCODE:(NSString*)WICKETKEEPERCODE:(NSString*)UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*)ATWOROTW:(NSString*)BOWLINGEN:(NSString*)BOWLTYPE:(NSString*)SHOTTYPE:(NSString*)SHOTTYPECATEGORY:(NSString*)ISLEGALBALL:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)RUNS:(NSNumber*)OVERTHROW:(NSNumber*)TOTALRUNS:(NSNumber*)WIDE:(NSNumber*)NOBALL:(NSNumber*)BYES:(NSNumber*)LEGBYES:(NSNumber*)PENALTY:(NSNumber*)TOTALEXTRAS:(NSNumber*)GRANDTOTAL:(NSNumber*)RBW:(NSString*)PMLINECODE:(NSString*)PMLENGTHCODE:(NSString*)PMSTRIKEPOINT:(NSString*)PMSTRIKEPOINTLINECODE:(NSNumber*)PMX1:(NSNumber*)PMY1:(NSNumber*)PMX2:(NSNumber*)PMY2:(NSNumber*)PMX3:(NSNumber*)PMY3:(NSString*)WWREGION:(NSNumber*)WWX1:(NSNumber*)WWY1:(NSNumber*)WWX2:(NSNumber*)WWY2:(NSNumber*)BALLDURATION:(NSString*)ISAPPEAL:(NSString*)ISBEATEN:(NSString*)ISUNCOMFORT:(NSString*)ISWTB:(NSString*)ISRELEASESHOT:(NSString*)MARKEDFOREDIT:(NSString*)REMARKS:(NSNumber*)ISWICKET:(NSString*)WICKETTYPE:(NSString*)WICKETPLAYER:(NSString*)FIELDINGPLAYER:(NSNumber*)ISWICKETUNDO:(NSString*)AWARDEDTOTEAMCODE:(NSNumber*)PENALTYRUNS:(NSString*)PENALTYTYPECODE:(NSString*)PENALTYREASONCODE:(NSString*)BALLSPEED:(NSString*)UNCOMFORTCLASSIFCATION:(NSString*)WICKETEVENT
{
//    NSString* BATTINGTEAMCODE = [[NSString alloc] init];
//    NSString* BOWLINGTEAMCODE = [[NSString alloc] init];
//    NSString* BATTEAMSHORTNAME = [[NSString alloc] init];
//    NSString* BOWLTEAMSHORTNAME = [[NSString alloc] init];
//    NSString* BATTEAMNAME = [[NSString alloc] init];
//    NSString* BOWLTEAMNAME = [[NSString alloc] init];
//    NSNumber* MATCHOVERS = [[NSNumber alloc] init];
//    NSString* BATTEAMLOGO = [[NSString alloc] init];
//    NSString* BOWLTEAMLOGO = [[NSString alloc] init];
//    NSString* MATCHTYPE = [[NSString alloc] init];
//    NSNumber* OLDISLEGALBALL = [[NSNumber alloc] init];
//    NSString* OLDBOWLERCODE = [[NSString alloc] init];
//    NSString* OLDSTRIKERCODE = [[NSString alloc] init];
//    NSString* OLDNONSTRIKERCODE = [[NSString alloc] init];
//    
//    NSMutableArray *GetDataArrayUpdateScoreEngine=[ DBManagerEndBall GetDataFromUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
//    if(GetDataArrayUpdateScoreEngine.count>0)
//    {
//        OLDISLEGALBALL=[GetDataArrayUpdateScoreEngine objectAtIndex:0];
//        OLDBOWLERCODE=[GetDataArrayUpdateScoreEngine objectAtIndex:1];
//        OLDSTRIKERCODE=[GetDataArrayUpdateScoreEngine objectAtIndex:2];
//        OLDNONSTRIKERCODE=[GetDataArrayUpdateScoreEngine objectAtIndex:3];
//        
//        
//    }
//    
//    BATTINGTEAMCODE =TEAMCODE;
//    
//    NSNumber* F_ISWICKET = [[NSNumber alloc] init];
//    NSNumber* F_ISWICKETCOUNTABLE = [[NSNumber alloc] init];
//    NSString* F_WICKETTYPE = [[NSString alloc] init];
//    
//    F_ISWICKETCOUNTABLE = [ DBManagerEndBall GetWicCountUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
//    
//    F_ISWICKET = [ DBManagerEndBall GetISWicCountUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
//    
//    F_WICKETTYPE = [ DBManagerEndBall GetWicTypeUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
//    
//    if(ISWICKET.intValue == 1)
//    {
//        
//        if( [DBManagerEndBall GetBallCodeExistsUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ] != 0)
//        {
//            [DBManagerEndBall UpdateWicEventsUpdateScoreEngine : WICKETTYPE :WICKETPLAYER:FIELDINGPLAYER:WICKETEVENT:COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
//        }
//        else
//        {
//            NSString *WICKETNO;
//            WICKETNO = [ DBManagerEndBall GetWicketNoUpdateScoreEngine :COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO ];
//            [DBManagerEndBall InsertWicEventsUpdateScoreEngine : BALLCODE:COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO:ISWICKET:WICKETNO:WICKETTYPE:WICKETPLAYER:FIELDINGPLAYER:WICKETEVENT];
//        }
//        WICKETPLAYER =[ DBManagerEndBall GetWicPlayersUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO ];
//        
//        if(ISWICKETUNDO.intValue == 1)
//        {
//            NSNumber* WICKETNO = [[NSNumber alloc] init];
//            WICKETNOS = [ DBManagerEndBall GetWicketNoUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO ];
//            [DBManagerEndBall DeleteWicketUpdateScoreEngine : COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO: BALLCODE ];
//            //BALLCODE = [ DBManager UpdateWicketEveUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO ]
//            [ DBManagerEndBall UpdateWicketEveUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE: TEAMCODE : INNINGSNO ];
//        }
//        [self UpdateScoreBoard: BALLCODE:COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:BOWLINGTEAMCODE:INNINGSNO:STRIKERCODE:ISFOUR:ISSIX:RUNS:OVERTHROW:ISWICKET:WICKETTYPE:WICKETPLAYER:BOWLERCODE:OVERNO:BALLNO:0:WIDE:NOBALL:BYES:LEGBYES:0:0:ISWICKETUNDO:F_ISWICKETCOUNTABLE:F_ISWICKET:F_WICKETTYPE];
//    }
//    if( STRIKERCODE != OLDSTRIKERCODE || NONSTRIKERCODE != OLDNONSTRIKERCODE)
//    {
//        [DBManagerEndBall UpdateBattingOrderUpdateScoreEngine : COMPETITIONCODE, MATCHCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,INNINGSNO ];
//        [DBManagerEndBall UpdateBowlingOrderUpdateScoreEngine : COMPETITIONCODE, MATCHCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,INNINGSNO ];
//        [DBManagerEndBall DeleteRemoveUnusedBatFBSUpdateScoreEngine : COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO ];
//        [DBManagerEndBall DeleteRemoveUnusedBowFBSUpdateScoreEngine : COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,BOWLINGTEAMCODE,INNINGSNO ];
//        if(AWARDEDTOTEAMCODE.length > 0)
//        {
//            if( [DBManagerEndBall GetPenaltyBallCodeUpdateScoreEngine :  COMPETITIONCODE:  MATCHCODE : INNINGSNO: BALLCODE ] != 0)
//            {
//                [DBManagerEndBall UpdatePenaltyScoreEngine : AWARDEDTOTEAMCODE :PENALTYRUNS : PENALTYTYPECODE : PENALTYREASONCODE :COMPETITIONCODE:MATCHCODE:TEAMCODE:BALLCODE ];
//            }
//            else
//            {
//                NSString* MAXID = [[NSString alloc] init];
//                NSString* PENALTYCODE = [[NSString alloc] init];
//                MAXID = [DBManagerEndBall GetMaxidUpdateScoreEngine];
//                PENALTYCODE = 'PNT' + RIGHT(REPLICATE('0',7)+CAST(@MAXID AS VARCHAR(7)),7)
//                [DBManager InsertPenaltyScoreEngine :COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE ];
//            }
//            if(OLDISLEGALBALL == 1 && ISLEGALBALL == 0)
//            {
//                [DBManagerEndBall UpdateBallPlusoneScoreEngine  : COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLCODE ];
//                [DBManagerEndBall UpdateBallMinusoneScoreEngine :COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLCODE ];
//            }
//            else if(OLDISLEGALBALL == 0 && ISLEGALBALL == 1)
//            {
//                [DBManagerEndBall LegalBallByOverNoUpdateScoreEngine  : COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO];
//                [DBManagerEndBall LegalBallCountUpdateScoreEngine :BALLCOUNT,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
//            }
//            NSString* LASTBALLCODE = [[NSString alloc] init];
//            LASTBALLCODE = [DBManagerEndBall LastBallCodeUPSE  : MATCHCODE,INNINGSNO];
//            if(BALLCODE = LASTBALLCODE)
//            {
//                NSString* CURRENTSTRIKERCODE = [[NSString alloc] init];
//                NSString* CURRENTNONSTRIKERCODE = [[NSString alloc] init];
//                NSString* CURRENTBOWLERCODE = [[NSString alloc] init];
//                NSNumber* OVERSTATUS = [[NSNumber alloc] init];
//                OVERSTATUS =  [DBManagerEndBall OverStatusUPSE  : COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
//                CURRENTSTRIKERCODE = STRIKERCODE, CURRENTNONSTRIKERCODE = NONSTRIKERCODE, CURRENTBOWLERCODE = BOWLERCODE;
//                NSString* T_STRIKERCODE = [[NSString alloc] init];
//                NSString* T_NONSTRIKERCODE = [[NSString alloc] init];
//                NSNumber* T_TOTALRUNS = [[NSNumber alloc] init];
//                
//                T_TOTALRUNS = (TOTALRUNS + (CASE WHEN @WIDE > 0 THEN WIDE-1 ELSE WIDE END) +
//                               (CASE WHEN NOBALL > 0 THEN NOBALL-1 ELSE NOBALL END) + LEGBYES + BYES + (CASE WHEN (BYES > 0 OR LEGBYES > 0) THEN OVERTHROW ELSE 0 END))
//                if((T_TOTALRUNS%2) = 0)
//                {
//                    T_STRIKERCODE = CASE WHEN OVERSTATUS = 1 THEN NONSTRIKERCODE ELSE STRIKERCODE END;
//                    T_NONSTRIKERCODE = CASE WHEN OVERSTATUS = 1 THEN STRIKERCODE ELSE NONSTRIKERCODE END;
//                }
//                else
//                {
//                    T_STRIKERCODE = CASE WHEN OVERSTATUS = 1 THEN STRIKERCODE ELSE NONSTRIKERCODE END;
//                    T_NONSTRIKERCODE = CASE WHEN OVERSTATUS = 1 THEN NONSTRIKERCODE ELSE STRIKERCODE END;
//                }
//                [DBManager InningEveUpdateScoreEngine :T_STRIKERCODE,T_NONSTRIKERCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
//                
//            }
//            if( [DBManager BallCodeUPSE :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO,OLDBOWLERCODE ] != 0)
//            {
//                [DBManager DeleteOverDetailsUPSE  :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO,OLDBOWLERCODE ];
//                NSString* OTHERBOWLEROVERBALLCNT = [[NSString alloc] init];
//                [DBManager OtherOverBallcntUPSE  :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO ];
//                
//                NSString* OTHERBOWLER = [[NSString alloc] init];
//                [DBManager OtherOverBallcntUPSE  :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
//                
//                if OTHERBOWLEROVERBALLCNT > 0
//                {
//                    NSString* OTHERBOWLER = [[NSString alloc] init];
//                    [DBManager IsMaidenOverUPSE  :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
//                    NSString* ISMAIDENOVER = [[NSString alloc] init];
//                    [DBManager IsOverCompleteUPSE  :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
//                }
//                if(ISMAIDENOVER = 1 && ISOVERCOMPLETE = 1)
//                {
//                    [DBManager BowMadienSummUPSE  :  COMPETITIONCODE ,MATCHCODE,INNINGSNO,OVERNO,BOWLERCODE];
//                    U_BOWLERMAIDENS = 1;
//                }
//                if(ISOVERCOMPLETE = 1)
//                {
//                    [DBManager BowSummaryOverplusoneUPSE  : COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER, OVERNO];
//                }
//                else
//                {
//                    [DBManager BowSummaryUPSE  : COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER, OVERNO];
//                }			
//                [DBManager BowSummaryUPSE  : COMPETITIONCODE,MATCHCODE,INNINGSNO];
//            }		
//        }
//    }
}







//DBManager.h
//UpdateScoreCard
//DBManager.M
//UpdateScoreCard
+(NSString*) SELECTALLUPSC :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) BALLCODE
    {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT STRIKERCODE, BOWLERCODE, ISLEGALBALL, OVERNO, BALLNO, RUNS, OVERTHROW, ISFOUR, ISSIX , WIDE, NOBALL, BYES, LEGBYES, PENALTY FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND	MATCHCODE = '%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return OVERSTATUS;
                }
                
            }
            else {
                sqlite3_reset(statement);
                
                return @"";
            }
        }
        sqlite3_reset(statement);
        return @"";
    }
+(BOOL)  UPDATEBATTINGSUMMARYUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_STRIKERCODE
    {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET RUNS = CASE WHEN (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (RUNS - (F_RUNS + F_OVERTHROW)) ELSE (RUNS - F_RUNS) END,BALLS = CASE WHEN F_WIDE = 0 THEN (BALLS - 1) ELSE BALLS END,ONES = CASE WHEN (F_RUNS + F_OVERTHROW = 1) AND (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (ONES - 1) ELSE ONES END,TWOS = CASE WHEN (F_RUNS + F_OVERTHROW = 2) AND (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (TWOS - 1) ELSE TWOS END,THREES = CASE WHEN (F_RUNS + F_OVERTHROW = 3) AND (F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (THREES - 1) ELSE THREES END,FOURS = CASE WHEN (F_ISFOUR = 1 AND F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (FOURS - 1) ELSE FOURS END,SIXES = CASE WHEN (F_ISSIX = 1 AND F_WIDE = 0 AND F_BYES = 0 AND F_LEGBYES = 0) THEN (SIXES - 1) ELSE SIXES END,DOTBALLS = CASE WHEN (F_RUNS = 0 AND F_WIDE = 0) THEN (DOTBALLS - 1) ELSE DOTBALLS END 	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@'	AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,F_STRIKERCODE];
                const char *selectStmt = [updateSQL UTF8String];
                if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                           sqlite3_reset(statement);
                                           return YES;
                                       }
                                   }
                                   }
                                   sqlite3_reset(statement);
                                   return NO;
                                   }
+(BOOL)  UPDATEBATTINGSUMBYINNUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO
            {
                NSString *databasePath = [self getDBPath];
                sqlite3_stmt *statement;
                sqlite3 *dataBase;
                const char *dbPath = [databasePath UTF8String];
                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                {
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETSCORE = WICKETSCORE - (O_RUNS - N_RUNS)	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND CONVERT(NUMERIC(5,2),CONVERT(NVARCHAR,WICKETOVERNO) + '%@' +CONVERT(NVARCHAR,WICKETBALLNO)) >= 	CONVERT(NUMERIC(5,2),CONVERT(NVARCHAR,@F_OVERS) + '%@' +CONVERT(NVARCHAR,F_BALLS))",O_RUNS,N_RUNS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
                        const char *selectStmt = [updateSQL UTF8String];
                                           if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                           {
                                               while(sqlite3_step(statement)==SQLITE_ROW){
                                                   sqlite3_reset(statement);
                                                   return YES;
                                               }
                                           }
                                           }
                                           sqlite3_reset(statement);
                                           return NO;
                                           }
+(BOOL) UPDATEINNINGSSUMMARYUPSC : (NSNumber*) O_RUNS: (NSNumber*) N_RUNS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO
                    {
                        NSString *databasePath = [self getDBPath];
                        sqlite3_stmt *statement;
                        sqlite3 *dataBase;
                        const char *dbPath = [databasePath UTF8String];
                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                        {
                            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSSUMMARY SET BYES = BYES - (CASE WHEN @F_NOBALL > 0 AND F_BYES > 0 THEN 0 ELSE F_BYES END),LEGBYES = LEGBYES - (CASE WHEN F_NOBALL > 0 AND F_LEGBYES > 0 THEN 0 ELSE F_LEGBYES END),NOBALLS = NOBALLS - (CASE	WHEN F_NOBALL > 0 AND F_BYES > 0 THEN F_NOBALL + F_BYES WHEN F_NOBALL > 0 AND F_LEGBYES > 0 THEN F_NOBALL + F_LEGBYES ELSE F_NOBALL END),WIDES = WIDES - (CASE WHEN F_WIDE > 0 THEN F_WIDE ELSE F_WIDE END),PENALTIES = PENALTIES - F_PENALTY, INNINGSTOTAL = INNINGSTOTAL - (F_RUNS + (CASE WHEN F_BYES > 0 OR F_LEGBYES > 0 OR F_WIDE > 0 THEN 0 ELSE F_OVERTHROW END) + F_BYES + F_LEGBYES + F_NOBALL + F_WIDE + F_PENALTY),INNINGSTOTALWICKETS = CASE WHEN (F_ISWICKET = 1 AND F_WICKETTYPE <> 'MSC102') OR (F_ISWICKET = 0 AND F_WICKETTYPE IN ('MSC107', 'MSC108', 'MSC133')) THEN (INNINGSTOTALWICKETS - 1) ELSE INNINGSTOTALWICKETS END WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
                                                   const char *selectStmt = [updateSQL UTF8String];
                                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                                   {
                                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                                           sqlite3_reset(statement);
                                                           return YES;
                                                       }
                                                   }
                                                   }
                                                   sqlite3_reset(statement);
                                                   return NO;
                                                   }
+(NSString*) SELECTINNBOWLEROVERSUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BOWLINGTEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  F_BOWLERCODE
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@"SELECT F_BOWLEROVERS = OVERS, F_BOWLERBALLS = BALLS, F_BOWLERPARTIALOVERBALLS = PARTIALOVERBALLS, F_BOWLERRUNS = RUNS, F_BOWLERWICKETS = WICKETS, F_BOWLERMAIDENS = MAIDENS, F_BOWLERNOBALLS = NOBALLS, F_BOWLERWIDES = WIDES, F_BOWLERDOTBALLS = DOTBALLS, F_BOWLERFOURS = FOURS, F_BOWLERSIXES = SIXES FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@'	AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,F_BOWLERCODE];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return OVERSTATUS;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
+(NSString*) GETISOVERCOMPLETE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*) F_OVERS
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@" SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND OVERNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,F_OVERS];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return OVERSTATUS;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
+(NSString*) GETBALLCOUNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@" SELECT COUNT(BOWLERCODE) AS BOWLERCOUNT FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *BOWLERCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return BOWLERCOUNT;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
+(NSString*) ISBALLEXISTS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE: (NSNumber*) INNINGSNO :(NSString*)  OVERS
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@" SELECT COUNT(BOWLERCODE) AS BOWLERCOUNT FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *BOWLERCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return BOWLERCOUNT;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
+(NSString*) BALLCOUNTUPSC : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  F_OVERS
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) BALLCOUNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO,F_OVERS];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *BALLCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return BALLCOUNT;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
                                                   
+(NSString*) SMAIDENOVER : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO :(NSString*)  F_OVERS :(NSString*) BALLCODE
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN (ISNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END  AS SMAIDENOVER FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLCODE != '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,F_OVERS,BALLCODE];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *SMAIDENOVER =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return SMAIDENOVER;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
+(NSString*) GETOVERS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSNumber*) INNINGSNO :(NSString*)  OVERS
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERS FROM BOWLINGMAIDENSUMMARY	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND INNINGSNO= '%@'	AND OVERS= '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
                                    const char *update_stmt = [updateSQL UTF8String];
                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                    {
                                        while(sqlite3_step(statement)==SQLITE_ROW){
                                            
                                            NSString *OVERS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                            sqlite3_finalize(statement);
                                            sqlite3_close(dataBase);
                                            return OVERS;
                                        }
                                        
                                    }
                                    else {
                                        sqlite3_reset(statement);
                                        
                                        return @"";
                                    }
                                }
                                sqlite3_reset(statement);
                                return @"";
                            }
+(BOOL)   DELBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO :(NSString*)  OVERS
                            {
                                NSString *databasePath = [self getDBPath];
                                sqlite3_stmt *statement;
                                sqlite3 *dataBase;
                                const char *dbPath = [databasePath UTF8String];
                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                {
                                    NSString *updateSQL = [NSString stringWithFormat:@"DELETE BOWLINGMAIDENSUMMARY WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@'	AND INNINGSNO= '%@'	AND OVERS= '%@'	",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERS];
                                                           const char *selectStmt = [updateSQL UTF8String];
                                                           if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                                           {
                                                               while(sqlite3_step(statement)==SQLITE_ROW){
                                                                   sqlite3_reset(statement);
                                                                   return YES;
                                                               }
                                                           }
                                                           }
                                                           sqlite3_reset(statement);
                                                           return NO;
                                                           }
+(BOOL)   INSERTBOWLINGMAIDENSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO : (NSString*) BOWLERCODE:(NSString*)  F_OVERS
                                    {
                                        NSString *databasePath = [self getDBPath];
                                        sqlite3_stmt *statement;
                                        sqlite3 *dataBase;
                                        const char *dbPath = [databasePath UTF8String];
                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                        {
                                            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY(COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,OVERS)VALUES('%@','%@','%@','%@','%@',)",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,F_OVERS];
                                                                   const char *selectStmt = [updateSQL UTF8String];
                                                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                                                   {
                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                                                           sqlite3_reset(statement);
                                                                           return YES;
                                                                       }
                                                                   }
                                                                   }
                                                                   sqlite3_reset(statement);
                                                                   return NO;
                                                                   }
                                                                   
                                                                   
+(BOOL) UPDATEBOWLINGSUMMARY : (NSString*) U_BOWLEROVERS :(NSString*) U_BOWLERBALLS : (NSString*) U_BOWLERPARTIALOVERBALLS :(NSString*) U_BOWLERMAIDENS :(NSString*) U_BOWLERRUNS :(NSString*) U_BOWLERWICKETS :(NSString*) U_BOWLERNOBALLS :(NSString*) U_BOWLERWIDES :(NSString*) U_BOWLERDOTBALLS :(NSString*) U_BOWLERFOURS :(NSString*) U_BOWLERSIXES :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSNumber*) INNINGSNO : (NSString*) BOWLINGTEAMCODE:(NSNumber*)  F_BOWLERCODE
    {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = '%@',BALLS = '%@',PARTIALOVERBALLS = '%@',MAIDENS = '%@',RUNS = '%@',WICKETS = '%@',	NOBALLS = '%@',WIDES = '%@',DOTBALLS = '%@',FOURS = '%@',SIXES = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",U_BOWLEROVERS,U_BOWLERBALLS,U_BOWLERPARTIALOVERBALLS,U_BOWLERMAIDENS,U_BOWLERRUNS,U_BOWLERWICKETS,U_BOWLERNOBALLS,U_BOWLERWIDES,U_BOWLERDOTBALLS,U_BOWLERFOURS,U_BOWLERSIXES,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,F_BOWLERCODE];
                    const char *selectStmt = [updateSQL UTF8String];
                    if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                        {
                            while(sqlite3_step(statement)==SQLITE_ROW){
                            sqlite3_reset(statement);
                            return YES;
                            }
                        }
                    }
                    sqlite3_reset(statement);
                    return NO;
                }
                                                                           
+(NSString*) WICKETNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE :(NSNumber*) INNINGSNO :(NSString*)  WICKETPLAYER
                                                    {
                                                        NSString *databasePath = [self getDBPath];
                                                        sqlite3_stmt *statement;
                                                        sqlite3 *dataBase;
                                                        const char *dbPath = [databasePath UTF8String];
                                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                                        {
                                                            NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETNO FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
                                                            const char *update_stmt = [updateSQL UTF8String];
                                                            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                                            if (sqlite3_step(statement) == SQLITE_DONE)
                                                            {
                                                                while(sqlite3_step(statement)==SQLITE_ROW){
                                                                    
                                                                    NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                                                    sqlite3_finalize(statement);
                                                                    sqlite3_close(dataBase);
                                                                    return WICKETNO;
                                                                }
                                                                
                                                            }
                                                            else {
                                                                sqlite3_reset(statement);
                                                                
                                                                return @"";
                                                            }
                                                        }
                                                        sqlite3_reset(statement);
                                                        return @"";
                                                    }
+(BOOL)   UPDATEBATTINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSString*) WICKETPLAYER;
                                                    {
    NSString *databasePath = [self getDBPath];
                                                        sqlite3_stmt *statement;
                                                        sqlite3 *dataBase;
                                                        const char *dbPath = [databasePath UTF8String];
                                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                                        {
                                                            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = NULL,WICKETTYPE = NULL,FIELDERCODE = NULL,BOWLERCODE = NULL,WICKETOVERNO = NULL,WICKETBALLNO = NULL 	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,WICKETPLAYER];
                                                                                   const char *selectStmt = [updateSQL UTF8String];
                                                                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                                                                   {
                                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                           sqlite3_reset(statement);
                                                                                           return YES;
                                                                                       }
                                                                                   }
                                                                                   }
                                                                                   sqlite3_reset(statement);
                                                                                   return NO;
                                                                                   }
+(BOOL)   UPDATEBATTINGSUMMARYO_WICNO : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSString*) O_WICKETNO
                                                            {
                                                                NSString *databasePath = [self getDBPath];
                                                                sqlite3_stmt *statement;
                                                                sqlite3 *dataBase;
                                                                const char *dbPath = [databasePath UTF8String];
                                                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                                                {
                                                                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETNO = WICKETNO - 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND WICKETNO > '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,O_WICKETNO];
                                                                                           const char *selectStmt = [updateSQL UTF8String];
                                                                                           if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                                                                           {
                                                                                               while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                                   sqlite3_reset(statement);
                                                                                                   return YES;
                                                                                               }
                                                                                           }
                                                                                           }
                                                                                           sqlite3_reset(statement);
                                                                                           return NO;
                                                                                           }
+(NSString*) BOWLEROVERBALLCNT : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO :(NSNumber*)  OVERNO:(NSString*) F_BOWLERCODE
                                                                    {
                                                                        NSString *databasePath = [self getDBPath];
                                                                        sqlite3_stmt *statement;
                                                                        sqlite3 *dataBase;
                                                                        const char *dbPath = [databasePath UTF8String];
                                                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                                                        {
                                                                            NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALLCODE) as BOWLEROVERBALLCNT FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1 	AND BOWLERCODE = @F_BOWLERCODE;",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,F_BOWLERCODE];
                                                                            const char *update_stmt = [updateSQL UTF8String];
                                                                            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                                                            if (sqlite3_step(statement) == SQLITE_DONE)
                                                                            {
                                                                                while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                    
                                                                                    NSString *BOWLEROVERBALLCNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                                                                    sqlite3_finalize(statement);
                                                                                    sqlite3_close(dataBase);
                                                                                    return BOWLEROVERBALLCNT;
                                                                                }
                                                                                
                                                                            }
                                                                            else {
                                                                                sqlite3_reset(statement);
                                                                                
                                                                                return @"";
                                                                            }
                                                                        }
                                                                        sqlite3_reset(statement);
                                                                        return @"";
                                                                    }
+(NSString*) GETBOWLERCODE : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:  (NSString*) BATTINGTEAMCODE:(NSString*) TEAMCODE :(NSNumber*)  INNINGSNO :(NSNumber*)  OVERNO:(NSString*) BOWLERCODE
                                                                    {
                                                                        NSString *databasePath = [self getDBPath];
                                                                        sqlite3_stmt *statement;
                                                                        sqlite3 *dataBase;
                                                                        const char *dbPath = [databasePath UTF8String];
                                                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                                                        {
                                                                            NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE	FROM BOWLEROVERDETAILS	WHERE	COMPETITIONCODE =	'%@' AND MATCHCODE =	'%@' AND TEAMCODE =	'%@'AND	INNINGSNO =	'%@' AND OVERNO	=	'%@' AND BOWLERCODE	=	'%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
                                                                            const char *update_stmt = [updateSQL UTF8String];
                                                                            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
                                                                            if (sqlite3_step(statement) == SQLITE_DONE)
                                                                            {
                                                                                while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                    
                                                                                    NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                                                                    sqlite3_finalize(statement);
                                                                                    sqlite3_close(dataBase);
                                                                                    return BOWLERCODE;
                                                                                }
                                                                                
                                                                            }
                                                                            else {
                                                                                sqlite3_reset(statement);
                                                                                
                                                                                return @"";
                                                                            }
                                                                        }
                                                                        sqlite3_reset(statement);
                                                                        return @"";
                                                                    }
+(BOOL)   INSERTBOWLEROVERDETAILS : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO : (NSNumber*) OVERNO :(NSString*) BOWLERCODE
                                                                    {
                                                                        NSString *databasePath = [self getDBPath];
                                                                        sqlite3_stmt *statement;
                                                                        sqlite3 *dataBase;
                                                                        const char *dbPath = [databasePath UTF8String];
                                                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
                                                                        {
                                                                            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME) VALUES('%@','%@','%@','%@','%@','%@',GETDATE(),NULL);",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,BATTINGTEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
                                                                                                   const char *selectStmt = [updateSQL UTF8String];
                                                                                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                                                                                   {
                                                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                                                                                           sqlite3_reset(statement);
                                                                                                           return YES;
                                                                                                       }
                                                                                                   }
                                                                                                   }
                                                                                                   sqlite3_reset(statement);
                                                                                                   return NO;
                                                                                                   }
+(BOOL)   PARTIALUPDATEBOWLINGSUMMARY : (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE
                                                                            {
                                                             
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
     if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = CASE WHEN OVERS > 0 THEN (OVERS - 1) ELSE OVERS END,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS + (CASE WHEN @BOWLEROVERBALLCNT > 0 THEN  CASE WHEN @F_ISLEGALBALL = 0 THEN (@BOWLEROVERBALLCNT)  ELSE (@BOWLEROVERBALLCNT - 1)  END ELSE 0 END) WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@'	AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
                const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
         {
            while(sqlite3_step(statement)==SQLITE_ROW){
                 sqlite3_reset(statement);
                    return YES;
                }
            }
        }
        sqlite3_reset(statement);
        return NO;
        }


+(NSMutableArray*) GetDataFromUpdateScoreEngine: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE;
{
    NSMutableArray *GetDataArrayUpdateScoreEngine=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISLEGALBALL, BOWLERCODE,STRIKERCODE,NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE     =	'%@' AND   MATCHCODE  =	'%@' AND   TEAMCODE =	'%@' AND   INNINGSNO  =	'%@'	AND   BALLCODE  =	'%@' ",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
           while(sqlite3_step(statement)==SQLITE_ROW){
           UpdateScoreEngineRecord *record=[[UpdateScoreEngineRecord alloc]init];
           record.OLDISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        record.OLDBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        record.OLDSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        record.OLDNONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
        [GetDataArrayUpdateScoreEngine addObject:record];
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetDataArrayUpdateScoreEngine;
    }
+(NSString*) GetBowlingTeamCodeUpdateScoreEngine : (NSNumber*) COMPETITIONCODE: (NSNumber*) MATCHCODE:(NSNumber*) BATTINGTEAMCODE:(NSNumber*) MATCHOVERS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
     NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@'THEN TEAMBCODE ELSE TEAMACODE END), '%@' = MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",BATTINGTEAMCODE,MATCHOVERS,COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
            {
              while(sqlite3_step(statement)==SQLITE_ROW){
                                                                      
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return BOWLERCODE;
                    }
                                                                  
                }
            else {
                sqlite3_reset(statement);
                                                                  
                    return @"";
                }
         }
        sqlite3_reset(statement);
        return @"";
}
+(NSString*) GetWicCountUpdateScoreEngine :  (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) AS  F_ISWICKETCOUNTABLE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@'	AND ISWICKET = 1 	AND WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                                                                              
                NSString *F_ISWICKETCOUNTABLE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return F_ISWICKETCOUNTABLE;
                }
                                                                          
            }
            else {
                    sqlite3_reset(statement);
                                                                          
                        return @"";
                    }
                }
                sqlite3_reset(statement);
                return @"";
        }
                                                              
+(NSString*) GetISWicCountUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) AS  F_ISWICKET FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                                                                              
                NSString *F_ISWICKET =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return F_ISWICKET;
                }
                                                                          
        }
            else {
            sqlite3_reset(statement);
            return @"";
                    }
            }
            sqlite3_reset(statement);
            return @"";
        }
                                                              
+(NSString*) GetWicTypeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) AS  WICKETTYPE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
            const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
        while(sqlite3_step(statement)==SQLITE_ROW){
                                                                              
        NSString *WICKETTYPE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return WICKETTYPE;
        }
                                                                          
    }
    else {
        sqlite3_reset(statement);
                                                                          
            return @"";
        }
    }
sqlite3_reset(statement);
return @"";
}
                                                              
+(NSString*)  GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
   sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@'	AND MATCHCODE= '%@'	AND TEAMCODE= '%@'	AND INNINGSNO= '%@'	AND BALLCODE ='%@' 	",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
         while(sqlite3_step(statement)==SQLITE_ROW){
                                                                              
        NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return BALLCODE;
        }
        }
        else {
            sqlite3_reset(statement);
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
        }
+(BOOL)   UpdateWicEventsUpdateScoreEngine  : (NSString*) WICKETTYPE:(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT:(NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETTYPE = '%@' ,WICKETPLAYER = '%@',FIELDINGPLAYER = '%@',WICKETEVENT  = '%@' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND OVERNO='%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_reset(statement);
            return YES;
        }
        }
    }
    sqlite3_reset(statement);
    return NO;
    }
+(NSString*)  GetBallCodeExistsUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(MAX(WKT.WICKETNO),0) + 1  FROM WICKETEVENTS WKT	WHERE WKT.COMPETITIONCODE= '%@'	AND WKT.MATCHCODE= '%@'	AND WKT.TEAMCODE= '%@'	AND WKT.INNINGSNO= '%@'	",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
                           
                           
+(BOOL)   InsertWicEventsUpdateScoreEngine :  (NSString*) WICKETNO: (NSString*) BALLCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSNumber*) ISWICKET:(NSString*) WICKETTYPE :(NSString*) WICKETPLAYER:(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT {
                               
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO WICKETEVENTS (BALLCODE,COMPETITIONCODE,	MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,VIDEOLOCATION,WICKETEVENT)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','','%@')",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER];
                               
                               const char *selectStmt = [updateSQL UTF8String];
                               
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               
                               }
                               
                               
+(NSString*)  GetWicPlayersUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETPLAYER FROM WICKETEVENTS	WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@' AND BALLCODE = '%@' AND ISWICKET = 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETPLAYER =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETPLAYER;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
                               
+(NSString*)  GetWicketNoUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETNO AS WICKETNOS  FROM WICKETEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETNOS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return WICKETNOS;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(NSString*)  GetBallCodeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND TEAMCODE= '%@' AND INNINGSNO= '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(BOOL)   UpdateWicketEveUpdateScoreEngine :  (NSNumber*) WICKETNO: (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSNumber*) INNINGSNO {
                                                                                                                                
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE WICKETEVENTS SET WICKETNO = WICKETNO - 1 WHERE WICKETNO > '%@' AND BALLCODE IN  ( SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@')", WICKETNO, COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO];
                               
                               const char *selectStmt = [updateSQL UTF8String];
                               
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               
                               }
                               
+(BOOL)  UpdateBattingOrderUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE
:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE
:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE
:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*)PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*)PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSString*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*)ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSString*)BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
                               
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BS SET BS.BATTINGPOSITIONNO = ALLM.ORDR FROM [BATTINGSUMMARY] BS INNER JOIN ( SELECT MATCHCODE,INNINGSNO,PLAYERNAME,STRIKERCODE,ROW_NUMBER()OVER(PARTITION BY MATCHCODE,INNINGSNO ORDER BY MIN(ORDR)) ORDR FROM(SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER.PLAYERNAME, STRIKERCODE,MIN(CONVERT( NUMERIC(10,5),( CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT) ) ) )-0.01 ORDR 	FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER ON PLAYERMASTER.PLAYERCODE = BE.STRIKERCODE	WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' GROUP BY BE.MATCHCODE,INNINGSNO, STRIKERCODE, PLAYERMASTER.PLAYERNAME UNION ALL	SELECT BE.MATCHCODE,INNINGSNO,PLAYERMASTER1.PLAYERNAME, NONSTRIKERCODE,MIN(CONVERT( NUMERIC(10,5),( CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT) ) ) ) 	FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PLAYERMASTER1 ON PLAYERMASTER1.PLAYERCODE = BE.NONSTRIKERCODE WHERE BE.MATCHCODE = '%@' AND TEAMCODE =	'%@' AND INNINGSNO = '%@' 				GROUP BY BE.MATCHCODE,INNINGSNO, PLAYERMASTER1.PLAYERNAME, NONSTRIKERCODE )SAM GROUP BY MATCHCODE,INNINGSNO,PLAYERNAME,STRIKERCODE ) ALLM 	ON BS.MATCHCODE = ALLM.MATCHCODE  AND BS.INNINGSNO = ALLM.INNINGSNO	AND BS.BATSMANCODE = ALLM.STRIKERCODE", MATCHCODE,TEAMCODE,INNINGSNO, MATCHCODE,TEAMCODE,INNINGSNO];
                               
                               const char *selectStmt = [updateSQL UTF8String];
                               
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(BOOL)  UpdateBowlingOrderUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE
:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSString*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
        {
        
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [databasePath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                NSString *updateSQL = [NSString stringWithFormat:@"MERGE BOWLINGSUMMARY BS USING (SELECT COMPETITIONCODE, MATCHCODE,INNINGSNO, BOWLERCODE, OVERNO, BOWLINGPOSITIONNO FROM(SELECT COMPETITIONCODE, MATCHCODE, INNINGSNO, BOWLERCODE, MIN(OVERNO) OVERNO, MIN(BALLNO) BALLNO, MIN(BALLCOUNT) BALLCOUNT,ROW_NUMBER() OVER (PARTITION BY COMPETITIONCODE, MATCHCODE, INNINGSNO ORDER BY COMPETITIONCODE, MATCHCODE, INNINGSNO, MIN(OVERNO), MIN(BALLNO), MIN(BALLCOUNT)) BOWLINGPOSITIONNO	FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' GROUP BY COMPETITIONCODE, MATCHCODE, INNINGSNO, BOWLERCODE) BOWLERORDERDETAILS ) BOD ON BS.COMPETITIONCODE = BOD.COMPETITIONCODE AND BS.MATCHCODE = BOD.MATCHCODE AND BS.INNINGSNO = BOD.INNINGSNO AND BS.BOWLERCODE = BOD.BOWLERCODE 	AND BOD.COMPETITIONCODE = '%@' 	AND BOD.MATCHCODE = '%@' 	AND BOD.INNINGSNO = '%@' WHEN MATCHED THEN UPDATE SET BS.BOWLINGPOSITIONNO = BOD.BOWLINGPOSITIONNO",COMPETITIONCODE, MATCHCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,INNINGSNO];
                                       
                                       const char *selectStmt = [updateSQL UTF8String];
                                       
                                       if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                       {
                                           while(sqlite3_step(statement)==SQLITE_ROW){
                                               sqlite3_reset(statement);
                                               return YES;
                                           }
                                       }
                                       }
                                       sqlite3_reset(statement);
                                       return NO;
                                       }
+(BOOL)  DeleteRemoveUnusedBatFBSUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BATSMANCODE IN ( SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE AND BS.BATTINGTEAMCODE = BE.TEAMCODE AND BS.INNINGSNO = BE.INNINGSNO AND (BS.BATSMANCODE = BE.STRIKERCODE OR BS.BATSMANCODE = BE.NONSTRIKERCODE) WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@' AND BS.BATTINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@' AND BE.STRIKERCODE IS NULL 	))",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,MATCHCODE,TEAMCODE,INNINGSNO];
                               
                               const char *selectStmt = [updateSQL UTF8String];
                               
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
                
+(BOOL)  DeleteRemoveUnusedBowFBSUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*)NONSTRIKERCODE:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE
:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
    {
    
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"DELETE BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE IN(SELECT BS.BOWLERCODE FROM BOWLINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE	AND BS.MATCHCODE = BE.MATCHCODE	AND BS.INNINGSNO = BE.INNINGSNO	AND BS.BOWLERCODE = BE.BOWLERCODE WHERE BS.COMPETITIONCODE = '%@'	AND BS.MATCHCODE = '%@'	AND BS.BOWLINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@'	AND BE.BOWLERCODE IS NULL)	" ,COMPETITIONCODE, MATCHCODE,BOWLERCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,INNINGSNO];
                                   
                                   const char *selectStmt = [updateSQL UTF8String];
                                   
                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                           sqlite3_reset(statement);
                                           return YES;
                                       }
                                   }
                                   }
                                   sqlite3_reset(statement);
                                   return NO;
                                   
                                   }
                                
                                   
                                   //PENALTY
+(NSString*)  GetPenaltyBallCodeUpdateScoreEngine : (NSString*) MATCHCODE:(NSString*) COMPETITIONCODE:(NSString*) BALLCODE :(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =	'%@' AND BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,BALLCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(BOOL)  UpdatePenaltyScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PENALTYDETAILS SET AWARDEDTOTEAMCODE = '%@',PENALTYRUNS = '%@', PENALTYTYPECODE = '%@', PENALTYREASONCODE = '%@' WHERE COMPETITIONCODE = '%@'AND MATCHCODE = '%@' AND INNINGSNO = '%@',AND BALLCODE = '%@'",MATCHCODE,TEAMCODE,BALLCODE];
                               
                               const char *selectStmt = [updateSQL UTF8String];
                               
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(NSString*)  GetMaxidUpdateScoreEngine {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(SUBSTRING(PENALTYCODE,4,7)),0)+1 AS MAXID FROM PENALTYDETAILS"];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MAXID =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MAXID;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(BOOL)  InsertPenaltyScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
    {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO PENALTYDETAILS (COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE];
                                   const char *selectStmt = [updateSQL UTF8String];
                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                           sqlite3_reset(statement);
                                           return YES;
                                       }
                                   }
                                   }
                                   sqlite3_reset(statement);
                                   return NO;
                                   }
+(BOOL)  UpdateBallPlusoneScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
    {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = '%@' + BALLCOUNT WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE  =	'%@' AND   TEAMCODE          =	'%@' AND   INNINGSNO         =	'%@' AND   OVERNO  =	'%@'	AND   BALLNO =	'%@' + 1",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
                                   const char *selectStmt = [updateSQL UTF8String];
                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                           sqlite3_reset(statement);
                                           return YES;
                                       }
                                   }
                                   }
                                   sqlite3_reset(statement);
                                   return NO;
                                   }
+(BOOL)  UpdateBallMinusoneScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE
:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE{
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = '%@' + BALLCOUNT WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE  =	'%@' AND TEAMCODE  =	'%@' AND   INNINGSNO         =	'%@' AND   OVERNO  =	'%@'	AND   BALLNO >	'%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
                                   const char *selectStmt = [updateSQL UTF8String];
                                   if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                                   {
                                       while(sqlite3_step(statement)==SQLITE_ROW){
                                           sqlite3_reset(statement);
                                           return YES;
                                       }
                                   }
                                   }
                                   sqlite3_reset(statement);
                                   return NO;
                                   }
+(BOOL)  LegalBallByOverNoUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE
:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*)UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE =	'%@' AND   TEAMCODE  =	'%@' AND   INNINGSNO         =	'%@' AND   OVERNO            =	'%@' AND   BALLNO			>	'%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(BOOL)  LegalBallCountUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
{
NSString *databasePath = [self getDBPath];
sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 , BALLCOUNT = BALLCOUNT - '%@'	WHERE COMPETITIONCODE   =	'%@' AND   MATCHCODE         =	'%@' AND   TEAMCODE          =	'%@' AND   INNINGSNO         =	'%@' AND   OVERNO            =	'%@' AND   BALLNO			=	'%@' AND	  BALLCOUNT			>   '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
                               
+(NSString*)  LastBallCodeUPSE  :(NSString*) MATCHCODE:(NSNumber*) INNINGSNO{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BE WHERE CONVERT(NUMERIC(10,5),(CONVERT(NVARCHAR,BE.OVERNO) + '.' + CONVERT(NVARCHAR,BE.BALLNO) + CONVERT(NVARCHAR,BE.BALLCOUNT))) = (SELECT MAX(CONVERT(NUMERIC(10,5),(CONVERT(NVARCHAR,BALL.OVERNO) + '.' + CONVERT(NVARCHAR,BALL.BALLNO) + CONVERT(NVARCHAR,BALL.BALLCOUNT)))) FROM BALLEVENTS BALL WHERE BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' ) AND BE.MATCHCODE = '%@' AND BE.INNINGSNO = '%@'",MATCHCODE,INNINGSNO,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(NSString*)  OverStatusUPSE : (NSString*) COMPETITIONCODE :(NSString*) MATCHCODE:(NSNumber*) INNINGSNO : (NSString*) OVERNO {
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(OVERSTATUS,0) FROM OVEREVENTS WHERE COMPETITIONCODE= '%@' AND MATCHCODE= '%@' AND INNINGSNO='%@' 	AND OVERNO= ='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OVERSTATUS;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
    
+(BOOL)  InningEveUpdateScoreEngine : (NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE
:(NSString*) BOWLERCODE :(NSString*) WICKETKEEPERCODE:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) ATWOROTW :(NSString*) BOWLINGEND:(NSString*) BOWLTYPE:(NSString*) SHOTTYPE:(NSString*) SHOTTYPECATEGORY :(NSString*) ISLEGALBALL:(NSNumber*) ISFOUR:(NSNumber*) ISSIX :(NSNumber*) RUNS:(NSNumber*) OVERTHROW:(NSNumber*) TOTALRUNS :(NSNumber*) WIDE:(NSNumber*) NOBALL:(NSNumber*) BYES :(NSNumber*) LEGBYES:(NSNumber*) PENALTY:(NSNumber*) TOTALEXTRAS :(NSNumber*) GRANDTOTAL:(NSNumber*) RBW:(NSNumber*) PMLINECODE :(NSString*) PMLENGTHCODE:(NSString*) PMSTRIKEPOINT:(NSString*) PMSTRIKEPOINTLINECODE :(NSString*) PMX1:(NSNumber*) PMY1:(NSNumber*) PMX2 :(NSNumber*) PMY2:(NSNumber*) PMX3:(NSNumber*) PMY3 :(NSNumber*) WWREGION:(NSNumber*) WWX1:(NSNumber*) WWY1 :(NSNumber*) WWX2:(NSNumber*) WWY2:(NSNumber*) BALLDURATION:(NSNumber*) ISAPPEAL :(NSNumber*) ISBEATEN:(NSNumber*) ISUNCOMFORT:(NSNumber*) ISWTB:(NSNumber*) ISRELEASESHOT :(NSNumber*) MARKEDFOREDIT:(NSString*) REMARKS:(NSNumber*) BALLSPEED:(NSString*) UNCOMFORTCLASSIFCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) TEAMCODE:(NSString*) INNINGSNO :(NSString*) BALLCODE
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS	SET CURRENTSTRIKERCODE = '%@' ,CURRENTNONSTRIKERCODE = '%@',	CURRENTBOWLERCODE = CURRENTBOWLERCODE WHERE COMPETITIONCODE = '%@'	AND MATCHCODE = '%@' 	AND TEAMCODE = '%@'	AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(NSString*)  BallCodeUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE {
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, OLDBOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(BOOL)  DeleteOverDetailsUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) OLDBOWLERCODE
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLEROVERDETAILS ",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, OLDBOWLERCODE];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(NSString*)   OtherOverBallcntUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO {
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  COUNT(1) as OtheroverBallcnt	FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OtheroverBallcnt =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OtheroverBallcnt;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(NSString*)  OtherBowlerUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO:(NSString*) BOWLERCODE {
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE as OtherBowler FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO =  '%@' AND OVERNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO, BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OtherBowler =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OtherBowler;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
    
+(NSString*) IsMaidenOverUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN (ISNULL(SUM(TOTALRUNS+NOBALL+WIDE),0) = 0) THEN 1 ELSE 0 END AS IsMaidenOver	FROM BALLEVENTS	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *IsMaidenOver =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return IsMaidenOver;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(NSString*) IsOverCompleteUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) OVERNO
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS 	WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' 	AND INNINGSNO='%@'	AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OVERSTATUS;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}
+(BOOL)  BowMadienSummUPSE :(NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO :(NSString*) BOWLERCODE :(NSString*) OVERNO
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGMAIDENSUMMARY(COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE,OVERS)VALUES 	('%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO, OVERNO];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(BOOL)  BowSummaryOverplusoneUPSE :(NSNumber*) OTHERBOWLEROVERBALLCNT : (NSNumber*)  U_BOWLERMAIDENS: (NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS + 1,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - OTHERBOWLEROVERBALLCNT,MAIDENS = MAIDENS + U_BOWLERMAIDENS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
+(BOOL)  BowSummaryUPSE : (NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - OTHERBOWLEROVERBALLCNT,MAIDENS = MAIDENS + U_BOWLERMAIDENS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
//+(BOOL)  BowSummaryUPSE : (NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO :(NSString*) OTHERBOWLER
//{
//NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY SET OVERS = OVERS,BALLS = 0,PARTIALOVERBALLS = PARTIALOVERBALLS - OTHERBOWLEROVERBALLCNT,MAIDENS = MAIDENS + U_BOWLERMAIDENS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,OTHERBOWLER, OVERNO;
//                               const char *selectStmt = [selectQry UTF8String];
//                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
//                               {
//                                   while(sqlite3_step(statement)==SQLITE_ROW){
//                                       sqlite3_reset(statement);
//                                       return YES;
//                                   }
//                               }
//                               }
//                               sqlite3_reset(statement);
//                               return NO;
//                               }
+(BOOL)  UPDATEWICKETOVERNOUPSE : (NSNumber*) COMPETITIONCODE:(NSNumber*) MATCHCODE:(NSString*) INNINGSNO
{
NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BS SET WICKETOVERNO=BE.OVERNO,WICKETBALLNO=BE.BALLNO,WICKETSCORE=(SELECT SUM(GRANDTOTAL) FROM BALLEVENTS BES WHERE BES.COMPETITIONCODE= '%@' AND BES.MATCHCODE= '%@' AND BES.INNINGSNO= '%@' AND (( CAST(CAST(BES.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BES.BALLNO AS NVARCHAR(MAX)) AS FLOAT)) BETWEEN 0.0 AND  CAST(CAST(BE.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BE.BALLNO AS NVARCHAR(MAX)) AS FLOAT))) FROM BATTINGSUMMARY BS INNER JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE AND WE.MATCHCODE=BS.MATCHCODE AND WE.INNINGSNO=BS.INNINGSNO AND WE.WICKETPLAYER=BS.BATSMANCODE AND BS.WICKETTYPE IS NOT NULL INNER JOIN BALLEVENTS BE ON BE.BALLCODE =WE.BALLCODE WHERE BS.COMPETITIONCODE='%@' AND BS.MATCHCODE='%@' AND BS.INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,INNINGSNO];
                               const char *selectStmt = [updateSQL UTF8String];
                               if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       sqlite3_reset(statement);
                                       return YES;
                                   }
                               }
                               }
                               sqlite3_reset(statement);
                               return NO;
                               }
    
@end
                               
                               
                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                   
