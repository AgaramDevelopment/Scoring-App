//
//  FETCHSEBALLCODEDETAILS.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FETCHSEBALLCODEDETAILS.h"
#import "DBManagerEditScoreEngine.h"
#import "ScoreEnginEditRecord.h"
@implementation FETCHSEBALLCODEDETAILS
//SP_FETCHSEBALLCODEDETAILS
-(void) FetchSEBallCodeDetails:(NSString *)COMPETITIONCODE :(NSString *)MATCHCODE :(NSString*)BALLCODE
{
    NSString* TEAMACODE=[[NSString alloc ]init];
    NSString* TEAMBCODE=[[NSString alloc ]init];
    NSString* BATTINGTEAMCODE=[[NSString alloc ]init];
    NSString* BOWLINGTEAMCODE=[[NSString alloc ]init];
    NSNumber* INNINGSNO= [[NSNumber alloc] init];
    NSNumber* INNINGSSTATUS= [[NSNumber alloc] init];
    NSNumber* SESSIONNO= [[NSNumber alloc] init];
    NSNumber* DAYNO= [[NSNumber alloc] init];
    NSString* BATTEAMSHORTNAME=[[NSString alloc ]init];
    NSString* BOWLTEAMSHORTNAME=[[NSString alloc ]init];
    NSString* BATTEAMNAME=[[NSString alloc ]init];
    NSString* BOWLTEAMNAME=[[NSString alloc ]init];
    NSNumber* MATCHOVERS= [[NSNumber alloc] init];
    NSString* BATTEAMLOGO=[[NSString alloc ]init];
    NSString* BOWLTEAMLOGO=[[NSString alloc ]init];
    NSString* MATCHTYPE=[[NSString alloc ]init];
    NSString* ISOTHERSMATCHTYPE=[[NSString alloc ]init];
    
    
    NSMutableArray *GetTeamDetailsArray=[DBManagerEditScoreEngine GetTeamDetailsForMatchRegistration :  COMPETITIONCODE:  MATCHCODE ];
    if(GetTeamDetailsArray.count>0)
    {
        
        GetSEDetailsForMatchRegistration *record=[GetTeamDetailsArray objectAtIndex:0];
        
        
        TEAMACODE=record.TEAMACODE;
        TEAMBCODE=record.TEAMBCODE;
        MATCHOVERS= [NSNumber numberWithInt: [record.MATCHOVERS intValue]] ;
        
        
    }
    NSMutableArray *GetTeamDetailsForCompetitionArray=[ DBManagerEditScoreEngine GetTeamDetailsForCompetition :  COMPETITIONCODE ];
    if(GetTeamDetailsForCompetitionArray.count>0)
    {
        
        
        GetSEDetailsForCompetition *record=[GetTeamDetailsForCompetitionArray objectAtIndex:0];
        
        MATCHTYPE=record.MATCHTYPE;
        ISOTHERSMATCHTYPE=record.ISOTHERSMATCHTYPE;
        
        
        
    }
    //BALLCODE
    


    
    NSMutableArray *GetTeamDetailsForBallEventsArray=[ DBManagerEditScoreEngine GetTeamDetailsForBallEvents :  TEAMACODE: BATTINGTEAMCODE:  TEAMBCODE: COMPETITIONCODE:  MATCHCODE: BALLCODE ];
    if(GetTeamDetailsForBallEventsArray.count>0)
    {
        GetSEDetailsForBallEvents *record=[GetTeamDetailsForBallEventsArray objectAtIndex:0];
        
        INNINGSNO=  [NSNumber numberWithInt: [record.INNINGSNO intValue] ];
        BATTINGTEAMCODE = record.BATTINGTEAMCODE;
        BOWLINGTEAMCODE =record.BOWLINGTEAMCODE;
        
    }
    
    
    SESSIONNO=[DBManagerEditScoreEngine GetSessionNoForSessionEvents : COMPETITIONCODE :MATCHCODE : INNINGSNO	];
    
    DAYNO =[DBManagerEditScoreEngine GetDayNoForSEDayEvents : COMPETITIONCODE :MATCHCODE : INNINGSNO	];
    
    INNINGSSTATUS =[DBManagerEditScoreEngine GetInningsStatusForSEInningsEvents : COMPETITIONCODE :MATCHCODE : INNINGSNO	];
    
    NSMutableArray *GetBattingTeamNamesArray=[ DBManagerEditScoreEngine GetBattingTeamNamesForTeamMaster :  BATTINGTEAMCODE ];
    if(GetBattingTeamNamesArray.count>0)
    {
        GetSEDetailsForBattingTeamNames *record=[GetBattingTeamNamesArray objectAtIndex:0];
        
        BATTEAMSHORTNAME=record.SHORTTEAMNAME;
        BATTEAMNAME=record.TEAMNAME;
        BATTEAMLOGO=record.TEAMLOGO;
        
        
        
    }
    NSMutableArray *GetBowlingTeamNamesArray=[ DBManagerEditScoreEngine GetBowlingTeamNamesForTeamMaster :  BOWLINGTEAMCODE ];
    if(GetBowlingTeamNamesArray.count>0)
    {
        GetSEDetailsForBowlingTeamNames *record=[GetBowlingTeamNamesArray objectAtIndex:0];

        
        BOWLTEAMSHORTNAME=record.SHORTTEAMNAME;
        BOWLTEAMNAME=record.TEAMNAME;
        BOWLTEAMLOGO=record.TEAMLOGO;
        
        
        
    }
	   NSNumber* T_TARGETRUNS= [[NSNumber alloc] init];
    NSNumber* T_TARGETOVERS= [[NSNumber alloc] init];
    NSMutableArray *GetRevisedTargetArray=[ DBManagerEditScoreEngine GetRevisedTargetForMatchEvents :  COMPETITIONCODE : MATCHCODE ];
    if(GetRevisedTargetArray.count>0)
    {
        GetSEDetailsForMtachRevisedTarget  *record=[GetRevisedTargetArray objectAtIndex:0];
        T_TARGETRUNS =record.TARGETRUNS;
        T_TARGETOVERS=record.TARGETOVERS;
        
        
        
        
    }
    MATCHOVERS =  T_TARGETOVERS.intValue > 0 ? T_TARGETOVERS : MATCHOVERS;
    
   // NSMutableArray *GetMatchDetailsArray=[ DBManagerEditScoreEngine GetMatchDetailsForSEMatchRegistration :  COMPETITIONCODE : MATCHCODE ];
    
    NSMutableArray *GetBowlTypeArray=[ DBManagerEditScoreEngine GetBowlTypeForBallCodeDetails  ];
    
    
    
    NSMutableArray *GetShotTypeArray=[ DBManagerEditScoreEngine GetShotTypeForBallCodeDetails];
    
    NSNumber* BATTEAMRUNS= [[NSNumber alloc] init];;
    NSNumber* BATTEAMWICKETS= [[NSNumber alloc] init];
    NSNumber* BATTEAMOVERS= [[NSNumber alloc] init];
    NSNumber* BATTEAMOVRBALLS= [[NSNumber alloc] init];
    NSNumber* BATTEAMRUNRATE= [[NSNumber alloc] init];
    NSNumber* ISOVERCOMPLETE= [[NSNumber alloc] init];
    NSNumber* ISPREVIOUSLEGALBALL= [[NSNumber alloc] init];
    NSNumber* BATTEAMOVRBALLSCNT= [[NSNumber alloc] init];
    NSString* BOWLERCODE= [[NSString alloc] init];
    NSNumber* TOTALBATTEAMRUNS= [[NSNumber alloc] init];
    NSNumber* TOTALBOWLTEAMRUNS= [[NSNumber alloc] init];
    NSNumber* REQRUNRATE= [[NSNumber alloc] init];
    NSNumber* RUNSREQUIRED= [[NSNumber alloc] init];
    NSNumber* REMBALLS= [[NSNumber alloc] init];
    NSString* T_ATWOROTW= [[NSString alloc] init];
    NSString* T_BOWLINGEND= [[NSString alloc] init];
    NSString* STRIKERCODE= [[NSString alloc] init];
    NSString* NONSTRIKERCODE= [[NSString alloc] init];
    NSNumber* STRIKERBALLS= [[NSNumber alloc] init];
    NSNumber* NONSTRIKERBALLS= [[NSNumber alloc] init];
    NSNumber* T_TOTALRUNS= [[NSNumber alloc] init];
    NSNumber* T_OVERSTATUS	= [[NSNumber alloc] init];
    NSNumber* T_WICKETPLAYER= [[NSNumber alloc] init];
    NSNumber* WICKETS= [[NSNumber alloc] init];
    
    
	   NSMutableArray *GetBallCodeArray=[ DBManagerEditScoreEngine GetBallCodeForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BALLCODE  ];
    if(GetBallCodeArray.count>0)
    {
        
        GetSEDetailsForBallEventsDetails *record = [GetBallCodeArray objectAtIndex:0];
        
        
        
        
        BATTEAMOVERS=[NSNumber numberWithInt:  record.OVERNO.intValue];
        BATTEAMOVRBALLS=[NSNumber numberWithInt:record.BALLNO.intValue];
        BATTEAMOVRBALLSCNT=[NSNumber numberWithInt:record.BALLCOUNT.intValue];
        BOWLERCODE=record.BOWLERCODE;
        T_ATWOROTW= record.ATWOROTW;
        T_BOWLINGEND=record.BOWLINGEND;
        STRIKERCODE=record.STRIKERCODE;
        NONSTRIKERCODE=record.NONSTRIKERCODE;
        
        
        
    }
    //X =
//    NSMutableArray *GetRetiredHurtChangesArray=[ DBManagerEditScoreEngine GetRetiredHurtChangesForBallevents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO ];
    

    NSMutableArray *GetBattingTeamPlayersArray=[ DBManagerEditScoreEngine GetBattingTeamPlayersForMatchRegistration :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ];
    

    
    
    BATTEAMRUNS =[ DBManagerEditScoreEngine GetSEGrandTotalForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ];
    
    int battingTeamRunsData = BATTEAMRUNS.intValue +[[ DBManagerEditScoreEngine GetPenaltyRunsForBallCodeDetails :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO ] intValue];
    
    BATTEAMRUNS =[NSNumber numberWithInt:battingTeamRunsData];
    
    
    BATTEAMWICKETS =[ DBManagerEditScoreEngine GetWicketNoForBallCodeDetails :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ];
    
    ISOVERCOMPLETE = [NSNumber numberWithInt:1];
    
    NSNumber* TOTALBALLS= [[NSNumber alloc] init];
    
    int totalBallsDataConv =  (BATTEAMOVERS.intValue * 6) + ( BATTEAMOVRBALLS.intValue > 6 ? 6 : BATTEAMOVRBALLS.intValue);
    
    TOTALBALLS = [NSNumber numberWithInt:totalBallsDataConv];
    
    BATTEAMRUNRATE = TOTALBALLS == 0 ? [NSNumber numberWithInt:0]: [NSNumber numberWithInt:(BATTEAMRUNS.intValue / TOTALBALLS.intValue) * 6] ;
    
    
    NSMutableArray *GetBowlingTeamPlayersArray=[ DBManagerEditScoreEngine GetBowlingTeamPlayersForMatchRegistration :  MATCHCODE : BOWLINGTEAMCODE: COMPETITIONCODE : BATTINGTEAMCODE :  INNINGSNO :BATTEAMOVERS];
    
    if(INNINGSNO.intValue > 0 && (INNINGSNO.intValue % 2) == 0 )
    {
        TOTALBATTEAMRUNS =[ DBManagerEditScoreEngine GetTotalBatTeamOversForGrandTotal :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO  ];
        

        
        TOTALBATTEAMRUNS = [NSNumber numberWithInt: TOTALBATTEAMRUNS.intValue + BATTEAMRUNS.intValue ];
        
        TOTALBOWLTEAMRUNS = [ DBManagerEditScoreEngine GetTotalBowlTeamOversForGrandTotal :  COMPETITIONCODE : MATCHCODE: BOWLINGTEAMCODE : INNINGSNO  ];
        
        
//        TOTALBOWLTEAMRUNS =
//        
//        (	CASE	WHEN ( MATCHTYPE IN ('MSC023','MSC114') AND  INNINGSNO = 4 AND  TOTALBOWLTEAMRUNS > 0) THEN
//                             
//                             
//                             TOTALBOWLTEAMRUNS + 1
//                             WHEN
//         
//         ( MATCHTYPE NOT IN ('MSC023','MSC114') AND  INNINGSNO = 2 AND  TOTALBOWLTEAMRUNS > 0) THEN  TOTALBOWLTEAMRUNS + 1
//         
//         
//         ELSE  TOTALBOWLTEAMRUNS END);
        
        
        if (([MATCHTYPE isEqualToString: @"MSC023"]||[MATCHTYPE isEqualToString: @"MSC114"] )&&INNINGSNO.intValue == 4 && TOTALBOWLTEAMRUNS.intValue >0  ) {
            
               TOTALBOWLTEAMRUNS = [NSNumber numberWithInt:TOTALBATTEAMRUNS.intValue+1];
        }else if((![MATCHTYPE isEqualToString: @"MSC023"]&&![MATCHTYPE isEqualToString: @"MSC114"])&&INNINGSNO.intValue == 2 && TOTALBOWLTEAMRUNS.intValue >0 ){
            TOTALBOWLTEAMRUNS = [NSNumber numberWithInt:TOTALBOWLTEAMRUNS.intValue+1];
        }
        
        
        
        
        TOTALBOWLTEAMRUNS = T_TARGETRUNS.intValue > 0 ?  T_TARGETRUNS :  TOTALBOWLTEAMRUNS ;
        
        TOTALBOWLTEAMRUNS =   TOTALBOWLTEAMRUNS == 0 ? [NSNumber numberWithInt:1] :  TOTALBOWLTEAMRUNS ;
        
        RUNSREQUIRED = [NSNumber numberWithInt: (TOTALBOWLTEAMRUNS.intValue -  TOTALBATTEAMRUNS.intValue) ];
        
        REMBALLS = [NSNumber numberWithInt: (MATCHOVERS.intValue * 6) -  TOTALBALLS.intValue ];
        
        REQRUNRATE = REMBALLS.intValue == 0 ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt: (( RUNSREQUIRED.intValue /  REMBALLS.intValue) * (REMBALLS.intValue < 6 ? 1 : 6)) ];
    }
    
        NSNumber* ISFREEHIT= [[NSNumber alloc] init];
        
        if( ![[DBManagerEditScoreEngine GetFreeHitDetailsForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO : BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT : BATTEAMOVERS ] isEqual:@""])
        {
            ISFREEHIT = [NSNumber numberWithInt:1];
        }
        
        
        
        STRIKERBALLS = [ DBManagerEditScoreEngine GetStrikerBallForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO :  STRIKERCODE :BATTEAMOVERS :BATTEAMOVRBALLS :   BATTEAMOVRBALLSCNT];
        
        
        
        if([ DBManagerEditScoreEngine GetStrikerDetailsForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO :   STRIKERCODE : BATTEAMOVERS:  BATTEAMOVRBALLS:  BATTEAMOVRBALLSCNT ]  !=0)
        {
            
            

            NSMutableArray *GetStrikerDetailsArray=[ DBManagerEditScoreEngine GetStrikerDetailsForSEBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE : INNINGSNO :  BATTEAMOVERS :BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT: STRIKERCODE:STRIKERBALLS ];
            
        }
        else
        {
            
            NSMutableArray *GetStrikerDetailsForPlayersArray=[ DBManagerEditScoreEngine GetStrikerDetailsForPlayerMaster : STRIKERCODE ];
            
            
            
        }
        NONSTRIKERBALLS =[ DBManagerEditScoreEngine GetNonStrikerBallForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE :INNINGSNO: NONSTRIKERCODE :   BATTEAMOVERS :  BATTEAMOVRBALLS :  BATTEAMOVRBALLSCNT];
        
        if(  [ DBManagerEditScoreEngine GetNonStrikerDetailsForBallEvents :  COMPETITIONCODE : MATCHCODE: BATTINGTEAMCODE :INNINGSNO :NONSTRIKERCODE :      BATTEAMOVERS :  BATTEAMOVRBALLS :BATTEAMOVRBALLSCNT] !=0)
        {
            
            
            
            
            NSMutableArray *GetNonStrikerDetailsArray=[ DBManagerEditScoreEngine GetNonStrikerDetailsForSEBallEvents :COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO:BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT: NONSTRIKERCODE:STRIKERBALLS ];
        }
        else
        {
            NSMutableArray *GetNonStrikerDetailsForPlayersArray=[ DBManagerEditScoreEngine GetNonStrikerDetailsForPlayerMaster :  NONSTRIKERCODE];
            
        }
        
        
        
        [DBManagerEditScoreEngine GetPartnershipDetailsForBallEvents :COMPETITIONCODE: MATCHCODE: INNINGSNO: STRIKERCODE: NONSTRIKERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT] ;
        
       
        
        WICKETS=[ DBManagerEditScoreEngine GetWicketsDetailsForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT: BOWLERCODE];
        
        
        NSNumber* TOTALBALLSBOWL= [[NSNumber alloc] init];
        NSNumber* MAIDENS= [[NSNumber alloc] init];
        NSNumber* BOWLERRUNS= [[NSNumber alloc] init];
        NSNumber* ISPARTIALOVER= [[NSNumber alloc] init];
        
        
        ISPARTIALOVER=[DBManagerEditScoreEngine GetBowlerCodeForBowlerOverDetails : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BOWLERCODE: BATTEAMOVERS];
        
        if(ISPARTIALOVER.intValue == 0)
        {
            
            ISPARTIALOVER =[DBManagerEditScoreEngine GetIsPartialOverForBowlerOverDetails : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BOWLERCODE: BATTEAMOVERS];
        }
        
        NSMutableArray *GetBallCountArray=[ DBManagerEditScoreEngine GetBallCountForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE:  INNINGSNO: BOWLERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT];
						  if(GetBallCountArray.count>0)
                          {
                              
                              GetSEBallCountForBallEvents *record = [GetBallCountArray objectAtIndex:0];

                              
                              TOTALBALLSBOWL=record.TOTALBALLSBOWL;
                              MAIDENS=record.MAIDENS;
                              BOWLERRUNS=record.BOWLERRUNS;
                              
                              
                              
                          }
        
						  NSNumber* BOWLERSPELL= [[NSNumber alloc] init];
        NSNumber* V_SPELLNO= [[NSNumber alloc] init];
						  
						  BOWLERSPELL=[DBManagerEditScoreEngine GetBowlerSpellForBallEvents :COMPETITIONCODE:MATCHCODE: INNINGSNO: BOWLERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT ];
						  
						  NSMutableArray *GetBowlerDetailsArray=[ DBManagerEditScoreEngine GetBowlerDetailsForBallEventsDetails : ISPARTIALOVER: TOTALBALLSBOWL: BATTEAMOVRBALLS: BOWLERRUNS: COMPETITIONCODE: MATCHCODE: INNINGSNO: BOWLERCODE: BATTEAMOVERS: BATTEAMOVRBALLS: BATTEAMOVRBALLSCNT];
						  
						  
						  NSMutableArray *GetMatchUmpireDetailsArray=[ DBManagerEditScoreEngine GetMatchUmpireDetailsForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO:BALLCODE];
						  
        NSNumber* ISINNINGSLASTOVER= [[NSNumber alloc] init];
        
        
        ISINNINGSLASTOVER=[ DBManagerEditScoreEngine GetIsInningsLastOverForBallevents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO:BATTEAMOVERS];
						  
						  
						  
						  NSMutableArray *GetBallCodeDetailsArray=[ DBManagerEditScoreEngine GetBallCodeDetailsForBallEvents : COMPETITIONCODE: MATCHCODE: BATTINGTEAMCODE: INNINGSNO:BATTEAMOVERS];
						  
						  NSMutableArray *GetSETeamDetailsForBallEventsArray=[ DBManagerEditScoreEngine GetSETeamDetailsForBallEventsBE : COMPETITIONCODE: MATCHCODE];
						  
						   self.GetBallDetailsForBallEventsArray=[ DBManagerEditScoreEngine GetBallDetailsForBallEvents : COMPETITIONCODE: MATCHCODE : BALLCODE];
						  
						  NSMutableArray *GetWicketEventDetailsArray=[ DBManagerEditScoreEngine GetWicketEventDetailsForWicketEvents : COMPETITIONCODE: MATCHCODE :BATTINGTEAMCODE : INNINGSNO: BALLCODE];
						  
						  NSMutableArray *GetAppealDetailsForAppealEventsArray=[ DBManagerEditScoreEngine GetAppealDetailsForAppealEvents :  BALLCODE];
						  
						  NSMutableArray *GetPenaltyDetailsForPenaltyEventsArray=[ DBManagerEditScoreEngine GetPenaltyDetailsForPenaltyEvents :  COMPETITIONCODE: MATCHCODE : INNINGSNO: BALLCODE];
						  
        
        
        //ADD TWO SP
        //[ SP_FETCHSEFIELDINGEVENTSPAGELOAD :  COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE];
						  
        //[FETCHSEALLINNINGSSCOREDETAILS : COMPETITIONCODE, MATCHCODE;];
						  
        NSMutableArray *GetSpinSpeedBallDetailsForMetadataArray=[ DBManagerEditScoreEngine GetSpinSpeedBallDetailsForMetadata];
						  
						  NSMutableArray *GetFastSpeedBallDetailsForMetadataArray=[ DBManagerEditScoreEngine GetFastSpeedBallDetailsForMetadata];
						  
						  
						  
    
    
}

    
    @end
