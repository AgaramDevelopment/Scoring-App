//
//  EndInnings.m
//  CAPScoringApp
//
//  Created by mac on 16/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndInnings.h"
#import "DBManager.h"

@implementation EndInnings

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


//-(void) InsertEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO:(NSString*)INNINGSSTARTTIME:
//(NSString*)INNINGSENDTIME:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)BUTTONNAME
//{
//    
//    
//    MATCHTYPE = [DBManager GetMatchTypeUsingCompetition:COMPETITIONCODE];
//    
//    
//    if(TOTALRUNS = nil){
//        
//        TOTALRUNS  = [NSNumber numberWithInteger:0];
//    }
//    if (ENDOVER = nil) {
//        ENDOVER = @"0.0";
//    }
//    if (TOTALWICKETS = nil) {
//        TOTALWICKETS = [NSNumber numberWithInteger:0];
//    }
//    
//    //SESSION WISE
//    if([DBManager GetDayNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE])
//    {
//        DAYNO = [DBManager GetMaxDayNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//    }
//    else
//    {
//        DAYNO = @"1";
//    }
//    if(DAYNO = nil)
//    {
//        DAYNO = @"1";
//    }
//    
//    //SESSION NO
//    SESSIONNO = [DBManager GetSessionNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO:DAYNO];
//    
//    if(SESSIONNO = nil)
//    {
//        SESSIONNO = @"1";
//        
//    }
//    //STARTOVERNO
//    STARTOVERNO = [DBManager GetStartoverNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: DAYNO];
//    
//    
//    if(STARTOVERNO = nil)
//    {
//        STARTOVERNO = [NSNumber numberWithInteger:0];
//    }
//    
//    STARTBALLNO = [DBManager GetBallNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: STARTOVERNO];
//    
//    
//    if(STARTBALLNO = nil)
//    {
//        STARTBALLNO = [NSNumber numberWithInteger:0];
//    }
//    
//    //startoverballno
//    
//    STARTOVERBALLNO = [[STARTOVERNO stringByAppendingString:@"."] stringByAppendingString:STARTBALLNO];
//    
//    RUNSSCORED = [DBManager GetRunScoredForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: DAYNO];
//    
//    WICKETLOST = [DBManager GetWicketLostForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO: SESSIONNO ];
//    
//    if(BUTTONNAME=@"SAVE")
//    {
//        
//        if([DBManager GetCompetitioncodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO])
//        {
//            
//            if(TOTALWICKETS<10 && [MATCHTYPE isEqualToString:@"MSC023"] || [MATCHTYPE isEqualToString :@"MSC115"] && OLDINNINGSNO < 4)
//            {
//                [DBManager UpdateInningsEventForMatchTypeBasedInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
//                
//            }
//            
//            //UPDATE OVER EVENTS FOR LASTE BALL IN A OVER
//            
//            
//            if([[ENDOVER componentsSeparatedByString:@"."] count]  > 0)
//            {
//                if (CONVERT(int, SUBSTRING(CONVERT(NVARCHAR,ENDOVER), CHARINDEX('.',ENDOVER,0) + 1,length(ENDOVER))) >= 6)
//                {
//                    
//                    LASTBALLCODE = [DBManager GetLastBallCodeForInsertEndInninges : MATCHCODE: OLDINNINGSNO];
//                    
//                    if(LASTBALLCODE != nil)
//                    {
//                        
//                        _BallEventArray = [[NSMutableArray alloc]init];
//                        _BallEventArray=[DBManager GetBallEventForInningsDetails: COMPETITIONCODE: MATCHCODE: OLDTEAMCODE: LASTBALLCODE];
//                        
//                        //    _BallEventArray = [DBManager GetCompetitioncodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE*OLDTEAMCODE : LASTBALLCODE];
//                        
//                        //EXEC [SP_MANAGESEOVERDETAILS] // Need Sp
//                        
//                    }
//                    
//                }
//                
//                [DBManager UpdateInningsEventForInsertEndInninges :INNINGSSTARTTIME: INNINGSENDTIME :OLDTEAMCODE :TOTALRUNS: ENDOVER: TOTALWICKETS :COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
//                
//                if([DBManager GetCompetitioncodeInAddOldInningsNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDTEAMCODE: OLDINNINGSNO])
//                {
//                    INNINGSCOUNT = [DBManager GetInningsCountForInsertEndInnings:MATCHCODE];
//                    
//                  
//                    if (([MATCHTYPE isEqualToString:@"MSC022"] || [MATCHTYPE isEqualToString:@"MSC024"] || [MATCHTYPE isEqualToString:@"MSC115"] || [MATCHTYPE isEqualToString:@"MSC116"])  && INNINGSCOUNT > 1)
//                    {
//                        [DBManager UpdateMatchRegistrationForInsertEndInnings :COMPETITIONCODE : MATCHCODE];
//                        
//                    }
//                }
//                
//                if([MATCHTYPE isEqualToString:@"MSC023" ] || [MATCHTYPE isEqualToString:@"MSC114" ])
//                {
//                    if([DBManager GetMatchBasedSessionNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDINNINGSNO : DAYNO : SESSIONNO])
//                    {
//                        [DBManager InsertSessionEventForInsertEndInnings :COMPETITIONCODE:MATCHCODE: OLDINNINGSNO: DAYNO:  SESSIONNO: OLDTEAMCODE:  STARTOVERBALLNO: ENDOVER: RUNSSCORED: TOTALWICKETS];
//                    }
//                    if([DBManager GetDayNoInDayEventForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDINNINGSNO : DAYNO ])
//                    {
//                        [DBManager InsertDayEventForInsertEndInnings:COMPETITIONCODE :MATCHCODE :OLDINNINGSNO :DAYNO :OLDTEAMCODE :TOTALRUNS :ENDOVER :TOTALWICKETS :SESSIONNO :STARTOVERBALLNO :RUNSSCORED];
//     
//                    }
//                    
//                }
//                
//                
//            }
//            
//            
//        }
//        
//    }
//    if([BUTTONNAME isEqualToString:@"UPDATE"])
//    {
//        if([DBManager GetCompetitioncodeInUpdateForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDTEAMCODE :OLDINNINGSNO])
//        {
//            
//            [DBManager UpdateInningsEventInUpdateForInsertEndInninges:INNINGSSTARTTIME :INNINGSENDTIME :TOTALRUNS :ENDOVER :TOTALWICKETS :COMPETITIONCODE :MATCHCODE :OLDTEAMCODE :OLDINNINGSNO];
//     
//
//        }
//        
//        
//    }
//    
//    NSMutableArray *InningsArray=[DBManager GetInningsDetails: MATCHCODE];
//    
//    if(OLDINNINGSNO == 3)
//    {
//        SECONDTEAMCODE = [DBManager GetSecondTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//        
//        THIRDTEAMCODE = [DBManager GetThirdTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//        
//        if(SECONDTEAMCODE=THIRDTEAMCODE)
//        {
//            
//            
//            SECONDTHIRDTOTAL = [DBManager GetSecondTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//            
//            FIRSTTHIRDTOTAL= [DBManager GetFirstTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//            
//            if(SECONDTHIRDTOTAL < FIRSTTHIRDTOTAL)
//            {
//               // SELECT '1' AS WINSTATUS,@FIRSTDTOTAL FIRSTDTOTAL;
//                WINSTATUS = [NSNumber numberWithInteger:1];
//                
//               NSString *FIRSTDTOTAL = FIRSTTHIRDTOTAL;
//                
//            }
//            else
//            {
//                WINSTATUS = [NSNumber numberWithInteger:0];
//            }
//            
//        }
//        else if(SECONDTEAMCODE != THIRDTEAMCODE)
//        {
//            SECONDTOTAL=[DBManager GetSecondTotalinSecondThirdTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//            FIRSTTHIRDTOTAL=[DBManager GetFirstThirdTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
//            
//            if(SECONDTOTAL > FIRSTTHIRDTOTAL)
//            {
//                
//                //SELECT '1' AS WINSTATUS ,@SECONDTOTAL AS SECONDTOTAL;
//                WINSTATUS = [NSNumber numberWithInteger:1];
//                
//                NSString *secondTotal = SECONDTOTAL;
//                
//            }
//            else
//            {
//                WINSTATUS = [NSNumber numberWithInteger:0];
//            }
//            
//        }
//    }
//}

