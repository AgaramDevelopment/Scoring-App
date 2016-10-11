//
//  EndInnings.m
//  CAPScoringApp
//
//  Created by mac on 16/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndInnings.h"
#import "DBManager.h"
#import "DBManagerEndInnings.h"
#import "EndInningsVC.h"
#import "BallEventRecord.h"
#import "EndInningsVC.h"
#import "DBManagerInsertScoreEngine.h"


@implementation EndInnings

@synthesize  BALLCODE;

@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize BOWLINGTEAMCODE;
@synthesize OLDTEAMCODE;
@synthesize OLDINNINGSNO;
@synthesize INNINGSSTARTTIME;
@synthesize INNINGSENDTIME;
@synthesize ENDOVER;
@synthesize TOTALRUNS;
@synthesize TOTALWICKETS;
@synthesize BUTTONNAME;
@synthesize MATCHTYPE;
@synthesize INNINGSCOUNT;
@synthesize RUNSSCORED;
@synthesize STARTOVERNO;
@synthesize STARTBALLNO;
@synthesize STARTOVERBALLNO;
@synthesize SESSIONNO;
@synthesize DAYNO;
@synthesize WICKETLOST;
@synthesize LASTBALLCODE;
@synthesize TEAMCODE;
@synthesize OVERNO;
@synthesize OVERSTATUS;
@synthesize BOWLERCODE;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize WICKETKEEPERCODE;
@synthesize UMPIRE1CODE;
@synthesize UMPIRE2CODE;
@synthesize ATWOROTW;
@synthesize BOWLINGEND;
@synthesize SECONDTEAMCODE;
@synthesize THIRDTEAMCODE;
@synthesize SECONDTHIRDTOTAL;
@synthesize FIRSTTHIRDTOTAL;
@synthesize SECONDTOTAL;
@synthesize WINSTATUS;
@synthesize TEAMNAME;
@synthesize BALLNO;
@synthesize OVERBALLNO;
@synthesize TOTALRUN;
@synthesize WICKETS;
@synthesize PENALITYRUNS;
@synthesize TOTALOVERS;
@synthesize INNINGSNO;
@synthesize BATTINGTEAMCODE;
@synthesize DAYDURATION;
@synthesize INNINGSDURATION;
@synthesize DURATION;
@synthesize BATTEAMRUNS;
@synthesize MAXID;
@synthesize BALLCODENO;
@synthesize BATTEAMOVRWITHEXTRASBALLS;
@synthesize BATTEAMOVRBALLSCNT;
@synthesize T_TOTALRUNS;
@synthesize T_STRIKERCODE;
@synthesize T_NONSTRIKERCODE;
@synthesize ISMAIDENOVER;
@synthesize BOWLERCOUNT;
@synthesize CURRENTBOWLER;
@synthesize BATTINGPOSITIONNO;
@synthesize RUNS;
@synthesize BALLS;
@synthesize ONES;
@synthesize TWOS;
@synthesize THREES;
@synthesize FOURS;
@synthesize SIXES;
@synthesize DOTBALLS;
@synthesize WICKETNO;
@synthesize WICKETTYPE;
@synthesize FIELDERCODE;
@synthesize FIELDINGPLAYER;
@synthesize BYES;
@synthesize LEGBYES;
@synthesize NOBALLS;
@synthesize WIDES;
@synthesize PENALTIES;
@synthesize INNINGSTOTAL;
@synthesize INNINGSTOTALWICKETS;
@synthesize BOWLINGPOSITIONNO;
@synthesize OVERS;
@synthesize PARTIALOVERBALLS;
@synthesize MAIDENS;
@synthesize BATSMANCODE;
@synthesize ISFOUR;
@synthesize ISSIX;
@synthesize OVERTHROW;
@synthesize ISWICKET;
@synthesize WICKETPLAYER;
@synthesize WICKETOVERNO;
@synthesize WICKETBALLNO;
@synthesize WICKETSCORE;
@synthesize WIDE;
@synthesize NOBALL;
@synthesize PENALTY;
@synthesize ISWKTDTLSUPDATE;
@synthesize ISBOWLERCHANGED;
@synthesize ISUPDATE;
@synthesize O_ISLEGALBALL;
@synthesize UPDATEFLAGBAT;
@synthesize O_BATTINGPOSITIONNO;
@synthesize O_RUNS;
@synthesize O_BALLS;
@synthesize O_ONES;
@synthesize O_TWOS;
@synthesize O_THREES;
@synthesize O_FOURS;
@synthesize O_SIXES;
@synthesize O_DOTBALLS;
@synthesize O_WICKETNO;
@synthesize O_WICKETTYPE;
@synthesize O_FIELDERCODE;
@synthesize O_BOWLERCODE;
@synthesize N_BATTINGPOSITIONNO;
@synthesize N_RUNS;
@synthesize N_BALLS;
@synthesize N_ONES;
@synthesize N_TWOS;
@synthesize N_THREES;
@synthesize N_FOURS;
@synthesize N_SIXES;
@synthesize N_DOTBALLS;
@synthesize N_WICKETNO;
@synthesize N_WICKETTYPE;
@synthesize N_FIELDERCODE;
@synthesize N_BOWLERCODE;
@synthesize UPDATEFLAGINNS;
@synthesize O_BYES;
@synthesize O_LEGBYES;
@synthesize O_NOBALLS;
@synthesize O_WIDES;
@synthesize O_PENALTIES;
@synthesize O_INNINGSTOTAL;
@synthesize O_INNINGSTOTALWICKETS;
@synthesize N_BYES;
@synthesize N_LEGBYES;
@synthesize N_NOBALLS;
@synthesize N_WIDES;
@synthesize N_PENALTIES;
@synthesize N_INNINGSTOTAL;
@synthesize N_INNINGSTOTALWICKETS;
@synthesize UPDATEFLAGBOWL;
@synthesize O_BOWLINGPOSITIONNO;
@synthesize O_BOWLEROVERS;
@synthesize O_BOWLERBALLS;
@synthesize O_BOWLERPARTIALOVERBALLS;
@synthesize O_BOWLERMAIDENS;
@synthesize O_BOWLERRUNS;
@synthesize O_BOWLERWICKETS;
@synthesize O_BOWLERNOBALLS;
@synthesize O_BOWLERWIDES;
@synthesize O_BOWLERDOTBALLS;
@synthesize O_BOWLERFOURS;
@synthesize O_BOWLERSIXES;
@synthesize N_BOWLINGPOSITIONNO;
@synthesize N_BOWLEROVERS;
@synthesize N_BOWLERBALLS;
@synthesize N_BOWLERPARTIALOVERBALLS;
@synthesize N_BOWLERMAIDENS;
@synthesize N_BOWLERRUNS;
@synthesize N_BOWLERWICKETS;
@synthesize N_BOWLERNOBALLS;
@synthesize N_BOWLERWIDES;
@synthesize N_BOWLERDOTBALLS;
@synthesize N_BOWLERFOURS;
@synthesize N_BOWLERSIXES;
@synthesize ISWICKETCOUNTABLE;
@synthesize ISOVERCOMPLETE;
@synthesize fetchEndInningsArray;
@synthesize GetWicketSDetails;
@synthesize GetOScoreBoardDetails;
@synthesize GetInningsSummaryDetails;
@synthesize GetBowlingDetailsForAssignDetails;
//@synthesize RESULTCODE;
//@synthesize RESULTTYPE;
EndInningsVC *save;
EndInnings *insertScoreCard;



