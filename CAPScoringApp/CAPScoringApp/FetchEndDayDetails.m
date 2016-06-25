//
//  FetchEndDayDetails.m
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchEndDayDetails.h"
#import "DBManagerEndDay.h"


@implementation FetchEndDayDetails
@synthesize DAYNO;
@synthesize TEAMNAME;
@synthesize RUNS;
@synthesize OVERBALLNO;

-(void) FetchEndDay:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSNumber*)INNINGSNO
{
    NSString* PENALITYRUNS = [[NSString alloc] init];
    NSString* ISCHECKDAYNIGHT = [[NSString alloc] init];
    
    
    ISCHECKDAYNIGHT=[DBManagerEndDay GetIsDayNightForFetchEndDay : MATCHCODE];
    
    
    TEAMNAME =[DBManagerEndDay GetTeamNameForFetcHEndDay : TEAMCODE];
    if(![[DBManagerEndDay GetDayNoForFetchEndDay : COMPETITIONCODE : MATCHCODE] isEqual:@""])
    {
        DAYNO=[DBManagerEndDay GetMaxDayNoForFetchEndDay : COMPETITIONCODE : MATCHCODE ];
        if(DAYNO==nil)
            
            DAYNO=[DBManagerEndDay GetMaxDayNoForFetchEndDayDetails : COMPETITIONCODE : MATCHCODE];
    }
    else
    {
        DAYNO= @1;
    }
    PENALITYRUNS=[DBManagerEndDay GetPenaltyRunsForFetchEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : TEAMCODE];
    
    
    RUNS = [DBManagerEndDay GetRunsForFetchEndDay : INNINGSNO : COMPETITIONCODE : MATCHCODE : TEAMCODE : DAYNO];
    
    NSString* MINOVERNO=[[NSString alloc] init];
    MINOVERNO = [DBManagerEndDay GetMinOverForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO :DAYNO];
    
    NSString* MINBALLNO=[[NSString alloc] init];
    MINBALLNO = [DBManagerEndDay GetMinBallNoForFetcHEndDay : COMPETITIONCODE :MATCHCODE : TEAMCODE : MINOVERNO : INNINGSNO : DAYNO];
    
    NSString* OVERNO=[[NSString alloc] init];
   OVERNO = [DBManagerEndDay GetMaxOverForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : DAYNO];
    
    NSString* BALLNO=[[NSString alloc] init];
   BALLNO = [DBManagerEndDay GetMaxBallNoForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO : INNINGSNO : DAYNO];
    
    
    NSNumber* MINOVERBALL=[[NSNumber alloc] init];
    
   MINOVERBALL= [NSString stringWithFormat:@"%@.%@",MINOVERNO,MINBALLNO];
    
    NSNumber* MAXOVERBALL=[[NSNumber alloc] init];
    
    MAXOVERBALL= [NSString stringWithFormat:@"%@.%@",OVERNO,BALLNO];
    
    NSString* TOTALOVERS= [DBManagerEndDay GetBallEventsForFetchEndDay : MATCHCODE : COMPETITIONCODE : INNINGSNO : MINOVERBALL : MAXOVERBALL];
    
    NSString* OVERS =TOTALOVERS;
    
   OVERS = [ NSString stringWithFormat:@"%d.%d",[OVERS intValue]/6,[OVERS intValue]%6];
    
    
    OVERBALLNO=OVERS;
    
    _WICKETS= [DBManagerEndDay GetWicketsCountForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : DAYNO];
    
    int runData = [RUNS intValue]+ (PENALITYRUNS==nil ?[PENALITYRUNS intValue]: 0);
    RUNS = [NSString stringWithFormat:@"%d",runData];
    
     _FetchEndDayArray =[DBManagerEndDay GetFetchEndDay : COMPETITIONCODE : MATCHCODE];
    
    NSMutableArray *FetchEndDayDetailsArray=[DBManagerEndDay GetMatchDateForFetchEndDay : COMPETITIONCODE : MATCHCODE];
    
    }
    @end