-(void)fetchEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO{
    
    
    TEAMNAME=[DBManager GetTeamNameForFetchEndInnings:TEAMCODE];
    
    PENALITYRUNS=[DBManager GetpenaltyRunsForFetchEndInnings : COMPETITIONCODE: MATCHCODE : INNINGSNO :TEAMCODE];
    
    TOTALRUNS=[DBManager GetTotalRunsForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO ];
    
    OVERNO=[DBManager GetOverNoForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO ];
    
    BALLNO=[DBManager GetBallNoForFetchEndInnings:COMPETITIONCODE :MATCHCODE :TEAMCODE :OVERNO :INNINGSNO];
            
    
    OVERSTATUS=[DBManager GetOverStatusForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO : OVERNO ];
    
    if([OVERSTATUS isEqualToString: @"1"])
    {
        
        //NSInteger *overNumber = (int)OVERNO + 1;
        
        NSUInteger overNumber = [OVERNO integerValue];
    
       // NSUInteger number = overNumber+1;
        
    OVERBALLNO = [NSString stringWithFormat:@"%d",overNumber +1];
        
    }else{
        
        OVERBALLNO = [NSString stringWithFormat:@"%@ . %@", OVERNO ,BALLNO];

    }
    
     WICKETS=[DBManager GetWicketForFetchEndInnings : COMPETITIONCODE: MATCHCODE :TEAMCODE: INNINGSNO ];
    
   // NSMutableArray *FetchEndInningsDetails=[DBManager FetchEndInningsDetailsForFetchEndInnings: MATCHCODE];
    
	  [DBManager GetMatchDateForFetchEndInnings : COMPETITIONCODE: MATCHCODE];
    
}

@end
