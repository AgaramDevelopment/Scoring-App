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

DBManagerEndSession *dbEndSession;



-(void) FetchEndSession:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)INNINGSNO :(NSString*)BATTINGTEAMCODE :(NSString*)BOWLINGTEAMCODE


{

    dbEndSession = [[DBManagerEndSession alloc]init];
    //CHECKDAYNIGHT
    ISCHECKDAYNIGHT = [dbEndSession GetIsDayNightForFetchEndSession : MATCHCODE];
    
    //DAYNO
    if([dbEndSession GetDayNoForFetchEndSession :COMPETITIONCODE: MATCHCODE])
    {
        
    DAYNO=[dbEndSession  GetDayNoStatusForFetchEndSession :COMPETITIONCODE: MATCHCODE ];
        
        if(DAYNO == nil)
        {
        DAYNO=[dbEndSession  GetDayNoStatusIn0ForFetchEndSession :COMPETITIONCODE: MATCHCODE];
            
        }
    }
    else
    {
        
        DAYNO = @"1";
    }
    
    //INNINGSNO
    INNINGSNOS = [dbEndSession  GetInningsNosForFetchEndSession :COMPETITIONCODE: MATCHCODE : BATTINGTEAMCODE];
    
    
    
    SESSIONNO=[dbEndSession  GetSessionNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : DAYNO];
    
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
    if([dbEndSession GetOverNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO : INNINGSNO : DAYNO ])
    {
        
        STARTOVERNO=[dbEndSession GetStartOverNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO : INNINGSNO : DAYNO];
    }
        else
            
        {
           
           NEWSTARTOVERNO =  [dbEndSession GetNewStartOverNoForFetchEndSession:COMPETITIONCODE :MATCHCODE :INNINGSNO];
            
        }
       //STARTBALLNO
        STARTBALLNO=[dbEndSession GetStartBallNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO :DAYNO: INNINGSNO :STARTOVERNO];
    
    
                      
    STARTOVERBALLNO = [NSString stringWithFormat:@"%@.%@" ,STARTOVERNO,STARTBALLNO];
        
    
        if(STARTOVERBALLNO == nil)
        {
            
            STARTOVERBALLNO = NEWSTARTOVERNO;
            }


//ENDOVER
    NSString *endOverNO = [dbEndSession GetEndOverNoForFetchEndSession:COMPETITIONCODE :MATCHCODE :SESSIONNO :DAYNO :INNINGSNO];

   ENDOVERNO = [NSString stringWithFormat:@"%@",endOverNO];
    
    
    //ENDBALLNO
    ENDBALLNO=[dbEndSession GetEndBallNoForFetchEndSession :COMPETITIONCODE: MATCHCODE : SESSIONNO :DAYNO: INNINGSNO : ENDOVERNO ];
    
    //OVERSTATUS
    OVERSTATUS=[dbEndSession GetOverStatusForFetchEndSession :COMPETITIONCODE: MATCHCODE : INNINGSNO : ENDOVERNO ];
    
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
        TEAMNAMES=[dbEndSession GetTeamNamesForFetchEndSession :BATTINGTEAMCODE ];
    
    //PENALITYRUNS
        PENALITYRUNS=[dbEndSession GetPenaltyRunsForFetchEndSession :COMPETITIONCODE: MATCHCODE : INNINGSNO : BATTINGTEAMCODE ];
    
    //RUNSSCORED
        RUNSSCORED=[dbEndSession GetRunsScoredForFetchEndSession :COMPETITIONCODE: MATCHCODE :SESSIONNO : INNINGSNO : DAYNO ];
    //TOTALWICKET
        WICKETLOST=[dbEndSession GetWicketLoftForFetchEndSession :COMPETITIONCODE: MATCHCODE :INNINGSNO :SESSIONNO  : DAYNO];
        
       //FETCHDOMINANT
    
    
    //GetBattingTeamDetails = [[NSMutableArray alloc]init];
    
         //GetBattingTeamDetails=[dbEndSession GetBattingTeamForFetchEndSession:BATTINGTEAMCODE];
    
    getBattingTeamUsingBowlingCode = [[NSMutableArray alloc]init];
    
   getBattingTeamUsingBowlingCode = [dbEndSession GetBattingTeamUsingBowlingCode:BOWLINGTEAMCODE];
    getMetaSubCode = [[NSMutableArray alloc]init];
   getMetaSubCode = [dbEndSession GetMetaSubCode];

//FETCH
    
    GetSessionEventDetails = [[NSMutableArray alloc]init];
         GetSessionEventDetails=[dbEndSession GetSessionEventsForFetchEndSession : COMPETITIONCODE : MATCHCODE];
        
//START DATE AND END DATE
        [dbEndSession GetStartDateForFetchEndSession : COMPETITIONCODE : MATCHCODE];
    
  //DATEVALIDATION(SESSION WISE)

    getSessionArray = [[NSMutableArray alloc]init];
   getSessionArray = [dbEndSession getSessionDetails:COMPETITIONCODE :MATCHCODE];

        //DATEVALIDATION(DAY WISE)
    GetDateDayWiseDetails = [[NSMutableArray alloc]init];
      GetDateDayWiseDetails=[dbEndSession GetDateDayWiseForFetchEndSession : COMPETITIONCODE : MATCHCODE];
    
        
}



//SP_INSERTENDSESSION----------------------------------------------------------------------



-(void) InsertEndSession:(NSString *)COMPETITIONCODE :(NSString*)MATCHCODE :(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)DAYNO:(NSString*)SESSIONNO :(NSString *)SESSIONSTARTTIME:(NSString*)SESSIONENDTIME :(NSString*)STARTOVER:(NSString*)ENDOVER:(NSString*)TOTALRUNS:(NSString*)TOTALWICKETS:(NSString*)DOMINANTTEAMCODE

