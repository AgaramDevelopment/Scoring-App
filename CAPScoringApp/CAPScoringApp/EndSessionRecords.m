//
//  EndSessionRecords.m
//  CAPScoringApp
//
//  Created by Deepak on 28/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "EndSessionRecords.h"
#import "DBManagerEndSession.h"

@implementation EndSessionRecords
@synthesize BATTINGTEAMCODE;
@synthesize BATTINGTEAMNAME;

@synthesize BOWLINGTEAMCODE;
@synthesize BOWLINGTEAMNAME;

@synthesize METASUBCODE;
@synthesize METADESCRIPTION;

@synthesize SESSIONSTARTTIME;
@synthesize SESSIONENDTIME;
@synthesize INNINGSNO;
@synthesize TEAMNAME;
@synthesize SHORTTEAMNAME;
@synthesize TOTALRUNS;
@synthesize TOTALWICKETS;
@synthesize DOMINANTNAME;
@synthesize STARTOVER;
@synthesize ENDOVER;
@synthesize SESSIONOVER;
@synthesize DURATION;


@synthesize INNINGSNOS;
@synthesize SESSIONNO;
@synthesize STARTOVERNO;

@synthesize NEWSTARTOVERNO;
@synthesize STARTBALLNO;
@synthesize ENDOVERNO;
@synthesize ENDBALLNO;
@synthesize STARTOVERBALLNO;
@synthesize ENDOVERBALLNO;
@synthesize RUNSSCORED;
@synthesize WICKETLOST;
@synthesize TEAMNAMES;
@synthesize OVERSTATUS;
@synthesize PENALITYRUNS;
@synthesize DAYNO;
@synthesize ISCHECKDAYNIGHT;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;




@synthesize STARTTIME;
@synthesize ENDTIME;
@synthesize OVERBALLNO;
@synthesize MATCHTYPE;
@synthesize WICKETS;
@synthesize RUNS;
@synthesize OVERNO;
@synthesize BALLNO;
@synthesize OVERSPLAYED;
@synthesize CHECKSTARTDATE;

@synthesize GetBattingTeamDetails;
@synthesize GetDateDayWiseDetails;
@synthesize GetSessionEventDetails;
@synthesize getSessionArray;
@synthesize getMetaSubCode;
@synthesize getBattingTeamUsingBowlingCode;





-(void) FetchEndSession:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)INNINGSNO :(NSString*)BATTINGTEAMCODE :(NSString*)BOWLINGTEAMCODE