-(void) InsertEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO:(NSString*)INNINGSSTARTTIME:(NSString*)INNINGSENDTIME:(NSString*)ENDOVER:(NSNumber*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)BUTTONNAME

    
{
    DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    
    MATCHTYPE = [dbEndInnings GetMatchTypeUsingCompetition:COMPETITIONCODE];
    
    NSInteger totalRuns = [TOTALRUNS integerValue];
    
    if(totalRuns == nil){
        
        totalRuns = 0;
    }
    if (ENDOVER.intValue == nil) {
        
        ENDOVER = @"0.0";
    }
    if (TOTALWICKETS == nil) {
    
        TOTALWICKETS = [NSNumber numberWithInt:0];
    }
    
    {
        
        //SESSION WISE
        if(![[dbEndInnings GetDayNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE] isEqualToString:@""])
        {
            DAYNO = [dbEndInnings GetMaxDayNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
        }
        else
        {
            DAYNO = @"1";
        }
        if(DAYNO == nil)
        
            DAYNO = @"1";
        
        
        //SESSION NO
        SESSIONNO = [dbEndInnings GetSessionNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO:DAYNO];
        
        if(SESSIONNO == nil)
        {
            SESSIONNO = @"1";
            
        }
        //STARTOVERNO
        STARTOVERNO = [dbEndInnings GetStartoverNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: DAYNO];
        
        
        if(STARTOVERNO == nil)
        {
            STARTOVERNO.intValue == 0;
        }
        
        //STARTBALLNO
        STARTBALLNO = [dbEndInnings GetBallNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO:STARTOVERNO];
        
        
        if(STARTBALLNO == nil)
        {
            STARTBALLNO.intValue ==0;
        }
        
        //STARTOVERBALLNO
        STARTOVERBALLNO = [NSString stringWithFormat:@"%@.%@", STARTOVERNO ,STARTBALLNO];
        
    
        }
    
    NSUInteger oldInningsNo = [OLDINNINGSNO integerValue];
    NSUInteger totalWickets = [TOTALWICKETS integerValue];
    
    //RUNSCORED
    RUNSSCORED = [dbEndInnings GetRunScoredForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: DAYNO];
    
    WICKETLOST = [dbEndInnings GetWicketLostForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO: SESSIONNO ];
    
    
    save = [[EndInningsVC alloc]initWithNibName:@"EndInningsVC" bundle:nil];
    
    NSLog(@"BTNSAVE=%@",BUTTONNAME);
    
    if([BUTTONNAME isEqualToString: @"INSERT"])
    {
        if([dbEndInnings GetCompetitioncodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO])
        {
            //MATCH TYPE BASED DECLARED INNINGS
            
            if(totalWickets < 10 && [MATCHTYPE isEqualToString:@"MSC023"] || [MATCHTYPE isEqualToString :@"MSC115"] && oldInningsNo < 4)
            {
                [dbEndInnings UpdateInningsEventForMatchTypeBasedInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
                
            }
            
            //UPDATE OVER EVENTS FOR LASTE BALL IN A OVER
            
            NSUInteger endOver = [ENDOVER integerValue];
            
            NSString *charIndex = nil;
            if([ENDOVER hasPrefix:@"."]) {
                charIndex = [ENDOVER substringFromIndex:1];
            }
            if(endOver > 0)
            {
                
                if(charIndex.length >=6)
                    
                    // if (CONVERT(int,SUBSTRING(ENDOVER), CHARINDEX('.',ENDOVER,0) + 1,length(ENDOVER))) >= 6)
                {
                    
                    LASTBALLCODE = [dbEndInnings GetLastBallCodeForInsertEndInninges : MATCHCODE: OLDINNINGSNO];
                    
                    if(LASTBALLCODE != nil)
                    {
                        
                        _BallEventArray = [[NSMutableArray alloc]init];
                        _BallEventArray=[dbEndInnings GetBallEventForInningsDetails:COMPETITIONCODE :MATCHCODE :LASTBALLCODE];
                        
                        
                        //[SP_MANAGESEOVERDETAILS]
                        
                        [self manageSeOverDetails:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :objBallEventRecord :OVERSTATUS :UMPIRE1CODE :UMPIRE2CODE: OVERNO:@"":@"":@""];
                        
                        
                        
                    }
                    
                }
                
            }
            
            
            [dbEndInnings UpdateInningsEventForInsertEndInninges :INNINGSSTARTTIME: INNINGSENDTIME :OLDTEAMCODE :TOTALRUNS: ENDOVER: TOTALWICKETS :COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
            
            if(![dbEndInnings GetCompetitioncodeInAddOldInningsNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDTEAMCODE: OLDINNINGSNO])
            {
                
                //NSString *inningsCount;
                
                NSString *inningsCount = [dbEndInnings GetInningsCountForInsertEndInnings:MATCHCODE];
                
                INNINGSCOUNT = [inningsCount integerValue];
                
                if (([MATCHTYPE isEqualToString:@"MSC022"] || [MATCHTYPE isEqualToString:@"MSC024"] || [MATCHTYPE isEqualToString:@"MSC115"] || [MATCHTYPE isEqualToString:@"MSC116"])  && INNINGSCOUNT > 1)
                {
                    [dbEndInnings UpdateMatchRegistrationForInsertEndInnings :COMPETITIONCODE : MATCHCODE];
                    
                }
            }
            
            
            
            if([MATCHTYPE isEqualToString:@"MSC023" ] || [MATCHTYPE isEqualToString:@"MSC114" ])
            {
                if(![dbEndInnings GetMatchBasedSessionNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDINNINGSNO : DAYNO : SESSIONNO])
                {
                    [dbEndInnings InsertSessionEventForInsertEndInnings :COMPETITIONCODE:MATCHCODE: OLDINNINGSNO: DAYNO:  OLDINNINGSNO: OLDTEAMCODE:  STARTOVERBALLNO: ENDOVER: RUNSSCORED: TOTALWICKETS];
                }
                if(![dbEndInnings GetDayNoInDayEventForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDINNINGSNO : DAYNO ])
                {
                    
                    
                    [dbEndInnings InsertDayEventForInsertEndInnings:COMPETITIONCODE :MATCHCODE :OLDINNINGSNO :DAYNO :OLDTEAMCODE :TOTALRUNS :ENDOVER :TOTALWICKETS];
                    
                }
                
            }
        }
    }
    EndInningsVC *end = [[EndInningsVC alloc]init];
    NSLog(@"btnname=%@",BUTTONNAME);
    if([BUTTONNAME isEqualToString:@"UPDATE"])
    {
        if([dbEndInnings GetCompetitioncodeInUpdateForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDTEAMCODE :OLDINNINGSNO])
        {
            
            [dbEndInnings UpdateInningsEventInUpdateForInsertEndInninges:INNINGSSTARTTIME :INNINGSENDTIME :TOTALRUNS :ENDOVER :TOTALWICKETS :COMPETITIONCODE :MATCHCODE :OLDTEAMCODE :OLDINNINGSNO];
            
            
        }
        
    }
    
    [dbEndInnings GetInningsDetails: MATCHCODE];
    
    if(OLDINNINGSNO.intValue == 3)
    {
        SECONDTEAMCODE = [dbEndInnings GetSecondTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
        
        THIRDTEAMCODE = [dbEndInnings GetThirdTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
        
        if(SECONDTEAMCODE=THIRDTEAMCODE)
        {
            
            
            SECONDTHIRDTOTAL = [dbEndInnings GetSecondTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
            
            FIRSTTHIRDTOTAL= [dbEndInnings GetFirstTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
            
            if(SECONDTHIRDTOTAL < FIRSTTHIRDTOTAL)
            {
                
                WINSTATUS.intValue == 1;
                
                
            }
            else
            {
                WINSTATUS.intValue == 0;
            }
            
        }
        else if(SECONDTEAMCODE != THIRDTEAMCODE)
        {
            SECONDTOTAL=[dbEndInnings GetSecondTotalinSecondThirdTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
            FIRSTTHIRDTOTAL=[dbEndInnings GetFirstThirdTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
            
            if(SECONDTOTAL > FIRSTTHIRDTOTAL)
            {
                
                WINSTATUS.intValue == 1;
                
                NSString *secondTotal = SECONDTOTAL;
                
            }
            else
            {
                WINSTATUS.intValue == 0;
            }
            
        }
    }
    
}

//FETCH ENDINNINGS--------------------------------------------------------------

-(void) fetchEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO

{
    DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    
    TEAMNAME=[dbEndInnings GetTeamNameForFetchEndInnings:TEAMCODE];
    
    PENALITYRUNS=[dbEndInnings GetpenaltyRunsForFetchEndInnings : COMPETITIONCODE: MATCHCODE : INNINGSNO :TEAMCODE];
    
    TOTALRUNS=[dbEndInnings GetTotalRunsForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO ];
    
    OVERNO=[dbEndInnings GetOverNoForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO ];
    
    BALLNO=[dbEndInnings GetBallNoForFetchEndInnings:COMPETITIONCODE :MATCHCODE :TEAMCODE :OVERNO :INNINGSNO];
    
    
    OVERSTATUS=[dbEndInnings GetOverStatusForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO : OVERNO ];
    
    if([OVERSTATUS isEqualToString: @"1"])
    {

        NSUInteger overNumber = [OVERNO integerValue];
        OVERBALLNO = [NSString stringWithFormat:@"%d",overNumber +1];
        
    }else{
        
        OVERBALLNO = [NSString stringWithFormat:@"%@.%@", OVERNO ,BALLNO];
        
    }
    
    WICKETS=[dbEndInnings GetWicketForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO ];
    
    [dbEndInnings GetMatchDateForFetchEndInnings : COMPETITIONCODE: MATCHCODE];
    
}


//SP_MANAGESEOVERDETAILS---------------------------------------------------------


-(void)manageSeOverDetails:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO :(NSObject *) balleventRecord:(NSString *) OverStatus :(NSString *)umpire1code :(NSString *) umpire2code:(NSString *) overNo:(NSString *) strickerCode:(NSString *) nonStrickerCode : (NSString*) BowlerCode


{
     DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    
    DBManagerInsertScoreEngine *dbInsertScoreEngine = [[DBManagerInsertScoreEngine alloc]init];
    STRIKERCODE = strickerCode;
    NONSTRIKERCODE = nonStrickerCode;
    objBallEventRecord =[[BallEventRecord alloc]init];
    objBallEventRecord=balleventRecord;
    
    BATTEAMOVRWITHEXTRASBALLS = [NSNumber numberWithInt:0];
    ISMAIDENOVER  = [NSNumber numberWithInt:0];
    BOWLERCOUNT  = [NSNumber numberWithInt:1];
    
    if(![dbEndInnings GetOverNoFormanageOverDetails : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO :overNo])
    {
        [dbEndInnings  InsertOverEventFormanageOverDetails :COMPETITIONCODE: MATCHCODE: TEAMCODE: INNINGSNO :overNo: OverStatus ];
        [dbEndInnings InsertBowlerOverDetailsFormanageOverDetails :COMPETITIONCODE: MATCHCODE: TEAMCODE: INNINGSNO :overNo:BowlerCode];
    }
    else
    {
        if(![dbEndInnings GetBallCodeFormanageOverDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO :overNo])
        {
            BOWLINGTEAMCODE=[dbEndInnings  GetBowlingTeamCodeFormanageOverDetails :TEAMCODE :COMPETITIONCODE: MATCHCODE];
            
            BATTEAMRUNS=[dbEndInnings GetBatTeanRunsFormanageOverDetails :COMPETITIONCODE:MATCHCODE: TEAMCODE :INNINGSNO];
            
            NSUInteger ballNo = [BALLNO integerValue];
            
            ballNo = 1;
            

            while(ballNo >= 1 && ballNo <= 6)
            {
                MAXID=[dbEndInnings GetMaxidFormanageOverDetails :MATCHCODE];
                
                
                // BALLCODENO = MATCHCODE + RIGHT(REPLICATE('0',10)+ MAXID,10);
                
                
                BALLCODE = [dbInsertScoreEngine GetMaxIdForInsertScoreEngine:MATCHCODE];
                
                
            [dbEndInnings  InsertBallEventsFormanageOverDetails : BALLCODE: COMPETITIONCODE: MATCHCODE:TEAMCODE: INNINGSNO : objBallEventRecord.objDayno:overNo :[NSString stringWithFormat:@"%d",ballNo]:objBallEventRecord.objSessionno:strickerCode:nonStrickerCode :BowlerCode:objBallEventRecord.objBowlercode:objBallEventRecord.objWicketkeepercode:umpire1code:umpire2code:@""];
                
                
                //EXEC SP_INSERTSCOREBOARD
    
                WICKETOVERNO = overNo;
                self.BOWLERCODE = BowlerCode;
                O_ISLEGALBALL = @1;// Added for default value.
                [self insertScordBoard:COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO];
               
                ballNo = ballNo+1;
            }
        }
        
        
        [dbEndInnings  UpdateOverEventFormanageOverDetails :OverStatus :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO :overNo];
        
        [dbEndInnings  UpdateBowlerOverDetailsFormanageOverDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO :overNo];
        
        BATTEAMOVRWITHEXTRASBALLS=[dbEndInnings  GetBattingteamOverwithExtraBallFormanageOverDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO :overNo];
        
        NSNumber * objBatteamwithextraball= [NSNumber numberWithInt:BATTEAMOVRWITHEXTRASBALLS.intValue];
        
        BATTEAMOVRBALLSCNT=[dbEndInnings  GetBattingteamOverBallCountFormanageOverDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE: INNINGSNO : overNo : BATTEAMOVRWITHEXTRASBALLS];
        
        NSNumber *objbatTeamOverballsCNT =[NSNumber numberWithInt:BATTEAMOVRBALLSCNT.intValue];
        
        LASTBALLCODE=[dbEndInnings  GetLastBallCodeFormanageOverDetails :COMPETITIONCODE:MATCHCODE:TEAMCODE:INNINGSNO :overNo :objBatteamwithextraball : objbatTeamOverballsCNT];
        
        NSString *ballCount = [dbEndInnings  GetBallEventCountFormanageOverDetails :COMPETITIONCODE:MATCHCODE:INNINGSNO];
        
        NSNumber *count = [NSNumber numberWithInt:ballCount.intValue];
        NSLog(@"COUNT %@",count);
        
    if(count > 0)
        {
            
            NSMutableArray * GetStrickerNonStrickerDetails=[dbEndInnings GetStrickerNonStrickerRunFormanageOverDetails : LASTBALLCODE];
            
            if(GetStrickerNonStrickerDetails.count>0)
            {
                
                EndInnings *record=[GetStrickerNonStrickerDetails objectAtIndex:0];
                T_STRIKERCODE = record.STRIKERCODE;
                T_NONSTRIKERCODE =record.NONSTRIKERCODE;
                T_TOTALRUNS = record.TOTALRUNS;
            }
            
                if(T_TOTALRUNS.intValue % 2==0)
                {
                    T_STRIKERCODE=NONSTRIKERCODE;
                    T_NONSTRIKERCODE=STRIKERCODE;
                }
                else
                {
                    
                    T_STRIKERCODE = NONSTRIKERCODE;
                    T_NONSTRIKERCODE = STRIKERCODE;
                }
                
            }
            [dbEndInnings  UpdateInningsEventFormanageOverDetails: T_STRIKERCODE : T_NONSTRIKERCODE : COMPETITIONCODE : MATCHCODE :  TEAMCODE : INNINGSNO];
            ISMAIDENOVER=0;
            
            if([dbEndInnings GetBallNoFormanageOverDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO :overNo])
            {
                
                
                ISMAIDENOVER=[dbEndInnings GetIsMaidenOverFormanageOverDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO :overNo];
                
                BOWLERCOUNT==1;
            }
        if([dbEndInnings GetBowlerCodeFormanageOverDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO :overNo])
            {
                
                BOWLERCOUNT=[dbEndInnings GetBowlerCountFormanageOverDetails:COMPETITIONCODE :MATCHCODE :INNINGSNO :overNo];
                
                
            }
        
            
            if(BOWLERCOUNT.intValue ==1)
            {
            CURRENTBOWLER=[dbEndInnings GetCurrentBowlerCountFormanageOverDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :overNo];
                
                [dbEndInnings UpdateBowlingSummaryFormanageOverDetails : BOWLERCOUNT: ISMAIDENOVER : COMPETITIONCODE: MATCHCODE:  INNINGSNO: CURRENTBOWLER ];
                
                
            }
            else
            {
                [dbEndInnings UpdateBowlingSummaryFormanageOver: BOWLERCOUNT : ISMAIDENOVER : COMPETITIONCODE : MATCHCODE :   INNINGSNO : overNo];
                
                
            }
            if(ISMAIDENOVER.intValue ==1 && BOWLERCOUNT.intValue==1)
            {
                [dbEndInnings InsertBowlingMaidenSummaryInElseFormanageOverDetails: COMPETITIONCODE : MATCHCODE :  INNINGSNO : objBallEventRecord.objBowlercode :overNo];
                
            }
            
        
        
    }
}

//SP_INSERTSCOREBOARD----------------------------------------------------------------

-(void)insertScordBoard:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO
{
    

    DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    
    ISWKTDTLSUPDATE = [NSNumber numberWithInt:1];
    ISBOWLERCHANGED = [NSNumber numberWithInt:0];
    
  //  O_ISLEGALBALL = [NSNumber numberWithInt:1]; Default value issue
    
    O_BATTINGPOSITIONNO = [NSNumber numberWithInt:0];
    O_RUNS = [NSNumber numberWithInt:0];
    O_BALLS = [NSNumber numberWithInt:0];
    O_ONES = [NSNumber numberWithInt:0];
    O_TWOS = [NSNumber numberWithInt:0];
    O_THREES = [NSNumber numberWithInt:0];
    O_FOURS = [NSNumber numberWithInt:0];
    O_SIXES = [NSNumber numberWithInt:0];
    O_DOTBALLS = [NSNumber numberWithInt:0];
    
    N_BATTINGPOSITIONNO = [NSNumber numberWithInt:0];
    N_RUNS = [NSNumber numberWithInt:0];
    N_BALLS = [NSNumber numberWithInt:0];
    N_ONES = [NSNumber numberWithInt:0];
    N_TWOS = [NSNumber numberWithInt:0];
    N_THREES = [NSNumber numberWithInt:0];
    N_FOURS = [NSNumber numberWithInt:0];
    N_SIXES = [NSNumber numberWithInt:0];
    N_DOTBALLS = [NSNumber numberWithInt:0];
    
    UPDATEFLAGINNS = [NSNumber numberWithInt:0];
    BOWLERCOUNT = [NSNumber numberWithInt:1];
    
    
    
    
    if([dbEndInnings GetBatsmanCodeForInsertScoreBoard  :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:BATSMANCODE])
    {
        
        UPDATEFLAGBAT= [NSNumber numberWithInt:1];
        
        GetOScoreBoardDetails = [[NSMutableArray alloc]init];
        
        GetOScoreBoardDetails = [dbEndInnings GetO_AssignValueForInsertScoreBoard :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:BATSMANCODE];
        
        
					   if(GetOScoreBoardDetails.count>0)
                       {
                           EndInnings *endInnings = [GetOScoreBoardDetails objectAtIndex:0];
                           
                           O_BATTINGPOSITIONNO = endInnings.BATTINGPOSITIONNO;
                           O_RUNS = endInnings.RUNS;
                           O_BALLS = endInnings.BALLS;
                           O_ONES = endInnings.ONES;
                           O_TWOS = endInnings.TWOS;
                           O_THREES = endInnings.THREES;
                           O_FOURS = endInnings.FOURS;
                           O_SIXES = endInnings.SIXES;
                           O_DOTBALLS = endInnings.DOTBALLS;
                           //                           O_WICKETNO = endInnings.WICKETNO;
                           //                           O_WICKETTYPE = endInnings.WICKETTYPE;
                           //                           O_FIELDERCODE = endInnings.FIELDERCODE;
                           O_BOWLERCODE = endInnings.BOWLERCODE;
                           
                       }
        
        
    }
    else
    {
        
        UPDATEFLAGBAT = [NSNumber numberWithInt:0];
        
       O_BATTINGPOSITIONNO = [dbEndInnings GetOBattingPositionNoForInsertScoreBoard :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
					   
        
    }
    
    N_BATTINGPOSITIONNO = O_BATTINGPOSITIONNO;
			 
    int nRuns = (WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_RUNS.intValue + RUNS.intValue + OVERTHROW.intValue) : (O_RUNS.intValue + RUNS.intValue);
    N_RUNS = [NSNumber numberWithInt:nRuns];
    
    int nBalls = WIDE.intValue > 0 ? O_BALLS.intValue : O_BALLS.intValue + 1;
    N_BALLS =[NSNumber numberWithInt:nBalls];
    
    
    int nOnes =  (RUNS.intValue + OVERTHROW.intValue) == 1 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0 ? (O_ONES.intValue + 1) : O_ONES.intValue;
    N_ONES = [NSNumber numberWithInt:nOnes];
    
    int nTwos = (RUNS.intValue + OVERTHROW.intValue) == 2 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0 ? (O_TWOS.intValue + 1) : O_TWOS.intValue;
    N_TWOS = [NSNumber numberWithInt:nTwos];
    
    
    int nThree = (RUNS.intValue + OVERTHROW.intValue) == 3 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0 ? (O_THREES.intValue + 1) : O_THREES.intValue;
    
    N_THREES = [NSNumber numberWithInt:nThree];
    
    
    int nFour = (ISFOUR.intValue == 1 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_FOURS.intValue + 1) : O_FOURS.intValue;
    
		  N_FOURS = [NSNumber numberWithInt:nFour];
    
    
    int nSix =  (ISSIX.intValue == 1 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_SIXES.intValue + 1) : O_SIXES.intValue;
    N_SIXES = [NSNumber numberWithInt:nSix];
    
    int dotBall = (RUNS.intValue == 0 && WIDE.intValue == 0) ? (O_DOTBALLS.intValue + 1) : O_DOTBALLS.intValue;
    N_DOTBALLS = [NSNumber numberWithInt:dotBall];
    
			 
    
    if(UPDATEFLAGBAT.intValue == 0 )
    {
        [ dbEndInnings InsertbattingSummaryForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:INNINGSNO: N_BATTINGPOSITIONNO :BATSMANCODE: N_RUNS: N_BALLS: N_ONES: N_TWOS : N_THREES: N_FOURS:N_SIXES: N_DOTBALLS ];
    }
    else
    {
        [dbEndInnings UpdatebattingSummaryForInsertScoreBoard : N_BATTINGPOSITIONNO : N_RUNS: N_BALLS: N_ONES:N_TWOS :N_THREES : N_FOURS : N_SIXES : N_DOTBALLS:COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO : BATSMANCODE];
        
    }
    
    if([dbEndInnings  GetWicKetTypeForInsertScoreBoard : COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE :INNINGSNO :WICKETPLAYER])
    {
        
        GetWicketSDetails = [[NSMutableArray alloc]init];
        
        GetWicketSDetails = [ dbEndInnings GetWicKetAssignVarForInsertScoreBoard :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO:WICKETPLAYER];
        
        
        if(GetWicketSDetails.count>0)
        {
            
            EndInnings *endInnings = [GetWicketSDetails objectAtIndex:0];
            
            N_WICKETNO = [NSNumber numberWithInt:[endInnings.WICKETNO intValue]];
            N_WICKETTYPE = endInnings.WICKETTYPE;
            N_FIELDERCODE = endInnings.FIELDINGPLAYER;
            //N_BOWLERCODE = [NSNumber numberWithInt:[endInnings.BOWLERCODE intValue]];
            N_BOWLERCODE = BOWLERCODE;
            
            
            
            
        }
    }
    else
    {
        
        N_WICKETNO = O_WICKETNO;
        N_WICKETTYPE = O_WICKETTYPE;
        N_FIELDERCODE = O_FIELDERCODE;
        N_BOWLERCODE = O_BOWLERCODE;
    }
    
    if(ISWKTDTLSUPDATE.intValue == 1)
    {
        [dbEndInnings UpdatebattingSummaryInWiCketForInsertScoreBoard : N_WICKETNO: N_WICKETTYPE: N_FIELDERCODE: N_BOWLERCODE: WICKETOVERNO: WICKETBALLNO: COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE : INNINGSNO : WICKETPLAYER];
    }
    
    
    
    O_BYES  = [NSNumber numberWithInt:0];
    O_LEGBYES = [NSNumber numberWithInt:0];
    O_NOBALLS = [NSNumber numberWithInt:0];
    O_WIDES = [NSNumber numberWithInt:0];
    O_PENALTIES = [NSNumber numberWithInt:0];
    O_INNINGSTOTAL= [NSNumber numberWithInt:0];
    O_INNINGSTOTALWICKETS = [NSNumber numberWithInt:0];
    
    
    N_BYES = [NSNumber numberWithInt:0];
    N_LEGBYES = [NSNumber numberWithInt:0];
    N_NOBALLS = [NSNumber numberWithInt:0];
    N_WIDES = [NSNumber numberWithInt:0];
    N_PENALTIES = [NSNumber numberWithInt:0];
    N_INNINGSTOTAL = [NSNumber numberWithInt:0];
    N_INNINGSTOTALWICKETS = [NSNumber numberWithInt:0];
    
    
    
    if([dbEndInnings GetBateamCodeForInsertScoreBoard : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO])
    {
        UPDATEFLAGINNS = [NSNumber numberWithInt:1];
        
        
        GetInningsSummaryDetails = [[NSMutableArray alloc]init];
        
        GetInningsSummaryDetails = [dbEndInnings GetInningsSummaryAssignForInsertScoreBoard :COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE:INNINGSNO];
        
        if(GetInningsSummaryDetails.count>0)
        {
            EndInnings *innings = [GetInningsSummaryDetails objectAtIndex:0];
            
            O_BYES = [NSNumber numberWithInt:[innings.BYES intValue]];
            O_LEGBYES = [NSNumber numberWithInt:[innings.LEGBYES intValue]];
            O_NOBALLS = [NSNumber numberWithInt:[innings.NOBALLS intValue]];
            O_WIDES = [NSNumber numberWithInt:[innings.WIDES intValue]];
            O_PENALTIES = [NSNumber numberWithInt:[innings.PENALTIES intValue]];
            O_INNINGSTOTAL = [NSNumber numberWithInt:[innings.INNINGSTOTAL intValue]];
            O_INNINGSTOTALWICKETS = [NSNumber numberWithInt:[innings.INNINGSTOTALWICKETS intValue]];
            
            
        }
    }
    
    
    
    int byes = O_BYES.intValue + (NOBALL.intValue > 0 && BYES.intValue > 0 ? 0 : BYES.intValue);
    N_BYES = [NSNumber numberWithInt:byes];
    
    
    
    int nLegByess = O_LEGBYES.intValue + (NOBALL.intValue > 0 && LEGBYES.intValue > 0 ? 0 : LEGBYES.intValue);
    N_LEGBYES = [NSNumber numberWithInt:nLegByess];
    
    
    
    int wide = WIDE.intValue > 0 ? O_WIDES.intValue + WIDE.intValue : O_WIDES.intValue;
    
    N_WIDES = [NSNumber numberWithInt:wide];
    
    int nPenalties = O_PENALTIES.intValue + PENALTY.intValue;
    N_PENALTIES = [NSNumber numberWithInt:nPenalties];
    
    
    int inningsTotal = O_INNINGSTOTAL.intValue + (RUNS.intValue + ((BYES.intValue > 0 || LEGBYES.intValue > 0 || WIDE.intValue > 0) ? 0 : OVERTHROW.intValue) + BYES.intValue + LEGBYES.intValue + NOBALL.intValue + WIDE.intValue + PENALTY.intValue);
    N_INNINGSTOTAL = [NSNumber numberWithInt:inningsTotal];
    
    
    int inningsTotalWickets = (ISWICKET.intValue == 1 && N_WICKETTYPE != @"MSC102") || (ISWICKET.intValue == 0 && [N_WICKETTYPE isEqualToString:@"MSC107"] || [N_WICKETTYPE isEqualToString:@"MSC108"] || [N_WICKETTYPE isEqualToString:@"MSC133"]) ? (O_INNINGSTOTALWICKETS.intValue + 1) : O_INNINGSTOTALWICKETS.intValue;
    
    N_INNINGSTOTALWICKETS = [NSNumber numberWithInt:inningsTotalWickets];
    
    if (UPDATEFLAGINNS.intValue == 0)
    {
        
        [dbEndInnings InsertInningsSummaryForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO : N_BYES :N_LEGBYES:N_NOBALLS:N_WIDES:N_PENALTIES:N_INNINGSTOTAL:N_INNINGSTOTALWICKETS];
    }
    else
    {
        [ dbEndInnings UpdateInningsSummaryForInsertScoreBoard :  N_BYES :N_LEGBYES:N_NOBALLS:N_WIDES:N_PENALTIES:N_INNINGSTOTAL:N_INNINGSTOTALWICKETS:COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO ];
        
    }
    
    [dbEndInnings UpdatebattingSummaryInWiCketScoreForInsertScoreBoard : N_INNINGSTOTAL:COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO :WICKETPLAYER];
    
    
    
    //BOWLING SUMMARY
    UPDATEFLAGBOWL = [NSNumber numberWithInt:0];
    O_BOWLINGPOSITIONNO = [NSNumber numberWithInt:0];
    O_BOWLEROVERS = [NSNumber numberWithInt:0];
    O_BOWLERBALLS = [NSNumber numberWithInt:0];
    O_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt:0];
    O_BOWLERMAIDENS = [NSNumber numberWithInt:0];
    O_BOWLERRUNS = [NSNumber numberWithInt:0];
    O_BOWLERWICKETS = [NSNumber numberWithInt:0];
    O_BOWLERNOBALLS = [NSNumber numberWithInt:0];
    O_BOWLERWIDES = [NSNumber numberWithInt:0];
    O_BOWLERDOTBALLS = [NSNumber numberWithInt:0];
    O_BOWLERFOURS = [NSNumber numberWithInt:0];
    O_BOWLERSIXES = [NSNumber numberWithInt:0];
    
    N_BOWLINGPOSITIONNO = [NSNumber numberWithInt:0];
    N_BOWLEROVERS = [NSNumber numberWithInt:0];
    N_BOWLERBALLS = [NSNumber numberWithInt:0];
    N_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt:0];
    N_BOWLERMAIDENS = [NSNumber numberWithInt:0];
    N_BOWLERRUNS = [NSNumber numberWithInt:0];
    N_BOWLERWICKETS = [NSNumber numberWithInt:0];
    N_BOWLERNOBALLS = [NSNumber numberWithInt:0];
    N_BOWLERWIDES = [NSNumber numberWithInt:0];
    N_BOWLERDOTBALLS = [NSNumber numberWithInt:0];
    N_BOWLERFOURS = [NSNumber numberWithInt:0];
    N_BOWLERSIXES = [NSNumber numberWithInt:0];
    ISWICKETCOUNTABLE = [NSNumber numberWithInt:0];
    
    
    ISOVERCOMPLETE=[dbEndInnings GetOverStatusForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: TEAMCODE: INNINGSNO :WICKETOVERNO];
    
    BOWLERCOUNT = [NSNumber numberWithInt:1];
    
    
    if([dbEndInnings GetBowlerForInsertScoreBoard:COMPETITIONCODE :MATCHCODE :INNINGSNO :WICKETOVERNO])
    {
        
        BOWLERCOUNT=[dbEndInnings GetBowlerCountForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: INNINGSNO :WICKETOVERNO];
        
        
    }
    else
    {
        
        [dbEndInnings InsertBowlerOverDetailsForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO :WICKETOVERNO :BOWLERCODE];
    }
    
    int isWicketCountAble = (ISWICKET.intValue == 1 &&  [N_WICKETTYPE isEqualToString:@"MSC105"]||[N_WICKETTYPE isEqualToString:@"MSC104"]||[N_WICKETTYPE isEqualToString:@"MSC099"]||[N_WICKETTYPE isEqualToString:@"MSC098"]||[N_WICKETTYPE isEqualToString:@"MSC096"]||[N_WICKETTYPE isEqualToString:@"MSC095"]) ? 1 : 0;
    
    ISWICKETCOUNTABLE = [NSNumber numberWithInt:isWicketCountAble];
    
    
    
    if([dbEndInnings GetBowlerCodeForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: BOWLINGTEAMCODE: INNINGSNO  :BOWLERCODE])
    {
        UPDATEFLAGBOWL = [NSNumber numberWithInt:1];
        
        
        GetBowlingDetailsForAssignDetails = [[NSMutableArray alloc]init];
        
        GetBowlingDetailsForAssignDetails = [dbEndInnings GetBowlingDetailsForassignvarForInsertScoreBoard :COMPETITIONCODE:MATCHCODE:BOWLINGTEAMCODE:INNINGSNO:BOWLERCODE];
        
        if(GetBowlingDetailsForAssignDetails.count>0)
        {
            
            
            EndInnings *innings = [GetBowlingDetailsForAssignDetails objectAtIndex:0];
            
            O_BOWLINGPOSITIONNO = [NSNumber numberWithInt:[innings.BOWLINGPOSITIONNO intValue]];
            O_BOWLEROVERS = [NSNumber numberWithInt:[innings.OVERS intValue]];
            O_BOWLERBALLS = [NSNumber numberWithInt:[innings.BALLS intValue]];
            O_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt:[innings.PARTIALOVERBALLS intValue]];
            O_BOWLERMAIDENS = [NSNumber numberWithInt:[innings.MAIDENS intValue]];
            O_BOWLERRUNS = [NSNumber numberWithInt:[innings.RUNS intValue]];
            O_BOWLERWICKETS = [NSNumber numberWithInt:[innings.WICKETS intValue]];
            O_BOWLERNOBALLS = [NSNumber numberWithInt:[innings.NOBALLS intValue]];
            O_BOWLERWIDES = [NSNumber numberWithInt:[innings.WIDES intValue]];
            O_BOWLERDOTBALLS = [NSNumber numberWithInt:[innings.DOTBALLS intValue]];
            O_BOWLERFOURS = [NSNumber numberWithInt:[innings.FOURS intValue]];
            O_BOWLERSIXES = [NSNumber numberWithInt:[innings.SIXES intValue]];
            
            
        }
    }
    else
    {
        UPDATEFLAGBOWL = [NSNumber numberWithInt:0];
        
        O_BOWLINGPOSITIONNO=[dbEndInnings GetBowlingPositionCountForInsertScoreBoard : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO];
        
        
    }
    if(ISUPDATE.intValue == 0)
    {
        
        if (ISOVERCOMPLETE.intValue == 0  || BOWLERCOUNT.intValue > 1)
        {
            
            int nBowlerBall = (NOBALL.intValue == 0 && WIDE.intValue == 0 && BOWLERCOUNT.intValue == 1) ? (O_BOWLERBALLS.intValue + 1) : O_BOWLERBALLS.intValue;
            N_BOWLERBALLS = [NSNumber numberWithInt:nBowlerBall];
            
            
            int nBowlerPartialOverBalls = (NOBALL.intValue == 0 && WIDE.intValue == 0 && BOWLERCOUNT.intValue > 1) ? (O_BOWLERPARTIALOVERBALLS.intValue + 1) : O_BOWLERPARTIALOVERBALLS.intValue;
            
            N_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt: nBowlerPartialOverBalls];
        }
        else
        {
            N_BOWLERBALLS = O_BOWLERBALLS;
            N_BOWLERPARTIALOVERBALLS = O_BOWLERPARTIALOVERBALLS;
        }
    }
    else
    {
        
        if (ISBOWLERCHANGED.intValue == 1 || (O_ISLEGALBALL.intValue == 0 && NOBALL.intValue == 0 && WIDE.intValue == 0))
        {
            
            int bowlerBalls =  (NOBALL.intValue == 0 && WIDE.intValue == 0 && BOWLERCOUNT.intValue == 1 && ISOVERCOMPLETE.intValue == 0) ? (O_BOWLERBALLS.intValue + 1) : O_BOWLERBALLS.intValue;
            N_BOWLERBALLS = [NSNumber numberWithInt:bowlerBalls];
            
            
            int nBowlerPartial =  (NOBALL.intValue == 0 && WIDE.intValue == 0 && BOWLERCOUNT.intValue > 1) ? (O_BOWLERPARTIALOVERBALLS.intValue + 1) : O_BOWLERPARTIALOVERBALLS.intValue;
            
            N_BOWLERPARTIALOVERBALLS = [NSNumber numberWithInt: nBowlerPartial];
        }
        else
        {
            
            N_BOWLERBALLS = O_BOWLERBALLS;
            N_BOWLERPARTIALOVERBALLS = O_BOWLERPARTIALOVERBALLS;
        }
    }
    N_BOWLEROVERS = O_BOWLEROVERS;
    N_BOWLINGPOSITIONNO = O_BOWLINGPOSITIONNO;
    N_BOWLERMAIDENS =  O_BOWLERMAIDENS;
    int bowlRuns;
    
    if(BYES.intValue > 0 && NOBALL.intValue > 0)
    {
         bowlRuns = (BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_BOWLERRUNS.intValue + RUNS.intValue + WIDE.intValue + NOBALL.intValue + (WIDE.intValue > 0 ? 0 : OVERTHROW.intValue)) : (O_BOWLERRUNS.intValue + WIDE.intValue + NOBALL.intValue+BYES.intValue);
    }
 else
 {
    bowlRuns = (BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_BOWLERRUNS.intValue + RUNS.intValue + WIDE.intValue + NOBALL.intValue + (WIDE.intValue > 0 ? 0 : OVERTHROW.intValue)) : (O_BOWLERRUNS.intValue + WIDE.intValue + NOBALL.intValue);
 }
    
    N_BOWLERRUNS = [NSNumber numberWithInt: bowlRuns];
    
    
    N_BOWLERWICKETS = [NSNumber numberWithInt:ISWICKETCOUNTABLE.intValue == 1 ? (O_BOWLERWICKETS.intValue + 1) : O_BOWLERWICKETS.intValue];
    
    N_BOWLERNOBALLS = [NSNumber numberWithInt: NOBALL.intValue > 0 ? (O_BOWLERNOBALLS.intValue + 1) : O_BOWLERNOBALLS.intValue];
    
    N_BOWLERWIDES = [NSNumber numberWithInt : WIDE.intValue > 0 ? (O_BOWLERWIDES.intValue + 1) : O_BOWLERWIDES.intValue];
    N_BOWLERDOTBALLS = [NSNumber numberWithInt:(WIDE.intValue == 0 && NOBALL.intValue == 0 && RUNS.intValue == 0) ? (O_BOWLERDOTBALLS.intValue + 1) : O_BOWLERDOTBALLS.intValue];
    
    N_BOWLERFOURS = [NSNumber numberWithInt: (ISFOUR.intValue == 1 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_BOWLERFOURS.intValue + 1) : O_BOWLERFOURS.intValue];
    
    N_BOWLERSIXES = [NSNumber numberWithInt: (ISSIX.intValue == 1 && WIDE.intValue == 0 && BYES.intValue == 0 && LEGBYES.intValue == 0) ? (O_BOWLERSIXES.intValue + 1) : O_BOWLERSIXES.intValue];
    
    
    ISMAIDENOVER = [NSNumber numberWithInt:0];
    
    if (ISOVERCOMPLETE.intValue == 1 && ISUPDATE.intValue == 0)
    {
        if( [dbEndInnings GetBallCountForInsertScoreBoard : COMPETITIONCODE: MATCHCODE:  INNINGSNO : WICKETOVERNO]  > 4)
        {
            ISMAIDENOVER=[dbEndInnings GetMaiDenOverForInsertScoreBoard : COMPETITIONCODE: MATCHCODE:  INNINGSNO : WICKETOVERNO];
            
            ISMAIDENOVER = [NSNumber numberWithInt: BOWLERCOUNT.intValue > 1 ? 0 : ISMAIDENOVER.intValue];
        }
        if([dbEndInnings GetOversForInsertScoreBoard : COMPETITIONCODE: MATCHCODE:  INNINGSNO : WICKETOVERNO])
        {
            
            ISMAIDENOVER.intValue == 0;
            {
                [dbEndInnings DeletebattingSummaryForInsertScoreBoard : COMPETITIONCODE: MATCHCODE:  INNINGSNO : WICKETOVERNO];
                
                N_BOWLERMAIDENS = [NSNumber numberWithInt:O_BOWLERMAIDENS.intValue - 1];
            }
        }
        
        else
        {
            
            if (ISMAIDENOVER.intValue == 1 && ISOVERCOMPLETE.intValue == 1 )
            {
                
                [dbEndInnings InsertBowlingMaidenSummaryForInsertScoreBoard : COMPETITIONCODE: MATCHCODE:  INNINGSNO : BOWLERCODE :WICKETOVERNO];
                
                N_BOWLERMAIDENS = [NSNumber numberWithInt:O_BOWLERMAIDENS .intValue+ 1];
            }
        }
        
        
        int bowlerOver = N_BOWLERBALLS.intValue >= 6 ? N_BOWLEROVERS.intValue + 1 : N_BOWLEROVERS.intValue;
        N_BOWLEROVERS = [NSNumber numberWithInt:bowlerOver];
        
        int bowlBalls = N_BOWLERBALLS.intValue >= 6 ? 0 : N_BOWLERBALLS.intValue;
        N_BOWLERBALLS = [NSNumber numberWithInt:bowlBalls];
        
        
    }
    
    if(UPDATEFLAGBOWL.intValue == 0)
    {
        
        [dbEndInnings InsertBowlingSummaryForInsertScoreBoard :COMPETITIONCODE: MATCHCODE: BOWLINGTEAMCODE:INNINGSNO: N_BOWLINGPOSITIONNO: BOWLERCODE: N_BOWLEROVERS: N_BOWLERBALLS: N_BOWLERPARTIALOVERBALLS: N_BOWLERMAIDENS: N_BOWLERRUNS: N_BOWLERWICKETS: N_BOWLERNOBALLS: N_BOWLERWIDES: N_BOWLERDOTBALLS: N_BOWLERFOURS: N_BOWLERSIXES];
        
    }else{
        [dbEndInnings UpdateBowlingSummaryForInsertScoreBoard : N_BOWLINGPOSITIONNO:N_BOWLEROVERS : N_BOWLERBALLS: N_BOWLERPARTIALOVERBALLS :N_BOWLERMAIDENS:N_BOWLERRUNS: N_BOWLERWICKETS: N_BOWLERNOBALLS: N_BOWLERWIDES: N_BOWLERDOTBALLS: N_BOWLERFOURS:N_BOWLERSIXES: COMPETITIONCODE: MATCHCODE: BOWLINGTEAMCODE : INNINGSNO: BOWLERCODE];
        
        NSLog(@"MADIDENS %@",N_BOWLERMAIDENS);
         
        
    }
    
    
}



//SP_DELETEENDINNINGS---------------------------------------------------------------------------

-(BOOL) DeleteEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO
{
     DBManagerEndInnings *dbEndInnings = [[DBManagerEndInnings alloc]init];
    
    MATCHTYPE = [dbEndInnings GetMatchTypeUsingCompetitionForDeleteEndInnings : COMPETITIONCODE];
    
    if(![dbEndInnings GetBallCodeForDeleteEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO] &&
       ![dbEndInnings GetInningsNoForDeleteEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO])
    {
        
        [dbEndInnings UpdateInningsEventForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
        
        [dbEndInnings DeleteInningsEventForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
        
        [dbEndInnings DeleteOverEventsForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
        
        [dbEndInnings DeleteBowlerOverDetailsForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
        
        [dbEndInnings DeleteSessionEventsForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
        
        if([dbEndInnings GetSessionNoForDeleteEndInninges : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO])
        {
            
            [dbEndInnings DeleteSessionEventsInInningsEntryForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
            
            [dbEndInnings DeleteDayEventsForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
            
            if([dbEndInnings GetDayNoForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO])
            {
                
                [dbEndInnings DeleteDayEventsInInningsEntryForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
                
                [dbEndInnings DeletePenaltyDetailsForDeleteEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO];
                
                
                NSString *inningsCount = [dbEndInnings GetInningsCountForDeleteEndInnings : MATCHCODE];
                
                INNINGSCOUNT = [inningsCount integerValue];
                

                
                if (([MATCHTYPE isEqualToString:@"MSC022"] || [ MATCHTYPE isEqualToString:@"MSC024"]||[ MATCHTYPE isEqualToString:@"MSC115"]||[ MATCHTYPE isEqualToString:@"MSC116"]) && INNINGSCOUNT > 1)
                    
                    
                    
                {
                    [dbEndInnings UpdatematchRegistrationForDeleteEndInnings : COMPETITIONCODE : MATCHCODE];
                    
                }
                
            }
            NSMutableArray *InningsArrayForDelete=[dbEndInnings GetInningsDetailsForDeleteEndInnings: MATCHCODE];
        }
        
        
    }else{
        
        [self showDialog:@"Delete Innings is not possible when the data exist for future Innings" andTitle:@"Error"];
        return NO;
    }

    
    return YES;
}

-(void) showDialog:(NSString*) message andTitle:(NSString*) title{
    UIAlertView *alertDialog = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alertDialog show];
}
@end
