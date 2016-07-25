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
    
    DBManagerEndDay *objDBManagerEndDay = [[DBManagerEndDay alloc] init];
    ISCHECKDAYNIGHT=[objDBManagerEndDay GetIsDayNightForFetchEndDay : MATCHCODE];
    
    
    TEAMNAME =[objDBManagerEndDay GetTeamNameForFetcHEndDay : TEAMCODE];
    if(![[objDBManagerEndDay GetDayNoForFetchEndDay : COMPETITIONCODE : MATCHCODE] isEqual:@""])
    {
        DAYNO=[objDBManagerEndDay GetMaxDayNoForFetchEndDay : COMPETITIONCODE : MATCHCODE ];
        if(DAYNO==nil)
            
            DAYNO=[objDBManagerEndDay GetMaxDayNoForFetchEndDayDetails : COMPETITIONCODE : MATCHCODE];
    }
    else
    {
        DAYNO= @1;
    }
    PENALITYRUNS=[objDBManagerEndDay GetPenaltyRunsForFetchEndDay : COMPETITIONCODE : MATCHCODE : INNINGSNO : TEAMCODE];
    
    
    RUNS = [objDBManagerEndDay GetRunsForFetchEndDay : INNINGSNO : COMPETITIONCODE : MATCHCODE : TEAMCODE : DAYNO];
    
    NSString* MINOVERNO=[[NSString alloc] init];
    MINOVERNO = [objDBManagerEndDay GetMinOverForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO :DAYNO];
    
    NSString* MINBALLNO=[[NSString alloc] init];
    MINBALLNO = [objDBManagerEndDay GetMinBallNoForFetcHEndDay : COMPETITIONCODE :MATCHCODE : TEAMCODE : MINOVERNO : INNINGSNO : DAYNO];
    
    NSString* OVERNO=[[NSString alloc] init];
   OVERNO = [objDBManagerEndDay GetMaxOverForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : DAYNO];
    
    NSString* BALLNO=[[NSString alloc] init];
   BALLNO = [objDBManagerEndDay GetMaxBallNoForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO : INNINGSNO : DAYNO];
    
    
    NSNumber* MINOVERBALL=[[NSNumber alloc] init];
    
   MINOVERBALL= [NSString stringWithFormat:@"%@.%@",MINOVERNO,MINBALLNO];
    
    NSNumber* MAXOVERBALL=[[NSNumber alloc] init];
    
    MAXOVERBALL= [NSString stringWithFormat:@"%@.%@",OVERNO,BALLNO];
    
    NSString* TOTALOVERS= [objDBManagerEndDay GetBallEventsForFetchEndDay : MATCHCODE : COMPETITIONCODE : INNINGSNO : MINOVERBALL : MAXOVERBALL];
    
    NSString* OVERS =TOTALOVERS;
    
   OVERS = [ NSString stringWithFormat:@"%d.%d",[OVERS intValue]/6,[BALLNO intValue]%6];
    
    
    OVERBALLNO=OVERS;
    
    _WICKETS= [objDBManagerEndDay GetWicketsCountForFetchEndDay : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : DAYNO];
    
    int runData = [RUNS intValue]+ (PENALITYRUNS==nil ?[PENALITYRUNS intValue]: 0);
    RUNS = [NSString stringWithFormat:@"%d",runData];
    
     _FetchEndDayArray =[objDBManagerEndDay GetFetchEndDay : COMPETITIONCODE : MATCHCODE];
    
    NSMutableArray *FetchEndDayDetailsArray=[objDBManagerEndDay GetMatchDateForFetchEndDay : COMPETITIONCODE : MATCHCODE];
    
    }
    @end