{

    //CHECKDAYNIGHT
    ISCHECKDAYNIGHT = [DBManagerEndSession GetIsDayNightForFetchEndSession : MATCHCODE];
    
    //DAYNO
    if([DBManagerEndSession GetDayNoForFetchEndSession :COMPETITIONCODE: MATCHCODE])
    {
        
    DAYNO=[DBManagerEndSession  GetDayNoStatusForFetchEndSession :COMPETITIONCODE: MATCHCODE ];
        
        if(DAYNO == nil)
        {
        DAYNO=[DBManagerEndSession  GetDayNoStatusIn0ForFetchEndSession :COMPETITIONCODE: MATCHCODE];
            
        }
    }
    else
    {
        
        DAYNO = @"1";
    }
    
    //INNINGSNO
    INNINGSNOS = [DBManagerEndSession  GetInningsNosForFetchEndSession :COMPETITIONCODE: MATCHCODE : BATTINGTEAMCODE];
    
    
    
    SESSIONNO=[DBManagerEndSession  GetSessionNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : DAYNO];
    
    if([SESSIONNO isEqual:@"0"])
    {
        SESSIONNO = @1;
    }
    else
    {
       
        SESSIONNO = [NSNumber numberWithInt: SESSIONNO.intValue +1];
    }
    if(SESSIONNO.intValue > 3)
    {
        
        SESSIONNO = @1;
        
        
        
        DAYNO = [NSString stringWithFormat:@"%d",DAYNO.intValue +1];
    }
    
    //STARTOVER
    if([DBManagerEndSession GetOverNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO : INNINGSNO : DAYNO ])
    {
        
        STARTOVERNO=[DBManagerEndSession GetStartOverNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO : INNINGSNO : DAYNO];
    }
        else
            
        {
           
           NEWSTARTOVERNO =  [DBManagerEndSession GetNewStartOverNoForFetchEndSession:COMPETITIONCODE :MATCHCODE :INNINGSNO];
            
        }
       //STARTBALLNO
        STARTBALLNO=[DBManagerEndSession GetStartBallNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO :DAYNO: INNINGSNO :STARTOVERNO];
    
    
                      
    STARTOVERBALLNO = [NSString stringWithFormat:@"%@.%@" ,STARTOVERNO,STARTBALLNO];
        
    
        if(STARTOVERBALLNO == nil)
        {
            
            STARTOVERBALLNO = NEWSTARTOVERNO;
            }


//ENDOVER
    NSString *endOverNO = [DBManagerEndSession GetEndOverNoForFetchEndSession:COMPETITIONCODE :MATCHCODE :SESSIONNO :DAYNO :INNINGSNO];

   ENDOVERNO = [NSString stringWithFormat:@"%@",endOverNO];
    
    
    //ENDBALLNO
    ENDBALLNO=[DBManagerEndSession GetEndBallNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO :DAYNO: INNINGSNO : ENDOVERNO ];
    
    //OVERSTATUS
    OVERSTATUS=[DBManagerEndSession GetOverStatusForFetchEndSession :COMPETITIONCODE: MATCHCODE : INNINGSNO : ENDOVERNO ];
    
    //ENDOVERBALLNO	BASED OVERSTATUS
    if(OVERSTATUS = @"1")
    {
        ENDOVERBALLNO = [NSString stringWithFormat:@"%d",ENDOVERNO.intValue +1];
    }
    else
    {
        
        ENDOVERBALLNO = [NSString stringWithFormat:@"%d.%d",ENDOVERNO,ENDBALLNO];
    }
    
    //ENDOVERBALLNO
        if (ENDOVERBALLNO == nil)
        {
            
            ENDOVERBALLNO = NEWSTARTOVERNO;
        }
    
    //TEAMNAME
        TEAMNAMES=[DBManagerEndSession GetTeamNamesForFetchEndSession :BATTINGTEAMCODE ];
    
    //PENALITYRUNS
        PENALITYRUNS=[DBManagerEndSession GetPenaltyRunsForFetchEndSession :COMPETITIONCODE: MATCHCODE : INNINGSNO : BATTINGTEAMCODE ];
    
    //RUNSSCORED
        RUNSSCORED=[DBManagerEndSession GetRunsScoredForFetchEndSession :COMPETITIONCODE: MATCHCODE :SESSIONNO : INNINGSNO : DAYNO ];
    //TOTALWICKET
        WICKETLOST=[DBManagerEndSession GetWicketLoftForFetchEndSession :COMPETITIONCODE: MATCHCODE :INNINGSNO :SESSIONNO  : DAYNO];
        
       //FETCHDOMINANT
    
    
    GetBattingTeamDetails = [[NSMutableArray alloc]init];
    
         GetBattingTeamDetails=[DBManagerEndSession GetBattingTeamForFetchEndSession:BATTINGTEAMCODE];
    
    getBattingTeamUsingBowlingCode = [[NSMutableArray alloc]init];
    
   getBattingTeamUsingBowlingCode = [DBManagerEndSession GetBattingTeamUsingBowlingCode:BOWLINGTEAMCODE];
    getMetaSubCode = [[NSMutableArray alloc]init];
   getMetaSubCode = [DBManagerEndSession GetMetaSubCode];

//FETCH
    
    GetSessionEventDetails = [[NSMutableArray alloc]init];
         GetSessionEventDetails=[DBManagerEndSession GetSessionEventsForFetchEndSession : COMPETITIONCODE : MATCHCODE];
        
//START DATE AND END DATE
        [DBManagerEndSession GetStartDateForFetchEndSession : COMPETITIONCODE : MATCHCODE];
    
  //DATEVALIDATION(SESSION WISE)

    getSessionArray = [[NSMutableArray alloc]init];
   getSessionArray = [DBManagerEndSession getSessionDetails:COMPETITIONCODE :MATCHCODE];

        //DATEVALIDATION(DAY WISE)
    GetDateDayWiseDetails = [[NSMutableArray alloc]init];
      GetDateDayWiseDetails=[DBManagerEndSession GetDateDayWiseForFetchEndSession : COMPETITIONCODE : MATCHCODE];
    
        
}



//SP_INSERTENDSESSION----------------------------------------------------------------------



-(void) InsertEndSession:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)DAYNO:(NSString*)SESSIONNO :(NSString *)SESSIONSTARTTIME:(NSString*)SESSIONENDTIME :(NSString*)STARTOVER:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)DOMINANTTEAMCODE

