//
//  InsertEndDay.m
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "InsertEndDay.h"
#import "DBManagerEndDay.h"

@implementation InsertEndDay
//SP_INSERTENDDAY
-(void) InsertEndDay:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)STARTTIME:(NSString*)ENDTIME:(NSString*)DAYNO:(NSString*)BATTINGTEAMCODE:(NSString*)TOTALRUNS:(NSString*)TOTALOVERS:(NSString*)TOTALWICKETS:(NSString*)COMMENTS:(NSString*)STARTTIMEFORMAT:(NSString*)ENDTIMEFORMAT
{
    
    NSString* STARTDATE = [[NSString alloc] init];
    NSString* ENDDATE = [[NSString alloc] init];
    NSString* MATCHTYPE = [[NSString alloc] init];
    NSNumber* STARTOVERNO = [[NSNumber alloc] init];
    NSNumber* STARTBALLNO = [[NSNumber alloc] init];
    NSNumber* ENDBALLNO = [[NSNumber alloc] init];
    NSString* STARTOVERBALLNO = [[NSString alloc] init];
    NSNumber* ENDOVERNO = [[NSNumber alloc] init];
    NSString* ENDOVERBALLNO = [[NSString alloc] init];
    NSNumber* RUNSSCORED = [[NSNumber alloc] init];
    NSString* WICKETLOST = [[NSString alloc] init];
    NSString* OVERSTATUS = [[NSString alloc] init];
    NSString* SESSIONNO = [[NSString alloc] init];
    
    MATCHTYPE=[DBManagerEndDay GetMatchTypeForInserTEndDay : COMPETITIONCODE];
    
    SESSIONNO=[DBManagerEndDay GetMaxSessionNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO];
    
    if(SESSIONNO==nil)
    {
        SESSIONNO= @"1";
        
    }
    
    STARTOVERNO=[DBManagerEndDay GetMinOverNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : DAYNO];
    
    STARTBALLNO=[DBManagerEndDay GetMinBallNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : STARTOVERNO];
    
    STARTOVERBALLNO= [NSString stringWithFormat:@"%@.%@",STARTOVERNO,STARTBALLNO];
    
    ENDOVERNO=[DBManagerEndDay GetMaxOverNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO];
    
    ENDBALLNO=[DBManagerEndDay GetMaxBallNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : ENDOVERNO];
    OVERSTATUS=[DBManagerEndDay GetOverStatusForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : ENDOVERNO];
    
    if([OVERSTATUS isEqual: @"1"])
    {
        ENDOVERBALLNO = [NSString stringWithFormat:@"%d",[ENDOVERNO intValue]+1];
    }
    else
    {
        ENDOVERBALLNO=[NSString stringWithFormat:@"%@.%@",ENDOVERNO,ENDBALLNO];
    }
    
    RUNSSCORED=[DBManagerEndDay GetRunsScoredForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : DAYNO];
    WICKETLOST=[DBManagerEndDay GetWicketLostForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : SESSIONNO];
    
    if(![DBManagerEndDay GetDayNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : DAYNO])
    {
        if(![DBManagerEndDay GetStartTimeForInsertEndDay : STARTTIMEFORMAT : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE])
        {
            
            [DBManagerEndDay SetDayEventsForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : STARTTIME : ENDTIME : DAYNO : BATTINGTEAMCODE : TOTALRUNS : TOTALOVERS : TOTALWICKETS : COMMENTS];
            
            if([MATCHTYPE isEqual:@"MSC023"]|| [MATCHTYPE isEqual:@"MSC114"])
            {
                NSString* RUNS=RUNSSCORED;
                NSString* SESSION=SESSIONNO;
                NSString* WICKETS=WICKETLOST;
                NSNumber* COUNT=@1;
                NSNumber* COUNTSESSION=@3;
                
                while(COUNT<=COUNTSESSION)
                {
                    if(![DBManagerEndDay GetSessionNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : COUNT])
                    {
                        if(STARTOVERBALLNO==nil)
                        {
                            TOTALOVERS=@"0.0";
                            SESSIONNO=COUNT;
                            STARTOVERBALLNO=TOTALOVERS;
                            TOTALOVERS=TOTALOVERS;
                            RUNSSCORED=0;
                            WICKETLOST=0;
                            
                        }
                        if(COUNT.intValue!=1)
                        {
                            SESSIONNO=COUNT;
                            STARTOVERBALLNO=STARTOVERBALLNO;
                            TOTALOVERS=TOTALOVERS;
                            RUNSSCORED=0;
                            WICKETLOST=0;
                            
                        }
                        if(SESSION==COUNT)
                        {
                            RUNSSCORED=RUNS;
                            WICKETLOST=WICKETS;
                        }
                        else
                        {
                            STARTOVERBALLNO=TOTALOVERS;
                            TOTALOVERS=TOTALOVERS;
                            RUNSSCORED=0;
                        }
                        [DBManagerEndDay SetSessionEventsForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : SESSIONNO : BATTINGTEAMCODE : STARTOVERBALLNO : TOTALOVERS : RUNSSCORED : WICKETLOST];
                        
                    }
                    COUNT = [NSNumber numberWithInt:COUNT.intValue +1];
                }
            }
        }else{
            
        }
        }else{
           //Day already exist
        }
            NSMutableArray *InsertEndDayArray=[DBManagerEndDay InsertEndDay : COMPETITIONCODE : MATCHCODE];
            
            //NEXTDAYO=
            [DBManagerEndDay GetMaxDayNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : BATTINGTEAMCODE];
            
            
            
        }
        
        
        
        
        @end
