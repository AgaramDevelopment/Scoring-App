//
//  EndInnings.m
//  CAPScoringApp
//
//  Created by Stephen on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndInnings.h"
#import "DBManager.h"
@implementation InningsDetails
@synthesize STARTTIME;
@synthesize ENDTIME;
@synthesize TEAMNAME;
@synthesize TOTALRUNS;
@synthesize TOTALOVERS;
@synthesize TOTALWICKETS;
@synthesize INNINGSNO;
@synthesize BATTINGTEAMCODE;
@synthesize DAYDURATION;
@synthesize INNINGSDURATION;
@synthesize DURATION;

//SP_INSERTENDINNINGS
+(void) InsertEndInnings:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)BOWLINGTEAMCODE:(NSString*)OLDTEAMCODE:(NSString*)OLDINNINGSNO:(NSString*)INNINGSSTARTTIME:
(NSString*)INNINGSENDTIME:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)BUTTONNAME
{
    NSString* MATCHTYPE = [[NSString alloc] init];
    int INNINGSCOUNT;
    NSNumber* RUNSSCORED = [[NSNumber alloc] init];
    NSNumber* STARTOVERNO = [[NSNumber alloc] init];
    NSNumber* STARTBALLNO = [[NSNumber alloc] init];
    NSString* STARTOVERBALLNO = [[NSString alloc] init];
    NSString* SESSIONNO = [[NSString alloc] init];
    NSString* DAYNO = [[NSString alloc] init];
    NSString* WICKETLOST = [[NSString alloc] init];
    
    NSString* LASTBALLCODE = [[NSString alloc] init];
    NSString* TEAMCODE = [[NSString alloc] init];
    NSString* OVERNO = [[NSNumber alloc] init];
    NSString* OVERSTATUS = [[NSNumber alloc] init];
    NSString* BOWLERCODE = [[NSString alloc] init];
    NSString* STRIKERCODE = [[NSString alloc] init];
    NSString* NONSTRIKERCODE = [[NSString alloc] init];
    NSString* WICKETKEEPERCODE = [[NSString alloc] init];
    NSString* UMPIRE1CODE = [[NSString alloc] init];
    NSString* UMPIRE2CODE = [[NSString alloc] init];
    NSString* ATWOROTW = [[NSString alloc] init];
    NSString* BOWLINGEND = [[NSString alloc] init];
    NSString* SECONDTEAMCODE = [[NSString alloc] init];
    NSString* THIRDTEAMCODE = [[NSString alloc] init];
    NSNumber* SECONDTHIRDTOTAL = [[NSString alloc] init];
    NSNumber* FIRSTTHIRDTOTAL = [[NSString alloc] init];
    
    MATCHTYPE = [DBManager GetMatchTypeUsingCompetition : COMPETITIONCODE];
    
    if(TOTALRUNS.length != 0)
        TOTALRUNS = 0;
    if(ENDOVER.length != 0)
        ENDOVER=@"0.0";
    if(TOTALWICKETS.length != 0)
        TOTALWICKETS=0;
    
    if([DBManager GetDayNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE].length != 0)
    {
        DAYNO = [DBManager GetMaxDayNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
    }
    else
    {
        DAYNO = @"1";
    }
    if(DAYNO.length != 0)
    {
        DAYNO = @"1";
    }
    
    SESSIONNO = [DBManager GetSessionNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDINNINGSNO:DAYNO];
    
    if(SESSIONNO.length != 0)
    {
        SESSIONNO = @"1";
        
    }
    STARTOVERNO = [DBManager GetStartoverNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: DAYNO];
    
    
    if(STARTOVERNO.intValue != 0)
    {
        STARTOVERNO = 0;
    }
    
    STARTBALLNO = [DBManager GetBallNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: STARTOVERNO];
    
    
    if(STARTBALLNO.intValue != 0)
    {
        STARTBALLNO = 0;
    }
    
    STARTOVERBALLNO = [[[NSString stringWithFormat:@"%d",STARTOVERNO] stringByAppendingString:@"."] stringByAppendingString:[NSString stringWithFormat:@"%d",STARTBALLNO]];
    
    RUNSSCORED = [DBManager GetRunScoredForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE: SESSIONNO: OLDINNINGSNO: DAYNO];
    
    WICKETLOST = [DBManager GetWicketLostForInsertEndInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO: SESSIONNO ];
    
    if(BUTTONNAME=@"SAVE")
    {
        
        if([DBManager GetCompetitioncodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO].length != 0)
        {
            
            if((TOTALWICKETS<10) && (MATCHTYPE == 'MSC023' || MATCHTYPE =='MSC115' ) && OLDINNINGSNO<4)
            {
                bool Updatestatus=[DBManager UpdateInningsEventForMatchTypeBasedInnings : COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
                
            }
            if([[ENDOVER componentsSeparatedByString:@"."] count]  > 0)
            {
                //                if (CONVERT(INT, SUBSTRING(CONVERT(NVARCHAR,ENDOVER), CHARINDEX('.',ENDOVER,0) + 1,lenght(ENDOVER))) >= 6)
                {
                    
                    LASTBALLCODE = [DBManager GetLastBallCodeForInsertEndInninges : MATCHCODE: OLDINNINGSNO];
                    if(LASTBALLCODE!=nil)
                    {
                        NSMutableArray *BallEventArray=[[NSMutableArray alloc]init];
                        
                        BallEventArray = [DBManager GetBallEventForInningsDetails : COMPETITIONCODE : MATCHCODE :OLDTEAMCODE : LASTBALLCODE];
                        
                        //EXEC [SP_MANAGESEOVERDETAILS] // Need Sp
                        
                    }
                    
                }
                
                bool Updatestatus=[DBManager UpdateInningsEventForInsertEndInninges :INNINGSSTARTTIME: INNINGSENDTIME :OLDTEAMCODE :TOTALRUNS: ENDOVER: TOTALWICKETS :COMPETITIONCODE : MATCHCODE: OLDTEAMCODE:OLDINNINGSNO];
                
                if([DBManager GetCompetitioncodeInAddOldInningsNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDTEAMCODE: OLDINNINGSNO].length == 0)
                {
                    INNINGSCOUNT = [DBManager GetInningsCountForInsertEndInnings : MATCHCODE];
                    NSArray *array = @[@"MSC022", @"MSC024", @"MSC115", @"MSC116"];
                    if([array containsObject : MATCHTYPE] && INNINGSCOUNT > 1)
                    {
                        bool Updatestatus=[DBManager UpdateMatchRegistrationForInsertEndInnings :COMPETITIONCODE : MATCHCODE];
                        
                    }
                }
                
                if([MATCHTYPE isEqualToString:@"MSC023"] || [MATCHTYPE isEqualToString:@"MSC114"])
                {
                    if([DBManager GetMatchBasedSessionNoForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDINNINGSNO : DAYNO : SESSIONNO].length == 0)
                    {
                        bool Insertstatus=[DBManager InsertSessionEventForInsertEndInnings :COMPETITIONCODE:MATCHCODE: OLDINNINGSNO: DAYNO:  SESSIONNO: OLDTEAMCODE:  STARTOVERBALLNO: ENDOVER: RUNSSCORED: TOTALWICKETS];
                    }
                    if([DBManager GetDayNoInDayEventForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDINNINGSNO : DAYNO].length == 0)
                    {
                        bool Insertstatus=[DBManager InsertDayEventForInsertEndInnings : COMPETITIONCODE: MATCHCODE: OLDINNINGSNO:  DAYNO:  OLDTEAMCODE:  TOTALRUNS: ENDOVER: TOTALWICKETS : SESSIONNO : STARTOVERBALLNO : RUNSSCORED];
                    }
                    
                }
                
                
            }
            
            
        }
        
    }
    if(BUTTONNAME=@"UPDATE")
    {
        if([DBManager GetCompetitioncodeInUpdateForInsertEndInnings : COMPETITIONCODE : MATCHCODE :OLDTEAMCODE :OLDINNINGSNO].length != 0)
        {
            bool Updatestatus=[DBManager UpdateInningsEventInUpdateForInsertEndInninges : INNINGSSTARTTIME :  INNINGSENDTIME : TOTALRUNS : ENDOVER : TOTALWICKETS : COMPETITIONCODE: MATCHCODE: OLDTEAMCODE : OLDINNINGSNO];
            
        }
        
        
    }
    
    NSMutableArray *InningsArray=[[NSMutableArray alloc]init];
    
    if([OLDINNINGSNO isEqualToString: @"3"])
    {
        SECONDTEAMCODE = [DBManager GetSecondTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO];
        
        THIRDTEAMCODE = [DBManager GetThirdTeamCodeForInsertEndInnings : COMPETITIONCODE : MATCHCODE : OLDINNINGSNO];
        
        if([SECONDTEAMCODE isEqualToString: THIRDTEAMCODE])
        {
            //            SECONDTHIRDTOTAL = [DBManager GetSecondTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
            //
            //            FIRSTTHIRDTOTAL= [DBManager GetFirstTotalForInsertEndInnings : COMPETITIONCODE : MATCHCODE];
            NSString * Winstatus = [[NSString alloc] init];
            if(SECONDTHIRDTOTAL<FIRSTTHIRDTOTAL)
            {
                Winstatus = @"1";
            }
            else
            {
                Winstatus = @"0";
            }
            
        }
    }
    
}

@end

@implementation BallEventForInningsDetails
@synthesize TEAMCODE;
@synthesize OVERNO;
@synthesize BOWLERCODE;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize WICKETKEEPERCODE;
@synthesize UMPIRE1CODE;
@synthesize UMPIRE2CODE;
@synthesize ATWOROTW;
@synthesize BOWLINGEND;
@end