{
    
  
    STARTTIME=SESSIONENDTIME;
    
    ENDTIME=SESSIONENDTIME;
    
    MATCHTYPE=[dbEndSession GetMatchTypeForInsertEndSession : COMPETITIONCODE];
    
    WICKETS=[dbEndSession GetWicketsForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    PENALITYRUNS=[dbEndSession GetPenaltyRunsForInsertEndSession : COMPETITIONCODE : MATCHCODE : INNINGSNO : TEAMCODE];
    
    RUNS=[dbEndSession GetPenaltyRunsForInsertEndSession :INNINGSNO: COMPETITIONCODE : MATCHCODE : TEAMCODE];
    
    OVERNO=[dbEndSession GetOverNoForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO];
    
    BALLNO=[dbEndSession GetBallNoForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : OVERNO: INNINGSNO];
    
    OVERSTATUS=[dbEndSession GetOverStatusForInsertEndSession : COMPETITIONCODE : MATCHCODE : TEAMCODE : INNINGSNO : OVERNO];
    
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
	   
	   OVERSPLAYED=[dbEndSession GetOversPlayedForInsertEndSession :INNINGSNO: COMPETITIONCODE : MATCHCODE : TEAMCODE];
	   
    CHECKSTARTDATE = SESSIONSTARTTIME;
    
    if(![dbEndSession GetSessionStartTimeForInsertEndSession : DAYNO : MATCHCODE : CHECKSTARTDATE])
    {
        if([dbEndSession GetCompetitionCodeForInsertEndSession :COMPETITIONCODE : MATCHCODE :INNINGSNO:  TEAMCODE ])
        {
            
            if(![dbEndSession GetDayNoInNotExistsForInsertEndSession :SESSIONSTARTTIME: SESSIONENDTIME : COMPETITIONCODE : MATCHCODE :INNINGSNO :DAYNO ])
            {
                if(![dbEndSession GetSessionNoForInsertEndSession :SESSIONSTARTTIME : SESSIONENDTIME : COMPETITIONCODE: MATCHCODE ])
                {
                    if(![dbEndSession GetCompetitionCodeInNotExistsForInsertEndSession :COMPETITIONCODE:MATCHCODE:INNINGSNO:SESSIONNO:DAYNO ])
                    {
                        [dbEndSession InsertSessionEventForInsertEndSession : COMPETITIONCODE: MATCHCODE :  INNINGSNO : DAYNO  : SESSIONNO : STARTTIME  : ENDTIME :TEAMCODE: STARTOVER: ENDOVER : TOTALRUNS:TOTALWICKETS :DOMINANTTEAMCODE];
                        
                        if(([MATCHTYPE isEqualToString:@"MSC023"] || [MATCHTYPE isEqualToString:@"MSC114"]) && (SESSIONNO = @3))
                        {
                            if(![dbEndSession GetDayNoForInsertEndSession :COMPETITIONCODE : MATCHCODE :INNINGSNO:  DAYNO  ])
                            {
                                [dbEndSession InsertDayEventForInsertEndSession :COMPETITIONCODE : MATCHCODE :INNINGSNO:  DAYNO : TEAMCODE : RUNS  : OVERBALLNO : WICKETS];
                                
                                
                                
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
    
    if(![dbEndSession GetSessionStartTimeForInsertEndSession : DAYNO : MATCHCODE : CHECKSTARTDATE])
    {
            if(![dbEndSession GetDayNoInNotExistsForInsertEndSession :SESSIONSTARTTIME: SESSIONENDTIME : COMPETITIONCODE : MATCHCODE :INNINGSNO :DAYNO ])
            {
                if(![dbEndSession GetSessionNoForInsertEndSession :SESSIONSTARTTIME : SESSIONENDTIME : COMPETITIONCODE: MATCHCODE ])
                {
                    
                    if([dbEndSession GetMatchCodeInNotExists:COMPETITIONCODE :MATCHCODE])
                    {
                    
                    if([dbEndSession GetCompetitionCodeInNotExistsForInsertEndSession :COMPETITIONCODE:MATCHCODE:INNINGSNO:SESSIONNO:DAYNO ])
                    {
                        
                        [dbEndSession updateEndSession:STARTTIME :ENDTIME :DOMINANTTEAMCODE :DAYNO :COMPETITIONCODE :MATCHCODE :INNINGSNO :SESSIONNO];

                    }
                }
            }
        }
        
    }
    

}

//SP_DELETEENDSESSION---------------------------------------------------------------------------

-(void) DeleteEndSession:(NSString *)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) DAYNO:(NSString*) SESSIONNO

{
   
    
if(![dbEndSession GetBallCodeForDeleteEndSession:COMPETITIONCODE :MATCHCODE :DAYNO :SESSIONNO] && ![dbEndSession GetBallCodeWithAddDayNoForDeleteEndSession: COMPETITIONCODE : MATCHCODE : DAYNO ])
    {
        
        if(![dbEndSession GetSessionNoForDeleteEndSession : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : SESSIONNO ])
        {
            if(![dbEndSession GetSessionNoWithAddDayNoForDeleteEndSession: COMPETITIONCODE :MATCHCODE :INNINGSNO :DAYNO])
            {
             
            [dbEndSession DeleteSessionEventsForDeleteEndSession : COMPETITIONCODE : MATCHCODE : INNINGSNO : DAYNO : SESSIONNO];
            }
            
        }
        
    }
    
  
    
    
}







@end