{
    
  
    STARTTIME=SESSIONENDTIME;
    
    ENDTIME=SESSIONENDTIME;
    
    MATCHTYPE=[DBManagerEndSession GetMatchTypeForInsertEndSession : COMPETITIONCODE];
    
    WICKETS=[DBManagerEndSession GetWicketsForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    PENALITYRUNS=[DBManagerEndSession GetPenaltyRunsForInsertEndSession : COMPETITIONCODE : MATCHCODE : INNINGSNO : TEAMCODE];
    
    RUNS=[DBManagerEndSession GetPenaltyRunsForInsertEndSession :INNINGSNO: COMPETITIONCODE : MATCHCODE : TEAMCODE];
    
    OVERNO=[DBManagerEndSession GetOverNoForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    BALLNO=[DBManagerEndSession GetBallNoForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
    
    OVERSTATUS=[DBManagerEndSession GetOverStatusForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : OVERNO];
    
	   if(OVERSTATUS = @"1")
       {
           OVERBALLNO= [NSString stringWithFormat:@"%d",OVERNO.intValue +1];

           
       }
       else
       {
           OVERBALLNO = [NSString stringWithFormat:@"%d.%d",OVERNO,BALLNO];
       }
	   if(OVERBALLNO == nil)
       {
           OVERBALLNO = @"0.0";
       }
	   
	   OVERSPLAYED=[DBManagerEndSession GetOversPlayedForInsertEndSession :INNINGSNO: COMPETITIONCODE : MATCHCODE : TEAMCODE];
	   
    CHECKSTARTDATE = SESSIONSTARTTIME;
    
    if(![DBManagerEndSession GetSessionStartTimeForInsertEndSession : DAYNO : MATCHCODE : CHECKSTARTDATE])
    {
        if([DBManagerEndSession GetCompetitionCodeForInsertEndSession :COMPETITIONCODE : MATCHCODE :INNINGSNO:  TEAMCODE ])
        {
            
            if(![DBManagerEndSession GetDayNoInNotExistsForInsertEndSession :SESSIONSTARTTIME: SESSIONENDTIME : COMPETITIONCODE : MATCHCODE :INNINGSNO :DAYNO ])
            {
                if(![DBManagerEndSession GetSessionNoForInsertEndSession :SESSIONSTARTTIME : SESSIONENDTIME : COMPETITIONCODE: MATCHCODE ])
                {
                    if(![DBManagerEndSession GetCompetitionCodeInNotExistsForInsertEndSession :COMPETITIONCODE:MATCHCODE:INNINGSNO:SESSIONNO:DAYNO ])
                    {
                        [DBManagerEndSession InsertSessionEventForInsertEndSession : COMPETITIONCODE: MATCHCODE :  INNINGSNO : DAYNO  : SESSIONNO : STARTTIME  : ENDTIME :TEAMCODE: STARTOVER: ENDOVER : TOTALRUNS:TOTALWICKETS :DOMINANTTEAMCODE];
                        
                        if(([MATCHTYPE isEqualToString:@"MSC023"] || [MATCHTYPE isEqualToString:@"MSC114"]) && (SESSIONNO = @3))
                        {
                            if(![DBManagerEndSession GetDayNoForInsertEndSession :COMPETITIONCODE : MATCHCODE :INNINGSNO:  DAYNO  ])
                            {
                                [DBManagerEndSession InsertDayEventForInsertEndSession :COMPETITIONCODE : MATCHCODE :INNINGSNO:  DAYNO : TEAMCODE : RUNS  : OVERBALLNO : WICKETS];
                                
                                
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
   
    
    
}


//SP_UPDATEENDSESSION----------------------------------------------------------------------

-(void) UpdateEndSession:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSNumber*)INNINGSNO:(NSString*)DAYNO:(NSString*)SESSIONNO :(NSString *)SESSIONSTARTTIME:(NSString*)SESSIONENDTIME: (NSString*)DOMINANTTEAMCODE

{
    
    STARTTIME=SESSIONENDTIME;
    
    ENDTIME=SESSIONENDTIME;
   
	   
    CHECKSTARTDATE = SESSIONSTARTTIME;
    
    if(![DBManagerEndSession GetSessionStartTimeForInsertEndSession : DAYNO : MATCHCODE : CHECKSTARTDATE])
    {
            if(![DBManagerEndSession GetDayNoInNotExistsForInsertEndSession :SESSIONSTARTTIME: SESSIONENDTIME : COMPETITIONCODE : MATCHCODE :INNINGSNO :DAYNO ])
            {
                if(![DBManagerEndSession GetSessionNoForInsertEndSession :SESSIONSTARTTIME : SESSIONENDTIME : COMPETITIONCODE: MATCHCODE ])
                {
                    
                    if([DBManagerEndSession GetMatchCodeInNotExists:COMPETITIONCODE :MATCHCODE])
                    {
                    
                    if([DBManagerEndSession GetCompetitionCodeInNotExistsForInsertEndSession :COMPETITIONCODE:MATCHCODE:INNINGSNO:SESSIONNO:DAYNO ])
                    {
                        
                        [DBManagerEndSession updateEndSession:STARTTIME :ENDTIME :DOMINANTTEAMCODE :DAYNO :COMPETITIONCODE :MATCHCODE :INNINGSNO :SESSIONNO];

                    }
                }
            }
        }
        
    }
    

}

//SP_DELETEENDSESSION---------------------------------------------------------------------------

-(void) DeleteEndSession:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)DAYNO:(NSString*)SESSIONNO

{
   
    
if(![DBManagerEndSession GetBallCodeForDeleteEndSession:COMPETITIONCODE :MATCHCODE :DAYNO :SESSIONNO] && ![DBManagerEndSession GetBallCodeWithAddDayNoForDeleteEndSession: COMPETITIONCODE : MATCHCODE : DAYNO ])
    {
        
        if(![DBManagerEndSession GetSessionNoForDeleteEndSession : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : SESSIONNO ])
        {
            if(![DBManagerEndSession GetSessionNoWithAddDayNoForDeleteEndSession:COMPETITIONCODE :MATCHCODE :INNINGSNOS :DAYNO])
            {
             
            [DBManagerEndSession DeleteSessionEventsForDeleteEndSession : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : SESSIONNO];
            }
            
        }
        
    }
    
  
    
    
}







@end
