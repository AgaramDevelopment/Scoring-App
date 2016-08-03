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
    
    NSString* STARTDATE ;
    NSString* ENDDATE ;
    NSString* MATCHTYPE ;
    NSNumber* STARTOVERNO ;
    NSNumber* STARTBALLNO ;
    NSNumber* ENDBALLNO ;
    NSString* STARTOVERBALLNO ;
    NSNumber* ENDOVERNO ;
    NSString* ENDOVERBALLNO ;
    NSNumber* RUNSSCORED ;
    NSString* WICKETLOST ;
    NSString* OVERSTATUS ;
    NSString* SESSIONNO ;
    DBManagerEndDay *objDBManagerEndDay = [[DBManagerEndDay alloc] init];
    MATCHTYPE=[objDBManagerEndDay GetMatchTypeForInserTEndDay : COMPETITIONCODE];
    
    SESSIONNO=[objDBManagerEndDay GetMaxSessionNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO];
    
    if([SESSIONNO isEqual:@""])
    {
        SESSIONNO= @"1";
        
    }
    
    STARTOVERNO=[objDBManagerEndDay GetMinOverNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : DAYNO];
    
    STARTBALLNO=[objDBManagerEndDay GetMinBallNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : STARTOVERNO];
    
    STARTOVERBALLNO= [NSString stringWithFormat:@"%@.%@",STARTOVERNO,STARTBALLNO];
    
    ENDOVERNO=[objDBManagerEndDay GetMaxOverNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO];
    
    ENDBALLNO=[objDBManagerEndDay GetMaxBallNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : ENDOVERNO];
    OVERSTATUS=[objDBManagerEndDay GetOverStatusForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : ENDOVERNO];
    
    if([OVERSTATUS isEqual: @"1"])
    {
        ENDOVERBALLNO = [NSString stringWithFormat:@"%d",[ENDOVERNO intValue]+1];
    }
    else
    {
        ENDOVERBALLNO=[NSString stringWithFormat:@"%@.%@",ENDOVERNO,ENDBALLNO];
    }
    
    RUNSSCORED=[objDBManagerEndDay GetRunsScoredForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : SESSIONNO : INNINGSNO : DAYNO];
    WICKETLOST=[objDBManagerEndDay GetWicketLostForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : SESSIONNO];
    
    if([[objDBManagerEndDay GetDayNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : DAYNO] isEqual:@""])
    {
        if([[objDBManagerEndDay GetStartTimeForInsertEndDay : STARTTIMEFORMAT : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE] isEqual:@""])
        {
            
            [objDBManagerEndDay SetDayEventsForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : STARTTIME : ENDTIME : DAYNO : BATTINGTEAMCODE : TOTALRUNS : TOTALOVERS : TOTALWICKETS : COMMENTS];
            
            if([MATCHTYPE isEqual:@"MSC023"]|| [MATCHTYPE isEqual:@"MSC114"])
            {
                NSString* RUNS=RUNSSCORED;
                NSString* SESSION=SESSIONNO;
                NSString* WICKETS=WICKETLOST;
                NSNumber* COUNT=@1;
                NSNumber* COUNTSESSION=@3;
                
                while(COUNT.intValue <= COUNTSESSION.intValue)
                {
                    if(![objDBManagerEndDay GetSessionNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : COUNT])
                    {
                        if(STARTOVERBALLNO==nil || [STARTOVERBALLNO isEqualToString:@"."])
                        {
                            
                            
                            TOTALOVERS=@"0.0";
                            SESSIONNO=[NSString stringWithFormat:@"%@",COUNT];
                            STARTOVERBALLNO=TOTALOVERS;
                            TOTALOVERS=TOTALOVERS;
                            RUNSSCORED=@0;
                            WICKETLOST=@0;
                            
                        }
                        if(COUNT.intValue!=1)
                        {
                            
                            
                            
                            SESSIONNO=[NSString stringWithFormat:@"%@",COUNT];
                            STARTOVERBALLNO=STARTOVERBALLNO;
                            TOTALOVERS=TOTALOVERS;
                            RUNSSCORED=@0;
                            WICKETLOST=@"0";
                            
                        }
                        if(SESSION==[NSString stringWithFormat:@"%@",COUNT])
                        {
                            RUNSSCORED= [NSNumber numberWithInt:RUNS.intValue];
                            WICKETLOST=WICKETS;
                        }
                        else
                        {
                            STARTOVERBALLNO=TOTALOVERS;
                            TOTALOVERS=TOTALOVERS;
                            RUNSSCORED=@0;
                        }
                        [objDBManagerEndDay SetSessionEventsForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : SESSIONNO : BATTINGTEAMCODE : STARTOVERBALLNO : TOTALOVERS : RUNSSCORED : WICKETLOST];
                        
                    }
                    COUNT = [NSNumber numberWithInt:COUNT.intValue +1];
                }
            }
        }else{
            
        }
        }else{
           //Day already exist
        }
            NSMutableArray *InsertEndDayArray=[objDBManagerEndDay InsertEndDay : COMPETITIONCODE : MATCHCODE];
            
            //NEXTDAYO=
            [objDBManagerEndDay GetMaxDayNoForInsertEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : BATTINGTEAMCODE];
            
            
            
        }
        
        
        
        
        @end
